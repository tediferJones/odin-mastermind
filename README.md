# odin-mastermind
Mastermind Project for TOP

Each game must consist of an even number of rounds, so that each player gets to be the codebreaker and codemaker the same number of times.

Each round consists of a maximum of 12 turns (codebreaker only gets 12 chances to correctly guess the secret code)

At the start of each round, determine codebreaker and codemaker

Allow the codemaker to create a secret code (array of 4 colors, with 6 color options)

Each round will have to return an array (order should be random) containing 4 of these three values (could use 1,2,3 or true, nil false) to the codebreaker
    - A true value would mean color and position are correct
    - A nil value would mean color is correct, but position is not
    - A false value would mean neither color nor position is correct

Based on this feedback, the codebreaker will continue to guess until they run out of turns (12 maximum) or they guess the code correctly

At the end of each round, the codemaker is awarded their points, based on how many guesses occured that round.  If it was guessed in the first round the codemaker recieves 1 point, if it was guessed in the 12th round, the codemaker would receive 12 points, and if the secret code was never correctly guessed, the codemaker receives 13 points