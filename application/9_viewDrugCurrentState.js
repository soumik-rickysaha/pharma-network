"use strict";

const helper = require("./contractHelper");

/**
 * @description This function is used view the current state of the DRUG
 * @param {*} drugName Name of the Drug
 * @param {*} serialNo SerailNo of the Drug
 * @param {*} organisationRole  This field will represent the Organization role
 */

async function main(drugName, serialNo, organisationRole) {
  try {
    const contract = await helper.getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("viewDrugCurrentState", drugName, serialNo);
    const drugCurrentState = JSON.parse(responseBuffer.toString());
    console.log(drugCurrentState);
    return drugCurrentState;
  } catch (err) {
    console.log("Failed to get Drug Current State. Error : " + err);
  } finally {
    helper.disconnect();
  }
}

module.exports.main = main;
