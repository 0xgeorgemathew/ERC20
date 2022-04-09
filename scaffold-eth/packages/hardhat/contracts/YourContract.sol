// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";

contract SyndicateSilver is
    ERC20,
    ERC20Burnable,
    Pausable,
    AccessControl,
    ERC20Permit
{
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BLACKLIST_ROLE = keccak256("BLACKLIST_ROLE");

    // Mapping for black listed addresses
    mapping(address => bool) public blacklistmap;
    //Events for when address is blacklisted
    event Blacklisted(address account);
    event Unblacklist(address account);

    constructor()
        ERC20("Syndicate Silver", "SSC")
        ERC20Permit("Syndicate Silver")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(BLACKLIST_ROLE, msg.sender);
        _mint(msg.sender, 10000 * 10**decimals());
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    // Function that allows to blacklist an address
    function blacklist(address _addr) public onlyRole(BLACKLIST_ROLE) {
        blacklistmap[_addr] = true;
        emit Blacklisted(_addr);
    }

    // Function that removes an address from the blacklist
    function unblacklist(address _addr) public onlyRole(BLACKLIST_ROLE) {
        blacklistmap[_addr] = false;
        emit Unblacklist(_addr);
    }

    // Function that checks if an address is blacklisted
    function isBlacklisted(address _addr) public view returns (bool) {
        return blacklistmap[_addr];
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20) whenNotPaused {
        require(!isBlacklisted(from), "Blacklisted address");
        require(!isBlacklisted(to), "Blacklisted address");

        super._beforeTokenTransfer(from, to, amount);
    }
}
