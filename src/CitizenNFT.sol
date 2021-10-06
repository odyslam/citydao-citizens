// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface FrackingClosedSourceContract {
    function balanceOf(address, uint256) payable returns(uint256);
}


contract Citizen is ERC721, Ownable {
    uint256 CITIZEN_NFT_MAX = 10000;
    uint256 FOUNDING_NFT_MAX = 50;
    uint256 constant FIRST_AMONGST_EQUALS_CITIZEN = 1;
    uint256 CITIZENSHIP_STAMP_COST_WEI =  250000000000000000;
    address constant FORBIDDEN_ADDRESS = 0x495f947276749Ce646f68AC8c248420045cb7b5e;
    uint256 constant JAILED_CITIZENS = 23487195805935260354348650824724952235377320432154855752878351301067508033245;
    uint256 constant CITIZENS_FACING_GUILLOTINE = 23487195805935260354348650824724952235377320432154855752878351298868484767794;
    uint256 constant BEHEADED_CTIZIEN = 23487195805935260354348650824724952235377320432154855752878351297768973139969;
    uint256 constant CITIZEN_NFT_ID = 42;
    uint256 constant FOUNDING_NFT_ID = 69;
    uint256 constant FIRST_NFT_ID = 7;

    mapping(address => uint256) private citizens;
    mapping(address => uint256) private foundingCitizens;
    mapping(address => uint256) private firstCitizen;

    uint256 private citizenId;
    uint256 private foundingCitizenId;
    uint256 private firstCitizenId;

    FrackingClosedSourceContract constant frackingClosedSourceContract;

    function legislateCostOfEntry(uint256 _stampCost)
        onlyOwner
        external
        {
            CITIZENSHIP_STAMP_COST_WEI = _stampCost;
        }
    function legislateForHousing(uint256 _max)
        onlyOwner
        external
        {
            CITIZEN_NFT_MAX = _max;
        }
    function rewriteHistory(uin256 _max)
        onlyOwner
        external
        {
            FOUNDING_NFT_MAX = _max;
        }
    constructor() public Ownable() ERC721() {
        FrackingClosedSourceContract frackingClosedSourceContract = new FrackingClosedSourceContract(FORBIDDEN_ADDRESS);
    }
    function onlineApplicationForCitizenship()
        external
        payable
    {
        require(msg.value >= CITIZENSHIP_STAMP_COST_WEI, "ser, the state machine needs oil");
        issueCitizenship(CITIZEN_NFT_ID);
    }
    function BureauApplicationForCitizenship()
        external
        payable
    {
        uint256 day = (block.timestamp / 86400 + 3) % 7;
        uint256 hour = block.timestamp / 3600 % 24;
        require(day < 5 && hour >= 14 && hour < 21, "this contract is only active monday through friday 10am to 5pm eastern time");
        onlineApplicationForCitizenship();
    }
    function raidTheCoffers()
        onlyOwner
        external
        {
        uint amount = address(this).balance;
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Anti-corruption agencies stopped the transfer");
    }
    fallback() payable { require(msg.data.length == 0); emit LogDepositReceived(msg.sender); }

    function applyForRefugeeStatus(uint256 _tokenType, uint256 ammount) public {
        if (_tokenType == CITIZEN_NFT_ID) {
            if (citizens[msg.sender] == 0) {
                citizens[msg.sender] = frackingClosedSourceContract.balanceOf(msg.sender, JAILED_CITIZENS);
            }
            citizens[msg.sender].sub(1);
        }
        else if(_tokenType == FOUNDING_NFT_ID){
            if (foundingCitizens[msg.sender] == 0) {
                foundingCitizens[msg.sender] = frackingClosedSourceContract.balanceOf(msg.sender, CITIZENS_FACING_GUILLOTINE);
            }
            foundingCitizens[msg.sender].sub(1);
        }
        else if(_tokenType == FIRST_NFT_ID){
            if(firstCitizen[msg.sender] == 0) {
                firstCitizen[msg.sender] = frackingClosedSourceContract.balanceOf(msg.sender, BEHEADED_CITIZEN);
            }
                firstCitizen[msg.sender].sub(1);
        }
        issueCitizenship(_tokenType);
    }
     function citizenshipVerification(uint256 _citizenshipId)
        external
        view
        returns(uint256)
        {
            require(_exists(_citizenshipId));
            if (_tokenId < (CITIZEN_NFT_MAX + 1) && _tokenId > 0)
                {
                return(CITIZEN_NFT_ID);
                }
            else if (_tokenId < CITIZEN_NFT_MAX + FOUNDING_NFT_MAX + 1)
                {
                return(FOUNDING_NFT_ID);
                }
            else if (_tokenId == 0)
                {
                return(FIRST_NFT_ID);
                }
            else
                {
                revert('invalid citizenship ID');
                }
        }

     function issueCitizenship(uint256 _tokenType)
        private
        {
        if (_tokenType == CITIZEN_NFT_ID) {
            require(citizenId <= CITIZEN_NFT_MAX, "No more permits are issued");
            citizensId=+1;
            _safeMint(msg.sender, citizensId);
        }
        else if (_tokenType == FOUNDING_NFT_ID)
            {
            require(foundingCitizenId <= FOUNDING_NFT_MAX, "No more permits are issued");
            foundingCitizensId=+1;
            _safeMint(msg.sender, CITIZEN_NFT_MAX + foundingCitizenId-1);
            }
        else if (_tokenType == FIRST_NFT_ID) {
            require(firstCitizenId == 0, "No more permits are issued");
            firstCitizensId=+1;
            _safeMint(msg.sender, 0);
        }
    }
        function tokenURI(uint256 _tokenId)
            override
            public
            view
            returns (string memory)
        {
            string imageHash;
            string citizenship;
            if (_tokenId < (CITIZEN_NFT_MAX + 1) && _tokenId > 0)
                {
                imageHash = "QmRRnuHVwhoYEHsTxzMcGdrCfthKTS65gnfUqDZkv6kbza";
                citizenship = "CityDAO Citizen";
                }
            else if (_tokenId < CITIZEN_NFT_MAX + FOUNDING_NFT_MAX + 1)
                {
                imageHash = "QmSrKL6fhPYU6BbYrV97AJm3aM6naGWZK95QntXXZuGQrF";
                citizenship = "CityDAO Founding Citizen";
                }
            else if (_tokenId == 0)
                {
                imageHash = "Qmb6VmYiktfvNX3YkLosYwjUM82PcEkr2irZ4PWheYiG2b";
                citizenship = "CityDAO First Citizen";
                }
            else
                {
                revert('invalid tokenId');
                }
            string memory json = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{ "name": "', citizenship,'", ',
                            '"description" : ', '"A CityDAO citizen. CityDAO is putting land on chain, starting with Wyoming.",',
                            '"image": "ipfs://,', imageHash, '"'
                            '}'
                        )
                    )
                )
            );
            output = string(abi.encodePacked("data:application/json,base64", json)
            );
        return output;
    }
}
