#!/usr/bin/python3
import time
from brownie import CantaloupeIsland, Contract, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT
from brownie.network.gas.strategies import GasNowStrategy
import json

gas_strategy = GasNowStrategy("fast")
uri_list = []

with open('/Users/adidonato/git_tree/nft-mix/scripts/cantaloupe/IPFSHASHES.log') as f:
    for line in f:
        #print(line)
        uri_list.append(line)


#####################################
price = 99000000000000000 # 0.099 ETH
#####################################

total_supply = 5

def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = CantaloupeIsland[len(CantaloupeIsland) - 1]
    # uri_list.sort()
    #while True:
    for i, uri in enumerate(uri_list):
        GAS_PRICE = gas_strategy.get_gas_price()
        print("GAS :{}".format(GAS_PRICE))
        #if GAS_PRICE < 25000000000:
        print("Executing {}".format(uri))
        transaction = simple_collectible.mintForSale(uri, price, {"from": dev, "gas_price": GAS_PRICE})
        transaction.wait(1) # one confirmation
        print(
            "Awesome! You can view your NFT at {}".format(
                OPENSEA_FORMAT.format(simple_collectible.address, total_supply + i)
            )
        )
        print('Please give up to 20 minutes, and hit the "refresh metadata" button')
