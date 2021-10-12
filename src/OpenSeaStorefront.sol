// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;
contract OpenSeaStorefront {
    mapping(address => uint256) private numberOfCommonRefugees;
    mapping(address => uint256) private numberOfHighClassRefugees;
    mapping(address => uint256) private numberOfRoyalty;
    uint256 private commonId;
    uint256 private highClassId;
    uint256 private royaltyId;

    constructor() {}

    function populate(
        uint256 _commonId,
        uint256 _highClassId,
        uint256 _royaltyId
    ) public {
        commonId = _commonId;
        highClassId = _highClassId;
        royaltyId = _royaltyId;
    }

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

