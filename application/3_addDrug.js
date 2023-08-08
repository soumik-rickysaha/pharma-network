"use strict";

const helper = require("./contractHelper");

async function main(drugName, serialNo, mfgDate, expDate, companyCRN, organisationRole) {
  let responseBuffer;

  try {
    const contract = await helper.getContractInstance(organisationRole);
    responseBuffer = await contract.submitTransaction("addDrug", drugName, serialNo, mfgDate, expDate, companyCRN);
    const drug = JSON.parse(responseBuffer.toString());
    console.log(drug);
    return drug;
  } catch (err) {
    let errmsg = "Failed to register Drug. Error : " + responseBuffer.toString();
    console.log("Failed to register Drug. Error : " + errmsg);
    return errmsg;
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main = main;
