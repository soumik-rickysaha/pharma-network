"use strict";

const { Contract } = require("fabric-contract-api");

class PharmaNetContract extends Contract {
  constructor() {
    super("pharmanet");
  }

  /**
   * @description Instantiate function to verify the smart contract was successfully published in the network
   * @param {*} ctx The transaction context object
   */

  async instantiate(ctx) {
    console.log("PharmaNetContract Chaincode was successfully deployed");
  }

  /**
   * @description This function find the Hierarchy key and return the value. If the value remains as 0 then, it will be an unauthorised access
   * @param {*} ctx The transaction context object
   */

  getCompnayHierarchyKey(txnContext) {
    let txnMSPID = txnContext.clientIdentity.getMSPID();

    let hKey = 0;

    if (txnMSPID.trim() === "ManufacturerMSP") {
      hKey = 1;
    } else if (txnMSPID.trim() === "DistributorMSP") {
      hKey = 2;
    } else if (txnMSPID.trim() === "RetailerMSP") {
      hKey = 3;
    } else if (txnMSPID.trim() === "TransporterMSP") {
      hKey = 4;
    }

    return hKey;
  }

  /**
   * @description This transaction/function will be used to register new entities on the ledger.
   * @param {*} ctx The transaction context object
   * @param {*} companyCRN This field stores the composite key with which the company will get registered on the network. The key comprises the Company Registration Number (CRN) and the Name of the company along with appropriate namespace
   * @param {*} companyName Name of the company
   * @param {*} Location Location of the company
   * @param {*} organisationRole  This field will take
   */

  async registerCompany(ctx, companyCRN, companyName, Location, organisationRole) {
    let hierarchyKey = this.getCompnayHierarchyKey(ctx);

    if (hierarchyKey > 0) {
      let companyKey = ctx.stub.createCompositeKey("pharmanet.company", [companyCRN]);

      let companyDetails = {
        companyID: companyCRN,
        name: companyName,
        location: Location,
        organisationRole: organisationRole,
        hierarchyKey: hierarchyKey,
        createdAt: ctx.stub.getTxTimestamp(),
        updatedAt: ctx.stub.getTxTimestamp(),
      };

      let companyDetailsBuffer = Buffer.from(JSON.stringify(companyDetails));

      await ctx.stub.putState(companyKey, companyDetailsBuffer);
      return companyDetails;
    } else {
      return "Not authorized to initiate the transaction. Please retry from an authorised MSP";
    }
  }

  /**
   * @description This transaction is used by any organisation registered as a ‘manufacturer’ to register a new drug on the ledger.
   * @param {*} ctx The transaction context object
   * @param {*} drugName Name of the product
   * @param {*} serialNo Composite key of the manufacturer used to store manufacturer’s detail on the ledger
   * @param {*} mfgDate Date of manufacturing of the drug
   * @param {*} expDate Expiration date of the drug
   * @param {*} companyCRN This field stores the composite key with which the company will get registered on the network. The key comprises the Company Registration Number (CRN) and the Name of the company along with appropriate namespace
   */

