module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    "net42": {
      host: "localhost",
      port: 8545,
      network_id: "*",
      gas: 4712388
    },
  }
};