"use strict";

const helper = require("./contractHelper");

async function main(drugName, serialNo, organisationRole) {
  try {
    const contract = await helper.getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("viewHistory", drugName, serialNo);
    const drugHistory = JSON.parse(responseBuffer.toString());
    console.log(drugHistory);
    return drugHistory;
  } catch (err) {
    console.log("Failed to get Drug History. Error : " + err);
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main = main;
