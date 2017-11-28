pragma solidity ^0.4.4;

// import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract Splitter {
	address bob;
	address alice;
	address owner;

// 	event Transfer(address indexed _from, address indexed _to, uint256 _value);

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