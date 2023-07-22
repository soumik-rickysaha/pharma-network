# Creating channel
echo    '================ Creating Channel on Orderer ================'
export PATH=${PWD}/../bin:$PATH
# export FABRIC_CFG_PATH=$PWD/../config/
export FABRIC_CFG_PATH=${PWD}/configtx
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/cacerts/ca.example.com-cert.pem
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Manufacturer.example.com/peers/peer0.Manufacturer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Manufacturer.example.com/users/Admin@Manufacturer.example.com/msp/
export CORE_PEER_ADDRESS=localhost:11051
peer channel create -o 0.0.0.0:7050 -c pharmachannel --ordererTLSHostnameOverride orderer.example.com -f ./Channels/pharma-channel.tx --outputBlock "./Blocks/pharma-channel.block" --cafile $ORDERER_CA

# Setting block ENV variable
echo    '================ Setting Block File ================'
export BLOCKFILE="./Blocks/pharma-channel.block"


# Joinning peers of Manufacturers 
echo    '================ Joinning peer0 of Manufacturer ================'
peer channel join -b $BLOCKFILE
# peer channel update -o 0.0.0.0:7050 -c pharmachannel -f ./AnchorPeerTrans/ManufacturerAnchors.tx --cafile $ORDERER_CA

echo    '================ Joinning peer1 of Manufacturer ================'
export CORE_PEER_ADDRESS=localhost:12051
peer channel join -b $BLOCKFILE

# Joinning peers of Consumers
echo    '================ Joinning peer0 of Consumer ================'
export CORE_PEER_LOCALMSPID="ConsumerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Consumer.example.com/peers/peer0.Consumer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Consumer.example.com/users/Admin@Consumer.example.com/msp/
export CORE_PEER_ADDRESS=localhost:7051
peer channel join -b $BLOCKFILE
# peer channel update -o 0.0.0.0:7050 -c pharmachannel -f ./AnchorPeerTrans/ConsumerAnchors.tx --cafile $ORDERER_CA

echo    '================ Joinning peer1 of Consumer ================'
export CORE_PEER_ADDRESS=localhost:8051
peer channel join -b $BLOCKFILE

# Joinning peers of Distributor
echo    '================ Joinning peer0 of Distributor ================'
export CORE_PEER_LOCALMSPID="DistributorMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Distributor.example.com/peers/peer0.Distributor.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Distributor.example.com/users/Admin@Distributor.example.com/msp/
export CORE_PEER_ADDRESS=localhost:9051
peer channel join -b $BLOCKFILE
# peer channel update -o 0.0.0.0:7050 -c pharmachannel -f ./AnchorPeerTrans/DistributorAnchors.tx --cafile $ORDERER_CA

echo    '================ Joinning peer1 of Distributor ================'
export CORE_PEER_ADDRESS=localhost:10051
peer channel join -b $BLOCKFILE

echo    '================ Joinning peer0 of Retailer ================'
export CORE_PEER_LOCALMSPID="RetailerMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Retailer.example.com/peers/peer0.Retailer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Retailer.example.com/users/Admin@Retailer.example.com/msp/
export CORE_PEER_ADDRESS=localhost:13051
peer channel join -b $BLOCKFILE
# peer channel update -o 0.0.0.0:7050 -c pharmachannel -f ./AnchorPeerTrans/RetailerAnchors.tx --cafile $ORDERER_CA

echo    '================ Joinning peer1 of Retailer ================'
export CORE_PEER_ADDRESS=localhost:14051
peer channel join -b $BLOCKFILE

echo    '================ Joinning peer0 of Transporter ================'
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/Transporter.example.com/peers/peer0.Transporter.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/Transporter.example.com/users/Admin@Transporter.example.com/msp/
export CORE_PEER_ADDRESS=localhost:15051
peer channel join -b $BLOCKFILE
# peer channel update -o 0.0.0.0:7050 -c pharmachannel -f ./AnchorPeerTrans/TransporterAnchors.tx --cafile $ORDERER_CA

echo    '================ Joinning peer1 of Transporter ================'
export CORE_PEER_ADDRESS=localhost:16051
peer channel join -b $BLOCKFILE