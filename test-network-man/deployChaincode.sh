# Setting the ENV variables
export PATH=${PWD}/../bin:$PATH
export CHANNEL_NAME=pharmachannel
export CC_NAME=pharmanet
export CC_SRC_PATH=../chaincodes
export CC_RUNTIME_LANGUAGE=node
export CC_VERSION=1.0
export CC_SEQUENCE=1
# export FABRIC_CFG_PATH=${PWD}/configtx
export FABRIC_CFG_PATH=$PWD/../config/

# sleep 10
# Package the chaincode
echo    '================ Packging the chancode================'
peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION}

# Deploy of chaincode on all ORGS
echo    '================ Deploying the chancode on peer0 of Manufacturer ================'
# export ORDERER_CA=${PWD}/organizations/ordererOrganizations/pharma-network.com/orderers/orderer.pharma-network.com/msp/tlscacerts/tlsca.pharma-network.com-cert.pem
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/pharma-network.com/orderers/orderer.pharma-network.com/msp/cacerts/ca.pharma-network.com-cert.pem
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer0.Manufacturer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:11051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 5

echo    '================ Deploying the chancode on peer1 of Manufacturer ================'
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer1.Manufacturer.pharma-network.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:12051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 5

echo    '================ Deploying the chancode on peer0 of Consumer ================'
export CORE_PEER_LOCALMSPID="ConsumerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/peers/peer0.Consumer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/users/Admin@Consumer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 5

echo    '================ Deploying the chancode on peer1 of Consumer ================'
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/peers/peer0.Consumer.pharma-network.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:8051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 5

echo    '================ Deploying the chancode on peer0 of Distributor ================'
export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/peers/peer0.Distributor.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/users/Admin@Distributor.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:9051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 5

echo    '================ Deploying the chancode on peer1 of Distributor ================'
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/peers/peer1.Distributor.pharma-network.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:10051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 5

echo    '================ Deploying the chancode on peer0 of Retailer ================'
export CORE_PEER_LOCALMSPID="RetailerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/peers/peer0.Retailer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/users/Admin@Retailer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:13051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 5

echo    '================ Deploying the chancode on peer1 of Retailer ================'
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/peers/peer1.Retailer.pharma-network.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:14051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 5

echo    '================ Deploying the chancode on peer0 of Transporter ================'
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer0.Transporter.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/users/Admin@Transporter.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:15051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 5

echo    '================ Deploying the chancode on peer1 of Transporter ================'
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer1.Transporter.pharma-network.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:16051
peer lifecycle chaincode install ${CC_NAME}.tar.gz

sleep 20
# Query the chaincode
chaincodePackageID=$(peer lifecycle chaincode queryinstalled | sed -n 's/^Package ID: \(.*\), Label:.*/\1/p')

# Check if the variable is empty (meaning the command failed)
if [ -z "$chaincodePackageID" ]; then
  echo "Failed to retrieve the Chaincode ID"
  exit 1
fi

# Storing the package ID in the 'PACKAGE_ID' environment variable
export PACKAGE_ID=$chaincodePackageID

echo "Package ID: $chaincodePackageID"
echo "Package ID stored in PACKAGE_ID environment variable: $PACKAGE_ID"

# Approval Transaction for all ORG's

echo    '================ Approving the Chaincode for the Org : Manufacturer ================'
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer0.Manufacturer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:11051
peer lifecycle chaincode approveformyorg -o localhost:7050 --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}
peer lifecycle chaincode checkcommitreadiness --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --output json > temp/Chaincode/CommitReadiness.json

echo    '================ Approving the Chaincode for the Org : Consumer ================'
export CORE_PEER_LOCALMSPID="ConsumerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/peers/peer0.Consumer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/users/Admin@Consumer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:7051
peer lifecycle chaincode approveformyorg -o localhost:7050 --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}
peer lifecycle chaincode checkcommitreadiness --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --output json > temp/Chaincode/CommitReadiness.json

echo    '================ Approving the Chaincode for the Org : Distributor ================'
export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/peers/peer0.Distributor.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/users/Admin@Distributor.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:9051
peer lifecycle chaincode approveformyorg -o localhost:7050 --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}
peer lifecycle chaincode checkcommitreadiness --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --output json > temp/Chaincode/CommitReadiness.json

echo    '================ Approving the Chaincode for the Org : Retailer ================'
export CORE_PEER_LOCALMSPID="RetailerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/peers/peer0.Retailer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/users/Admin@Retailer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:13051
peer lifecycle chaincode approveformyorg -o localhost:7050 --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}
peer lifecycle chaincode checkcommitreadiness --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --output json > temp/Chaincode/CommitReadiness.json

echo    '================ Approving the Chaincode for the Org : Transporter ================'
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer0.Transporter.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/users/Admin@Transporter.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:15051
peer lifecycle chaincode approveformyorg -o localhost:7050 --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE}
peer lifecycle chaincode checkcommitreadiness --channelID pharmachannel --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --output json > temp/Chaincode/CommitReadiness.json

sleep 20


echo    '================ Commiting Chaincode ================'
peer lifecycle chaincode commit -o localhost:7050 --cafile $ORDERER_CA --channelID pharmachannel --name ${CC_NAME} --peerAddresses localhost:11051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer0.Manufacturer.pharma-network.com/tls/ca.crt --peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/peers/peer0.Consumer.pharma-network.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/peers/peer0.Distributor.pharma-network.com/tls/ca.crt --peerAddresses localhost:13051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/peers/peer0.Retailer.pharma-network.com/tls/ca.crt --peerAddresses localhost:15051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer0.Transporter.pharma-network.com/tls/ca.crt --version ${CC_VERSION} --sequence ${CC_SEQUENCE} #--init-required #--signature-policy "OR ('ManufacturerMSP.peer','DistributorMSP.peer','ConsumerMSP.peer','RetailerMSP.peer','TransporterMSP.peer')"

sleep 10

peer lifecycle chaincode querycommitted --channelID pharmachannel --name ${CC_NAME}

sleep 5
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"Args":["pharmanet:instantiate"]}' --cafile $ORDERER_CA

sleep 5

peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"registerCompany","Args":["1","testCompany","Mars","1"]}' --cafile $ORDERER_CA

peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"getRegisterCompany","Args":["1"]}' --cafile $ORDERER_CA