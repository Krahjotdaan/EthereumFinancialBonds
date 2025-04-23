// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract InvestorsStorage {

    address[] public _investors;
    mapping(address => uint256) private indexes;

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;

    function addInvestor(address _newInvestor) internal returns(bool) {
        require(!contains(_newInvestor), "Investors Storage: Already contains this investor");
        _investors.push(_newInvestor);
        indexes[_newInvestor] = _investors.length;

        return true;
    }

    function contains(address _investor) internal view returns(bool) {
        return indexes[_investor] != 0;
    }

    function removeInvestor(address _investor) internal returns(bool) {
        require(contains(_investor), "Investors Storage: Does not contain such investor");

        // find out the index
        uint256 index = indexes[_investor];

        // moves last element to the place of the value
        // so there are no free spaces in the array
        address lastInvestor = _investors[_investors.length - 1];
        _investors[index - 1] = lastInvestor;
        indexes[_investor] = index;

        delete indexes[_investor];

        _investors.pop();

        return true;
    }

    function investors() internal view returns(address[] memory) {
        return _investors;
    }
}