# Setting the ENV variables
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/

export ORDERER_CA=${PWD}/organizations/ordererOrganizations/pharma-network.com/orderers/orderer.pharma-network.com/msp/cacerts/ca.pharma-network.com-cert.pem
# Deploy of chaincode on all ORGS
echo '================ Register Company ================'

export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer0.Manufacturer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:11051
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"registerCompany","Args":["MAN001","Sun Pharma","Chennai","MANUFACTURER"]}' --cafile $ORDERER_CA

sleep 2

export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/peers/peer0.Distributor.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/users/Admin@Distributor.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:9051
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"registerCompany","Args":["DIST001","VG Pharma","Vizag","Distributor"]}' --cafile $ORDERER_CA

sleep 2

export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer0.Transporter.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/users/Admin@Transporter.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:15051
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"registerCompany","Args":["TRA001","FedEx","Delhi","Transporter"]}' --cafile $ORDERER_CA
sleep 2
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"registerCompany","Args":["TRA002","Blue Dart","Bangalore","Transporter"]}' --cafile $ORDERER_CA

sleep 2

export CORE_PEER_LOCALMSPID="RetailerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/peers/peer0.Retailer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/users/Admin@Retailer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:13051
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"registerCompany","Args":["RET002","Upgrad","Mumbai","Retailer"]}' --cafile $ORDERER_CA

sleep 2

echo '================ Add Drug================'

export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer0.Manufacturer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:11051

peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"addDrug","Args":["Paracetamol","001","1/1/2020","1/1/2023","MAN001-Sun Pharma"]}' --cafile $ORDERER_CA

sleep 1
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"addDrug","Args":["Paracetamol","002","1/1/2020","1/1/2023","MAN001-Sun Pharma"]}' --cafile $ORDERER_CA
sleep 1

peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"addDrug","Args":["Paracetamol","003","1/1/2020","1/1/2023","MAN001-Sun Pharma"]}' --cafile $ORDERER_CA
sleep 1

peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"addDrug","Args":["Paracetamol","004","1/1/2020","1/1/2023","MAN001-Sun Pharma"]}' --cafile $ORDERER_CA
sleep 1

sleep 2
echo '================ View Drug Current state ================'
peer chaincode invoke -o localhost:9051 -C pharmachannel -n pharmanet -c '{"function":"viewDrugCurrentState","Args":["Paracetamol","001"]}' --cafile $ORDERER_CA

echo '================ Part A ================'

echo '================ Create PO ================'
export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/peers/peer0.Distributor.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/users/Admin@Distributor.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:9051

peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"createPO","Args":["DIST001-VG Pharma","MAN001-Sun Pharma","Paracetamol","2"]}' --cafile $ORDERER_CA

sleep 2
echo '================ View Drug Current state ================'
peer chaincode invoke -o localhost:9051 -C pharmachannel -n pharmanet -c '{"function":"viewDrugCurrentState","Args":["Paracetamol","001"]}' --cafile $ORDERER_CA

sleep 2

echo '================ Create Shipment ================'
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer0.Manufacturer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:11051
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"createShipment","Args":["DIST001-VG Pharma","Paracetamol","[\"001\",\"002\"]","TRA001-FedEx"]}' --cafile $ORDERER_CA

sleep 2
echo '================ View Drug Current state ================'
peer chaincode invoke -o localhost:9051 -C pharmachannel -n pharmanet -c '{"function":"viewDrugCurrentState","Args":["Paracetamol","001"]}' --cafile $ORDERER_CA

sleep 2
echo '================ Update Shipment ================'
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer0.Transporter.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/users/Admin@Transporter.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:15051
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"updateShipment","Args":["DIST001-VG Pharma","Paracetamol","TRA001-FedEx"]}' --cafile $ORDERER_CA

sleep 2
echo '================ View Drug Current state ================'
peer chaincode invoke -o localhost:9051 -C pharmachannel -n pharmanet -c '{"function":"viewDrugCurrentState","Args":["Paracetamol","001"]}' --cafile $ORDERER_CA

echo '================ Part B ================'

echo '================ Create PO ================'
export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/peers/peer0.Distributor.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/users/Admin@Distributor.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:9051

peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"createPO","Args":["RET002-Upgrad","DIST001-VG Pharma","Paracetamol","2"]}' --cafile $ORDERER_CA

sleep 2
echo '================ View Drug Current state ================'
peer chaincode invoke -o localhost:9051 -C pharmachannel -n pharmanet -c '{"function":"viewDrugCurrentState","Args":["Paracetamol","001"]}' --cafile $ORDERER_CA

sleep 2

echo '================ Create Shipment ================'
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer0.Manufacturer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:11051
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"createShipment","Args":["RET002-Upgrad","Paracetamol","[\"001\",\"002\"]","TRA002-Blue Dart"]}' --cafile $ORDERER_CA

sleep 2
echo '================ View Drug Current state ================'
peer chaincode invoke -o localhost:9051 -C pharmachannel -n pharmanet -c '{"function":"viewDrugCurrentState","Args":["Paracetamol","001"]}' --cafile $ORDERER_CA

sleep 2
echo '================ Update Shipment ================'
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer0.Transporter.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/users/Admin@Transporter.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:15051
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"updateShipment","Args":["RET002-Upgrad","Paracetamol","TRA002-Blue Dart"]}' --cafile $ORDERER_CA

sleep 2
echo '================ View Drug Current state ================'
peer chaincode invoke -o localhost:9051 -C pharmachannel -n pharmanet -c '{"function":"viewDrugCurrentState","Args":["Paracetamol","001"]}' --cafile $ORDERER_CA

sleep 2
echo '================ Retail Drug ================'
export CORE_PEER_LOCALMSPID="RetailerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/peers/peer0.Retailer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/users/Admin@Retailer.pharma-network.com/msp
export CORE_PEER_ADDRESS=localhost:13051
peer chaincode invoke -o localhost:7050 -C pharmachannel -n pharmanet -c '{"function":"retailDrug","Args":["Paracetamol","001","RET002-Upgrad","AAD001"]}' --cafile $ORDERER_CA

sleep 2
echo '================ View Drug Current state ================'
peer chaincode invoke -o localhost:9051 -C pharmachannel -n pharmanet -c '{"function":"viewDrugCurrentState","Args":["Paracetamol","001"]}' --cafile $ORDERER_CA

sleep 2
echo '================ View Drug History ================'
peer chaincode invoke -o localhost:9051 -C pharmachannel -n pharmanet -c '{"function":"viewHistory","Args":["Paracetamol","001"]}' --cafile $ORDERER_CA

