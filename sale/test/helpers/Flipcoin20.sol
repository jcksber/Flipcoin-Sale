/******************************************************************************
 * COINFLIP MEMBERSHIP TOKEN
 * FLIPCOIN [v1.0.0]
 * Created: July 17, 2017 04:18
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 05:54
 ******************************************************************************/
import "./Stoppable.sol";
import "./SafeMath.sol";
import "./Flipcoin_Standard.sol";

pragma solidity ^0.4.11;


contract Flipcoin20 is Stoppable, Flipcoin_Standard(0) {

    // Name the token
    string public name = "Flipcoin";

    // Declare symbol
    string public symbol = "FLP";
    // Assign decimal #
    uint8 public decimals = 18; // standard


    // Receive ether != bueno
    function () { revert(); }

    // ERC20 call forwards
    function transfer(address dst, uint pot) stoppable note returns (bool) {
        return super.transfer(dst, pot);
    }


    function transferFrom(
        address src, address dst, uint pot
    ) stoppable note returns (bool) {
        return super.transferFrom(src, dst, pot);
    }
    function approve(address addy, uint pot) stoppable note returns (bool) {
        return super.approve(addy, pot);
    }


    // Alias to transfer
    function push(address dst, uint pot) returns (bool) {
        return transfer(dst, pot);
    }

    // Alias to transferFrom
    function pull(address src, uint pot) returns (bool) {
        return transferFrom(src, msg.sender, pot);
    }


    // CREATE Flipcoins in msg.sender
    function mint(address reciever, uint pot) auth stoppable note {
        _balances[reciever] = add(_balances[reciever], pot);
        _supply = add(_supply, pot);
    }

}
