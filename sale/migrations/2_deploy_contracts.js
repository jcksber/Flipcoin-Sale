let utils = require("../test/utils/utils.js");
utils.setWeb3(web3);

const Flipsale = artifacts.require("CoinflipSale");
const Flipcoin = artifacts.require("Flipcoin20");
const Flipcoin_Standard = artifacts.require("Flipcoin_Standard");
const Flipcoin_Abstract = artifacts.require("Flipcoin_Abstract");

module.exports = function(deployer, network) {

    let accounts = web3.eth.accounts;
    let wallet = accounts[0];
    let deployAccount = accounts[1];

    let startBlock = web3.eth.blockNumber
    let endBlock = web3.eth.blockNumber + 1000
    let min_eth = 1000;

    var sale;
    var token;

    deployer.deploy(Flipsale, startBlock, endBlock, wallet, min_eth).then(function(instance){
      return Flipsale.deployed(instance);
    }).then(function(instance){
        sale = instance;
      return sale.Flipcoin().then(function(instance){
        token = instance;
      })
    });

}
