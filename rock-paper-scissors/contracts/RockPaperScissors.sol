pragma solidity ^0.4.17;

contract RockPaperScissors {
  /*
	Feedback
	-add events to state changes
	-one require statement per line for readability
	-change sendChoice to take the id as well as the choice
	-change from mappings to struct properites

	problem: how to authenticate a player to a game
	The game struct has references to both players, and if another address attempts to access it, it will be denied.

	problem: keeping track of balance for each game/
	Solution, use variables in the game struct to keep track of wager. Use buyIn instead of 1 var for each player, since the wager must be equal on both sides. Then, send twice that amount when paying out the winnings

	problem: keeping track of the games
	Solution, map them to the id in mapping, don't think that id is actually a necessary property in the game struct, since that is the key to it in the mapping.

	problem: Mappings vs Struct properties
	Solution, less sstores to add them to struct, since the mappings require an SSTORE of the mapping as well as all of the stored values.

	problem: reducing SSTORE transactions
	These transactions occur whenever persistent storage is used. All of the instance variables represent SSTORES, and adding to a mapping is an SSTORE.
	Since mappings in solidty are by default initialized for every possible key to value 0, you can set the games variables as if it already existed under that key in the mapping


  */
	  address private owner;
	  bool private paused;
	  uint private curID;
	  enum ActionChoices { None, Rock, Paper, Scissors }
	  event IsContractStopped(bool paused);
	  event GameCreated(uint id, address creator, uint buyIn);
	  event GameJoined(uint id, address player2);
	  mapping(address=>ActionChoices) private choices;


	  struct Game {
	  	bool exists;
	  	address player1;
	  	address player2;
	  	uint buyIn;
	  	ActionChoices player1Choice;
	  	ActionChoices player2Choice;
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
		require(msg.value > 0);
		games[curID].exists = true;
		games[curID].player1 = msg.sender;
		games[curID].buyIn = msg.value;
		GameCreated(curID, msg.sender, msg.value);
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
		require(games[id].exists == true);
		require(games[id].buyIn == msg.value);
		require(games[id].player1 != msg.sender);
		games[id].player2 = msg.sender;
		GameJoined(id, msg.sender);
		return true;
	}



	// function sendChoice(ActionChoices choice)
	// public
	// onlyIfRunning
	// returns(bool success)
	// {
	// 	uint id = players[msg.sender];
	// 	Game storage games[id] = games[id];
	// 	require(games[id].id != 0);
	// 	require(games[id].numPlayers == 2);
	// 	require(games[id].finished == false);
	// 	require(players[msg.sender] == id);
	// 	require(balance[msg.sender] >= 1 ether);
	// 	require(choices[msg.sender] == ActionChoices.None);
	// 	choices[msg.sender] = choice;
	// 	require(choice != ActionChoices.None);
	// 	games[id].playersReady+=1;
	// 	return true;
	// }

	// function declareWinner()
	// public
	// onlyIfRunning
	// returns(address winner)
	// {
	// 	uint id = players[msg.sender];
	// 	require(id > 0);
	// 	Game memory games[id] = games[id];
	// 	require(games[id].id != 0 && games[id].numPlayers == 2 && games[id].finished == false && games[id].playersReady == 2);

	// }



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