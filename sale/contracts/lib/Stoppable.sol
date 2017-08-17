/************************************
 * COINFLIP
 * Created: July 18, 2017 04:18
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 05:10
 ************************************/

 pragma solidity ^0.4.10;

import "./Auth.sol";
import "./Note.sol";

contract Stoppable is Auth, Note {

    bool public stopped;

    modifier stoppable {
        assert (!stopped);
        _;
    }
    function stop() auth note {
        stopped = true;
    }
    function start() auth note {
        stopped = false;
    }

}
