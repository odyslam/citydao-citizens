// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./utils/CitizenNFTTest.sol";
import "../CitizenNFT.sol";

contract NewCityDAOCitizen is CitizenTest {
    function testBuyCitizenNFT() public {
        payable(address(bob)).transfer(1 ether);
        uint256 token1;
        uint256 token2;
        uint256 tokenPrice = 250000000000000000;
        token1 = bob.onlineApplicationForCitizenship(tokenPrice);
        token2 = bob.onlineApplicationForCitizenship(tokenPrice);
        assertEq(token1, 1);
        assertEq(token2, 2);
        assertEq(citizenNFT.ownerOf(token1), address(bob));
        assertEq(address(citizenNFT).balance, 2 * tokenPrice);
    }

    function testTokenURI() public {
        payable(address(bob)).transfer(1 ether);
        uint256 token1;
        token1 = bob.onlineApplicationForCitizenship(250000000000000000);
        string memory meta = citizenNFT.tokenURI(token1);
        emit log(meta);
    }

    function testFailGetOpenSeaCitizenNFT() public {
        bob.applyForRefugeeStatus(34);
    }

    function testFailGetOpenSeaFoundingCitizenNFT() public {
        bob.applyForRefugeeStatus(10045);
    }

    function testFailGetOpenSeaFirstCitizenNFT() public {
        bob.applyForRefugeeStatus(0);
    }

}

contract ExistingCityDAOCitizen is CitizenTest {
    uint256 private citizenIdCounter;

    function testGetCitizenNFT() public{
        uint256 token1;
        for (citizenIdCounter=1;citizenIdCounter<=10000;citizenIdCounter=citizenIdCounter+1){
            token1 = alice.applyForRefugeeStatus(citizenNFTInternalId);
            assertEq(address(alice), citizenNFT.ownerOf(token1));

        }
    }
    function testGetFoundingCitizenNFT() public {
        uint256 token1;
        for (
            citizenIdCounter = 1001;
            citizenIdCounter <= 1050;
            citizenIdCounter = citizenIdCounter + 1
        ) {
            token1 = alice.applyForRefugeeStatus(foundingCitizenNFTInternalId);
            assertEq(address(alice), citizenNFT.ownerOf(token1));
        }
    }

    function testGetFirstCitizenNFT() public {
        uint256 token1;
        token1 = alice.applyForRefugeeStatus(firstCitizenNFTInternalId);
        assertEq(address(alice), citizenNFT.ownerOf(token1));
    }

    function testFailGetMoreCitizenNFTs() public {
        User seneca = new User(citizenNFT);
        openSeaStorefront.populateAddress(
            address(seneca),
            10,
            45,
            1
        );
        uint256 tokenId;
        for (uint256 i = 0; i <= 20; i = i + 1) {
            tokenId = seneca.applyForRefugeeStatus(citizenNFTInternalId);
        }
    }
}

contract Legislate is CitizenTest {
    function testOwnerChangeCitizenCost(uint96 _weiAmmount) public {
        _weiAmmount = _weiAmmount % 100000000000000000000;
        odys.legislateCostOfEntry(_weiAmmount);
        payable(address(bob)).transfer(10000 ether);
        uint256 token1;
        token1 = bob.onlineApplicationForCitizenship(_weiAmmount);
        assertEq(token1, 1);
        assertEq(citizenNFT.inquireCostOfEntry(), _weiAmmount);
    }

    function testOwnerChangeCitizensNumber(uint256 _housingNumber) public {
        odys.legislateForHousing(_housingNumber);
        assertEq(citizenNFT.inquireHousingNumbers(), _housingNumber);
    }

    function testRewriteHistory(uint256 _maxFoundingCitizens) public {
        odys.rewriteHistory(_maxFoundingCitizens);
        assertEq(citizenNFT.inquireAboutHistory(), _maxFoundingCitizens);
    }

    function testFailnonOwnerChangeCitizenCost(uint96 _weiAmmount) public {
        _weiAmmount = _weiAmmount % 100000000000000000000;
        bob.legislateCostOfEntry(_weiAmmount);
        payable(address(bob)).transfer(100 ether);
        uint256 token1;
        token1 = bob.onlineApplicationForCitizenship(_weiAmmount);
        assertEq(token1, 1);
        assertEq(citizenNFT.inquireCostOfEntry(), _weiAmmount);
    }

    function testFailChangeCitizensNumber(uint256 _housingNumber) public {
        bob.legislateForHousing(_housingNumber);
        assertEq(citizenNFT.inquireHousingNumbers(), _housingNumber);
    }
}

contract advancedTesting is CitizenTest {
    function proveFailnonOpenSeaUserGetRefugee(uint96 _tokenId) public {
        bob.applyForRefugeeStatus(_tokenId);
    }
}
