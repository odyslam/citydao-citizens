// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Base64.sol";
import "ds-test/test.sol";

interface FrackingClosedSourceContract {
    function balanceOf(address, uint256) external payable returns (uint256);
}

contract CitizenNFT is ERC721, Ownable, DSTest {
    using SafeMath for uint256;
    uint256 private availableHousingForCitizens = 10000;
    uint256 private museumSize = 50;
    uint256 private constant firstCitizensAmongstEquals = 1;
    uint256 public citizenshipStampCostInWei = 250000000000000000;
    address private forbiddenAddress;
    uint256 private jailedCitizens;
    uint256 private citizensFacingGuillotine;
    uint256 private beheadedCitizen;
    uint256 private constant CITIZEN_NFT_ID = 42;
    uint256 private constant FOUNDING_NFT_ID = 69;
    uint256 private constant FIRST_NFT_ID = 7;

    mapping(address => uint256) private citizens;
    mapping(address => uint256) private foundingCitizens;
    mapping(address => uint256) private firstCitizen;
    mapping(uint256 => uint256) private citizenNFTtoOpenSea;
    mapping(uint256 => uint256) private citizenIdtoType;

    uint256 private citizenCounter;
    uint256 private foundingCitizenCounter;
    uint256 private firstCitizenCounter;
    uint256 private universalCitizenId;

    event LogEthDeposit(address);
    event CitizenLegislatureChanged(string, uint256);
    event RefugeeSaved(address, uint256);
    event NewCitizen(address, uint256, uint256);
    FrackingClosedSourceContract private frackingClosedSourceContract;

    constructor(
        address _forbiddenAddress,
        uint256 _jailedCitizens,
        uint256 _citizensFacingGuillotine,
        uint256 _beheadedCitizen
    ) Ownable() ERC721("CityDAO Citizen", "CTZN") {
        frackingClosedSourceContract = FrackingClosedSourceContract(
            _forbiddenAddress
        );
        citizenNFTtoOpenSea[CITIZEN_NFT_ID] = _jailedCitizens;
        citizenNFTtoOpenSea[FOUNDING_NFT_ID] = _citizensFacingGuillotine;
        citizenNFTtoOpenSea[FIRST_NFT_ID] = _beheadedCitizen;
        forbiddenAddress = _forbiddenAddress;
    }

    function legislateCostOfEntry(uint256 _stampCost) external onlyOwner {
        citizenshipStampCostInWei = _stampCost;
        emit CitizenLegislatureChanged("stampCost", _stampCost);
    }

    function legislateForHousing(uint256 _newMaxCitizenNFTs)
        external
        onlyOwner
    {
        availableHousingForCitizens = _newMaxCitizenNFTs;
        emit CitizenLegislatureChanged("citizenNftMax", _newMaxCitizenNFTs);
    }

    function rewriteHistory(uint256 _max) external onlyOwner {
        museumSize = _max;
        emit CitizenLegislatureChanged("foundingCitizenNftMax", _max);
    }

    function inquireCostOfEntry() external view returns (uint256) {
        return citizenshipStampCostInWei;
    }

    function inquireHousingNumbers() external view returns (uint256) {
        return availableHousingForCitizens;
    }

    function inquireAboutHistory() external view returns (uint256) {
        return museumSize;
    }
    function inquireRefugeeStatus(address _refugeeAddress, uint256 _citizensType) external returns (uint256) {
        return frackingClosedSourceContract.balanceOf(
                    _refugeeAddress,
                    citizenNFTtoOpenSea[_citizensType]
                );

    }

    function onlineApplicationForCitizenship()
        public
        payable
        returns (uint256)
    {
        require(
            msg.value >= citizenshipStampCostInWei,
            "ser, the state machine needs oil"
        );
        return issueCitizenship(msg.sender, CITIZEN_NFT_ID);
    }

    function bureauApplicationForCitizenship() external payable {
        uint256 day = (block.timestamp / 86400 + 3) % 7;
        uint256 hour = (block.timestamp / 3600) % 24;
        require(
            day < 5 && hour >= 14 && hour < 21,
            "this contract is only active monday through friday 10am to 5pm eastern time"
        );
        onlineApplicationForCitizenship();
    }

    function raidTheCoffers() external onlyOwner {
        uint256 amount = address(this).balance;
        (bool success, ) = owner().call{value: amount}("");
        require(success, "Anti-corruption agencies stopped the transfer");
    }

    fallback() external payable {
        emit LogEthDeposit(msg.sender);
    }

    receive() external payable {
        emit LogEthDeposit(msg.sender);
    }

    function applyForRefugeeStatus(address _refugeeAddress, uint256 _citizenType)
        public
        returns (uint256 refugeeId)
    {
        uint256 tempCitizen;

        if (_citizenType == CITIZEN_NFT_ID) {
            tempCitizen = citizens[_refugeeAddress];
        }
        else if (_citizenType == FOUNDING_NFT_ID){
            tempCitizen = foundingCitizens[_refugeeAddress];
        }
        else if (_citizenType == FIRST_NFT_ID) {
            tempCitizen = firstCitizen[_refugeeAddress];
        }
        require(
                tempCitizen != 6969696969,
                "ser, all citizens have been rescued"
            );
        if (tempCitizen == 0) {
            tempCitizen = frackingClosedSourceContract.balanceOf(
                _refugeeAddress,
                citizenNFTtoOpenSea[_citizenType]
            );
        }
        tempCitizen = tempCitizen.sub(1);
        if (tempCitizen == 0) {
            tempCitizen = 6969696969;
        }
        if (_citizenType == CITIZEN_NFT_ID) {
            citizens[_refugeeAddress] = tempCitizen;
        }
        else if (_citizenType == FOUNDING_NFT_ID){
            foundingCitizens[_refugeeAddress] = tempCitizen;
        }
        else if (_citizenType == FIRST_NFT_ID) {
            firstCitizen[_refugeeAddress] = tempCitizen;
        }
        citizens[_refugeeAddress] = tempCitizen;
        emit RefugeeSaved(_refugeeAddress, _citizenType);
        return issueCitizenship(_refugeeAddress, _citizenType);
    }

    function citizenshipVerification(uint256 _citizenshipId)
        external
        view
        returns (uint256)
    {
        return citizenIdtoType[_citizenshipId];
    }

    function issueCitizenship(address _citizenAddress, uint256 _citizenType)
        private
        returns (uint256 citizenNFTId)
    {
        if (_citizenType == CITIZEN_NFT_ID) {
            require(
                citizenCounter <= availableHousingForCitizens,
                "No more permits are issued"
            );
            citizenCounter = citizenCounter.add(1);

        } else if (_citizenType == FOUNDING_NFT_ID) {
            require(
                foundingCitizenCounter <= museumSize,
                "No more permits are issued"
            );
            foundingCitizenCounter = foundingCitizenCounter.add(1);
        } else if (_citizenType == FIRST_NFT_ID) {
            require(firstCitizenCounter == 0, "No more permits are issued");
            firstCitizenCounter = firstCitizenCounter.add(1);
        }
        citizenIdtoType[universalCitizenId] = _citizenType;
        universalCitizenId = universalCitizenId.add(1);
        emit NewCitizen(_citizenAddress, universalCitizenId-1, _citizenType);
        _safeMint(_citizenAddress, universalCitizenId - 1);
        return universalCitizenId - 1;
    }
    function tokenURI(uint256 _citizenshipId)
        public
        view
        override
        returns (string memory)
    {
        string memory imageHash;
        string memory citizenship;
        if (
            citizenIdtoType[_citizenshipId] == 42
        ) {
            imageHash = "QmRRnuHVwhoYEHsTxzMcGdrCfthKTS65gnfUqDZkv6kbza";
            citizenship = "CityDAO Citizen";
        } else if (
            citizenIdtoType[_citizenshipId] ==  69
        ) {
            imageHash = "QmSrKL6fhPYU6BbYrV97AJm3aM6naGWZK95QntXXZuGQrF";
            citizenship = "CityDAO Founding Citizen";
        }  else if (
            citizenIdtoType[_citizenshipId] ==  7
        ) {
            imageHash = "Qmb6VmYiktfvNX3YkLosYwjUM82PcEkr2irZ4PWheYiG2b";
            citizenship = "CityDAO First Citizen";
        } else {
            revert("invalid citizenshipId");
        }
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "',
                        citizenship,
                        '", ',
                        '"description" : ',
                        '"A Citizen of CityDAO holds governance in the operations and activities of CityDAO.",',
                        '"image": "ipfs://',
                        imageHash,
                        '"'
                        "}"
                    )
                )
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", json));
    }
}
