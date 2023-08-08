"use strict";

const helper = require("./contractHelper");

  /**
   * @description This function is used to create a shipment
   * @param {*} buyerCRN CRN of the Company who is rasing the PO
   * @param {*} drugName Name of the Drug
   * @param {*} listOfAssets Drug serial numbers
   * @param {*} transporterCRN Details of the transporter
   * @param {*} organisationRole  This field will represent the Organization role
   */

async function main(buyerCRN, drugName, listOfAssets, transporterCRN, organisationRole) {
  let responseBuffer;
  try {
    const contract = await helper.getContractInstance(organisationRole);
    responseBuffer = await contract.submitTransaction("createShipment", buyerCRN, drugName, listOfAssets, transporterCRN);
    const shipment = JSON.parse(responseBuffer.toString());
    console.log(shipment);
    return shipment;
  } catch (err) {
    let errmsg = "Failed to create shipment. Error : " + responseBuffer.toString();
    console.log("Failed to create shipment. Error : " + errmsg);
    return errmsg;
  } finally {
    helper.disconnect();
  }
}


module.exports.main = main;
