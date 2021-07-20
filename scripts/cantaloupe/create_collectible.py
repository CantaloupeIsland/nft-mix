#!/usr/bin/python3
from brownie import CantaloupeIsland, Contract, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT
from brownie.network.gas.strategies import GasNowStrategy
import json

gas_strategy = GasNowStrategy("slow")

uri_list = []

with open('/Users/adidonato/git_tree/nft-mix/scripts/cantaloupe/IPFSHASHES.log') as f:
    for line in f:
        print(line)
        uri_list.append(line)
#!!!!!!!!!!!!!!!!!!!!!!!!!!
##!!!!!!!!!!!!!!!!!!!!!
price = 100
#####################################

def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = CantaloupeIsland[len(CantaloupeIsland) - 1]
    # simple_collectible = CantaloupeIsland.deploy({"from": dev})
    uri_list.sort()
    for i, uri in enumerate(uri_list):
        transaction = simple_collectible.mintForSale(uri, price, {"from": dev})
        transaction.wait(1) # one confirmation
        print(
            "Awesome! You can view your NFT at {}".format(
                OPENSEA_FORMAT.format(simple_collectible.address, i)
            )
        )
        print('Please give up to 20 minutes, and hit the "refresh metadata" button')
