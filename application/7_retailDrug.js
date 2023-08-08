"use strict";

const helper = require("./contractHelper");

async function main(drugName, serialNo, retailerCRN, customerAadhar, organisationRole) {
  try {
    const contract = await helper.getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("retailDrug", drugName, serialNo, retailerCRN, customerAadhar);
    const retailDrugDetails = JSON.parse(responseBuffer.toString());
    console.log(retailDrugDetails);
    return retailDrugDetails;
  } catch (err) {
    console.log("Failed to Retail Drug. Error : " + err);
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main = main;
