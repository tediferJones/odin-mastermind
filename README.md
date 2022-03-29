# odin-mastermind
Mastermind Project for TOP

each game consists of 2 rounds, so each player has the chance to be codebreaker and codemaker.  the players may want to play best of 3 games, or first 2 wins.

each round consists of a maximum of 12 turns (codebreaker only gets 12 chances to correctly guess the secret code)

at the start of each round, determine codebreaker and codemaker

allow the codemaker to create a secret code (array of 4 digits between 0 and 5)

each round will have to return an array (order should be random) containing 4 of these three values (could use 1,2,3 or true, nil false) to the codebreaker
a true value would mean position and value are correct
a nil value would mean position is incorrect but the value is correct
a false value would mean neither position nor value is correct

based on this feedback, the codebreaker will continue to guess until they run out of turns (12 maximum) or they guess the code correctly

At the end of each round, the codemaker is awarded their points, based on how many guesses occured that round.  If it was guessed in the first round the codemaker recieves 1 point, if it was guessed in the 12th round, the codemaker would receive 12 points, and if the secret code was never correctly guessed, the codemaker receives 13 points