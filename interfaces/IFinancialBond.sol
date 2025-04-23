// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFinancialBond {
    
    // events
    /**
    * @notice MUST be emitted when bond tokens are transferred, issued or redeemed, except during contract creation
    * @param _from the account that owns bonds
    * @param _to the account that receives the bond
    * @param _amount amount of bond tokens to be transferred
    */
    event Transfer(address indexed _from, address indexed _to, uint256 _amount);

    /**
    * @notice MUST be emitted when an account is approved or when the allowance is decreased
    * @param _owner bond token's owner
    * @param _spender the account to be allowed to spend bonds
    * @param _amount amount of bond tokens allowed by _owner to be spent by `_spender`
    *        Or amount of bond tokens to decrease allowance from `_spender`
    */
    event Approval(address indexed _owner, address indexed _spender, uint256 _amount);

    // setter functions
    /**
    * @notice Authorizes `_spender` account to manage `_amount`of their bond tokens
    * @param _spender the address to be authorized by the bondholder
    * @param _amount amount of bond tokens to approve
    */
    function approve(address _spender, uint256 _amount) external returns(bool);

    /**
    * @notice Uppers the allowance of `_spender` by `_amount`
    * @param _spender the address to be authorized by the bondholder
    * @param _amount amount of bond tokens to add to allowance
    */
    function increaseAllowance(address _spender, uint256 _amount) external returns(bool);

    /**
    * @notice Lowers the allowance of `_spender` by `_amount`
    * @param _spender the address to be authorized by the bondholder
    * @param _amount amount of bond tokens to remove from allowance
    */
    function decreaseAllowance(address _spender, uint256 _amount) external returns(bool);

    /**
    * @notice Moves `_amount` bonds to address `_to`. This methods also allows to attach data to the token that is being transferred
    * @param _to the address to send the bonds to
    * @param _amount amount of bond tokens to transfer
    */
    function transfer(address _to, uint256 _amount) external returns(bool);

    /**
    * @notice Moves `_amount` bonds from an account that has authorized the caller through the approve function
    *         This methods also allows to attach data to the token that is being transferred
    * @param _from the bondholder address
    * @param _to the address to transfer bonds to
    * @param _amount amount of bond tokens to transfer.
    */
    function transferFrom(address _from, address _to, uint256 _amount) external returns(bool);
}