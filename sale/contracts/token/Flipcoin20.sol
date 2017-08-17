/******************************************************************************
 * COINFLIP MEMBERSHIP TOKEN
 * FLIPCOIN [v1.0.0]
 * Created: July 17, 2017 04:18
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 05:54
 ******************************************************************************/
import "../lib/Stoppable.sol";
import "../lib/Security.sol";
import "../lib/SafeMath.sol";
import "./Flipcoin_Standard.sol";

pragma solidity ^0.4.11;


contract Flipcoin20 is Stoppable, Flipcoin_Standard(0) {

    // Name the token
    string public name = "Flipcoin";
    // Declare symbol
    string public symbol = "FLP";
    // Assign decimal #
    uint8 public decimals = 18; // standard

    // minting lock
    bool  public mintingLocked;

    // constructor function call
    function Flipcoin20()
    {
      super.stop();
      mintingLocked = false;
    }

    // Receive ether != bueno
    function () { revert(); }

    // ERC20 call forwards
    function transfer(address dst, uint pot)
             stoppable
             note
             returns (bool)
    {
        return super.transfer(dst, pot);
    }


    function transferFrom(address src, address dst, uint pot)
             stoppable
             note
             returns (bool)
    {
      return super.transferFrom(src, dst, pot);
    }

    // Alis to approve
    function approve(address addy, uint pot)
             stoppable
             note returns (bool)
    {
        return super.approve(addy, pot);
    }


    // Alias to transfer
    function push(address dst, uint pot)
             stoppable
             returns (bool)
    {
        return transfer(dst, pot);
    }

    // Alias to transferFrom
    function pull(address src, uint pot)
             stoppable
             returns (bool) {
        return transferFrom(src, msg.sender, pot);
    }


    // Create Flipcoins in msg.sender
    function mint(address reciever, uint pot)
             auth
             minting_not_locked
             note
    {
        _balances[reciever] = add(_balances[reciever], pot);
        _supply = add(_supply, pot);
    }

    // lock minting - can be only called once
    function finalized()
             auth
             minting_not_locked
             returns (bool)
    {
      mintingLocked = true;
      super.start();
    }

    // modifier for mint lock -- to be only used for mint function
    modifier minting_not_locked
    {
      assert(!mintingLocked);
      _;
    }


}
