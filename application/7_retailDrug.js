"use strict";

const helper = require("./contractHelper");

 /**
   * @description This function is used to sell the durg to the consumer
   * @param {*} drugName Name of the Drug
   * @param {*} serialNo SerailNo of the Drug
   * @param {*} retailerCRN SerailNo of the Drug
   * @param {*} customerAadhar SerailNo of the Drug
   * @param {*} organisationRole  This field will represent the Organization role
   */

async function main(drugName, serialNo, retailerCRN, customerAadhar, organisationRole) {
  let responseBuffer;
  try {
    const contract = await helper.getContractInstance(organisationRole);
    responseBuffer = await contract.submitTransaction("retailDrug", drugName, serialNo, retailerCRN, customerAadhar);
    const retailDrugDetails = JSON.parse(responseBuffer.toString());
    console.log(retailDrugDetails);
    return retailDrugDetails;
  } catch (err) {
    let errmsg = "Failed to Retail Drug. Error : " + responseBuffer.toString();
    console.log("Failed to Retail Drug. Error : " + errmsg);
    return errmsg;
  } finally {
    helper.disconnect();
  }
}


module.exports.main = main;
