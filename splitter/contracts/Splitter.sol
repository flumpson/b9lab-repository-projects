pragma solidity ^0.4.4;

// import "./ConvertLib.sol";


contract Splitter {

	address public bob;
	address public alice;
	address public carol;
	address public owner;
	uint public bobsFunds;
	uint public carolsFunds;
	bool private paused;


	function Splitter(address _bob, address _alice, address _carol) {
		require(_bob != 0 && _alice != 0 && _carol != 0);
		bob = _bob;
		alice = _alice;
		carol = _carol;
		owner = msg.sender;
		paused = false;
	}
	
	function receive() 
	public
	payable 
	returns(bool success){
	    require(msg.value > 0 && paused == false);
	    if( msg.sender != alice){
	    	msg.sender.transfer(msg.value);
	    	return false;
	    }
	    bobsFunds = msg.value/2;
	    carolsFunds = msg.value/2;
	    return true;

	}

	function withdraw() 
	public 
	returns(bool success){
		require(paused == false);
		if(msg.sender == bob && bobsFunds > 0){
			bob.transfer(bobsFunds);
			bobsFunds = 0;
		}
		if(msg.sender == carol && carolsFunds > 0){
			carol.transfer(carolsFunds);
			carolsFunds = 0;
		}
	    return true;
	}

	function pause()
	public
	returns(bool success){
		require(msg.sender == owner);
		if(paused == true){ paused = false;}
		else{paused = true;}
		return true;
	}
	
}
