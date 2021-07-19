// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;
///////////////////////////////////////////////////////////////////////////////////
// CANTALOUPE ISLAND DAO
///////////////////////////////////////////////////////////////////////////////////
//@@@@@@@@@@@@@@@@@@@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@/#((#@@@@@@@@(#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@#/((((#@@@/#(#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@&#/(((##@@(###@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@@#//((#(@((##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@((((((((((&@@@&/((##((#(@@@@#######################@@@@@@@@@@@@@@@@@@@@@@@@@@
///*&(//**(((((((((@/((((##(&#########%%#///*******//(#%%#####@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@//***/((((((((#(######((*************************/(%###@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@(((((((((((#####(**************,***,**************/%##&@@@@@@@@@@@@
//@@@@@@@@@%(((((((((((((((/*#/####/,,,,,,,,,,,,,,,,,,,,,,,*********/%##@@@@@@@@@@
//@@@@@@@%(((/(/@/((((#/#((#***,*,/(##,,,,,,,,,,,,,,,,,,,,,,,,,********(##@@@@@@@@
//@@@@@@#/#(/@*@((((#**(*(((/,,,,,,,,/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,******/%#@@@@@@
//@@@@@@*@@@@@@(((#/****((((/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,******(#&@@@@
//@@@@@@@@@@@@(((#*******((#,,,,,,,,,,******************,,,,,,,,,,,,,,******/#&@@@
//@@@@@@@@@@@((((******,,((*,,,,,,,*************************,,,,,,,,,,,,******#%@@
//@@@@@@@@@@((((******,,,,*,,,,,,*********,,,,,,,,,,**********,,,,,,,,,,,******%@@
//@@@@@@@@@(((#*****,,,,,,,,,,,*******,,,,,,,,,,,,,,,,,,*******,,,,,,,,,,,*****/%@
//@@@@@@@@@(((/*****,,,,,,,,,,*******,,,,,,,,,,,,,,,,,,,,,*******,,,,,,,,,,*****#@
//@@@@@@@@%(((******,,,,,,,,,,******,,,,,,,........,,,,,,,,******,,,,,,,,,,*****/(
//@@@@@@@@#(((******,,,,,,,,,*******,,,,,,...........,,,,,,*/*******************/@
//@@@@@@@@#(((*******************/**,,,,,,...........,,,,,,//*******************/@
//@@@@@@@@@(((*******************//*,,,,,***,.....*/(/*,,,*//*******************(@
//@@@@@@@@@(((/*******************//*///(////*,,,/////((***/********************#@
//@@@@@@@@@@(((************************,*****////**,,,,************************(@@
//@@@@@@@@@@@(((*************************,,,,,,,,,,,,*************************/%@@
//@@@@@@@@@@@@(((************************************************************/#@@@
//@@@@@@@@@@@@@((#**********************************************************(%@@@@
//@@@@@@@@@@@@@@/((/*******************************************************#@@@@@@
//@@@@@@@@@@@@@@@@###/***************************************************#&@@@@@@@
//@@@@@@@@@@@@@@@@@@((#/***********************************************#@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@/##******************************************##@@@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@#(#(**********************************/(&@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@%/(#/************************/((&@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#(/(#(((////(((((#%@@@@@@@@@@@@@@@@@@@@@@@@@@
///////////////////////////////////////////////////////////////////////////////////

import "@openzeppelin/contracts/presets/ERC721PresetMinterPauserAutoId.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CantaloupeIsland is ERC721PresetMinterPauserAutoId, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdTracker;
  address payable public _owner;
  mapping (uint => bool) public sold;
  mapping (uint => uint) public price;
  
  event Purchase(address owner, uint price, uint id, string uri);

  constructor() ERC721PresetMinterPauserAutoId("Cantaloupe Island", "CANTALOUPEISLAND", "") {
  	address _owner = msg.sender;
  }
    
// @dev: mint is deprecated use mintForSale (with price) or mintForSelf to transfer to msg.sender
//
  function mintForSale(string memory _tokenURI, uint _price)  public virtual returns (bool) {
      require(hasRole(MINTER_ROLE, _msgSender()), "CantaloupeIsland: must have minter role to mint for sale");
      _tokenIdTracker.increment();
      price[_tokenIdTracker.current()] = _price;
      _mint(address(this), _tokenIdTracker.current());
      _setTokenURI(_tokenIdTracker.current(), _tokenURI);
      return true;
  }
  
//
 // @dev: mint is deprecated use mintForSale (with price) or mintForSelf to transfer to msg.sender 
  function mintForSelf(string memory _tokenURI)  public virtual returns (bool) {
      require(hasRole(MINTER_ROLE, _msgSender()), "CantaloupeIsland: must have minter role to mint to self");
      _tokenIdTracker.increment();
      price[_tokenIdTracker.current()] = 0;
      _mint(_msgSender(), _tokenIdTracker.current());
      _setTokenURI(_tokenIdTracker.current(), _tokenURI);
      return true;
  }
  
  

  function buy(uint _id) external payable {
    _validate(_id); //check req. for trade
    _trade(_id); //swap nft for eth
    
    emit Purchase(msg.sender, price[_id], _id, tokenURI(_id));
  }

  function _validate(uint _id) internal {
  	require(_exists(_id), "Error, wrong Token id"); //not exists
    require(!sold[_id], "Error, Token is sold"); //already sold
    require(msg.value >= price[_id], "Error, Token costs more"); //costs more
  }

  function _trade(uint _id) internal {
  	_transfer(address(this), msg.sender, _id); //nft to user
  	_owner.transfer(msg.value); //eth to owner
  	sold[_id] = true; //nft is sold
  }
  
  function transferFromSale(uint _id) external onlyOwner {
  	_transfer(address(this), msg.sender, _id); //nft to user
  	//_owner.transfer(msg.value); //eth to owner
  	sold[_id] = true; //nft is sold
  }
  
}