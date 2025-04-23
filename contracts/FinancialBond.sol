// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IFinancialBond} from "../interfaces/IFinancialBond.sol";
import {FinancialBondMetadata} from "./FinancialBondMetadata.sol";
import {InvestorsStorage} from "./InvestorsStorage.sol";

contract FinancialBond is InvestorsStorage, FinancialBondMetadata, IFinancialBond {

    uint256 public _remainingCoupons;
    bool public _isMatured = false;

    constructor(
        string memory isin_,
        string memory name_,
        uint256 faceValue_, 
        uint256 totalSupply_,
        uint256 couponRate_, 
        uint256 couponFrequency_,
        uint256 totalCoupons_
    ) {
        issuer = msg.sender;
        _isin = isin_;
        _name = name_;
        _faceValue = faceValue_;
        _totalSupply = totalSupply_;
        _issueDate = block.timestamp;
        _maturityDate = _issueDate + (31536000 / couponFrequency_ * totalCoupons_);
        _totalCoupons = totalCoupons_;
        _couponRate = couponRate_;
        _couponFrequency = couponFrequency_;
        _previousCoupon = _issueDate;
        _remainingCoupons = totalCoupons_;

        balances[msg.sender] = _totalSupply;
    }

    function approve(address spender, uint256 amount) external returns(bool) {
        require(!_isMatured, "Financial bond: already matured");
        require(amount > 0, "Financial bond: amount must be greater 0");
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 amount) external returns(bool) {
        require(!_isMatured, "Financial bond: already matured");
        require(amount > 0, "Financial bond: amount must be greater 0");
        allowance[msg.sender][spender] += amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function decreaseAllowance(address spender, uint256 amount) external returns(bool) {
        require(!_isMatured, "Financial bond: already matured");
        require(amount > 0, "Financial bond: amount must be greater to 0");
        require(amount <= allowance[msg.sender][spender], "Financial bond: amount must be lesser or equal to current allowance");
        allowance[msg.sender][spender] -= amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address _to, uint256 _amount) external returns(bool) {
        require(!_isMatured, "Financial bond: already matured");
        require(_amount > 0, "Financial bond: amount must be greater to 0");
        require(balances[msg.sender] >= _amount, "Financial bond: not enough tokens");

        balances[_to] += _amount;
        balances[msg.sender] -= _amount;

        emit Transfer(msg.sender, _to, _amount);

        addInvestor(_to);

        if (balances[msg.sender] == 0) {
            removeInvestor(msg.sender);
        }

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) external returns(bool) {
        require(!_isMatured, "Financial bond: already matured");
        require(_amount > 0, "Financial bond: amount must be greater to 0");
        require(allowance[_from][msg.sender] >= _amount, "Financial bond: not enough allowance to transfer");
        require(balances[_from] >= _amount, "Financial bond: not enough tokens");

        allowance[_from][msg.sender] -= _amount;
    
        balances[_to] += _amount;
        balances[_from] -= _amount;
     
        emit Transfer(_from, _to, _amount);

        addInvestor(_to);

        if (balances[_from] == 0) {
            removeInvestor(_from);
        }

        return true;
    }

    function couponPayment() external payable returns(bool) {
        require(!_isMatured, "Financial bond: already matured");
        require(msg.sender == issuer, "Financial bond: only issuer");
        require(_remainingCoupons > 0, "Financial bond: no coupons available");
        require(block.timestamp >= this.nextCoupon(), "Financial bond: not time to pay next coupon");

        uint256 couponAmount;

        if (_remainingCoupons > 1) {
            couponAmount = _faceValue / 10000 * _couponRate;
        }
        else {
            couponAmount = _faceValue / 10000 * _couponRate + _faceValue;
        }

        require(msg.value == couponAmount * _totalSupply, "Financial bond: msg.value does not match total coupon amount");

        address[] memory _investors = investors();

        for(uint256 i = 0; i < _investors.length; ++i) {
            address investor = _investors[i];
            payable(investor).transfer(couponAmount * balances[investor]);
        }

        _previousCoupon = this.nextCoupon();
        --_remainingCoupons;

        emit CouponPayment(_couponRate, _faceValue, _totalSupply);

        if (_remainingCoupons == 0) {
            _isMatured = true;
        }

        return true;
    }
}