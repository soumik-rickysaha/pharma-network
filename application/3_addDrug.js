"use strict";

const helper = require("./contractHelper");

async function main(drugName, serialNo, mfgDate, expDate, companyCRN, organisationRole) {
  try {
    const contract = await helper.getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("addDrug", drugName, serialNo, mfgDate, expDate, companyCRN);
    const drug = JSON.parse(responseBuffer.toString());
    console.log(drug);
    return drug;
  } catch (err) {
    console.log("Failed to register Drug. Error : " + err);
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main = main;
