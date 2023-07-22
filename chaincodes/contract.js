'use strict';

const {contract} = require('fabric-contract-api');

class CertnetContract extends contract{
    constructor(){
        super('pharmanet');
    }

    // Instantiate

    async instantiate(ctx){
        console.log('Chaincode was successfully deployed')
    }


    //1. Create Student

    async createStudent(ctx,studentID,name,email){
        
    }
    //2. Get Student
    //3. Issue Student
    //4. Verify Student


}

module.exports= CertnetContract;