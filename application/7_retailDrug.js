"use strict";

const helper = require("./contractHelper");

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

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main = main;
