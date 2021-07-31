pragma solidity ^0.7.6;

import "@openzeppelin/contracts/proxy/TransparentUpgradeableProxy.sol";


contract AdminUpgradeabilityProxy is TransparentUpgradeableProxy {
    constructor(address logic, address admin, bytes memory data) payable TransparentUpgradeableProxy(logic, admin, data) {}
}