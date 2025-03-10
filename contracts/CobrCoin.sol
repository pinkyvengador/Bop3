// SPDX-License-Identifier: MIT
pragma solidity ^0.8.x;

/// @title BOP3 Token Contract
/// @notice Implements a basic ERC20 token.
contract BOP3 {
    string public name = "BOP3";
    string public symbol = "BOP3";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// @notice Constructor that initializes the token supply.
    /// @param initialSupply The initial supply of tokens.
    constructor(uint256 initialSupply) {
        totalSupply = initialSupply * 10 ** decimals;
        _balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /// @notice Returns the balance of an account.
    /// @param account The address to query.
    /// @return The balance of the account.
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /// @notice Transfers tokens to a specified address.
    /// @param to The address to transfer to.
    /// @param value The amount of tokens to transfer.
    /// @return A boolean indicating success.
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /// @notice Transfers tokens from one address to another.
    /// @param from The address to transfer from.
    /// @param to The address to transfer to.
    /// @param value The amount of tokens to transfer.
    /// @return A boolean indicating success.
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _spendAllowance(from, msg.sender, value);
        _transfer(from, to, value);
        return true;
    }

    /// @notice Approves a spender to spend tokens.
    /// @param spender The address to approve.
    /// @param value The amount of tokens to approve.
    /// @return A boolean indicating success.
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "ERC20: approve to zero address");
        require(msg.sender != address(0), "ERC20: approve from zero address");
        
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /// @notice Returns the remaining allowance for a spender.
    /// @param owner The address of the owner.
    /// @param spender The address of the spender.
    /// @return The remaining allowance.
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /// @notice Internal function to transfer tokens.
    /// @param from The address to transfer from.
    /// @param to The address to transfer to.
    /// @param value The amount of tokens to transfer.
    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(value > 0, "ERC20: transfer value must be greater than zero");
        require(_balances[from] >= value, "ERC20: insufficient balance");

        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
    }

    /// @notice Internal function to approve a spender.
    /// @param owner The address of the owner.
    /// @param spender The address of the spender.
    /// @param value The amount of tokens to approve.
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /// @notice Internal function to spend allowance.
    /// @param from The address to spend from.
    /// @param spender The address of the spender.
    /// @param value The amount of tokens to spend.
    function _spendAllowance(address from, address spender, uint256 value) internal {
        uint256 currentAllowance = allowance(from, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= value, "ERC20: insufficient allowance");
            _approve(from, spender, currentAllowance - value);
        }
    }
}
