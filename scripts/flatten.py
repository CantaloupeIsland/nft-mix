#!/usr/bin/python3
from brownie import CantaloupeIsland, accounts, network, config, interface
import json


def main():
    flatten()


def flatten():
    file = open("./CantaloupeIsland_flattened.json", "w")
    json.dump(CantaloupeIsland.get_verification_info(), file)
    file.close()
