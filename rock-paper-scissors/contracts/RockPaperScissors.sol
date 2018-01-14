pragma solidity ^0.4.17;

contract RockPaperScissors {
  /*
  What do I need here?

  address owner
  Since there needs to be a balance for each player, let's actually use a map.
  let's also do the paused thing, so that we can activate/disactivate the contract
  function registerPlayer

  maybe we should look at it in the context of a game.
  One player creates a game, and sends value,. The next player joins an open game, and sends value. 

matchmaking is the hard part. 


	1 = rock
	2 = paper
	3 = scissors
  */
	  address private owner;
	  bool private paused;
	  mapping(address=>ActionChoices) choices; 
	  mapping(address=>uint) balances; 
	  enum ActionChoices { Rock, Paper, Scissors }
	  event IsContractStopped(bool paused);


	  struct Game {
	  	uint numPlayers;
	  	address player1;
	  	address player2;
	  }

  	Game[] public games;

  	modifier onlyIfRunning {
  		require(!paused);
  		_;
	}

	function RockPaperScissors () {
		owner = msg.sender;
	}

	function createGame()
	public
	payable
	onlyIfRunning
	returns(bool success)
	{
		require(msg.value >= 1 ether);
		Game newGame = Game(1,msg.sender,0);



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