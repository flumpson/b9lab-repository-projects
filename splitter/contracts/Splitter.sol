pragma solidity ^0.4.4;

// import "./ConvertLib.sol";


contract Splitter {

	address public owner;
	bool private paused;
	mapping(address=>uint) public balances; 


	function Splitter() {
		owner = msg.sender;
		paused = false;
	}
	
	function receive( address _alice, address _bob, address _carol) 
	public
	payable 
	returns(bool success){
		require((_bob != 0 && _alice != 0 && _carol != 0) && (msg.value > 0 && paused == false));
	    uint r = msg.value % 2;
	    balances[_bob] = msg.value / 2;
	    balances[_carol] = msg.value / 2;
	    msg.sender.transfer(r);
	    return true;

	}

	function withdraw() 
	public 
	returns(bool success){
		require((paused == false) && (balances[msg.sender] != 0));
		uint funds = balances[msg.sender];
		balances[msg.sender] = 0;
		msg.sender.transfer(funds);
	    return true;
	}

	function stop()
	public
	returns(bool success){
		require(msg.sender == owner);
		paused = true;
		return true;
	}

	function run()
	public
	returns(bool success){
		require(msg.sender == owner);
		paused = false;
		return true;
	}
	
}
