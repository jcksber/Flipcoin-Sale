 /**************************************************************
 * Owner.sol - modifier & address tracker for a singular owner
 * Created: July 18, 2017 04:20
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 04:21
 **************************************************************/

import "./Ownable.sol";

pragma solidity ^0.4.11;

// Contactable
// Basic version of a contactable contract, allowing the owner to provide a string with their
// contact information.
contract Contactable is Ownable {

    string public contactInformation;

    function setContactInformation(string info) onlyOwner {
         contactInformation = info;
     }
}
