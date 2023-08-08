"use strict";

const helper = require("./contractHelper");

/**
 * @description This fucntion will be used to add Drugs
 * @param {*} drugName Name of the product
 * @param {*} serialNo Serial Number of the Drug
 * @param {*} mfgDate Date of manufacturing of the drug
 * @param {*} expDate Expiration date of the drug
 * @param {*} companyCRN This field stores the key with which the company will get registered on the network. The key comprises the Company Registration Number (CRN) and the Name of the company along with appropriate namespace
 * @param {*} organisationRole  This field will represent the Organization role
 */

async function main(drugName, serialNo, mfgDate, expDate, companyCRN, organisationRole) {
  let responseBuffer;

  try {
    const contract = await helper.getContractInstance(organisationRole);
    responseBuffer = await contract.submitTransaction("addDrug", drugName, serialNo, mfgDate, expDate, companyCRN);
    const drug = JSON.parse(responseBuffer.toString());
    console.log(drug);
    return drug;
  } catch (err) {
    let errmsg = "Failed to register Drug. Error : " + responseBuffer.toString();
    console.log("Failed to register Drug. Error : " + errmsg);
    return errmsg;
  } finally {
    helper.disconnect();
  }
}

module.exports.main = main;
