"use strict";

const helper = require("./contractHelper");

/**
 * @description This function is used view the History of the DRUG
 * @param {*} drugName Name of the Drug
 * @param {*} serialNo SerailNo of the Drug
 * @param {*} organisationRole  This field will represent the Organization role
 */

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


module.exports.main = main;
