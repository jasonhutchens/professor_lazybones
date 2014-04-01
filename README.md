Professor Lazybones
===================

Professor Lazybones is a game about making games

* map is made of 48px tiles
* aim is to god 4 lab assistants to collect loot
* limited set of commands cards
  + move (0 = until blocked, 1-8 = steps)
    - moving against a pushable takes double the steps
  + face (n, s, e, w, l, r, u)
  + wait (0 = forever, 1-8 = steps)
  + work (0 = forever, 1-8 = steps)
  + take (n, s, e, w, l, r, u, x)
  + give (n, s, e, w, l, r, u, x, i)
  + swap (1-9 = inventory items)
  + loop (0 = forever, 1-8 = steps)
  + bomb (0 = now, 1-8 = steps)
  + stop (breakpoint)
* items in the level
  + loot (aim is to add these to inventory, quote for each level)
  + food
  + pick
  + axe
  + shield
  + switch
  + door
  + key
* lab assistants have HP and perhaps different skillz
* select a dwarf, and command it
* play / step through the level
* dwarf dialog for errors etc
* all other entities have programs too which you can inspect!
* bit of story too

TODO

* interface for the level, including selection and stuff (boring)
* implement the little programs to make stuff happen (fun)

* VM that runs the programs with registers that we can read off for controlling entities
