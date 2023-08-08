"use strict";

const fs = require("fs");
const { Wallets } = require("fabric-network");

async function main(certificatePath, privateKeyFilePath, organisationRole) {
  try {
    const wallet = await Wallets.newFileSystemWallet("./identity/Orgs/" + organisationRole);
    const certificate = fs.readFileSync(certificatePath).toString();
    const keyFile = fs.readFileSync(privateKeyFilePath).toString();
    const mspId = organisationRole + "MSP";
    const label = "Admin_" + organisationRole;

    const identity = {
      credentials: {
        certificate: certificate,
        privateKey: keyFile,
      },
      mspId: mspId,
      type: "X.509",
    };

    await wallet.put(label, identity);
    console.log("Successfully added user to wallet");
    return "Successfully added user to wallet";
  } catch (err) {
    console.log("Failed to add user to wallet. Error :" + err);
    return "Failed to add user to wallet. Error :" + err;
  }
}

module.exports.main = main;
// const certPath="/home/soumik/All_DEV/BlockChain/HyperLedger-Fabric/pharma-network/test-network-man/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp/signcerts/Admin@Manufacturer.pharma-network.com-cert.pem"
// const keyPath="/home/soumik/All_DEV/BlockChain/HyperLedger-Fabric/pharma-network/test-network-man/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp/keystore/priv_sk"
// main(certPath,keyPath,"Manufacturer");
