"use strict";

const fs = require("fs");
const { Wallets } = require("fabric-network");


/**
 * @description This fucntion will be used to create Identities
 * @param {*} certificatePath This will contain user certificate path
 * @param {*} privateKeyFilePath This will contain user private key path
 * @param {*} organisationRole This will contain user Organization details
 */

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
