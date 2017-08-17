/******************************************************************************
 * COINFLIP CROWDSALE [v2.0.0]
 * Created: July 17, 2017 04:33
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 19, 2017 00:03
 *
 * Original source can be found here 
 * -> [https://github.com/OpenZeppelin/zeppelin-solidity/../CappedCrowdsale.sol]
 ******************************************************************************/
pragma solidity ^0.4.11;

import './Crowdsale20_bones.sol';

/**
 * @title CappedCrowdsale
 * @dev Extension of Crowsdale with a max amount of funds raised
 */
contract CappedCrowdsale{
  using SafeMath for uint256;

  // 100 million TOTAL_SUPPLY
  uint256 public fundingCap;    // 50 million tokens
  uint256 public fundingGoal;   // UNDECIDED

  uint256 public price;

  uint256 public amountRaised;

  bool fundingCapReached = false;  // booleans for states
  bool fundingGoalReached = false;
  bool crowdsaleClosed = false;
  mapping(address => uint256) public balanceOf; // unsure
  
  // Constructor function for CappedCrowdsale
  function CappedCrowdsale(uint256 cap, uint256 fundingGoalInEthers, uint256 durationInMinutes) {
    fundingCap = cap;
    fundingGoal = fundingGoalInEthers * 1 ether;
    deadline = now + durationInMinutes * 1 minutes;
  }

  // Allow investors to purchase Flipcoin 
  function () 
    payable 
    {
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


  modifier afterDeadline() { 
    if (now >= deadline)
      _; 
  }

  modifier goalMet() {
    if (fundingGoalRaised)
      _;
  }


  function icoSuccess() public constant returns (bool) {

  }

  // @return true if crowdsale goal has been reached event has ended
  function saleClosed() public constant returns (bool) {
    // Immediate conclusions..
    if (crowdsaleClosed)            return true;
    if (amountRaised >= fundingCap) return true;
    // ICO SUCCESS !!!
    if (amountRaised >= fundingGoal) {
      fundingGoalReached = true;
      return false;
    }

    // GoalReached actually will inform the blockchain that
    // crowdsale is over
    return super.hasEnded();

    // if (amountRaised >= fundingGoal) { 
    //   fundingGoalReached = true;       
    //   if (amountRaised >= fundingCap){ 
    //     fundingCapReached = true;         
    //     GoalReached(wallet, amountRaised);
    //     crowdsaleClosed = true;
    //     return true;
    //   }
    // }

    // if (now >= deadline) {
    //   if (fundingGoalReached){
    //     GoalReached(wallet, amountRaised);
    //   }
    //   crowdsaleClosed = true;
    //   return true;
    // }

    // return super.hasEnded();
  }
  
  
  /* checks if the goal or time limit has been reached 
   * and ends the campaign
   */ // INTEGRATE THIS INTO hasEnded() (above)
  // function checkGoalReached() afterDeadline {
  //     if (amountRaised >= fundingGoal){
  //         fundingGoalReached = true;
  //         GoalReached(beneficiary, amountRaised);
  //     }
  //     crowdsaleClosed = true;
  // }



  //  UNSAFE !!!
  // UNFINISHED
  function safeWithdrawal() afterDeadline {
    if (!fundingGoalReached) {
        uint amount = balanceOf[msg.sender];
        balanceOf[msg.sender] = 0;
        if (amount > 0) {
            if (msg.sender.send(amount)) {
                FundTransfer(msg.sender, amount, false);
            } else {
                balanceOf[msg.sender] = amount;
            }
        }
    }

    if (fundingGoalReached && wallet == msg.sender) {
        if (wallet.send(amountRaised)) {  // NO BUENO !!! PULL INSTEAD
              // PUSHES ARE WHEN ATTACKERS CAN RE-ENTER !!!!!
            FundTransfer(wallet, amountRaised, false);
        } else {
            //If we fail to send the funds to beneficiary, unlock funders balance
            fundingGoalReached = false;
        }
    }
  }

}
