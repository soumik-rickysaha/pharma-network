"use strict";

const helper = require("./contractHelper");

async function main(drugName, serialNo,organisationRole) {
  try {
    const contract = await helper.getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("viewDrugCurrentState", drugName, serialNo);
    const drugCurrentState = JSON.parse(responseBuffer.toString());
    console.log(drugCurrentState);
    return drugCurrentState;
  } catch (err) {
    console.log("Failed to get Drug Current State. Error : " + err);
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main=main;
