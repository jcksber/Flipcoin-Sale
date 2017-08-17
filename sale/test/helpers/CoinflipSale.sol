/*0xfF5abAf74Ae9102077079fE058f5AA1963337637*/
pragma solidity ^0.4.11;

import "./Auth.sol";
import "./Exec.sol";
import "./SafeMath.sol";
import "./Flipcoin20.sol";

contract CoinflipSale is Auth, SafeMath {
    Flipcoin20      public  Flipcoin;             // Flipcoin: Token being sold

    uint            public  totalSupply;          // Total FlipCoin amount created
    uint            public  foundersAllocation;   // Amount given to founders
    uint            public  saleAllocation;       // Total amount of sellable tokens

    address         public  foundersWallet;       // wallet address of founder
    address         public  flipcoinAddress;

    uint            public  startBlock;           // Starting block of crowdsale
    uint            public  endBlock;             // Ending block of Crowdsale

    uint            public  price;                // (FLP/ETH) Default sale price of Flipcoin  - triggered if GetPrice comparisons fail
    uint            public  tierOne;              // (FLP/ETH) Token Tier-one price, triggered at start of sale (FLP/ETH)
    uint            public  tierTwo;              // (FLP/ETH) Token Tier-two price, triggered after tierOneLimit threshold exceeded (FLP/ETH)
    uint            public  tierThree;            // (FLP/ETH) Token Tier-three price, triggered after tierTwoLimit threshhold exceeded (FLP/ETH)

    uint            public  tierOneLimit;          // tierOne price threshold
    uint            public  tierTwoLimit;          // tierTwo price threshold
    uint            public  tierThreeLimit;        // tierThree price threshold
    uint            public  tierFourLimit;         // tierFour price threshold

    uint            public  totalMinted   = 0;
    uint            public  fundingAmount = 0;

    bool            public  saleFinalized = false;        // has Coinflip sale finalized?
    bool            public  saleStopped   = false;        // has Coinflip stopped selling?
    bool            public  reopenLock    = false;        // has Coinflip been reopened?

    uint            public  fundingMinimum;               // minimum-funding amount in Wei

    uint  constant  public  decimalMultiplier = 10**18;   // ether-to-Wei conversion


    mapping (uint => uint)                       public  dailyTotals;
    mapping (address => uint)                    public  userBuys;

    event LogBuy        (address user, uint amount);
    event LogCollect    ( address user, uint amount);
    event LogRegister   (address user, address key);
    event LogRetrieved    (uint amount);
    event LogFinalized  ();
    event LogStopped    ();
    event LogOpened     ();


    ////////////////////////////////////////
    /* ---------- Coinflip Sale --------- */
    ////////////////////////////////////////

    // @dev:  Contract creator needs to input the following correct parameters.
    // @param: (uint) _startBlock is the block number of when the crowdsale would start.
    // @param: (uint) _endBlock is the block number of when the crowdsale would end. Flipcoin sale lasts 1 month -
    //                block number would be predicted using etherscan and gasstation metrics
    // @param: (address) _foundersWallet is the address of the founder's cold storage wallet. Funds would be redirected to this address
    // @param: (uint) _fundingMinimum is the minimum ether funding amount in Wei.
    // @notice: Although there are checks during contract construction, Flipcoin contract creator requires due diligence.

    function CoinflipSale(
        uint     _startBlock,
        uint     _endBlock,
        address  _foundersWallet,
        uint     _fundingMinimum
    ) {
        startBlock         = _startBlock;
        endBlock           = _endBlock;
        foundersWallet     = _foundersWallet;
        fundingMinimum      = _fundingMinimum * 1 ether;

        totalSupply        = 0;                 // Total number of tokens minted  (in 18 decimal places)
        totalMinted        = 0;                 // Initial Mint amount is         (in 0 decimal places)
        saleAllocation     = 50000000;          // Total number of tokens minted  (in 0 decimal places)

        price              = 800  ;             // - FALL BACK PRICE - 1 USD/FLP by default
        tierOne            = 2000 ;             // - ADJUSTED 1 HOUR BEFORE CROWDSALE - 0.05 USD/FLP
        tierTwo            = 1600 ;             // - ADJUSTED 1 HOUR BEFORE CROWDSALE - 0.1 USD/FLP
        tierThree          = 1000 ;             // - ADJUSTED 1 HOUR BEFORE CROWDSALE - 0.5 USD/FLP

        tierOneLimit       = 1000000;           // - MAY ADJUST - first 1% of total tokens sold @ tierOne price in Wei
        tierTwoLimit       = 2000000;           // - MAY ADJUST - first 2% of total tokens sold @ tierTwo price in Wei
        tierThreeLimit     = 3000000;           // - MAY ADJUST - first 3% of total tokens sold @ tierThree price in Wei
        tierFourLimit      = 4000000;           // - MAY ADJUST - first 4% of total tokens sold @ tierFour price in Wei


        // Creates Flipcoin
        Flipcoin = new Flipcoin20();
        flipcoinAddress = address(Flipcoin);

        // assertion checks
        assert(fundingMinimum > 0);
        assert(startBlock < endBlock);
        assert(sub(endBlock,startBlock) >= 100);


    }

    ////////////////////////////////////////
    /* ---------- Token Buying  --------- */
    ////////////////////////////////////////

    // @dev: Main buying function for token sale. Calls buyInternal function with sender address
    function Buy() public payable
    {
       buyInternal(msg.sender);
    }

    // @dev: ProxyBuy allows a third-party to pay on behalf of a future token-holder.
    // @param: (address) address of the receiver
    function ProxyBuy(address reciever) public payable
    {
       buyInternal(reciever);
    }

    // @dev: fallback function calls are revert()n
    function () public payable {
       ProxyBuy(msg.sender);
    }


    ////////////////////////////////////////
    /* ------- Internal Functions ------- */
    ////////////////////////////////////////


    // @dev: buyInternal is an internal function that receives ether and assigns
    //       Flipcoins to contributer
    // @param: (address) address of contributer
    function buyInternal(address _address)
        internal
        during_sale_period
        non_zero_address(_address)
    {
        assert(msg.value >= 0.01 ether);

        // Price calculation
        price = getPrice(totalMinted);
        uint reward = mul(price, msg.value);

        // Capped crowdsale at 50 million tokens sold
        require(withinCap(totalSupply, reward));

        //Update metrics
        fundingAmount += msg.value * 1 ether;
        userBuys[_address] += reward;

        //Assign Flipcoins to investor
        assignFlipcoin(msg.sender,reward);

        //Push ether to foundersWallet
        sendToWallet(msg.value);

    }

    // @dev: getPrice is an internal function that receives the total supply of tokens minted
    //       and returns the given price level
    // @param: (uint) total # of tokens minted
    function getPrice(uint _totalMinted)
             internal
             returns (uint)
    {
        assert(_totalMinted >= 0);
        if (_totalMinted <= tierOneLimit ){ return tierOne;}
        else if (_totalMinted > tierOneLimit && _totalMinted <= tierTwoLimit ) {return tierTwo;}
        else if (_totalMinted > tierTwoLimit && _totalMinted <= tierThreeLimit) {return tierThree;}
        else {return price;}
    }

    // @dev: time is an internal function that returns the current block number
    // @notice: returned value is a (uint)
   function getBlock()
            constant
            internal
            returns (uint)
   {
       return block.number;
   }

   // @dev: withinCap determines whether if the incoming transaction will be in-cap or out
   // @param: (uint) _totalSupply: total supply of tokens created in 18 DECIMALS
   // @param: (uint) _amount: ether value in Wei (18 DECIMALS)
   // @notice: comparison logic is conducted with a multiplier - DECIMALS
   function withinCap(uint _totalSupply, uint _amount) internal returns (bool)
   {
      uint newTotal = add(_totalSupply, _amount);
      if (newTotal <= mul(saleAllocation,decimalMultiplier)){return true;}
      else {return false;}
   }



   ////////////////////////////////////////
   /* -------- Private Functions -------- */
   ////////////////////////////////////////


   // @dev: assignFlipcoin is a private function that mints contributer given amount in wei-FLP amount
   // @param: (address) address of token receiver
   // @param: (uint) the amount of flipcoins in wei-FLP conversion
   // @notice: totalSupply logged in total token mint volume - denominated to 18 decimal places
   // @notice: minumum eth deposit is 0.01 ether. Base price is >= 100, upholding uint type

   function assignFlipcoin(address receiver, uint amount)
            auth
            private
   {
     Flipcoin.mint(receiver, amount);

     // update 18 decimal balance
     totalSupply = add(totalSupply, amount);

     // update 0 decimal balance
     uint tokenAmount = div(amount,decimalMultiplier);
     totalMinted = add(totalMinted,tokenAmount);

     //Trigger LogBuy Event
     LogBuy(receiver, tokenAmount);
   }

   // @dev: internalFinalize is a private function that is called by the finalizeSale function
   // @notice: 50% of total token supply is retained by Coinflip
   function internalFinalize()
            auth
            private
   {
     foundersAllocation = totalSupply;
     assignFlipcoin(foundersWallet, foundersAllocation);
     saleFinalized = true;
   }

   // @dev: sendToWallet is a private function that forwards the contract ether to founder's cold storage
   function sendToWallet(uint balance)
            auth
            private
   {
       uint amount = balance;
       if (!foundersWallet.send(amount)) {revert();}
   }

   ////////////////////////////////////////
   //* -------- Owner Functions -------- */
   ////////////////////////////////////////

   // @notice: All owner functions must are both public and have the 'auth' modifier

   // @notice: ownership is initialized upon contract creation
   // Crowdsale owners can collect ETH any number of times
   function collect()
           auth
           public
           returns (bool)
   {
   sendToWallet(this.balance);
   LogCollect(foundersWallet,this.balance);
   return true;
   }

   // @dev: emergecyStop is a public function that allows the contract owner to stop the token
   //       in an unexpected event. The sale can only stopped during the token sale.
   function emergencyStop()
            auth
            during_sale_period
            public
   {
      saleStopped = true;
      LogStopped();
   }

   // @dev: after stopping crowdsale, the contract owner can restart the crowdsale
   // @notice: - restartSale is a one-way function - contract can be only restarted once

   function restartSale()
            auth
            has_stopped
            reopenable
            public
    {
      saleStopped = false;
      reopenLock = true;
      LogOpened();
    }

   // @dev: finalizeSale is a public function that finalizes the sale
   // @notice: in order to protect the interest of investors, crowdsale can only be finalized after crowdsale ends

   function finalizeSale()
            auth
            after_sale_closed
            public
   {
      internalFinalize();
   }


  ////////////////////////////////////////
  /* ----------- Modifiers  ----------- */
  ////////////////////////////////////////

  // @dev: during_sale_period is a modifier that determines if the msg was sent DURING crowdsale period

   modifier during_sale_period
   {
      assert(getBlock() >= startBlock);
      assert(getBlock() <= endBlock);
      assert(!saleStopped);
      assert(!saleFinalized);
      _;
   }

   // @dev: after_sale_period is a modifier that determines if the msg was sent AFTER crowdsale ends
   modifier after_sale_closed
   {
     assert(getBlock() > endBlock);
     _;
   }

   // @dev: reopenable is a modifier that determines if Flipcoin crowdsale can be re-opened
   modifier reopenable
   {
     assert(!reopenLock);
     _;
   }

   // @dev: has_stopped is a modifier that determines if Flipcoin crowdsale has stopped
   modifier has_stopped
   {
     assert(saleStopped);
     _;
   }

   modifier non_zero_address(address _address)
   {
    require(_address != 0x0);
    _;
   }

}
