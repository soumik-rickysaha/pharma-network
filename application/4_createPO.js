"use strict";

const helper = require("./contractHelper");

  /**
   * @description This function is used to create a Purchase Order (PO) to buy drugs, by companies belonging to ‘Distributor’ or ‘Retailer’ organisation.
   * @param {*} buyerCRN CRN of the Company who is rasing the PO
   * @param {*} sellerCRN CRN of the Company who is selling the drug
   * @param {*} drugName Name of the drug
   * @param {*} quantity Quantity of the drug that is being purchased/sold
   * @param {*} organisationRole  This field will represent the Organization role
   */

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


module.exports.main = main;
