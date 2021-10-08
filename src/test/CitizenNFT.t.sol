// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./utils/CitizenNFTTest.sol";
import "../CitizenNFT.sol";

contract NewCityDAOCitizen is CitizenTest {

    function testBuyCitizenNFT() public {
        payable(address(bob)).transfer(1 ether);
        uint256 token1;
        uint256 token2;
        token1 = bob.onlineApplicationForCitizenship(250000000000000000);
        token2 = bob.onlineApplicationForCitizenship(250000000000000000);

        assertEq(token1, 1);
        assertEq(token2, 2);
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

    function testFailGetOpenSeaFoundingCitizenNFT() public{
        bob.applyForRefugeeStatus(10045);
    }

    function testFailGetOpenSeaFirstCitizenNFT() public{
        bob.applyForRefugeeStatus(0);
    }
}
contract existingCityDAOCitizen is CitizenTest {
    uint256 citizenIdCounter;

    function testGetCitizenNFT() public{
        uint256 token1;
        for (citizenIdCounter=1;citizenIdCounter<=10000;citizenIdCounter=citizenIdCounter+1){
            token1 = alice.applyForRefugeeStatus(citizenNFTInternalId);
            assertEq(address(alice), citizenNFT.ownerOf(token1));
        }
    }
    function testGetFoundingCitizenNFT() public {
        uint256 token1;
        for (citizenIdCounter=1001; citizenIdCounter <= 1050;citizenIdCounter=citizenIdCounter+1){
            token1 = alice.applyForRefugeeStatus(foundingCitizenNFTInternalId);
            assertEq(address(alice), citizenNFT.ownerOf(token1));
        }
    }
    function testGetFirstCitizenNFT() public {
        uint256 token1;
        token1 = alice.applyForRefugeeStatus(firstCitizenNFTInternalId);
        assertEq(address(alice), citizenNFT.ownerOf(token1));
    }
}
