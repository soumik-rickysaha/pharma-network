# Creating channel
echo    '================ Creating Channel on Orderer ================'
export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
# export FABRIC_CFG_PATH=${PWD}/configtx
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/pharma-network.com/orderers/orderer.pharma-network.com/msp/cacerts/ca.pharma-network.com-cert.pem
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer0.Manufacturer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:11051
peer channel create -o localhost:7050 -c pharmachannel -f ./Channels/pharma-channel.tx --outputBlock "./Blocks/pharma-channel.block" --cafile $ORDERER_CA

# Setting block ENV variable
echo    '================ Setting Block File ================'
export BLOCKFILE="./Blocks/pharma-channel.block"


# Joinning peers of Manufacturers 
echo    '================ Joinning peer0 of Manufacturer ================'
peer channel join -b $BLOCKFILE



echo    '================ Joinning peer1 of Manufacturer ================'
export CORE_PEER_ADDRESS=localhost:12051
peer channel join -b $BLOCKFILE

# Joinning peers of Consumers
echo    '================ Joinning peer0 of Consumer ================'
export CORE_PEER_LOCALMSPID="ConsumerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/peers/peer0.Consumer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/users/Admin@Consumer.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:7051
peer channel join -b $BLOCKFILE


echo    '================ Joinning peer1 of Consumer ================'
export CORE_PEER_ADDRESS=localhost:8051
peer channel join -b $BLOCKFILE

# Joinning peers of Distributor
echo    '================ Joinning peer0 of Distributor ================'
export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/peers/peer0.Distributor.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/users/Admin@Distributor.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:9051
peer channel join -b $BLOCKFILE


echo    '================ Joinning peer1 of Distributor ================'
export CORE_PEER_ADDRESS=localhost:10051
peer channel join -b $BLOCKFILE

echo    '================ Joinning peer0 of Retailer ================'
export CORE_PEER_LOCALMSPID="RetailerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/peers/peer0.Retailer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/users/Admin@Retailer.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:13051
peer channel join -b $BLOCKFILE


echo    '================ Joinning peer1 of Retailer ================'
export CORE_PEER_ADDRESS=localhost:14051
peer channel join -b $BLOCKFILE

echo    '================ Joinning peer0 of Transporter ================'
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer0.Transporter.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/users/Admin@Transporter.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:15051
peer channel join -b $BLOCKFILE


echo    '================ Joinning peer1 of Transporter ================'
export CORE_PEER_ADDRESS=localhost:16051
peer channel join -b $BLOCKFILE

echo    '================ Updating Anchor Peers : Manufacturers ================'
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/peers/peer0.Manufacturer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.pharma-network.com/users/Admin@Manufacturer.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:11051
peer channel update -o localhost:7050 -c pharmachannel -f ./AnchorPeerTrans/ManufacturerAnchors.tx --cafile $ORDERER_CA

echo    '================ Updating Anchor Peers : Consumer ================'
export CORE_PEER_LOCALMSPID="ConsumerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/peers/peer0.Consumer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Consumer.pharma-network.com/users/Admin@Consumer.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:7051
peer channel update -o localhost:7050 -c pharmachannel -f ./AnchorPeerTrans/ConsumerAnchors.tx --cafile $ORDERER_CA

echo    '================ Updating Anchor Peers : Distributor ================'
export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/peers/peer0.Distributor.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.pharma-network.com/users/Admin@Distributor.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:9051
peer channel update -o localhost:7050 -c pharmachannel -f ./AnchorPeerTrans/DistributorAnchors.tx --cafile $ORDERER_CA

echo    '================ Updating Anchor Peers : Retailer ================'
export CORE_PEER_LOCALMSPID="RetailerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/peers/peer0.Retailer.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Retailer.pharma-network.com/users/Admin@Retailer.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:13051
peer channel update -o localhost:7050 -c pharmachannel -f ./AnchorPeerTrans/RetailerAnchors.tx --cafile $ORDERER_CA

echo    '================ Updating Anchor Peers : Transporter ================'
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer0.Transporter.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.pharma-network.com/users/Admin@Transporter.pharma-network.com/msp/
export CORE_PEER_ADDRESS=localhost:15051
peer channel update -o localhost:7050 -c pharmachannel -f ./AnchorPeerTrans/TransporterAnchors.tx --cafile $ORDERER_CA

sleep 20