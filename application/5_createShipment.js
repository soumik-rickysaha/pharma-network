"use strict";

const helper = require("./contractHelper");

async function main(buyerCRN, drugName, listOfAssets, transporterCRN, organisationRole) {
  try {
    const contract = await helper.getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("createShipment", buyerCRN, drugName, listOfAssets, transporterCRN);
    const shipment = JSON.parse(responseBuffer.toString());
    console.log(shipment);
    return shipment;
  } catch (err) {
    console.log("Failed to create shipment. Error : " + err);
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main = main;
