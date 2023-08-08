"use strict";

const fs = require("fs");
const { Wallets, Gateway } = require("fabric-network");
const yaml = require("js-yaml");
let gateway;

async function getContractInstance(organisationRole) {
  gateway = new Gateway();
  const conProfile = yaml.load(fs.readFileSync("./ccp-Manufacturer.yaml", "utf-8"));

  const wallet = await Wallets.newFileSystemWallet("./identity/Orgs/" + organisationRole);
  const identity = "Admin_" + organisationRole;
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

function disconnect(){
    gateway.disconnect();
}

module.exports.getContractInstance=getContractInstance;
module.exports.disconnect=disconnect;