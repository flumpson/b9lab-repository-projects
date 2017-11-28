pragma solidity ^0.4.4;

// import "./ConvertLib.sol";


contract Splitter {
	address bob;
	address alice;
	address owner;


	function Splitter(address _bob, address _alice) {
		bob = _bob;
		alice = _alice;
		owner = msg.sender;
	}
	
	function splitEther() 
	public
	payable 
	returns(bool success){
	    if(msg.value == 0) throw;
	    uint amount = this.balance;
	    bob.send(amount/2);
	    alice.send(amount/2);
	    return true;
	}

	function kill() 
	public
	{
	    if(msg.sender != owner) throw;
	    selfdestruct(owner);
	}
	
}
