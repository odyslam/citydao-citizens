// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/math/SafeMath.sol"

interface FrackingClosedSourceContract {
    function balanceOf(address, uint256) payable returns(uint256);
}


contract Citizen is ERC1155, Ownable {
    using SafeMath for uint;

    uint256 constant CITIZEN_NFT_MAX = 10000;
    uint256 constant FOUNDING_NFT_MAX = 50;
    uint256 constant FIRST_AMONGST_EQUALS_CITIZEN = 1;
    uint256 constant CITIZENSHIP_STAMP_COST_WEI =  250000000000000000
    uint256 constant FOUNDING_CITIZENSHIP_CEREMONY_COST =
    address constant FORBIDDEN_ADDRESS = 0x495f947276749Ce646f68AC8c248420045cb7b5e;
    uint256 constant JAILED_CITIZENS = 23487195805935260354348650824724952235377320432154855752878351301067508033245;
    uint256 constant CITIZENS_FACING_GUILLOTINE =

    uint256 constant CITIZEN_NFT_ID = 42;
    uint256 constant FOUNDING_NFT_ID = 69;
    uint256 constant FIRST_NFT_ID = 7;

    mapping(address => uint256) private citizens;
    mapping(address => uint256) private foundingCitizens;
    FrackingClosedSourceContract constant frackingClosedSourceContract;

    constructor() public Ownable() ERC1155() {
        _mint(msg.sender, CITIZEN_NFT_ID, CITIZEN_NFT_MAX);
        _mint(msg.sender, FOUNDING_NFT_ID, FOUNDING_NFT_MAX);
        _mint(msg.sender, FIRST_NFT_ID, FIRST_NFT_MAX);
        FrackingClosedSourceContract frackingClosedSourceContract = new FrackingClosedSourceContract(FORBIDDEN_ADDRESS);

    function OnlineApplicationForCitizenship() {
    }
    function BureauApplicationForCitizenship() {
    }

    function applyForRefugeeStatus(uint256 tokenId, uint256 ammount) public {
        if (tokenId == 42){
            if (citizens[msg.sender] == 0) {
                citizens[msg.sender] = frackingClosedSourceContract.balanceOf(msg.sender, JAILED_CITIZENS);
            }
            citizens[msg.sender].sub(ammount);
            safeTransferFrom(owner, msg.sender, CITIZEN_NFT_ID, ammount);
        }
        else if(tokenId == 69){
            if (firstCitizens[msg.sender] == 0 {
                firstCitizens[msg.sender] = frackingClosedSourceContract.balanceOf(msg.sender, CITIZENS_FACING_GUILLOTINE);
            }
            foundingCitizens[msg.sender].sub(ammount);
            safeTransferFrom(owner, msg.sender, FOUNDING_NFT_ID, ammount);
        }
    }



}
