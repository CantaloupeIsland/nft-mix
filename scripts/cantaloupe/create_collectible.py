#!/usr/bin/python3
from brownie import CantaloupeIsland, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT

sample_token_uri = "https://ipfs.io/ipfs/Qmd9MCGtdVz2miNumBHDbvj8bigSgTwnr4SbyH6DNnpWdt?filename=0-PUG.json"
uri_list = []

with open('IPFSHASHES.log') as f:
    for line in f:
        uri_list.append(line)

def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    simple_collectible = CantaloupeIsland[len(CantaloupeIsland) - 1]
    token_id = simple_collectible.tokenCounter()
    for uri in uri_list:
        transaction = simple_collectible.mintForSale(uri, price, {"from": dev})
        transaction.wait(1)
        print(
            "Awesome! You can view your NFT at {}".format(
                OPENSEA_FORMAT.format(simple_collectible.address, token_id)
            )
        )
        print('Please give up to 20 minutes, and hit the "refresh metadata" button')
