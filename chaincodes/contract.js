'use strict';

const {Contract} = require('fabric-contract-api');

class CertnetContract extends Contract{
    
    constructor(){
        super('certnet');
    }

    // Instantiate

    async instantiate(ctx){
        console.log('Chaincode was successfully deployed');
    }
}

module.exports= CertnetContract;