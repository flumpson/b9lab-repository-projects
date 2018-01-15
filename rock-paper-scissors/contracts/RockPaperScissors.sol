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
	  uint private curID;
	  enum ActionChoices { None, Rock, Paper, Scissors }
	  event IsContractStopped(bool paused);
	  mapping(address=>uint) private wagers;
	  mapping(address=>uint) private players;
	  mapping(address=>ActionChoices) private choices;


	  struct Game {
	  	uint id;
	  	uint numPlayers;
	  	uint playersReady;
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
		require(msg.value == 1 ether);
		Game memory newGame = Game(curID,1,0);
		games[curID] = newGame;
		wagers[msg.sender] = msg.value;
		players[msg.sender] = curID;
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
		require(msg.value == 1 ether);
		Game storage desiredGame = games[id];
		require(desiredGame.id != 0 && desiredGame.numPlayers == 1 && desiredGame.playersReady == 0);
		desiredGame.numPlayers+=1;
		players[msg.sender] = id;
		wagers[msg.sender] = msg.value;
		return true;
	}

	function sendChoice(ActionChoices choice)
	public
	onlyIfRunning
	returns(bool success)
	{
		uint id = players[msg.sender];
		Game storage desiredGame = games[id];
		require(desiredGame.id != 0 && desiredGame.numPlayers == 2);
		require(players[msg.sender] == id);
		require(wagers[msg.sender] >= 1 ether);
		require(choices[msg.sender] == ActionChoices.None);
		choices[msg.sender] = choice;
		if(choice != ActionChoices.None){
			desiredGame.playersReady+=1;
		}
		return true;
	}

	// function checkWinner()



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