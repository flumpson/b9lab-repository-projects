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
	  uint curID;
	  enum ActionChoices { Rock, Paper, Scissors, None }
	  event IsContractStopped(bool paused);


	  struct Game {
	  	uint id;
	  	uint wager1;
	  	uint wager2;
	  	address player1;
	  	address player2;
	  	ActionChoices choice1;
	  	ActionChoices choice2;

	  }

  	mapping(uint=>Game) public games; 

  	modifier onlyIfRunning {
  		require(!paused);
  		_;
	}

	function RockPaperScissors () {
		owner = msg.sender;
		curID = 1;
	}

	function createGame()
	public
	payable
	onlyIfRunning
	returns(bool success)
	{
		require(msg.value >= 1 ether);
		Game memory newGame = Game(curID,msg.value,0,msg.sender,0,ActionChoices.None,ActionChoices.None);
		games[curID] = newGame;
		curID+=1;
		return true;
	}

	function joinGame(uint id)
	public
	payable
	onlyIfRunning
	returns(bool success)
	{
		// check to see if these assignments persist
		require(msg.value >= 1 ether);
		Game storage desiredGame = games[id];
		require(desiredGame.id != 0 && desiredGame.wager1 != 0 && desiredGame.player1 != 0 && desiredGame.player1 != msg.sender);
		desiredGame.player2 = msg.sender;
		desiredGame.wager2 = msg.value;
		return true;
	}

	function sendChoice(uint id)
	public
	onlyIfRunning
	returns(bool success)
	{
		// require()
		Game memory desiredGame = games[id];
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