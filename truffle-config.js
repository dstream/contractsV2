const HDWalletProvider = require('truffle-hdwallet-provider');
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    matic: {
      provider: () => new HDWalletProvider(mnemonic, `https://rpc-mumbai.matic.today`),
      network_id: 16110,
      gas: 8000000,
      gasPrice: '0x0',
      confirmations: 0,
      timeoutBlocks: 200,
      skipDryRun: true
    },
  },

  mocha: {
    // timeout: 100000
  },

  compilers: {
    solc: {
      version: "0.6.11",
      settings: {
       optimizer: {
         enabled: true,
         runs: 200
       },
       evmVersion: "istanbul"
      }
    }
  }
}
