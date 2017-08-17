/*************************************
 * COINFLIP
 * Created: July 18, 2017 04:58
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 05:09
 *************************************/

pragma solidity ^0.4.8;

// Authority interface
contract Authority {
    function canCall(
        address src, address dst, bytes4 sig
    ) constant returns (bool);
}

contract AuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
    event LogSetHelper    (address indexed helper):
}

// Auth
// Access control pattern for Ethereum
contract Auth is AuthEvents {
    Authority public authority;
    address public owner;
    address public founder;
    address public helper;

    // Auth - constructor
    function Auth() {
        owner = msg.sender;
        LogSetOwner(msg.sender);
    }

    // Setter functions
    function setOwner(address owner_)
        auth
    {
        owner = owner_;
        LogSetOwner(owner);
    }

    function setFounder(address founder_)
        auth
    {
        founder = founder_;
        LogSetHelper(helper);

    }

    function setAuthority(Authority authority_)
        auth
    {
        authority = authority_;
        LogSetAuthority(authority);
    }

    modifier auth {
        assert(isAuthorized(msg.sender, msg.sig));
        _;
    }

    // Internal helper functions
    function isAuthorized(address src, bytes4 sig) internal returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (src == founder) {
            return true;
        } else if (authority == Authority(0)) {
            return false;
        } else {
            return authority.canCall(src, this, sig);
        }
    }

    function assert(bool x) internal {
        if (!x) revert();
    }
}
