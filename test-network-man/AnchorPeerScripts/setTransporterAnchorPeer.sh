export PATH=${PWD}/../../bin:$PATH
export FABRIC_CFG_PATH=$PWD/../config/
# export FABRIC_CFG_PATH=${PWD}/../configtx
export ORDERER_CA=${PWD}/../organizations/ordererOrganizations/pharma-network.com/orderers/orderer.pharma-network.com/msp/cacerts/ca.pharma-network.com-cert.pem
export CORE_PEER_LOCALMSPID="TransporterMSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../organizations/peerOrganizations/Transporter.pharma-network.com/peers/peer0.Transporter.pharma-network.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../organizations/peerOrganizations/Transporter.pharma-network.com/users/Admin@Transporter.pharma-network.com/msp/
export CORE_PEER_ADDRESS=peer0.Transporter.pharma-network.com:15051
peer channel fetch config config_block.pb -o 0.0.0.0:7050 -c pharmachannel --cafile $ORDERER_CA

configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config >"${CORE_PEER_LOCALMSPID}config.json"
export HOST="peer0.Transporter.pharma-network.com:"
export PORT=15051
jq '.channel_group.groups.Application.groups.'${CORE_PEER_LOCALMSPID}'.values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "'$HOST'","port": '$PORT'}]},"version": "0"}}' ${CORE_PEER_LOCALMSPID}config.json > ${CORE_PEER_LOCALMSPID}modified_config.json

configtxlator proto_encode --input "${CORE_PEER_LOCALMSPID}config.json" --type common.Config >original_config.pb
configtxlator proto_encode --input "${CORE_PEER_LOCALMSPID}modified_config.json" --type common.Config >modified_config.pb
configtxlator compute_update --channel_id "pharmachannel" --original original_config.pb --updated modified_config.pb >config_update.pb
configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate >config_update.json
echo '{"payload":{"header":{"channel_header":{"channel_id":"pharmachannel", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . >config_update_in_envelope.json
configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope >"${CORE_PEER_LOCALMSPID}anchors.tx"

peer channel update -o 0.0.0.0:7050 -c pharmachannel -f ${CORE_PEER_LOCALMSPID}anchors.tx  --cafile $ORDERER_CA