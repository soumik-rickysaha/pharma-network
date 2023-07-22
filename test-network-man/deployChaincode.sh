# Setting the ENV variables
export PATH=${PWD}/../bin:$PATH
export CHANNEL_NAME=pharmachannel
export CC_NAME=demo
export CC_SRC_PATH=../chaincodes
export CC_RUNTIME_LANGUAGE=node
export CC_VERSION=1.0
export CC_SEQUENCE=1
export FABRIC_CFG_PATH=${PWD}/configtx

# sleep 10
# Package the chaincode
echo    '================ Packging the chancode================'
peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION}

# Deploy of chaincode on all ORGS
echo    '================ Deploying the chancode on peer0 of Manufacturer ================'
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/cacerts/ca.example.com-cert.pem
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.example.com/peers/peer0.Manufacturer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.example.com/users/Admin@Manufacturer.example.com/msp/
export CORE_PEER_ADDRESS=localhost:11051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

echo    '================ Deploying the chancode on peer1 of Manufacturer ================'
export CORE_PEER_ADDRESS=localhost:12051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

echo    '================ Deploying the chancode on peer0 of Consumer ================'
export CORE_PEER_LOCALMSPID="ConsumerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Consumer.example.com/peers/peer0.Consumer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Consumer.example.com/users/Admin@Consumer.example.com/msp/
export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

echo    '================ Deploying the chancode on peer1 of Consumer ================'
export CORE_PEER_ADDRESS=localhost:8051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

echo    '================ Deploying the chancode on peer0 of Distributor ================'
export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.example.com/peers/peer0.Distributor.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.example.com/users/Admin@Distributor.example.com/msp/
export CORE_PEER_ADDRESS=localhost:9051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

echo    '================ Deploying the chancode on peer1 of Distributor ================'
export CORE_PEER_ADDRESS=localhost:10051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

echo    '================ Deploying the chancode on peer0 of Retailer ================'
export CORE_PEER_LOCALMSPID="RetailerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.example.com/peers/peer0.Retailer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Retailer.example.com/users/Admin@Retailer.example.com/msp/
export CORE_PEER_ADDRESS=localhost:13051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

echo    '================ Deploying the chancode on peer1 of Retailer ================'
export CORE_PEER_ADDRESS=localhost:14051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

echo    '================ Deploying the chancode on peer0 of Transporter ================'
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.example.com/peers/peer0.Transporter.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.example.com/users/Admin@Transporter.example.com/msp/
export CORE_PEER_ADDRESS=localhost:15051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

echo    '================ Deploying the chancode on peer1 of Transporter ================'
export CORE_PEER_ADDRESS=localhost:16051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

# Query the chaincode
chaincodePackageID= peer lifecycle chaincode queryinstalled

# Storing the package ID
export PACKAGE_ID=$chaincodePackageID

# Approval Transaction for all ORG's

echo    '================ Approving the Chaincode for the Org : Manufacturer ================'
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.example.com/peers/peer0.Manufacturer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.example.com/users/Admin@Manufacturer.example.com/msp/
export CORE_PEER_ADDRESS=localhost:11051
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}

echo    '================ Approving the Chaincode for the Org : Consumer ================'
export CORE_PEER_LOCALMSPID="ConsumerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Consumer.example.com/peers/peer0.Consumer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Consumer.example.com/users/Admin@Consumer.example.com/msp/
export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}

echo    '================ Approving the Chaincode for the Org : Distributor ================'
export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.example.com/peers/peer0.Distributor.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.example.com/users/Admin@Distributor.example.com/msp/
export CORE_PEER_ADDRESS=localhost:9051
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}

echo    '================ Approving the Chaincode for the Org : Retailer ================'
export CORE_PEER_LOCALMSPID="RetailerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.example.com/peers/peer0.Retailer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Retailer.example.com/users/Admin@Retailer.example.com/msp/
export CORE_PEER_ADDRESS=localhost:13051
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}

echo    '================ Approving the Chaincode for the Org : Transporter ================'
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.example.com/peers/peer0.Transporter.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.example.com/users/Admin@Transporter.example.com/msp/
export CORE_PEER_ADDRESS=localhost:15051
peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}


# Checking commit readiness for all the orgs
echo    '================ Checking Commit Readiness ================'
peer lifecycle chaincode checkcommitreadiness --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --output json > temp/Chaincode/CommitReadiness.json

# Commiting the chaincode
echo    '================ Commiting Chaincode ================'
peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME}  --peerAddresses localhost:11051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Manufacturer.example.com/peers/peer0.Manufacturer.example.com/tls/ca.crt --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Consumer.example.com/peers/peer0.Consumer.example.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Distributor.example.com/peers/peer0.Distributor.example.com/tls/ca.crt --peerAddresses localhost:13051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Retailer.example.com/peers/peer0.Retailer.example.com/tls/ca.crt --peerAddresses localhost:15051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Transporter.example.com/peers/peer0.Transporter.example.com/tls/ca.crt --version ${CC_VERSION} --sequence ${CC_SEQUENCE}