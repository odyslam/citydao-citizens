// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

/// @title  OpenSeaStoreFront
/// @author Odysseas Lamtzidis
/// @notice A smart contract that is used to simulate the Open Sea shared Storefront smart contract, for testing purposes.
/// This smart contract is NOT deployed on production.
contract OpenSeaStorefront {
    mapping(address => uint256) private numberOfCommonRefugees;
    mapping(address => uint256) private numberOfHighClassRefugees;
    mapping(address => uint256) private numberOfRoyalty;
    uint256 private commonId;
    uint256 private highClassId;
    uint256 private royaltyId;

    constructor() {}

    /// @notice Define the IDs of the different types of Citizen NFTs. These IDs are the same as the ItemIds that are used inside
    /// the Open Sea shared storefront smart contract to differentiate NFTs.
    /// @param _commonId = Regular Citizen NFT
    /// @param _highClassId = Founding Citizen NFT
    /// @param _royaltyId = First Citizen NFT
    function populate(
        uint256 _commonId,
        uint256 _highClassId,
        uint256 _royaltyId
    ) public {
        commonId = _commonId;
        highClassId = _highClassId;
        royaltyId = _royaltyId;
    }

    /// @notice Populate an address with Citizen NFTs. Aftwards, this address can be used to test
    /// the minting of existing Citizen NFTs from the main CitizenNFT smart contract
    function populateAddress(
        address _testRefugee,
        uint256 _numberOfCommonRefugees,
        uint256 _numberOfHighClassRefugees,
        uint256 _numberOfRoyalty
    ) public {
        numberOfCommonRefugees[_testRefugee] = _numberOfCommonRefugees;
        numberOfHighClassRefugees[_testRefugee] = _numberOfHighClassRefugees;
        numberOfRoyalty[_testRefugee] = _numberOfRoyalty;
    }

    function balanceOf(address _testRefugee, uint256 _refugeeType)
        public
        view
        returns (uint256)
    {
        if (
            _refugeeType ==
            23487195805935260354348650824724952235377320432154855752878351301067508033245
        ) {
            return numberOfCommonRefugees[_testRefugee];
        } else if (
            _refugeeType ==
            23487195805935260354348650824724952235377320432154855752878351298868484767794
        ) {
            return numberOfHighClassRefugees[_testRefugee];
        } else {
            return numberOfRoyalty[_testRefugee];
        }
    }
}
