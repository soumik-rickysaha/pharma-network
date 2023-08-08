"use strict";

const helper = require("./contractHelper");

async function main(buyerCRN, sellerCRN, drugName, quantity, organisationRole) {
  let responseBuffer;
  try {
    const contract = await helper.getContractInstance(organisationRole);
    responseBuffer = await contract.submitTransaction("createPO", buyerCRN, sellerCRN, drugName, quantity);
    const PO = JSON.parse(responseBuffer.toString());
    console.log(PO);
    return PO;
  } catch (err) {
    let errmsg = "Failed to create PO. Error : " + responseBuffer.toString();
    console.log("Failed to create PO. Error : " + errmsg);
    return errmsg;
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main = main;
