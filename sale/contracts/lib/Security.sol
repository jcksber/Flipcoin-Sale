/********************************************************
 * COINFLIP
 * Created: July 17, 2017 02:57
 *
 * Jack Kasbeer (@jcksber)
 *
 * Modified Last: July 18, 2017 05:57
 ********************************************************/
pragma solidity ^0.4.11;

/***************************
 * RE-ENTRY ATTACK GUARD
 ***************************/
/**
 * @title Helps contracts guard agains rentrancy attacks.
 * @author Remco Bloemen <remco@2π.com>
 * @notice If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {
  // Lock for ENTIRE contract (or function)
  bool private rentrancy_lock = false;

  // Prevents a contract from calling itself, directly or indirectly.
  modifier nonReentrant() {
    if(rentrancy_lock == false) {
      rentrancy_lock = true;
      _;
      rentrancy_lock = false;
    } else {
      revert();
    }
  }
  /* @notice If you mark a function `nonReentrant`, you should also
   * mark it `external`. Calling one nonReentrant function from
   * another is not supported. Instead, you can implement a
   * `private` function doing the actual work, and a `external`
   * wrapper marked as `nonReentrant`.
   */
}
