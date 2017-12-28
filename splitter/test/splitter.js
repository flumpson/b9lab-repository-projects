var Splitter = artifacts.require("./Splitter.sol");
let Promise = require("bluebird");
Promise.promisifyAll(web3.eth, { suffix: "Promise" });

contract('Splitter', function(accounts) {

  owner = accounts[0];
  bob = accounts[1];
  carol = accounts[2];


  it(`should check that owner is correct`, function() {
    return Splitter.deployed().then(_instance => {
      instance = _instance;
      return instance.getOwner.call({ from: owner });
    }).then(owner => {
      console.log(owner);
      assert.equal(owner, accounts[0], "owner and accounts[0] should be equal")
    })
  });

  it(`should call stop, then check if paused is true`, function() {
    return Splitter.deployed().then(_instance => {
      instance = _instance;
      return instance.stop.sendTransaction( {from: owner });
    }).then(paused => {
      return instance.isPaused.call({ from: owner });
    }).then(paused => {
      assert.equal(true, paused, "sendTransaction to stop was unsuccesful")
    });
  });

  it(`should call run, then check if paused is false`, function() {
    return Splitter.deployed().then(_instance => {
      instance = _instance;
      return instance.isPaused.call({ from: owner });
    }).then(paused => {
      assert.equal(true, paused, "paused should be true from earlier call to stop")
      return instance.run.sendTransaction( {from: owner });
    }).then(paused => {
      return instance.isPaused.call({ from: owner });
    }).then(paused => {
      assert.equal(false, paused, "sendTransaction to run was unsuccesful")
    });
  });

  it(`sends value to recieve, and checks if each address has half of that value`, function() {
    return Splitter.deployed().then(_instance => {
      instance = _instance;
      return instance.receive.sendTransaction(bob, carol, { value: web3.toWei(1, "ether") ,from: owner });
    }).then(txhash => {
      return instance.balances.call(bob);
    }).then(balance => {
      assert.equal(balance.toString(10), "500000000000000000", "check bob's balance");
      return instance.balances.call(carol);
    }).then(balance =>{
      assert.equal(balance.toString(10), "500000000000000000", "check carol's balance");
    });
  });

  // owner => web3.eth.getBalancePromise(owner)


});
// web3.eth.getAccounts((err, accounts) => account0 = accounts[0])
// Splitter.deployed().then(instance => instance.stop.call({from:account0}))
// Splitter.deployed().then(instance => instance.isPaused.call({from:account0}))
