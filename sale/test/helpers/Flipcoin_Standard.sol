/**********************************************************
 * COINFLIP MEMBERSHIP TOKEN
 * ERC20 BASIC IMPLEMENTATION [v1.0.0]
 * Created: July 17, 2017 04:00
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 20, 2017 00:57
 **********************************************************/
pragma solidity ^0.4.11;

import "./SafeMath.sol";
import "./Flipcoin_Abstract.sol";


contract Flipcoin_Standard is Flipcoin_Abstract, SafeMath {
    uint256 public                                    _supply;
    mapping (address => uint256)                      _balances;
    mapping (address => mapping (address => uint256)) _approvals;


    // Standard Flipcoin
    function Flipcoin_Standard(uint256 supply) {
        _balances[msg.sender] = supply;
        _supply = supply;
    }


    // Getter functions
    function totalSupply() constant returns (uint256) {
        return _supply;
    }

    function balanceOf(address src) constant returns (uint256) {
        return _balances[src];
    }

    function allowance(address src, address addy) constant returns (uint256) {
        return _approvals[src][addy];
    }

    // Token movement handlers
    function transfer(address dst, uint pot) returns (bool) {
        assert(_balances[msg.sender] >= pot);

        _balances[msg.sender] = sub(_balances[msg.sender], pot);
        _balances[dst] = add(_balances[dst], pot);

        Transfer(msg.sender, dst, pot);

        return true;
    }

    function transferFrom(address src, address dst, uint pot) returns (bool) {
        assert(_balances[src] >= pot);
        assert(_approvals[src][msg.sender] >= pot);

        _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], pot);
        _balances[src] = sub(_balances[src], pot);
        _balances[dst] = sub(_balances[dst], pot);

        Transfer(src, dst, pot);

        return true;
    }

    function approve(address addy, uint pot) returns (bool) {
        _approvals[msg.sender][addy] = pot;

        Approval(msg.sender, addy, pot);

        return true;
    }
}
