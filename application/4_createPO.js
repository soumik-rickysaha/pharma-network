"use strict";

const helper = require("./contractHelper");

async function main(buyerCRN, sellerCRN, drugName, quantity, organisationRole) {
  try {
    const contract = await helper.getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("createPO", buyerCRN, sellerCRN, drugName, quantity);
    const PO = JSON.parse(responseBuffer.toString());
    console.log(PO);
    return PO;
  } catch (err) {
    console.log("Failed to create PO. Error : " + err);
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main = main;
