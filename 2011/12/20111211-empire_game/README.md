Empire game (part 5)
====================
Io Codejam - 20111211 (part 5)

The game is in a fully functional state!  This is probably as "finished" as this version will ever be, aside from a few refactors here and there that won't be a part of a codejam, but rather released on my [blog](http://blog.suspended-chord.info/), if I ever get around to it.


Total time: 5 hours.  Not bad :)

Running the game:
-----------------
Alright, so to start the game, run:

  ./rungame.io
  
on a unix system, or 

  io rungame.io
  
on any other system type.  This game relies upon *no* addons, and should run with a basic Io setup, such as from the [iobin project](http://iobin.suspended-chord.info/).  Do note, however, that this game requires the ioutils.io file found in the lib directory of this repo.  If you've cloned the repo, you'll be just fine.

About the game:
---------------
The object of this game is to be the last kingdom standing, so to speak.  Your kingdom ends if you have 0 peasants or 0 land at any given time.

Each turn, you will have to make choices in how to proceed with your kingdom's finances, food supply, military activities, and appearances.  The turn order is as follows:

**Phase 1: Weather and Migration reports.**
In this phase, you receive a weather report, which affects various aspects of the game, as well as a report whether or not any peasants immigrated into your kingdom this year.  Immigration is influenced solely by the impressive facade of your palace, and in many cases isn't worth all that much, but if you have a few thousand income to throw around, an impressive palace is a wonderful way to stroke your ego.

**Phase 2: Harvest phase.**
In this phase, you harvest your grain, dependent upon the weather and the number of farms in your kingdom.

**Phase 3: Feed the people.**
In this phase, you must feed your peasants and armies.  Feed them too much and they'll start reproducing like rabbits.  Feed them too little and they'll starve off.  Tax rate also affects the population variance.

**Phase 4: Generate income.**
In this phase, you make money.  This is based largely upon the amount of cities you own, along with the amount of peasants to work in them, and the tax rate.  Income is based on trade, so weather affects this as well.  After you generate income, you are asked to set the tax rate for next year--tax too high and your people will overwork themselves.  Tax too low, and you'll risk population explosion and lack of income.

**Phase 5: Purchase.**
In this phase, you purchase things for your kingdom.  However, be careful!  The marketplace is open for only a short time, and you only get one chance at making a bid.  If you make an incorrect bid, you must live with the consequences of your choices.

**Phase 6: To War!**
In this phase, you may attack the other kingdoms.  Pretty self explanatory.  As with the marketplace, be careful with your commands.  You may just end up sending your troops to their deaths (weather plays a very important role here, as does luck), or you may waste an attack by attempting to attack a kingdom that doesn't exist!

**Phase 7: End of turn stats.**
In this phase, your stats are printed to the screen.

**Turn order**
Turns are played in random order each year, to represent the shifting of political powers.


I hope you enjoy it!  But please, don't look at the code... it's a mess. :P

-->Jake
