pragma solidity ^0.4.4;

// import "./ConvertLib.sol";


contract Splitter {

	address private owner;
	bool private paused;
	mapping(address=>uint) public balances; 
	event RecievedValue(uint value, address sender, address recipient1, address recipient2);
	event WithdrewValue(uint value, address recipient);
	event IsContractStopped(bool paused);

	modifier onlyIfRunning {
  		require(!paused);
  		_;
	}


	function Splitter () {
		owner = msg.sender;
	}
	
	function receive (address recipient1, address recipient2) 
	public
	payable 
	onlyIfRunning
	returns(bool success){
		require(recipient1 != 0);
		require(recipient2 != 0);
		require(msg.value > 0);
	    uint r = msg.value % 2;
	    uint value = msg.value / 2;
	    balances[recipient1] = value;
	    balances[recipient2] = value;
	   	RecievedValue(value, msg.sender, recipient1, recipient2);
	    msg.sender.transfer(r);
	    return true;

	}

	function withdraw() 
	public 
	onlyIfRunning
	returns(bool success){
		require(!paused);
		require(balances[msg.sender] != 0);
		uint funds = balances[msg.sender];
		balances[msg.sender] = 0;
		WithdrewValue(funds, msg.sender);
		msg.sender.transfer(funds);
	    return true;
	}

	function stop()
	public
	onlyIfRunning
	returns(bool success){
		require(msg.sender == owner);
		paused = true;
		IsContractStopped(paused);
		return true;
	}

	function run()
	public
	returns(bool success){
		require(msg.sender == owner);
		paused = false;
		IsContractStopped(paused);
		return true;
	}

	function getOwner()
	public 
	constant 
	returns(address theOwner) {
  		return owner;
	}

	function isPaused()
	public 
	constant 
	returns(bool state) {
  		return paused;
	}
	
}
