"use strict";

const helper = require("./contractHelper");

async function main(buyerCRN, drugName, transporterCRN,organisationRole) {
  try {
    const contract = await helper.getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("updateShipment", buyerCRN, drugName, transporterCRN);
    const shipment = JSON.parse(responseBuffer.toString());
    console.log(shipment);
    return shipment;
  } catch (err) {
    console.log("Failed to update shipment. Error : " + err);
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main=main;
