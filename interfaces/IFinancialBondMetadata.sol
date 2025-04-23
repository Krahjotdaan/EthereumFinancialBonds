// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFinancialBondMetadata {

    event CouponPayment(uint256 indexed couponRate, uint256 indexed denomination, uint256 indexed totalSupply);

    function isin() external view returns(string memory);

    function name() external view returns(string memory);

    function denomination() external view returns(uint256);

    function totalSupply() external view returns(uint256);

    function issueDate() external view returns(uint256);

    function maturityDate() external view returns(uint256);

    function totalCoupons() external view returns(uint256);

    function couponRate() external view returns(uint256);

    function couponFrequency() external view returns(uint256);

    function nextCoupon() external view returns(uint256);

    function accumulatedCouponIncome() external view returns(uint256);
}