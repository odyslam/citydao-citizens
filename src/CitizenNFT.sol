// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// ============ Imports ============

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Base64.sol";
import "ds-test/test.sol";

library Errors {
    string constant invalidCitizenshipId = "Unknown Citizen NFT ID";
}

/// @title CitizenNFT
/// @author Odysseas Lamtzidis
/// @notice An ERC721 NFT that replaces the Citizen NFTs that are issued by the OpenSea Storefront Smart contract.
/// This smart contract enables users to either mint a new CitizenNFT or
/// "transfer" their Citizen NFTs from the OpenSea smart contract to this one.
contract CitizenNFT is ERC1155, Ownable, DSTest {
    // We use safemath to avoid under and over flows
    using SafeMath for uint256;

    uint256 private availableHousingForCitizens = 10000;
    uint256 private museumSize = 50;
    uint256 private constant firstCitizensAmongstEquals = 1;
    // At the time of writing, a new CitizenNFT costs 0.25 ether.
    // This variable can change by the appropriate function
    uint256 private citizenshipStampCostInWei = 250000000000000000;
    // Internal Ids that are used to differentiate between the different Citizen NFTs
    uint256 private constant CITIZEN_NFT_ID = 42;
    uint256 private constant FOUNDING_NFT_ID = 69;
    uint256 private constant FIRST_NFT_ID = 7;
    // Events
    event LogEthDeposit(address);
    event CitizenLegislatureChanged(string, uint256);
    event NewCitizen(address, uint256, uint256);
    // erc1155
    uint256 private mintedCitizensCounter = 0;
    uint256 private mintedFoundingCitizensCounter = 0;
    uint256 private mintedFirstCitizensCounter = 0;
    /// @notice Initialise CitizenNFT smart contract with the appropriate address and ItemIds of the
    /// Open Sea shared storefront smart contract and the Citizen NFTs that are locked in it.
    constructor(
        address _forbiddenAddress,
        uint256 _jailedCitizens,
        uint256 _citizensFacingGuillotine,
        uint256 _beheadedCitizen
    ) Ownable() ERC1155("") {}
     /// @notice Transfer regular Citizen NFTs from the CityDAO owner address to the user.
    /// @param _citizenNumber How many citizenNFTs will be transfered.
    /// The user must include in the transaction, the appropriate number of ether in Wei.
    function onlineApplicationForCitizenship(uint256 _citizenNumber)
        public
        payable
    {
        require(
            msg.value >= citizenshipStampCostInWei * _citizenNumber,
            "ser, the state machine needs oil"
        );
        _safeTransferFrom(this.owner(), msg.sender, CITIZEN_NFT_ID, _citizenNumber,"");
    }
    function issueNewCitizenships(address _to, uint256 _citizenType, uint256 _numberOfCitizens) public onlyOwner {
        if (_citizenType == 42){
            mintedCitizensCounter = mintedCitizensCounter.add(_numberOfCitizens);
        }
        else if ( _citizenType == 69 ) {
            mintedFoundingCitizensCounter = mintedFoundingCitizensCounter.add(_numberOfCitizens);
        }
        else if ( _citizenType == 7 ) {
            mintedFirstCitizensCounter = mintedFirstCitizensCounter.add(_numberOfCitizens);
        }
        else {
            revert(Errors.invalidCitizenshipId);
        }
        _mint(_to, _citizenType, _numberOfCitizens, "");
    }
    function initialCitizenship() external onlyOwner {
        issueNewCitizenships(msg.sender, CITIZEN_NFT_ID, availableHousingForCitizens);
        issueNewCitizenships(msg.sender, FOUNDING_NFT_ID, museumSize);
        issueNewCitizenships(msg.sender, FIRST_NFT_ID, firstCitizensAmongstEquals);
    }
    /// @notice Change the cost for minting a new regular Citizen NFT
    /// Can only be called by the owner of the smart contract.
    function legislateCostOfEntry(uint256 _stampCost) external onlyOwner {
        citizenshipStampCostInWei = _stampCost;
        emit CitizenLegislatureChanged("stampCost", _stampCost);
    }
    /// @notice Mint new Citizen NFTs to the owner of the smart contract
    /// Can only be called by the owner of the smart contract.
    function buildHousing(uint256 _newCitizens)
        external
        onlyOwner
    {
        emit CitizenLegislatureChanged("Minted new citizen NFTs", _newCitizens);
        issueNewCitizenships(msg.sender, CITIZEN_NFT_ID, _newCitizens);
    }
    /// @notice  Mint new Citizen NFTs to the owner of the smart contract
    /// Can only be called by the owner of the smart contract.
    function rewriteHistory(uint256 _newCitizens) external onlyOwner {
        emit CitizenLegislatureChanged("Minted new Founding Citizen NFTs", _newCitizens);
        issueNewCitizenships(msg.sender, FOUNDING_NFT_ID, _newCitizens);
    }

    /// @notice Return the current cost of minting a new regular Citizen NFT.
    function inquireCostOfEntry() external view returns (uint256) {
        return citizenshipStampCostInWei;
    }

    /// @notice Return the number of minted Citizen NFTs
    function inquireHousingNumbers() external view returns (uint256) {
        return mintedCitizensCounter;
    }

    /// @notice Return the current maximum number of  minted Founding Citizen NFTs
    function inquireAboutHistory() external view returns (uint256) {
        return mintedFoundingCitizensCounter;
    }
     /// @notice Withdraw the funds locked in the smart contract,
    /// originating from the minting of new regular Citizen NFTs.
    /// Can only becalled by the owner of the smart contract.
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
    /// the citizen NFT has different metadata.
    function uri(uint256 _citizenshipId)
        public
        pure
        override
        returns (string memory)
    {
        string memory imageHash;
        string memory citizenship;
        if ( _citizenshipId== 42) {
            imageHash = "QmRRnuHVwhoYEHsTxzMcGdrCfthKTS65gnfUqDZkv6kbza";
            citizenship = "CityDAO Citizen";
        } else if ( _citizenshipId == 69) {
            imageHash = "QmSrKL6fhPYU6BbYrV97AJm3aM6naGWZK95QntXXZuGQrF";
            citizenship = "CityDAO Founding Citizen";
        } else if ( _citizenshipId == 7) {
            imageHash = "Qmb6VmYiktfvNX3YkLosYwjUM82PcEkr2irZ4PWheYiG2b";
            citizenship = "CityDAO First Citizen";
        } else {
            revert(Errors.invalidCitizenshipId);
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
