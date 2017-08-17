/*************************************
 * COINFLIP 
 * Created: July 18, 2017 05:14
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 05:15
 *************************************/

pragma solidity ^0.4.8;

// Note
// 'note' modifier : for logging calls as events
contract Note {
    event LogNote(
        bytes4   indexed  sig,
        address  indexed  addy,
        bytes32  indexed  foo,
        bytes32  indexed  bar,
	    uint	 	      pot,
        bytes             fax
    ) anonymous;

    modifier note {
        bytes32 foo;
        bytes32 bar;

        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
        }

        LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);

        _;
    }
}