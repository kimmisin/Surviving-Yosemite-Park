# Surviving-Yosemite-Park
2D platform survival game in Processing Java language\
Processing Download Link: https://processing.org/download/ \

Upon start of the Processing file, the user sees a menu screen with buttons to see the game instructions, mute sound, view the high score list, or play the game. When “Play” is chosen, a random map out of 3 varying difficulty candidates is chosen for the game.  Once the game starts, the player spawns on a random map with 5 lives.  The player can move around the map and the screen follows.  Obstacles (logs, rocks, and bears) randomly spawn on the screen and the player can jump, dodge, or shoot to avoid them.  The player must collect stars to get points.  Every 1000 points, the user is boosted to the next level where obstacles spawn faster and more often.  Touching the water is instant death.  This game doesn’t have a specific win condition, and instead the player shoots for a high score.  High scores are displayed once the player dies. Pause functionality is also included during gameplay. \

This was a group final project for my Elements of Graphics course at the University of Texas at Austin. The goal was to create a product that implemented animation hierarchies, user interactivity with mutliple GUI systems, data input/ouput, and sound options. The work distribution is as follows below with more details of my contribution further below. \

Kimmi Sin - Sprite class, Attack class, Star class, edge detection, map creation and interaction with player, Sound class, game troubleshooting \
Michael Eng - all obstacle (Rock, Log, Bear, Obstacle, ObstacleSystem) classes, creating map variations and implementing map randomization, game troubleshooting\
Ankur Bhagwath- GUI creation, data passing, menus, game troubleshooting \
In Ho Kim - created some of the sound files, high score functionality, game troubleshooting \
Haris Bhatti - initial GUI systems \

I created the classes Sprite, Attack, Star, Map and Sound. Sprite sets were used in the Sprite, Attack, and Star classes and regulated with timers. These classes worked with the Sound class to include sound effects when the player ran, jumped, shot fireballs, and collected Star objects via keyboard input. Animation hierarchy was implemented with an flying pet bird following the player. For interaction between classes, I created methods for edge detection to check if the player is in contact with the star object before they can pick it up, and if the player has collided with an obstacle and thus loses a life. The method of creating maps from the tile sets was created by me as well as player position and interaction with the map. I created the Sound class to play the associated sound effects for each player action and implemented the functionality while ensuring no opportunies for echoing. Lastly, I aided in troubleshooting for any classes that required it.
