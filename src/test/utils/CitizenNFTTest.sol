// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "ds-test/test.sol";
import "./Hevm.sol";
import "../../CitizenNFT.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

/// @notice Since we deplyo the smart contract from another smart contract and
/// the users are smart contracts as well, we need to implement a special function
/// so that they can receive ERC721. We inherent from a well-known library
contract User is ERC721Holder, DSTest {
    CitizenNFT internal citizenNFT;

    constructor(CitizenNFT _citizenNFT){
        citizenNFT = _citizenNFT;
    }

    function applyForRefugeeStatus(uint256 _tokenId) public returns(uint256 refugeeId){
        return citizenNFT.applyForRefugeeStatus(address(this), _tokenId);
     }
    function onlineApplicationForCitizenship(uint256 _weiAmmount) public returns(uint256 citizenshipId){
        return citizenNFT.onlineApplicationForCitizenship{value:_weiAmmount}();
    }

   function legislateCostOfEntry(uint256 _weiAmmount) public {
       citizenNFT.legislateCostOfEntry(_weiAmmount);
   }
   function legislateForHousing(uint256 _max) public {
       citizenNFT.legislateForHousing(_max);
   }

    receive() external payable {}
}

/// @notice Helper test contract that sets up the testing suite.

contract OpenSeaStorefront is DSTest{
    address private testRefugee;
    uint256 private numberOfCommonRefugees;
    uint256 private numberOfHighClassRefugees;
    uint256 private numberOfRoyalty;
    uint256 private commonId;
    uint256 private highClassId;
    uint256 private royaltyId;
    constructor() {}
    function populate(address _testRefugee, uint256 _numberOfCommonRefugees,
                                uint256 _numberOfHighClassRefugees,uint256 _numberOfRoyalty,
                                uint256 _commonId, uint256 _highClassId, uint256 _royaltyId)
    public{
        testRefugee = _testRefugee;
        numberOfCommonRefugees = _numberOfCommonRefugees;
        numberOfHighClassRefugees = _numberOfHighClassRefugees;
        numberOfRoyalty = _numberOfRoyalty;
        commonId = _commonId;
        highClassId = _highClassId;
        royaltyId = _royaltyId;
    }

    function balanceOf(address _testRefugee, uint256 _refugeeType) public returns(uint256){
        if( _testRefugee == testRefugee){
            if ( _refugeeType == 23487195805935260354348650824724952235377320432154855752878351301067508033245) {
                return numberOfCommonRefugees;
            }
            else  if (_refugeeType == 23487195805935260354348650824724952235377320432154855752878351298868484767794) {
                return numberOfHighClassRefugees;
            }
            else {
                return numberOfRoyalty;
            }
        }
        else {
            return 0;
        }
    }
}
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

    uint256 openseaCitizenNFTId = 23487195805935260354348650824724952235377320432154855752878351301067508033245;
    uint256 openseaFoundingCitizenNFTId = 23487195805935260354348650824724952235377320432154855752878351298868484767794;
    uint256 openseaFirstCitizenNFTId = 23487195805935260354348650824724952235377320432154855752878351297768973139969;

// Internal Ids

   uint256 citizenNFTInternalId = 42;
   uint256 foundingCitizenNFTInternalId = 69;
   uint256 firstCitizenNFTInternalId = 7;

    function setUp() public virtual {
        openSeaStorefront = new OpenSeaStorefront();
        citizenNFT = new CitizenNFT(address(openSeaStorefront), openseaCitizenNFTId, openseaFoundingCitizenNFTId, openseaFirstCitizenNFTId );
        bob = new User(citizenNFT);
        alice = new User(citizenNFT);
        odys = new User(citizenNFT);
        openSeaStorefront.populate(address(alice), 10000, 50, 1, openseaCitizenNFTId, openseaFoundingCitizenNFTId, openseaFirstCitizenNFTId);
        citizenNFT.transferOwnership(address(odys));
        assertEq(address(odys), citizenNFT.owner());
    }
}
