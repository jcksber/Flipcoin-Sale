 /****************************************************************
 * Claimable.sol - modifier & address for buyer who needs to claim
 * Created: July 18, 2017 04:04
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 04:15
 *****************************************************************/

import "./Ownable.sol";

pragma solidity ^0.4.11;

 // Claimable
 // Extension for the Ownable contract, where the ownership needs to be claimed.
 // This allows the new owner to accept the transfer.

contract Claimable is Ownable {
  address public pendingOwner;

  function transferOwnership(address heir) onlyOwner {
    pendingOwner = heir;
  }

  function claimOwnership() onlyPendingOwner {
    owner = pendingOwner;
    pendingOwner = 0x0;
  }

  modifier onlyPendingOwner() {
    if (msg.sender != pendingOwner) { revert(); }
    _;
  }
}
