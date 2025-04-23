// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IFinancialBondMetadata} from "../interfaces/IFinancialBondMetadata.sol";

abstract contract FinancialBondMetadata is IFinancialBondMetadata {
    address public issuer;

    uint256 _faceValue;
    uint256 _totalSupply;

    uint256 _issueDate;
    uint256 _maturityDate;

    uint256 _totalCoupons;
    uint256 _couponRate;
    uint256 _couponFrequency;
    uint256 _previousCoupon;

    string _isin;
    string _name;

    function isin() external view returns(string memory) {
        return _isin;
    }

    function name() external view returns(string memory) {
        return _name;
    }

    function faceValue() external view returns(uint256) {
        return _faceValue;
    }
    
    function totalSupply() external view returns(uint256) {
        return _totalSupply;
    }

    function issueDate() external view returns(uint256) {
        return _issueDate;
    }

    function maturityDate() external view returns(uint256) {
        return _maturityDate;
    }

    function totalCoupons() external view returns(uint256) {
        return _totalCoupons;
    }
    
    function couponRate() external view returns(uint256) {
        return _couponRate;
    }
    
    function couponFrequency() external view returns(uint256) {
        return _couponFrequency;
    }

    function nextCoupon() external view returns(uint256) {
        return _previousCoupon + 31536000 / _couponFrequency;
    }

    function accumulatedCouponIncome() external view returns(uint256) {
        return (_faceValue / 10000 * _couponRate * (block.timestamp - _previousCoupon) / (31536000 / _couponFrequency));
    }
}