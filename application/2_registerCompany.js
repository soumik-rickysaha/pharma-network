"use strict";

const helper = require("./contractHelper");

async function main(companyCRN, companyName, Location, organisationRole) {
  try {
    const contract = await helper.getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("registerCompany", companyCRN, companyName, Location, organisationRole.toUpperCase());
    const company = JSON.parse(responseBuffer.toString());
    console.log(company);
    return company;
  } catch (err) {
    console.log("Failed to register company. Error : " + err);
  } finally {
    helper.disconnect();
  }
}

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main=main;
