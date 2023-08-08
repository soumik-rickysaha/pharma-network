"use strict";

const helper = require("./contractHelper");

  /**
   * @description This function is used to update a shipment
   * @param {*} buyerCRN CRN of the Company who is rasing the PO
   * @param {*} drugName Name of the Drug
   * @param {*} transporterCRN Details of the transporter
   * @param {*} organisationRole  This field will represent the Organization role
   */

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


module.exports.main=main;
