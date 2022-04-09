pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract YourContract {
    event SetPurpose(address sender, string purpose);
    event SetMasterPurpose(address sender, string masterPurpose);

    string public purpose = "Started Finally!";
    string public masterPurpose = "Only " "MASTER OWNER" " can change !";

    constructor() payable {
        // what should we do on deploy?
    }

    uint256 public writePrice = 0.01 ether;
    address public owner = 0x69C784748bA48614F063030d2184149178A74BbF;

    function setPurpose(string memory newPurpose) public payable {
        purpose = newPurpose;
        console.log(msg.sender, "set purpose to", purpose);
        require(msg.value >= writePrice, "Not enought ether");
        emit SetPurpose(msg.sender, purpose);
    }

    function setMasterPurpose(string memory newMasterPurpose) public payable {
        require(msg.sender == owner, "Not the owner");
        masterPurpose = newMasterPurpose;

        emit SetMasterPurpose(msg.sender, masterPurpose);
    }

    function withdraw() public payable {
        require(msg.sender == owner, "Not the owner, you pice of shit");
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Failed to withdraw");
    }

    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}
}
