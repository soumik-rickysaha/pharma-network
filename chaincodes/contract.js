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

  // =============================================== Utils Functions ===============================================

  getCompanyDbKey(companyCRN, companyName) {
    let key = companyCRN + "-" + companyName;
    return key;
  }

  getDrugDBKey(drugName, serialNo) {
    let key = drugName + "-" + serialNo;
    return key;
  }

  getpoDBKey(buyerCRN, drugName) {
    let key = buyerCRN + "-" + drugName;
    return key;
  }

  getShipmentKey(buyerCRN, drugName) {
    let key = buyerCRN + "-" + drugName;
    return key;
  }

  // =============================================== Utils Functions End ===============================================

  /**
   * @description This function find the Hierarchy key and return the value. If the value remains as 0 then, it will be an unauthorised access
   * @param {*} ctx The transaction context object
   */

  getCompanyHierarchyKey(txnContext) {
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
    } else if (txnMSPID.trim() === "ConsumerMSP") {
      hKey = 5;
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
    let hierarchyKey = this.getCompanyHierarchyKey(ctx);

    if (hierarchyKey > 0) {
      let companyDBKey = this.getCompanyDbKey(companyCRN, companyName);
      let companyKey = ctx.stub.createCompositeKey("pharmanet.company", [companyDBKey]);

      let companyDetails = {
        companyID: companyDBKey,
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
    let ctxHierarchy = this.getCompanyHierarchyKey(ctx);

    if (ctxHierarchy === 1) {
      // Check if the company is registered in the netwokr
      let companyKey = ctx.stub.createCompositeKey("pharmanet.company", [companyCRN]);
      try {
        let companyDetailsBuffer = await ctx.stub.getState(companyKey);
        if (companyDetailsBuffer) {
          let companyObject = JSON.parse(companyDetailsBuffer.toString());

          // Check if the company has role of manufacturer
          if (companyObject.organisationRole.toUpperCase() === "MANUFACTURER") {
            // Generate drug Key
            let drugDBKey = this.getDrugDBKey(drugName, serialNo);
            let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugDBKey]);

            //Create drug Object
            let drugDetails = {
              productID: drugDBKey,
              name: drugName,
              manufacturer: companyCRN,
              manufacturingDate: mfgDate,
              expiryDate: expDate,
              owner: companyCRN,
              shipment: "",
              createdAt: ctx.stub.getTxTimestamp(),
              updatedAt: ctx.stub.getTxTimestamp(),
            };

            console.log("===================================" + drugDetails);
            let drugBuffer = Buffer.from(JSON.stringify(drugDetails));
            await ctx.stub.putState(drugKey, drugBuffer);
            return drugDetails;
          }else{
            console.log("=================================== Organisation Role Did not match");
          }
        } else {
          console.log("=================================== Issue with Company details Buffer");
        }
      } catch (err) {
        console.log("Error in adding drug" + err);
      }
    } else {
      return "Error in adding drug. Hierarchy does not match";
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

  // generatePOModel(poID, drugName, quantity, buyer, seller) {
  //   // Create and return PO Model


  //   return poDetails;
  // }

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
    let ctxHierarchy = this.getCompanyHierarchyKey(ctx);

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
            (buyerObject.organisationRole.toUpperCase() === "RETAILER" && sellerObject.organisationRole.toUpperCase() === "DISTRIBUTOR") ||
            (buyerObject.organisationRole.toUpperCase() === "DISTRIBUTOR" && sellerObject.organisationRole.toUpperCase() === "MANUFACTURER")
          ) {
            // let buyerName = buyerObject.name;
            let poDBKey = this.getpoDBKey(buyerCRN, drugName);
            let poKey = ctx.stub.createCompositeKey("pharmanet.PurchaseOrders", [poDBKey]);

            // let po = this.generatePOModel(ctx,poDBKey, drugName, quantity, buyerCRN, sellerCRN);
            let poDetails = {
              poID: poDBKey,
              drugName: drugName,
              quantity: quantity,
              buyer: buyerCRN,
              seller: sellerCRN,
              createdAt: ctx.stub.getTxTimestamp(),
              updatedAt: ctx.stub.getTxTimestamp(),
            };
            let poBuffer = Buffer.from(JSON.stringify(poDetails));
            await ctx.stub.putState(poKey, poBuffer);
            return poDetails;
          } else {
            console.log("The buyer and seller are not matchig the criteria");
          }
          return po;
        } else {
          console.log("The Buyer Or Seller are not registered in the system");
        }
      } catch (err) {
        console.log("Failed to get Buyer or Seller Keys." + err);
      }
    }else{
      return "Error in creating PO. Hierarchy does not match";
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
      let ctxHierarchy = this.getCompanyHierarchyKey(ctx);
      listOfAssets=JSON.parse(listOfAssets);
      if (ctxHierarchy === 1 || ctxHierarchy === 2) {
        // Create the PO Key
        let poDBKey = this.getpoDBKey(buyerCRN, drugName);
        let poKey = ctx.stub.createCompositeKey("pharmanet.PurchaseOrders", [poDBKey]);
        let poBuffer = await ctx.stub.getState(poKey);
        let poDetails = JSON.parse(poBuffer.toString());
        let totalPOItems = poDetails.quantity;
        // console.log("Type Of Purchase Quantity in PO is : " + typeof totalPOItems);
        
        let totalItemsReceived=0;

        if(Array.isArray(listOfAssets)){
          totalItemsReceived=listOfAssets.length;
        }else{
          return "Received value is not an array";
        }
        

        let totalAssets = [];
        if (parseInt(totalPOItems) === parseInt(totalItemsReceived)) {
          for (let items of listOfAssets) {
            let drugDBKey = this.getDrugDBKey(drugName, items);
            // let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugDBKey]);
            totalAssets.push(drugDBKey);
          }
        } else {
          return "Quantity requested does not match the quantity provided";
        }

        //Create Shipment Details
        let shipmentDBKey = this.getShipmentKey(buyerCRN, drugName);
        let shipmentKey = ctx.stub.createCompositeKey("pharmanet.shipment", [shipmentDBKey]);
        // let transporterKey = ctx.stub.createCompositeKey("pharmanet.transporter", [transporterCRN]);

        let shipmentObject = {
          shipmentID: shipmentDBKey,
          creator: ctx.clientIdentity.getID(),
          assets: totalAssets,
          transporter: transporterCRN,
          status: "in-transit",
          createdAt: ctx.stub.getTxTimestamp(),
          updatedAt: ctx.stub.getTxTimestamp(),
        };

        let shipmentBuffer = Buffer.from(JSON.stringify(shipmentObject));
        await ctx.stub.putState(shipmentKey, shipmentBuffer);
        //Update the Owner of the drug
        for (let items of listOfAssets) {
          // Update owner
          let drugDBKey = this.getDrugDBKey(drugName, items);
          let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugDBKey]);
          let drugBuffer = await ctx.stub.getState(drugKey);
          let drugObject = JSON.parse(drugBuffer.toString());
          drugObject.owner = transporterCRN;
          // Update in the ledger
          let updatedDrugBuffer = Buffer.from(JSON.stringify(drugObject));
          await ctx.stub.putState(drugKey, updatedDrugBuffer);
        }
        return shipmentObject;
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
    let ctxHierarchy = this.getCompanyHierarchyKey(ctx);

    if (ctxHierarchy === 4) {
      let shipmentDBKey = this.getShipmentKey(buyerCRN, drugName);
      let shipmentKey = ctx.stub.createCompositeKey("pharmanet.shipment", [shipmentDBKey]);
      let shipmentBuffer = await ctx.stub.getState(shipmentKey);
      let shipmentObject = JSON.parse(shipmentBuffer.toString());
      let companyKey = ctx.stub.createCompositeKey("pharmanet.company", [buyerCRN]);
      let companyBuffer = await ctx.stub.getState(companyKey);
      let companyObject = JSON.parse(companyBuffer.toString());
      let currentOwner = "";
      if (companyObject.organisationRole.toUpperCase() === "DISTRIBUTOR" || companyObject.organisationRole.toUpperCase() === "Retailer") {
        currentOwner = buyerCRN;
      }
      shipmentObject.status = "Delivered";
      shipmentObject.updatedAt = ctx.stub.getTxTimestamp();
      shipmentObject.owner = currentOwner;
      // let drugName = shipmentObject.drugName;

      let drugSerialNo = shipmentObject.assets;

      for (let item of drugSerialNo) {

        let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [item]);
        let drugBuffer = await ctx.stub.getState(drugKey);
        let drugObject = JSON.parse(drugBuffer.toString());
        drugObject.shipment = shipmentKey;

        //Update the ledger
        let updatedDrugBuffer = Buffer.from(drugObject.toString());
        await ctx.stub.putState(drugKey, updatedDrugBuffer);
      }

      let updatedShipmentBuffer = Buffer.from(shipmentObject.toString());
      await ctx.stub.putState(shipmentKey, updatedShipmentBuffer);
      return shipmentObject;
    } else {
      console.log("Shipment can only be updated by the tranporter");
    }
  }

  /**
   * @description This function is used to sell the durg to the consumer
   * @param {*} ctx The transaction context object
   * @param {*} drugName Name of the Drug
   * @param {*} serialNo SerailNo of the Drug
   * @param {*} retailerCRN SerailNo of the Drug
   * @param {*} customerAadhar SerailNo of the Drug
   */

  async retailDrug(ctx, drugName, serialNo, retailerCRN, customerAadhar) {
    let hierarchyKey = this.getCompanyHierarchyKey(ctx);

    if (hierarchyKey === 5) {
      let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugName + "-" + serialNo]);
      let drugBuffer = await ctx.stub.getState(drugKey).catch((err) => console.log(err));
      let drugDetails = JSON.parse(drugBuffer.toString());

      let companyKey = ctx.stub.createCompositeKey("pharmanet.company", [retailerCRN]);

      if (drugDetails.owner === companyKey) {
        drugDetails.owner = customerAadhar;

        let updatedDrugBuffer = Buffer.from(JSON.stringify(drugDetails));
        await ctx.stub.putState(drugKey, updatedDrugBuffer);

        return drugDetails;
      }
    } else {
      console.log("User does not have the right to sell drug to consumer");
    }
  }

  /**
   * @description This function is used view the History of the DRUG
   * @param {*} ctx The transaction context object
   * @param {*} drugName Name of the Drug
   * @param {*} serialNo SerailNo of the Drug
   */

  async viewHistory(ctx, drugName, serialNo) {
    let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugName + "-" + serialNo]);

    let allDrugDetails = await ctx.stub.getHistoryForKey(drugKey);
    console.log("=============== All Drug Details :" + allDrugDetails);
    let allDurgResult = [];

    let res = await allDrugDetails.next();

    //Iterate till res.done becomes false
    while (res.done) {
      console.log("=============== res.value = " + res.value);
      console.log("=============== res.value.value = " + res.value.value);
      console.log("=============== res.value.value.toString('utf8') = " + res.value.vlue.toString("utf8"));

      let jsonResponse = {};

      jsonResponse.txID = res.value.tx_id;
      jsonResponse.Timestamp = res.value.timestamp;
      jsonResponse.IsDelete = res.value.is_delete.toString();

      try {
        jsonResponse.Value = JSON.parse(res.value.value.toString("utf8"));
      } catch (err) {
        console.log(err);
        jsonResponse.Value = res.value.value.toString("utf8");
      }

      allDurgResult.push(jsonResponse);
    }

    await NodeIterator.close();
    return allDurgResult;
  }

  /**
   * @description This function is used view the current state of the DRUG
   * @param {*} ctx The transaction context object
   * @param {*} drugName Name of the Drug
   * @param {*} serialNo SerailNo of the Drug
   */

  async viewDrugCurrentState(ctx, drugName, serialNo) {
    let drugDBKey = this.getDrugDBKey(drugName, serialNo);
    console.log("******" + drugDBKey);
    let drugKey = ctx.stub.createCompositeKey("pharmanet.drug", [drugDBKey]);
    console.log(drugKey);
    let drugBuffer = await ctx.stub.getState(drugKey).catch((err) => console.log(err));
    let drugDetails = JSON.parse(drugBuffer.toString());

    return drugDetails;
  }
}

module.exports = PharmaNetContract;
