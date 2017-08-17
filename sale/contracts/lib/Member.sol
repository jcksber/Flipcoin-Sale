/*************************************************************
 * COINFLIP MEMBERSHIP TOKEN
 * [v1.0.0]
 * Created: July 17, 2017 05:48
 *
 * Author: Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 05:56
 *************************************************************/

import "./Claimable.sol";

pragma solidity ^0.4.11;

// Member
// Inherits Claimable and inspired by Contactable
contract Member is Claimable {
    // Contact information for token owner
    string public contactName;
    string public contactPhone;
    string public contactEmail;

    // Setter methods
    function setContactName(string name) onlyOwner {
      contactName = name;
    }

    function setContactPhone(string phone) onlyOwner {
      contactPhone = phone;
    }
}
