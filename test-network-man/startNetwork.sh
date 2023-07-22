
echo    '================ Setting Path ================'
export PATH=${PWD}/../bin:$PATH

echo    '================ Creating Folders ================'
mkdir temp
mkdir temp/GenesisBlock
mkdir temp/Channel
mkdir temp/AnchorPeerTx
mkdir temp/OrgInfo


# Setup crypto materials
echo    '================ Generating crypto Materials================'
cryptogen generate --config=./organizations/cryptogen/crypto-config-Consumer.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-Distributor.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-Manufacturer.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-Retailer.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-Transporter.yaml --output="organizations"

#setup configtx config file
echo    '================ Setting ConfigTx Path ================'
export FABRIC_CFG_PATH=${PWD}/configtx

#Create genesis Block
echo    '================ Generating Geneis Block for Orderer ================'
configtxgen -outputBlock ./Blocks/pharma-genesis.block -profile PharmaOrdererGenesis -channelID ordererchannel
# Output the Block details in JSON File. Please create temp folder else it will result in failure
echo    '================ Generating JSON Output for Genesis Block ================'
configtxgen -inspectBlock ./Blocks/pharma-genesis.block > temp/GenesisBlock/pharma-genesis.json


#Create Channel
echo    '================ Generating PharmaChannel ================'
configtxgen -outputCreateChannelTx ./Channels/pharma-channel.tx -profile PharmaMainChannel -channelID pharmachannel
# Output the ChannelTX details in JSON File. Please create temp folder else it will result in failure
echo    '================ Generating JSON Output for the Pharma Channel ================'
configtxgen -inspectChannelCreateTx ./Channels/pharma-channel.tx > temp/Channel/pharma-channel.json

#Update Anchor Peers
echo    '================ Updating Anchor Peers ================'
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/ConsumerAnchors.tx -profile PharmaMainChannel -channelID pharmachannel -asOrg ConsumerMSP
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/DistributorAnchors.tx -profile PharmaMainChannel -channelID pharmachannel -asOrg DistributorMSP
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/ManufacturerAnchors.tx -profile PharmaMainChannel -channelID pharmachannel -asOrg ManufacturerMSP
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/RetailerAnchors.tx -profile PharmaMainChannel -channelID pharmachannel -asOrg RetailerMSP
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/TransporterAnchors.tx -profile PharmaMainChannel -channelID pharmachannel -asOrg TransporterMSP

# Output the ChannelTX details in JSON File. Please create temp folder else it will result in failure
echo    '================ Generating JSON output for Anchor Peers ================'
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/ConsumerAnchors.tx > temp/AnchorPeerTx/ConsumerAnchors.json
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/DistributorAnchors.tx > temp/AnchorPeerTx/DistributorAnchors.json
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/ManufacturerAnchors.tx > temp/AnchorPeerTx/ManufacturerAnchors.json
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/RetailerAnchors.tx > temp/AnchorPeerTx/RetailerAnchors.json
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/TransporterAnchors.tx > temp/AnchorPeerTx/ransporterAnchors.json

#Print information on Organization
echo    '================ Generating Informtion on Organizations ================'
configtxgen -printOrg ConsumerMSP > temp/OrgInfo/ConsumerMSP.json
configtxgen -printOrg DistributorMSP > temp/OrgInfo/DistributorMSP.json
configtxgen -printOrg ManufacturerMSP > temp/OrgInfo/ManufacturerMSP.json
configtxgen -printOrg RetailerMSP > temp/OrgInfo/RetailerMSP.json
configtxgen -printOrg TransporterMSP > temp/OrgInfo/TransporterMSP.json

echo    '================ Starting Dockers ================'

docker compose -f dockers/docker-compose-pharmaNet.yaml -f dockers/docker-compose-ca.yaml up -d
# sleep 15
