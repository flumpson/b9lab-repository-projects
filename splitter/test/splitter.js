var Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts) {

  owner = accounts[0];

  beforeEach(function(){
    return Splitter.new({from: owner});
  });

  it(`should check that owner is correct`, function() {
    return Splitter.deployed().then(_instance => {
      instance = _instance;
      return instance.getOwner.call({ from: accounts[0] });
    }).then(owner => {
      console.log(owner);
      assert.equal(owner, accounts[0], "should be equal")
    })
  });

  it(`should call stop, then check if pause is true`, function() {
    return Splitter.deployed().then(_instance => {
      instance = _instance;
      return instance.stop.sendTransaction( {from: owner });
    }).then(paused => {
      return instance.isPaused.call({ from: accounts[0] });
    }).then(paused => {
      assert.equal(true, paused, "call to stop was unsuccesful")
    });
  });

    // it(`should use getter on contract pause variable expecting false, 
  //   then set it to true, then call getter again to verify. 
  //   It should then call stop, and verify the setter worked`, function() {
  //   return Splitter.deployed().then(_instance => {
  //     instance = _instance;
  //     return instance.isPaused.call({ from: accounts[0] });
  //   }).then(paused => {
  //     assert.isFalse(paused, "paused is set to false at Init")
  //     instance.stop.call( {from: accounts[0] });
  //     return instance.isPaused({ from: accounts[0] });
  //   }).then(paused => {
  //     assert.isTrue(paused, "paused is set to true after calling stop");
  //     instance.run.call( {from: accounts[0] });
  //     return instance.isPaused({ from: accounts[0] });
  //   }).then(paused => {
  //     // console.log(paused);
  //     assert.isFalse(paused, "paused is set to false after calling run");
  //   })
  // });
});
// web3.eth.getAccounts((err, accounts) => account0 = accounts[0])
// Splitter.deployed().then(instance => instance.stop.call({from:account0}))
// Splitter.deployed().then(instance => instance.isPaused.call({from:account0}))
