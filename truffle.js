var HDWalletProvider = require("truffle-hdwallet-provider");

var mnemonic = 'spirit supply whale amount human item harsh scare congress discover talent hamster';

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    }, 
    rinkeby: {
      host: '127.0.0.1',
      port: 7545,
      network_id: "4",
      from: "0x27d8d15cbc94527cadf5ec14b69519ae23288b95", // default address to use for any transaction Truffle makes during migrations
      gas: 4612388, // Gas limit used for deploys
      gasPrice: 10000000000
    },    
    infura: {
      provider: function() { 
        return new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/76ac8ac11a5e4aa4b10788976ee55439') 
      },
      network_id: 4,
      gas: 4612388,
      gasPrice: 100000000000,
    }
  }
};