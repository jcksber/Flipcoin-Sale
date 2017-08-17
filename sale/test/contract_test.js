// const ether          =  require('./helpers/ether');
// const advanceToBlock =  require('./helpers/advanceToBlock');
// const EVMThrow       =  require('./helpers/EVMThrow');
//
// const assertJump = require('./helpers/assertJump');
// utils = require("./utils/utils.js");
// utils.setWeb3(web3);
//
// const should = require('chai-as-promised')
//   .should
//
// const assert = require("assert");
// const BigNumber = web3.BigNumber
// const Flipsale = artifacts.require("CoinflipSale");
// const Flipcoin = artifacts.require("Flipcoin20");
// const Flipcoin_Standard = artifacts.require("Flipcoin_Standard");
// const Flipcoin_Abstract = artifacts.require("Flipcoin_Abstract");
//
// // because im a neanderthal and use old es versions
// require("babel-core").transform("code", {
//   plugins: ["syntax-async-functions"]
// });
//
//
// contract('CoinflipSale', function(accounts){
//
//   const value = ether(1);
//
//   wallet = accounts[0];
//   owner = wallet;
//
//   accountOne    = accounts[1];
//   accountTwo    = accounts[2];
//   accountThree  = accounts[3];
//   accountFour   = accounts[4];
//   accountFive   = accounts[5];
//
//     beforeEach( () => {
//       this.startBlock = web3.eth.blockNumber + 1
//       this.endBlock   = web3.eth.blockNumber + 1000
//       this.max        = 10000;
//       Flipsale.new(this.startBlock, this.endBlock, wallet,this.max, {from:wallet}).then(function(instance){
//         this.Flipsale = instance.deployed();
//       })
//     })
//
//
//     // TESTING BLOCK_NUMBER LOGIC
//     // Using accountOne
//     it('should reject payments before start',function() {
//       advanceToBlock(this.startBlock - 1)
//       Flipsale.deployed().then(function(deployed){
//         return deployed.Buy({value: value, from: accountOne}).should.be.rejectedWith(EVMThrow)
//       })
//     })
//
//
//     it('should accept payments after start',function(done) {
//       // advanceToBlock(this.startBlock + 10)
//       // Flipsale.new(this.startBlock, this.endBlock, wallet,this.max, {from:wallet}).then(function(instance){
//       //   return instance.sendTransaction({value, from: accountOne, gas: 200000})
//       // }).then(function(){
//       //   return Flipsale.Flipcoin()
//       // }).then(function(token){
//       //   token.balanceOf(accountOne)
//       // }).then(function(number){
//       //   let balance = number;
//       //   let expectedBalance = value * 2000
//       //   assert.equal(balance,expectedBalance)
//       // })
//       Flipsale.deployed().then(function(deployed){
//         return deployed.Buy({value: value, from: accountOne})
//       }).then(() => {done() }).catch(done)
//     })
//
//     // TESTING BUY FUNCTIONS
//
//
//     //
//     // // buying at tierOne price
//     // it('should update token balance after buy',function(done) {
//     //     // advanceToBlock(this.startBlock + 2)
//     //     Flipsale.deployed().then(function(deployed){
//     //     deployed.sendTransaction({value, from: accountOne})
//     //     return deployed.flipcoinAddress()
//     //   }).then(function(address){
//     //     Flipcoin.at(address)
//     //     return Flipcoin.balanceOf(accountTwo)
//     //   }).then(function(balance){
//     //     let expectedValue = value * 2000
//     //     assert.equal(expectedValue, balance)
//     //   }).then(() => {done() })
//     // })
//     //
//     //
//     // it('should increase totalMinted by value * price',function (done) {
//     //   advanceToBlock(web3.eth.blockNumber + 1)
//     //   Flipsale.deployed().then(function(deployed){
//     //       var sale = deployed
//     //       sale.Buy({value: value, from: accountTwo})
//     //       return sale.Flipcoin()
//     //   }).then(function(token){
//     //       return Flipcoin.at(token)
//     //   }).then(function(deployed) {
//     //       let totalMinted = sale.totalMinted
//     //       let balance= deployed.balanceOf(accountTwo)
//     //       let expectedValue = value * 2000
//     //
//     //       assert.equal(totalMinted,expectedValue)
//     //       assert.equal(balance, expectedValue)
//     //   }).then(() => {done() })
//     // })
//     //
//     //
//     // it('should allow proxyBuy function during sale', function(done) {
//     //   advanceToBlock(this.startBlock + 4)
//     //   Flipsale.deployed().then(function(deployed){
//     //     deployed.ProxyBuy(accountThree,{value: value, from: accountThree})
//     //   }).then(function(deployed){
//     //     return deployed.balanceOf(accountTwo)
//     //   }).then(function(balance){
//     //     amount = balance
//     //     let expectedValue = value * 2000;
//     //     assert.equal(expectedValue, amount)
//     //   }).then(() => {done() })
//     // })
//     //
//     //
//     // it('should reject payments after end', function() {
//     //   advanceToBlock(this.endBlock + 5)
//     //   Flipsale.deployed().then(function(deployed){
//     //     return deployed.Buy({value: value, from: accountOne}).should.be.rejectedWith(EVMThrow)
//     //   }).then(() => {done() })
//     // })
//     //
//     //
//     //
//     //
//     //
//
//       // it('should assign tokens to sender', async function () {
//       //   await this.crowdsale.sendTransaction({value: value, from: investor})
//       //   let balance = await this.token.balanceOf(investor);
//       //   balance.should.be.bignumber.equal(expectedTokenAmount)
//       // })
//       //
//       // it('should forward funds to wallet', async function () {
//       //   const pre = web3.eth.getBalance(wallet)
//       //   await this.crowdsale.sendTransaction({value, from: investor})
//       //   const post = web3.eth.getBalance(wallet)
//       //   post.minus(pre).should.be.bignumber.equal(value)
//       // })
//
//
// });
// //   it('should allow payment and return Flipcoin balance of priceTierOne', function(done) {
// //     FlipSale.new(numberOfDays,openTime,startTime,wallet).then(function(instance){
// //       sale = FlipSale.at(instance.address);
// //       return FlipSale.Flipcoin;
// //     }).then(function(instance){
// //       var token = Flipcoin.at(instance);
// //     }).then(function() {
// //       var acc1 = accounts[3];
// //       web3.eth.sendTransaction({from: acc1, to: sale, value: web3.toWei(1, 'ether'), gasLimit: 21000, gasPrice: 20000000000});
// //     }).then(done).catch(done);
// //   })
// // });
