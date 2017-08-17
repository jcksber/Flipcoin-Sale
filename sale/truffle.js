module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 4712388, // 4 milliShannon
      gasPrice:100000000000, // 100 Shannon == 100 billion Wei
    },
    testnet: {
      host: "127.0.0.1",
      //host: "192.241.195.178",
      port: 45585,
      network_id: "*", // Match any network id
      gas: 4712388, // 4 milliShannon
      gasPrice:100000000000, // 100 Shannon == 100 billion Wei
    },
    live: {
      host: "localhost",
      port:8545,
      network_id: 1,
      gas: 4712388, // 4 milliShannon
      gasPrice:100000000000, // 100 Shannon == 100 billion Wei
    }
  },
  mocha: {
    useColors: true
  }
};
