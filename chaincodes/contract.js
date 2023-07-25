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
    }

    return hKey;
  }

  /**
   * @description This transaction/function will be used to register new entities on the ledger.
   * @param {*} ctx The transaction context object
   * @param {*} companyCRN The transaction context object
   * @param {*} companyName The transaction context object
   * @param {*} Location The transaction context object
   * @param {*} organisationRole The transaction context object
   */

  async registerCompany(ctx, companyCRN, companyName, Location, organisationRole) {
    let hierarchyKey = this.getCompnayHierarchyKey(ctx);

    if (hierarchyKey > 0) {
        
      let companyKey = ctx.stub.createCompositeKey("org.pharma-network.pharmanet.company", [companyCRN]);

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
}

module.exports = PharmaNetContract;
