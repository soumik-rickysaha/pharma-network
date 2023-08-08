"use strict";

// Import Librarie

const express = require("express");
const cors = require("cors");
const app = express();
const port = 3000;

// Import Chaincode Clinet Functions
const addToWallet = require("./1_addToWallet");
const registerCompany = require("./2_registerCompany");
const addDrug = require("./3_addDrug");
const createPO = require("./4_createPO");
const createShipment = require("./5_createShipment");
const updateShipment = require("./6_updateShipment");
const retailDrug = require("./7_retailDrug");
const viewHistory = require("./8_viewHistory");
const viewDrugCurrentState = require("./9_viewDrugCurrentState");
const { reset } = require("nodemon");

// Set express Server
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.set("title", "Pharma Network");

// Create Request and Response Function for Each function supported by Pharma-Network Chaincode

/**
 * @description This fucntion will be used as welcome message
 * @param {*} req The request sent by the user
 * @param {*} res This response that will be sent to the user
 */

app.get("/", (req, res) => res.send("Welcome to Pharma-Network"));

/**
 * @description This fucntion will be used as welcome message
 * @param {*} req The request sent by the user
 * @param {*} res This response that will be sent to the user
 */

app.post("/addToWallet", (req, res) => {
  addToWallet
    .main(req.body.certificatePath, req.body.privateKeyFilePath, req.body.organisationRole)
    .then(() => {
      //   console.log("User Credentials added to wallet");
      const result = {
        status: "success",
        message: "User credentials added to wallet",
      };
      res.json(result);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});

/**
 * @description This fucntion will be used as welcome message
 * @param {*} req The request sent by the user
 * @param {*} res This response that will be sent to the user
 */

app.post("/registerCompany", (req, res) => {
  registerCompany
    .main(req.body.companyCRN, req.body.companyName, req.body.Location, req.body.organisationRole)
    .then((output) => {
      //   console.log("User Credentials added to wallet");
      res.json(output);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});

app.post("/addDrug", (req, res) => {
  addDrug
    .main(req.body.drugName, req.body.serialNo, req.body.mfgDate, req.body.expDate, req.body.companyCRN, req.body.organisationRole)
    .then((output) => {
      //   console.log("User Credentials added to wallet");
      res.json(output);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});

app.post("/createPO", (req, res) => {
  createPO
    .main(req.body.buyerCRN, req.body.sellerCRN, req.body.drugName, req.body.quantity, req.body.organisationRole)
    .then((output) => {
      //   console.log("User Credentials added to wallet");
      res.json(output);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});

app.post("/createShipment", (req, res) => {
  createShipment
    .main(req.body.buyerCRN, req.body.drugName, req.body.listOfAssets, req.body.transporterCRN, req.body.organisationRole)
    .then((output) => {
      //   console.log("User Credentials added to wallet");
      res.json(output);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});

app.post("/updateShipment", (req, res) => {
  updateShipment
    .main(req.body.buyerCRN, req.body.drugName, req.body.transporterCRN, req.body.organisationRole)
    .then((output) => {
      //   console.log("User Credentials added to wallet");
      res.json(output);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});

app.post("/retailDrug", (req, res) => {
  retailDrug
    .main(req.body.drugName, req.body.serialNo, req.body.retailerCRN, req.body.customerAadhar, req.body.organisationRole)
    .then((output) => {
      //   console.log("User Credentials added to wallet");
      res.json(output);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});

app.post("/viewHistory", (req, res) => {
  viewHistory
    .main(req.body.drugName, req.body.serialNo, req.body.organisationRole)
    .then((output) => {
      //   console.log("User Credentials added to wallet");
      res.json(output);
    })
    .catch((e) => {
      const result = {
        status: "error",
        message: "Failed",
        error: e,
      };
      res.status(500).send(result);
    });
});


app.post("/viewDrugCurrentState", (req, res) => {
    viewDrugCurrentState
      .main(req.body.drugName, req.body.serialNo, req.body.organisationRole)
      .then((output) => {
        //   console.log("User Credentials added to wallet");
        res.json(output);
      })
      .catch((e) => {
        const result = {
          status: "error",
          message: "Failed",
          error: e,
        };
        res.status(500).send(result);
      });
  });
app.listen(port, () => console.log(`Pharma Network is running on port ${port}`));
