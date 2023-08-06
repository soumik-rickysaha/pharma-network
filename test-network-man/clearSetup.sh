docker compose -f dockers/docker-compose-pharmaNet.yaml -f dockers/docker-compose-ca.yaml down
docker volume prune -f
docker rmi $(docker images --filter=reference="dev-peer*")



rm -rf /home/soumik/All_DEV/BlockChain/HyperLedger-Fabric/pharma-network/test-network-man/organizations/ordererOrganizations
rm -rf /home/soumik/All_DEV/BlockChain/HyperLedger-Fabric/pharma-network/test-network-man/organizations/peerOrganizations
rm -rf /home/soumik/All_DEV/BlockChain/HyperLedger-Fabric/pharma-network/test-network-man/Blocks
rm -rf /home/soumik/All_DEV/BlockChain/HyperLedger-Fabric/pharma-network/test-network-man/Channels
rm -rf /home/soumik/All_DEV/BlockChain/HyperLedger-Fabric/pharma-network/test-network-man/temp
rm -rf /home/soumik/All_DEV/BlockChain/HyperLedger-Fabric/pharma-network/test-network-man/AnchorPeerTrans