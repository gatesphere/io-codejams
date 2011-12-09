Empire game (part 4)
====================
Io Codejam - 20111208 (part 4)

The game is finally playable!

To play this game, run the script
    
    ./rungame.io
    
It is currently limited to two players.  The goal is to be the final remaining player.

Each turn, you get a weather report.  This weather report influences various game factors, leading to some variability.

After that, you make harvest, generating grain.

After that, you must feed your people.  Feed them too little and they'll starve.  Feed them too much and they'll have babies.

Next, you gain income based upon how many cities you have, your tax rate, and how many peasants you have.  You'll be asked to set the tax rate for the following year as an integer percentage.  Tax too high, and your peasants will work themselves to death.  Tax too low and your income suffers.

Next you buy various things for your kingdom.  Don't mess up... fraud is a nasty business and the market is only open for a short time!

Next is war!  You attack the other countries in the game.  Note: attacking a kingdom which has 0 armies results in nothing happening at the moment.  Again, don't mess up!  You only have 3 attacks, and your armies may be lost and meandering if you try to send them to fight an enemy that doesn't exist!

Finally is the end-of-turn stats check.

If at any point you find yourself in a situation where you have 0 peasants or 0 land, you are out of the game for good!

Cleanups and optimizations are coming, along with a few tweaks to make the game more... game-like.

-->Jake