  async addDrug(ctx, drugName, serialNo, mfgDate, expDate, companyCRN) {
    // Check if the transaction is being performed by the manufacturer

    // getting the transaction hierarchy
    let ctxHierarchy = this.getCompnayHierarchyKey(ctx);

    if (ctxHierarchy === 1) {
      // Check if the company is registered in the netwokr
      let companyKey = ctx.stub.createCompositeKey("pharmanet.company", [companyCRN]);
      try {
        let companyDetailsBuffer = await ctx.stub.getState(companyKey);
        if (companyDetailsBuffer) {
          let companyObject = JSON.parse(companyDetailsBuffer.toString());

          // Check if the company has role of manufacturer
          if (companyObject.organisationRole === "manufacturer") {
            // Generate drug Key
            let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugName + "-" + serialNo]);

            //Create drug Object
            let drugDetails = {
              productID: drugKey,
              name: drugName,
              manufacturer: companyKey,
              manufacturingDate: mfgDate,
              expiryDate: expDate,
              owner: companyKey,
              shipment: "",
              createdAt: ctx.stub.getTxTimestamp(),
              updatedAt: ctx.stub.getTxTimestamp(),
            };

            let drugBuffer = Buffer.from(JSON.stringify(drugDetails));
            await ctx.stub.putState(drugKey, drugDetails);
            return drugDetails;
          }
        }
      } catch (err) {
        console.log("Error in adding drug" + err);
      }
    }
  }

  /**
   * @description This function create the purchase orject object
   * @param {*} poID Stores the composite key of the PO using which the PO is stored on the ledger.
   * @param {*} drugName Contains the name of the drug for which the PO is raised.
   * @param {*} quantity Denotes the number of units required.
   * @param {*} buyer Stores the composite key of the buyer.
   * @param {*} seller Stores the composite key of the seller of the drugs.
   */

  generatePOModel(poID, drugName, quantity, buyer, seller) {
    // Create and return PO Model
    let poDetails = {
      poID: poID,
      drugName: drugName,
      quantity: quantity,
      buyer: buyer,
      seller: seller,
      createdAt: ctx.stub.getTxTimestamp(),
      updatedAt: ctx.stub.getTxTimestamp(),
    };

    return poDetails;
  }

  /**
   * @description This function is used to create a Purchase Order (PO) to buy drugs, by companies belonging to ‘Distributor’ or ‘Retailer’ organisation.
   * @param {*} ctx The transaction context object
   * @param {*} buyerCRN CRN of the Company who is rasing the PO
   * @param {*} sellerCRN CRN of the Company who is selling the drug
   * @param {*} drugName Name of the drug
   * @param {*} quantity Quantity of the drug that is being purchased/sold
   */

  async createPO(ctx, buyerCRN, sellerCRN, drugName, quantity) {
    // Check if the transaction is being performed by the Distributor or Retailer
    let ctxHierarchy = this.getCompnayHierarchyKey(ctx);

    //  PO : Retailer => Distributor
    if (ctxHierarchy === 3 || ctxHierarchy === 2) {
      let buyerKey = ctx.stub.createCompositeKey("pharmanet.company", [buyerCRN]);
      let selletKey = ctx.stub.createCompositeKey("pharmanet.company", [sellerCRN]);

      //Check if buyer and seller is present in the system
      try {
        let buyerBuffer = await ctx.stub.getState(buyerKey);
        let sellerBuffer = await ctx.stub.getState(selletKey);

        if (buyerBuffer && sellerBuffer) {
          // Check if the buyer in ths scenario is a Retailer

          let buyerObject = JSON.parse(buyerBuffer.toString());
          let sellerObject = JSON.parse(sellerBuffer.toString());

          if (
            (buyerObject.organisationRole === "Retailer" && sellerObject.organisationRole === "Distributor") ||
            (buyerObject.organisationRole === "Distributor" && sellerObject.organisationRole === "Manufacturer")
          ) {
            let buyerName = buyerObject.name;

            let poKey = ctx.stub.createCompositeKey("pharmanet.PurchaseOrders", [buyerCRN + "-" + drugName]);

            let po = this.generatePOModel(poKey, drugName, quantity, buyerCRN, sellerCRN);
            let poBuffer = Buffer.from(JSON.stringify(po));
            await ctx.stub.putState(poKey, poBuffer);
          } else {
            console.log("The buyer and seller are not matchig the criteria");
          }
          return po;
        } else {
          console.log("The Buyer Or Seller are not registered in the system");
        }
      } catch (err) {
        console.log("Failer to get Buyer or Seller Keys." + err);
      }
    }
  }

  /**
   * @description This function is used to create a shipment
   * @param {*} ctx The transaction context object
   * @param {*} buyerCRN CRN of the Company who is rasing the PO
   * @param {*} drugName Name of the Drug
   * @param {*} listOfAssets Drug serial numbers
   * @param {*} transporterCRN Details of the transporter
   */

  async createShipment(ctx, buyerCRN, drugName, listOfAssets, transporterCRN) {
    try {
      // Verify the buyer is either a retailer or a distributor
      let ctxHierarchy = this.getCompnayHierarchyKey(ctx);

      if (ctxHierarchy === 1 || ctxHierarchy === 2) {
        // Create the PO Key
        let poKey = ctx.stub.createCompositeKey("pharmanet.PurchaseOrders", [buyerCRN + "-" + drugName]);
        let poBuffer = Buffer.from(JSON.stringify(poKey));
        let poDetails = JSON.parse(poBuffer.toString());

        let totalPOItems = poDetails.quantity;
        let totalItemsReceived = listOfAssets.split(",");

        let totalAssets = [];
        if (totalPOItems === totalItemsReceived) {
          for (let items of listOfAssets) {
            let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugName + "-" + items]);
            totalAssets.push(drugKey);
          }
        } else {
          console.log("Quantity requested does not match the quantity provided");
        }

        //Create Shipment Details
        let shipmentKey = ctx.stub.createCompositeKey("pharmanet.shipment", [buyerCRN + "-" + drugName]);
        let transporterKey = ctx.stub.createCompositeKey("pharmanet.transporter", [transporterCRN]);

        let shipmentObject = {
          shipmentID: shipmentKey,
          creator: ctx.getID(),
          assets: totalAssets,
          transporter: transporterKey,
          status: "in-transit",
          createdAt: ctx.stub.getTxTimestamp(),
          updatedAt: ctx.stub.getTxTimestamp()
        };

        let shipmentBuffer = Buffer.from(JSON.stringify(shipmentObject));
        ctx.stub.putState(shipmentKey, shipmentBuffer);

        //Update the Owner of the drug
        for (let items of listOfAssets) {
          // Update owner
          let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugName + "-" + items]);
          let drugBuffer = ctx.stub.getState(drugKey);
          let drugObject = JSON.parse(drugBuffer.toString());
          drugObject.owner = transporterKey;

          // Update in the ledger
          let updatedDrugBuffer = Buffer.from(JSON.stringify(drugObject));
          ctx.stub.putState(drugKey, updatedDrugBuffer);
        }
      } else {
        console.log("User is not allowed to create shipment");
      }
    } catch (err) {
      console.log("Error in create shipment : " + err);
    }
  }

  /**
   * @description This function is used to update a shipment
   * @param {*} ctx The transaction context object
   * @param {*} buyerCRN CRN of the Company who is rasing the PO
   * @param {*} drugName Name of the Drug
   * @param {*} transporterCRN Details of the transporter
   */

  async updateShipment(ctx, buyerCRN, drugName, transporterCRN) {
    // Verify the buyer is either a retailer or a distributor
    let ctxHierarchy = this.getCompnayHierarchyKey(ctx);

    if (ctxHierarchy === 4) {
      let shipmentKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugName + "-" + items]);
      let shipmentBuffer = ctx.stub.getState(shipmentKey);
      let shipmentObject = JSON.parse(shipmentBuffer.toString());

      let txnMSPID = ctx.clientIdentity.getMSPID();

      let currentOwner = "";
      if (txnMSPID.trim() === "DistributorMSP") {
        currentOwner = "Distributor";
      } else {
        currentOwner = "Consumer";
      }


      shipmentObject.status="Delivered";
      shipmentObject.updatedAt=ctx.stub.getTxTimestamp();
      shipmentObject.owner=currentOwner;


      let drugName=shipmentObject.drugName;

      let drugSerialNo=shipmentObject.assets;

      for(let item of drugSerialNo){
        let drugKey=ctx.stub.createCompositeKey("pharmanet.drug", [drugName + "-" + item]);
        let drugBuffer=ctx.stub.getState(drugKey);
        let drugObject=JSON.parse(drugBuffer.toString());

        drugObject.shipment=shipmentKey;

        //Update the ledger
        let updatedDrugBuffer=Buffer.from(drugObject.toString());
        ctx.stub.putState(drugKey, updatedDrugBuffer);
      }

      let updatedShipmentBuffer=Buffer.from(shipmentObject.toString());
      ctx.stub.putState(shipmentKey,updatedShipmentBuffer);

    } else {
      console.log("Shipment can only be updated by the tranporter");
    }
  }
}

module.exports = PharmaNetContract;
