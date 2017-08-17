/************************************
 * COINFLIP CROWDSALE
 * v1.0.0
 * Created: July 19, 2017 20:50
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 19, 2017 22:44
 ************************************/

// A base contract used by anything that wants to do "untyped" calls
//(*) Blanket for .call (via exec and tryExec)

pragma solidity ^0.4.8;

contract Exec {
    function tryExec( address target, bytes calldata, uint value)
             internal
             returns (bool call_ret)
    {
        return target.call.value(value)(calldata);
    }
    function exec( address target, bytes calldata, uint value)
             internal
    {
        if(!tryExec(target, calldata, value)) {
            revert();
        }
    }

    // Convenience aliases
    function exec( address t, bytes c )
        internal
    {
        exec(t, c, 0);
    }
    function exec( address t, uint256 v )
        internal
    {
        bytes memory c; exec(t, c, v);
    }
    function tryExec( address t, bytes c )
        internal
        returns (bool)
    {
        return tryExec(t, c, 0);
    }
    function tryExec( address t, uint256 v )
        internal
        returns (bool)
    {
        bytes memory c; return tryExec(t, c, v);
    }
}
