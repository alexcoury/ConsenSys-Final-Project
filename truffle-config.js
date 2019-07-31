var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "shield goat amateur affair thing apart conduct roast miracle chuckle trim heart";
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!

  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    develop: {
      port: 8545
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/844adf6da58c4ebfa65fa85e2de4fe12")
      },
      network_id: 4
    }   
  }
};
