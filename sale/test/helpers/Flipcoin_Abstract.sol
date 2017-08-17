pragma solidity ^0.4.11;

contract Flipcoin_Abstract {
    function totalSupply() constant returns (uint supply);
    function balanceOf(address who) constant returns (uint256 balance);
    function allowance(address owner, address spender) constant returns (uint256 _allowance);

    function transfer(address to, uint256 value) returns (bool kk);
    function transferFrom(address from, address to, uint256 value) returns (bool kk);
    function approve(address spender, uint256 value) returns (bool kk);

    event Transfer(address indexed from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
