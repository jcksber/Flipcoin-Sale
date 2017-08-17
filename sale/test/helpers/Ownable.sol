/**************************************************************
 * Owner.sol - modifier & address tracker for a singular owner
 * Created: July 18, 2017 04:06
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 04:10
 **************************************************************/
pragma solidity ^0.4.11;

// Ownable
// The contract has an owner address, and provides basic authorization control
// functions, this simplifies the implementation of "user permissions".

contract Ownable {
  address public owner;

  function Ownable() {
    owner = msg.sender;
  }

  function transferOwnership(address heir) onlyOwner {
    if (heir != address(0)) {
      owner = heir;
    }
  }


  modifier onlyOwner() {
    if (msg.sender != owner) { revert(); }
    _;
  }
}
