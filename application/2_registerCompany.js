"use strict";

const helper = require("./contractHelper");

/**
 * @description This fucntion will be used to register Companies
 * @param {*} companyCRN This field stores the composite key with which the company will get registered on the network. The key comprises the Company Registration Number (CRN) and the Name of the company along with appropriate namespace
 * @param {*} companyName Name of the company
 * @param {*} Location Location of the company
 * @param {*} organisationRole  This field will represent the Organization role
 */

async function main(companyCRN, companyName, Location, organisationRole) {
  let responseBuffer;

  try {
    const contract = await helper.getContractInstance(organisationRole);
    responseBuffer = await contract.submitTransaction("registerCompany", companyCRN, companyName, Location, organisationRole.toUpperCase());
    const company = JSON.parse(responseBuffer.toString());
    console.log(company);
    return company;
  } catch (err) {
    let errmsg = "Failed to register company. Error : " + responseBuffer.toString();
    console.log("Failed to register company. Error : " + errmsg);
    return errmsg;
  } finally {
    helper.disconnect();
  }
}

module.exports.main = main;
