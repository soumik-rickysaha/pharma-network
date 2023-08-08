"use strict";

const fs = require("fs");
const { Wallets, Gateway } = require("fabric-network");
const yaml = require("js-yaml");
let gateway;

async function getContractInstance(organisationRole) {
  gateway = new Gateway();
  const conProfile = yaml.load(fs.readFileSync("./ccp-Manufacturer.yaml", "utf-8"));

  const wallet = await Wallets.newFileSystemWallet("./identity/Orgs/Manufacturer");
  const identity="Admin_"+ organisationRole;
  const gatewayOptions = {
    wallet: wallet,
    identity: identity,
    discovery: {
      enable: true,
      asLocalhost: true,
    },
  };

  await gateway.connect(conProfile, gatewayOptions);
  const channel = await gateway.getNetwork("pharmachannel");
  return channel.getContract("pharmanet", "pharmanet");
}

async function main(companyCRN, companyName, Location, organisationRole) {
  try {
    const contract = await getContractInstance(organisationRole);
    const responseBuffer = await contract.submitTransaction("registerCompany", companyCRN, companyName, Location, organisationRole.toUpperCase());
    const company = JSON.parse(responseBuffer.toString());
    console.log(company);
    return company;
  } catch (err) {
    console.log("Failed to register company. Error : " + err);
  } finally {
    gateway.disconnect();
  }
}

main("MAN001", "Sun Pharma", "Chennai", "Manufacturer");
