/******************************************************************************
 * COINFLIP CROWDSALE [v2.0.0]
 * Created: July 17, 2017 04:42
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 17, 2017 08:00
 *
 * Original source can be found here 
 * -> [https://github.com/OpenZeppelin/zeppelin-solidity/../Crowdsale.sol]
 ******************************************************************************/
 pragma solidity ^0.4.11;

import './Flipcoin20.sol';

// Crowdsale
// Base contract for managing a token crowdsale.
// Crowdsales have a start and end block.
contract Crowdsale {
  using SafeMath for uint256;

  Flipcoin20 public token; // DOUBLE CHECK THIS

  uint256 public startBlock; // INCLUSIVE
  uint256 public endBlock;   // INCLUSIVE
  // address where funds are collected
  address public wallet;
  // how many token units a buyer gets per ETH
  uint256 public price;
  // amount of raised money in wei
  uint256 public amountRaised;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */ 
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  event GoalReached(address beneficiary, uint amountRaised); // unsure
  event FundTransfer(address backer, uint amount, bool isContribution); // unsure


  function Crowdsale(uint256 _startBlock, uint256 _endBlock, uint256 rateInEther, address _wallet) {
    require(_startBlock >= block.number);
    require(_endBlock >= _startBlock);
    require(_rate > 0);
    require(_wallet != 0x0);

    wallet = _wallet;               //formerly called 'beneficiary'
    startBlock = _startBlock;       //unsure
    endBlock = _endBlock;           //unsure
    price = rateInEther * 1 ethers; //evaluates to Wei 
  }

  // Allow investors to purchase Flipcoin 
  function () payable {
    if (crowdsaleClosed) throw;
    uint256 amount = msg.value;
    balanceOf[msg.sender] = amount;
    amountRaised += amount;
    token.transfer(msg.sender, amount / price); // DOUBLE CHECK THIS
    FundTransfer(msg.sender, amount, true);
  }

  // @return true if the transaction can buy tokens
  function validPurchase() internal constant returns (bool) {
    uint256 current = block.number;
    bool withinPeriod = current >= startBlock && current <= endBlock;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod && nonZeroPurchase;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public constant returns (bool) {
    return 
    // add more checks here
  } 


  // DELETED CODE 

  // creates the token to be sold. 
  // function createTokenContract() internal returns (Flipcoin20) {
  //   return new Flipcoin20();
  // }

}
