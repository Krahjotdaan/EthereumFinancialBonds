// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFinancialBondMetadata {

    function isin() external view returns(string memory);

    function name() external view returns(string memory);

    function faceValue() external view returns(uint256);

    function totalSupply() external view returns(uint256);

    function issueDate() external view returns(uint256);

    function maturityDate() external view returns(uint256);

    function totalCoupons() external view returns(uint256);

    function couponRate() external view returns(uint256);

    function couponFrequency() external view returns(uint256);

    function nextCoupon() external view returns(uint256);

    function accuredInterest() external view returns(uint256);
}