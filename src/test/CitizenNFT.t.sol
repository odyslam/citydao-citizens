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

    }

    function testFailGetOpenSeaCitizenNFT() public {}

    function testFailGetOpenSeaFoundingCitizenNFT() public{}

    function testFailGetOpenSeaFirstCitizenNFT() public{}
}
contract existingCityDAOCitizen is CitizenTest {


    function testGetCitizenNFT() public{}


    function testGetFoundingCitizenNFT() public{}


    function testGetFirstCitizenNFT() public{}


}
