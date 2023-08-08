"use strict";

const helper = require("./contractHelper");

async function main(buyerCRN, drugName, transporterCRN,organisationRole) {
  let responseBuffer;
  try {
    const contract = await helper.getContractInstance(organisationRole);
    responseBuffer = await contract.submitTransaction("updateShipment", buyerCRN, drugName, transporterCRN);
    const shipment = JSON.parse(responseBuffer.toString());
    console.log(shipment);
    return shipment;
  } catch (err) {
    let errmsg = "Failed to update shipment. Error : " + responseBuffer.toString();
    console.log("Failed to update shipment. Error : " + errmsg);
    return errmsg;
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main=main;
