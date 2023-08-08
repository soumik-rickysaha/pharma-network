"use strict";

const helper = require("./contractHelper");

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

// main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
module.exports.main=main;
