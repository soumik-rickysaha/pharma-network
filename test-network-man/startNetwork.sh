export PATH=${PWD}/../bin:$PATH
mkdir temp
mkdir temp/GenesisBlock
mkdir temp/Channel
mkdir temp/AnchorPeerTx
mkdir temp/OrgInfo

# Setup crypto materials
cryptogen generate --config=./organizations/cryptogen/crypto-config-Consumer.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-Distributor.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-Manufacturer.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-orderer.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-Retailer.yaml --output="organizations"
cryptogen generate --config=./organizations/cryptogen/crypto-config-Transporter.yaml --output="organizations"

#setup configtx config file
export FABRIC_CFG_PATH=${PWD}/configtx

#Create genesis Block
configtxgen -outputBlock ./Blocks/pharma-genesis.block -profile FiveOrgsApplicationGenesis -channelID ordererChannel
# Output the Block details in JSON File. Please create temp folder else it will result in failure
configtxgen -inspectBlock ./Blocks/pharma-genesis.block > temp/GenesisBlock/pharma-genesis.json


#Create Channel
configtxgen -outputCreateChannelTx ./Channels/pharma-channel.tx -profile FiveOrgsApplicationGenesis -channelID pharmachannel
# Output the ChannelTX details in JSON File. Please create temp folder else it will result in failure
configtxgen -inspectChannelCreateTx ./Channels/pharma-channel.tx > temp/Channel/pharma-channel.json

#Update Anchor Peers
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/ConsumerAnchors.tx -profile FiveOrgsApplicationGenesis -channelID pharmachannel -asOrg ConsumerMSP
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/DistributorAnchors.tx -profile FiveOrgsApplicationGenesis -channelID pharmachannel -asOrg DistributorMSP
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/ManufacturerAnchors.tx -profile FiveOrgsApplicationGenesis -channelID pharmachannel -asOrg ManufacturerMSP
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/RetailerAnchors.tx -profile FiveOrgsApplicationGenesis -channelID pharmachannel -asOrg RetailerMSP
configtxgen -outputAnchorPeersUpdate ./AnchorPeerTrans/TransporterAnchors.tx -profile FiveOrgsApplicationGenesis -channelID pharmachannel -asOrg TransporterMSP

# Output the ChannelTX details in JSON File. Please create temp folder else it will result in failure
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/ConsumerAnchors.tx > temp/AnchorPeerTx/ConsumerAnchors.json
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/DistributorAnchors.tx > temp/AnchorPeerTx/DistributorAnchors.json
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/ManufacturerAnchors.tx > temp/AnchorPeerTx/ManufacturerAnchors.json
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/RetailerAnchors.tx > temp/AnchorPeerTx/RetailerAnchors.json
configtxgen -inspectChannelCreateTx ./AnchorPeerTrans/TransporterAnchors.tx > temp/TAnchorPeerTx/ransporterAnchors.json

#Print information on Organization
configtxgen -printOrg ConsumerMSP > temp/OrgInfo/ConsumerMSP.json
configtxgen -printOrg DistributorMSP > temp/OrgInfo/DistributorMSP.json
configtxgen -printOrg ManufacturerMSP > temp/OrgInfo/ManufacturerMSP.json
configtxgen -printOrg RetailerMSP > temp/OrgInfo/RetailerMSP.json
configtxgen -printOrg TransporterMSP > temp/OrgInfo/TransporterMSP.json