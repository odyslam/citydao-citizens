// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "ds-test/test.sol";
import "./Hevm.sol";
import "../../CitizenNFT.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "../../OpenSeaStorefront.sol";

/// @notice Since we deploy the smart contract from another smart contract and
/// the users are smart contracts as well, we need to implement a special function
/// so that they can receive ERC721. We inherent from a well-known library
contract User is ERC721Holder, DSTest {
    CitizenNFT internal citizenNFT;

    constructor(CitizenNFT _citizenNFT) {
        citizenNFT = _citizenNFT;
    }

    function applyForRefugeeStatus(uint256 _tokenId)
        public
        returns (uint256 refugeeId)
    {
        return citizenNFT.applyForRefugeeStatus(address(this), _tokenId);
    }

    function onlineApplicationForCitizenship(uint256 _weiAmmount)
        public
        returns (uint256 citizenshipId)
    {
        return citizenNFT.onlineApplicationForCitizenship{value: _weiAmmount}();
    }

    function legislateCostOfEntry(uint256 _weiAmmount) public {
        citizenNFT.legislateCostOfEntry(_weiAmmount);
    }

    function legislateForHousing(uint256 _maxCitizens) public {
        citizenNFT.legislateForHousing(_maxCitizens);
    }

    function rewriteHistory(uint256 _maxFoundingCitizens) public {
        citizenNFT.rewriteHistory(_maxFoundingCitizens);
    }

    function raidTheCoffers() public {
        citizenNFT.raidTheCoffers();
    }
    receive() external payable {}
}

/// @notice Helper test contract that sets up the testing suite.


contract CitizenTest is DSTest {
    Hevm internal constant hevm = Hevm(HEVM_ADDRESS);

    // contracts
    CitizenNFT internal citizenNFT;
    OpenSeaStorefront internal openSeaStorefront;
    // users
    User internal alice;
    User internal bob;
    User internal odys;

    // OpenSea items id;

    uint256 internal openseaCitizenNFTId =
        23487195805935260354348650824724952235377320432154855752878351301067508033245;
    uint256 internal openseaFoundingCitizenNFTId =
        23487195805935260354348650824724952235377320432154855752878351298868484767794;
    uint256 internal openseaFirstCitizenNFTId =
        23487195805935260354348650824724952235377320432154855752878351297768973139969;

    // Internal Ids

    uint256 citizenNFTInternalId = 42;
    uint256 foundingCitizenNFTInternalId = 69;
    uint256 firstCitizenNFTInternalId = 7;

    function setUp() public virtual {
        openSeaStorefront = new OpenSeaStorefront();
        citizenNFT = new CitizenNFT(
            address(openSeaStorefront),
            openseaCitizenNFTId,
            openseaFoundingCitizenNFTId,
            openseaFirstCitizenNFTId
        );
        bob = new User(citizenNFT);
        alice = new User(citizenNFT);
        odys = new User(citizenNFT);
        openSeaStorefront.populate(
            openseaCitizenNFTId,
            openseaFoundingCitizenNFTId,
            openseaFirstCitizenNFTId
        );
        // give Alice the maximum default number of Citizen NFTs on the Open Sea shared storefront smart contract
        openSeaStorefront.populateAddress(address(alice), 10000, 50, 1);
        citizenNFT.transferOwnership(address(odys));
        assertEq(address(odys), citizenNFT.owner());
    }
}
