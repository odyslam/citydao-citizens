// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "ds-test/test.sol";
import "./Hevm.sol";
import "../../CitizenNFT.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

/// @notice Since we deplyo the smart contract from another smart contract and
/// the users are smart contracts as well, we need to implement a special function
/// so that they can receive ERC721. We inherent from a well-known library
contract User is ERC721Holder {
    CitizenNFT internal citizenNFT;

    constructor(CitizenNFT _citizenNFT){
        citizenNFT = _citizenNFT;
    }

    function applyForRefugeeStatus(uint256 _tokenId) public {
         citizenNFT.applyForRefugeeStatus(_tokenId);
     }
    function onlineApplicationForCitizenship(uint256 _weiAmmount) public returns(uint256){
        return citizenNFT.onlineApplicationForCitizenship{value:_weiAmmount}();
    }

    receive() external payable {}
}

/// @notice Helper test contract that sets up the testing suite.

contract OpenSeaStorefront {
    address private refugee;
    uint256 private numberOfCommonRefugees;
    uint256 private numberOfHighClassRefugees;
    uint256 private numberOfRoyalty;
    uint256 private commonId;
    uint256 private highClassId;
    uint256 private royaltyId;
    constructor() {}
    function populate(address _refugee, uint256 _numberOfCommonRefugees,
                                uint256 _numberOfHighClassRefugees,uint256 _numberOfRoyalty,
                                uint256 _commonId, uint256 _highClassId, uint256 _royaltyId)
    public{
        refugee = _refugee;
        numberOfCommonRefugees = _numberOfCommonRefugees;
        numberOfHighClassRefugees = _numberOfHighClassRefugees;
        numberOfRoyalty = _numberOfRoyalty;
        commonId = _commonId;
        highClassId = _highClassId;
        royaltyId = _royaltyId;
    }

    function balanceOf(address _testRefugee, uint256 _refugeeType) public view returns(uint256){
        require(_testRefugee == refugee, "test address is incorrect");
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
}
contract CitizenTest is DSTest {
    Hevm internal constant hevm = Hevm(HEVM_ADDRESS);

    // contracts
    CitizenNFT internal citizenNFT;

    // users
    User internal alice;
    User internal bob;
    User internal odys;

    // OpenSea items id;

    uint256 citizenNFTId = 1;
    uint256 foundingCitizenNFTId = 2;
    uint256 firstCitizenNFTId = 3;

    // CitizenNFts
    uint256 aliceOpenSeaCitizenNFTs = 5;
    uint256 aliceOpenSeaFoundingCitizenNFTs = 1;
    function setUp() public virtual {
        OpenSeaStorefront openSeaStorefront = new OpenSeaStorefront();
        citizenNFT = new CitizenNFT(address(openSeaStorefront), citizenNFTId, foundingCitizenNFTId, firstCitizenNFTId );
        bob = new User(citizenNFT);
        alice = new User(citizenNFT);
        openSeaStorefront.populate(address(alice), 13, 23, 1, citizenNFTId, foundingCitizenNFTId, firstCitizenNFTId);
        odys = new User(citizenNFT);
        citizenNFT.transferOwnership(address(odys));
        assertEq(address(odys), citizenNFT.owner());
    }
}
