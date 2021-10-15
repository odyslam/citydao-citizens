// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// ============ Imports ============

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Base64.sol";
import "ds-test/test.sol";

/// @title FrackingClosedSourceContract
/// @author Odysseas Lamtzidis
/// @notice An interface for the Open Sea shared Storefront smart contract. It implements the only function
/// that we care about, balanceOf.
interface FrackingClosedSourceContract {
/// @notice Returns the number of NFTs for a specific ItemId that a particular address has. It is used to verify
/// how many NFTs for every type of Citizen NFT a user has already in the Open Sea shared Storefront smart contract.
    function balanceOf(address, uint256) external payable returns (uint256);
}


/// @title CitizenNFT
/// @author Odysseas Lamtzidis
/// @notice An ERC721 NFT that replaces the Citizen NFTs that are issued by the OpenSea Storefront Smart contract.
/// This smart contract enables users to either mint a new CitizenNFT or
/// "transfer" their Citizen NFTs from the OpenSea smart contract to this one.
contract CitizenNFT is ERC721, Ownable, DSTest {
    // We use safemath to avoid under and over flows
    using SafeMath for uint256;
    // The maximum number of NFTs that can be minted for every category: Regular, Founding, First
    // These variables can be changed by the appropriate function
    uint256 private availableHousingForCitizens = 10000;
    uint256 private museumSize = 50;
    uint256 private constant firstCitizensAmongstEquals = 1;
  // At the time of writing, a new CitizenNFT costs 0.25 ether.
  // This variable can change by the appropriate function
    uint256 public citizenshipStampCostInWei = 250000000000000000;
 // Variable that stores the address of the deployed  OpenSea shared Storefront smart contract
 // At the time of writing, this is the address: https://etherscan.io/address/0x495f947276749ce646f68ac8c248420045cb7b5e
    address private forbiddenAddress;
// Variables that store the ItemIDs of the CitizenNFTs on the OpenSea shared Storefront smart contract
// Every NFT in the smart contract is identified by a unique ItemId
// jailedCitizens = Citizen NFT, OpenSea: https://opensea.io/assets/0x495f947276749ce646f68ac8c248420045cb7b5e/23487195805935260354348650824724952235377320432154855752878351301067508033245
// citizensFacingGuillotine = Founding Citizen NFT, Opensea: https://opensea.io/assets/0x495f947276749ce646f68ac8c248420045cb7b5e/23487195805935260354348650824724952235377320432154855752878351298868484767794
// beheadedCitizen = First Citizen NFT, https://opensea.io/assets/0x495f947276749ce646f68ac8c248420045cb7b5e/23487195805935260354348650824724952235377320432154855752878351297768973139969
    uint256 private jailedCitizens;
    uint256 private citizensFacingGuillotine;
    uint256 private beheadedCitizen;
// Internal Ids that are used to differentiate between the different Citizen NFTs
    uint256 private constant CITIZEN_NFT_ID = 42;
    uint256 private constant FOUNDING_NFT_ID = 69;
    uint256 private constant FIRST_NFT_ID = 7;
// Mapping that stores how many Citizen NFTs users have locked in the Open Sea shared Storefront
// These mappings are used to keep track, so that users don't mint more existing Citizen NFTs than they have.
    mapping(address => uint256) private citizens;
    mapping(address => uint256) private foundingCitizens;
    mapping(address => uint256) private firstCitizen;
// Map the interal Ids we use for the different types of citizen IDs to the ones used
// in the Open Sea shared Storefront
    mapping(uint256 => uint256) private citizenNFTtoOpenSea;
    mapping(uint256 => uint256) private citizenIdtoType;

// Count how many different Citizen NFTs exist by type
    uint256 private citizenCounter;
    uint256 private foundingCitizenCounter;
    uint256 private firstCitizenCounter;
// The ID of every Citizen NFT. Every Citizen NFT (regular, founding, first) belongs to the same NFT,
// but has different metadata. Thus there is a global ID for every citizen NFT.
    uint256 private universalCitizenId;

// Events
    event LogEthDeposit(address);
    event CitizenLegislatureChanged(string, uint256);
    event RefugeeSaved(address, uint256);
    event NewCitizen(address, uint256, uint256);

    FrackingClosedSourceContract private frackingClosedSourceContract;
/// @notice Initialise CitizenNFT smart contract with the appropriate address and ItemIds of the
/// Open Sea shared storefront smart contract and the Citizen NFTs that are locked in it.
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
/// @notice Change the cost for minting a new regular Citizen NFT
/// Can only be called by the owner of the smart contract.
    function legislateCostOfEntry(uint256 _stampCost) external onlyOwner {
        citizenshipStampCostInWei = _stampCost;
        emit CitizenLegislatureChanged("stampCost", _stampCost);
    }
/// @notice Change the maximum number of regular Citizen NFTs that can be minted
/// Can only be called by the owner of the smart contract.
    function legislateForHousing(uint256 _newMaxCitizenNFTs)
        external
        onlyOwner
    {
        availableHousingForCitizens = _newMaxCitizenNFTs;
        emit CitizenLegislatureChanged("citizenNftMax", _newMaxCitizenNFTs);
    }
/// @notice Change the maximum number of Founding Citizen NFTs that can be minted
/// Can only be called by the owner of the smart contract.
    function rewriteHistory(uint256 _max) external onlyOwner {
        museumSize = _max;
        emit CitizenLegislatureChanged("foundingCitizenNftMax", _max);
    }
/// @notice Return the current cost of minting a new regular Citizen NFT.
    function inquireCostOfEntry() external view returns (uint256) {
        return citizenshipStampCostInWei;
    }
/// @notice Return the current maximum number of regular Citizen NFTs.
    function inquireHousingNumbers() external view returns (uint256) {
        return availableHousingForCitizens;
    }
/// @notice Return the current maximum number of Founding NFTs.
    function inquireAboutHistory() external view returns (uint256) {
        return museumSize;
    }
/// @notice Return the number of NFTs  of a particular type that the address has locked in the Open Sea shared Storefront
/// smart contract.
    function inquireRefugeeStatus(address _refugeeAddress, uint256 _citizensType) external returns (uint256) {
        return frackingClosedSourceContract.balanceOf(
                    _refugeeAddress,
                    citizenNFTtoOpenSea[_citizensType]
                );

    }

/// @notice Mint a new citizen NFT
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
/// @notice Mint a  new citizen NFT, only at working hours
    function bureauApplicationForCitizenship() external payable {
        uint256 day = (block.timestamp / 86400 + 3) % 7;
        uint256 hour = (block.timestamp / 3600) % 24;
        require(
            day < 5 && hour >= 14 && hour < 21,
            "this contract is only active monday through friday 10am to 5pm eastern time"
        );
        onlineApplicationForCitizenship();
    }
/// @notice Withdraw the funds from the minting of new regular Citizen NFTs.
/// Can only be called by the owner of the smart contract.
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
/// @notice Mint a citizen NFT that already exists locked in the Open Sea shared Storefront smart contract. It returns the ID of the minted CityDAO NFT.
/// @param _refugeeAddress The address which owns the locked NFT and to which the new NFT will be minted to
/// @param _citizenType The type of Citizen NFT. Regular: 42, Founding: 69, First: 7. They are defined as constants at the
/// start of the smart contract.
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
/// @notice Return the type of a particular Citizen NFT, based on it's id.
    function citizenshipVerification(uint256 _citizenshipId)
        external
        view
        returns (uint256)
    {
        return citizenIdtoType[_citizenshipId];
    }
/// @notice Internal function that mints a new citizen NFT. It chekcs whether the maximum number of cityDAO nfts
/// has been minted for every type of CityDAO NFT (regular, founding, first).
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
/// @notice Returns the metadata for a particular CityDAo Citizen NFT, based on it's ID.
/// Every ID is mapped to a Citizen NFT type (Regular: 42, Founding: 68, First: 7). Based on the mapping
/// the citizen NFT has different metadata. Apart from the metadata, all Citizen NFTs are the same NFT.
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
