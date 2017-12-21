pragma solidity ^0.4.4;

// import "./ConvertLib.sol";


contract Splitter {

	address public owner;
	bool private paused;
	mapping(address=>uint) public balances; 
	event recievedValue(uint value, address recipient);
	event withdrewValue(uint value, address recipient);
	event isContractStopped(bool paused);


	function Splitter() {
		owner = msg.sender;
	}
	
	function receive( address sender, address recipient1, address recipient2) 
	public
	payable 
	returns(bool success){
		require(sender != 0);
		require(recipient1 != 0);
		require(recipient2 != 0);
		require(msg.value > 0);
		require(!paused);
	    uint r = msg.value % 2;
	    uint value = msg.value / 2;
	    balances[recipient1] = value;
	    balances[recipient2] = value;
	    msg.sender.transfer(r);
	    recievedValue(value, recipient1);
	    recievedValue(value, recipient2);
	    return true;

	}

	function withdraw() 
	public 
	returns(bool success){
		require(!paused);
		require(balances[msg.sender] != 0);
		uint funds = balances[msg.sender];
		balances[msg.sender] = 0;
		msg.sender.transfer(funds);
		withdrewValue(funds, msg.sender);
	    return true;
	}

	function stop()
	public
	returns(bool success){
		require(msg.sender == owner);
		paused = true;
		isContractStopped(paused);
		return true;
	}

	function run()
	public
	returns(bool success){
		require(msg.sender == owner);
		paused = false;
		isContractStopped(paused);
		return true;
	}
	
}
