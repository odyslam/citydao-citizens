// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./utils/CitizenNFTTest.sol";
import "../CitizenNFT.sol";

contract NewCityDAOCitizen is CitizenTest {
    /// @notice Mint new Citizen NFTs, verify that owners are correct and balance of smart contract
    /// is equal to the value transfered for the minting.
    function testBuyCitizenNFT() public {
        payable(address(bob)).transfer(1 ether);
        uint256 token1;
        uint256 token2;
        uint256 tokenPrice = 250000000000000000;
        token1 = bob.onlineApplicationForCitizenship(tokenPrice);
        token2 = bob.onlineApplicationForCitizenship(tokenPrice);
        assertEq(token1, 0);
        assertEq(token2, 1);
        assertEq(citizenNFT.ownerOf(token1), address(bob));
        assertEq(address(citizenNFT).balance, 2 * tokenPrice);
    }

    /// @notice Output the tokenURI in base64 format to be used in a decoder and observe the json metadata
    function testTokenURI() public {
        payable(address(bob)).transfer(1 ether);
        uint256 token1;
        token1 = bob.onlineApplicationForCitizenship(250000000000000000);
        string memory meta = citizenNFT.tokenURI(token1);
        emit log(meta);
    }

    /// @notice Bob must fail to mint an existing regular Citizen NFT, as he doesn't own any on the OpenSea smart contract
    function testFailGetOpenSeaCitizenNFT() public {
        bob.applyForRefugeeStatus(34);
    }

    /// @notice Bob must fail to mint an existing Founding Citizen NFT, as he doesn't own any on the OpenSea smart contract
    function testFailGetOpenSeaFoundingCitizenNFT() public {
        bob.applyForRefugeeStatus(10045);
    }

    /// @notice  Bob must fail to mint an existing First CItizen NFT, as he doesn't own any n the OpenSea smart contract
    function testFailGetOpenSeaFirstCitizenNFT() public {
        bob.applyForRefugeeStatus(0);
    }
}

contract ExistingCityDAOCitizen is CitizenTest {
    uint256 private citizenIdCounter;

    /// @notice Lengthy test that attemps to mint every single CitizenNFT.
    //    function testGetCitizenNFT() public {
    //        uint256 token1;
    //        for (
    //            citizenIdCounter = 1;
    //            citizenIdCounter <= 10000;
    //            citizenIdCounter = citizenIdCounter + 1
    //        ) {
    //            token1 = alice.applyForRefugeeStatus(citizenNFTInternalId);
    //            assertEq(address(alice), citizenNFT.ownerOf(token1));
    //        }
    //    }
    /// @notice Verify that alice can mint every single founding NFT
    function testGetFoundingCitizenNFT() public {
        uint256 token1;
        for (
            citizenIdCounter = 0;
            citizenIdCounter < 50;
            citizenIdCounter = citizenIdCounter + 1
        ) {
            token1 = alice.applyForRefugeeStatus(foundingCitizenNFTInternalId);
            assertEq(address(alice), citizenNFT.ownerOf(token1));
            assertEq(citizenNFT.citizenshipVerification(token1), 69);
        }
    }

    /// @notice Verify that alice can mint a first citizen NFT
    function testGetFirstCitizenNFT() public {
        uint256 token1;
        token1 = alice.applyForRefugeeStatus(firstCitizenNFTInternalId);
        assertEq(address(alice), citizenNFT.ownerOf(token1));
    }

    /// @notice Verify that Seneca can't mint more existing Citizen NFTs that the ones that are owned
    /// by his address in the Open Sea shared storefront smart contract
    function testFailGetMoreCitizenNFTs() public {
        User seneca = new User(citizenNFT);
        openSeaStorefront.populateAddress(address(seneca), 10, 45, 1);
        uint256 tokenId;
        for (uint256 i = 0; i <= 20; i = i + 1) {
            tokenId = seneca.applyForRefugeeStatus(citizenNFTInternalId);
        }
    }

    /// @notice Test the type of Citizen NFTs owned by Alice
    function testInquireRefugeeStatus() public {
        assertEq(
            citizenNFT.inquireRefugeeStatus(address(alice), 42),
            openSeaStorefront.balanceOf(
                address(alice),
                23487195805935260354348650824724952235377320432154855752878351301067508033245
            )
        );
    }
}

contract Legislate is CitizenTest {
    /// @notice Test the change of cost for acquiring a citizen NFT.
    /// The test is fuzzed, meaning that it will test many different values as arguments
    function testOwnerChangeCitizenCost(uint96 _weiAmmount) public {
        _weiAmmount = _weiAmmount % 100000000000000000000;
        odys.legislateCostOfEntry(_weiAmmount);
        payable(address(bob)).transfer(10000 ether);
        uint256 token1;
        token1 = bob.onlineApplicationForCitizenship(_weiAmmount);
        assertEq(address(bob), citizenNFT.ownerOf(token1));
        assertEq(citizenNFT.inquireCostOfEntry(), _weiAmmount);
    }

    /// @notice Test the change of the maximum number regular Citizen NFTs that can be minted
    /// The test is fuzzed, meaning that it will test many different  values  as arguments
    function testOwnerChangeCitizensNumber(uint96 _housingNumber) public {
        odys.legislateForHousing(_housingNumber);
        assertEq(citizenNFT.inquireHousingNumbers(), _housingNumber);
    }

    /// @notice Test the change of the maximum number of founding Citizen NFTs that can be minted
    function testRewriteHistory(uint96 _maxFoundingCitizens) public {
        odys.rewriteHistory(_maxFoundingCitizens);
        assertEq(citizenNFT.inquireAboutHistory(), _maxFoundingCitizens);
    }

    /// @notice If a non-owner tries to affect the cost of regular Citizen NFTs, it should fail
    function testFailnonOwnerChangeCitizenCost(uint96 _weiAmmount) public {
        _weiAmmount = _weiAmmount % 100000000000000000000;
        bob.legislateCostOfEntry(_weiAmmount);
        payable(address(bob)).transfer(100 ether);
        uint256 token1;
        token1 = bob.onlineApplicationForCitizenship(_weiAmmount);
        assertEq(token1, 1);
        assertEq(citizenNFT.inquireCostOfEntry(), _weiAmmount);
    }

    /// @notice If a non-owner user tries to affect the maximum number of regular Citizen NFTs, it should fail
    function testFailChangeCitizensNumber(uint256 _housingNumber) public {
        bob.legislateForHousing(_housingNumber);
        assertEq(citizenNFT.inquireHousingNumbers(), _housingNumber);
    }

    /// @notice The owner should be able to withdraw the funds that exist in the smart contract
    function testRaidTheCoffers() public {
        payable(address(bob)).transfer(1 ether);
        uint256 token1;
        uint256 token2;
        uint256 tokenPrice = 250000000000000000;
        token1 = bob.onlineApplicationForCitizenship(tokenPrice);
        token2 = bob.onlineApplicationForCitizenship(tokenPrice);
        odys.raidTheCoffers();
        assertEq(address(odys).balance, tokenPrice * 2);
    }
}

contract AdvancedTesting is CitizenTest {
    /// @notice  Symbolically verify that a user without a Citizen NFT locked inside an Open Sea shared storefront Smart Contract,
    /// will always fail to mint an existing Citizen NFT
    function proveFailnonOpenSeaUserGetRefugee(uint96 _tokenId) public {
        bob.applyForRefugeeStatus(_tokenId);
    }
}
