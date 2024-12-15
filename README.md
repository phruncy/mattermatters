Advanced Techniques for Creative Coding in Processing - Assignment 1  
Franziska Schneider

# Matter matters

## About this project 

Matter Matters  is a 2d physics based high score game written with processing and based on the Box2d physics engine. Developed as part of the course 'Advanced Techniques for Creative Coding in Processing' during the winter term 19/20.

### Information on executing the program
For a smoother gaming experience with a higher frame rate, it is recommended to run one of the compiled versions of the program and not via the Play-button of the Processing IDE. 

# Concept

In this game, the player takes control over a star that attracts a cloud of stellar particles. By moving the mouse, the movement of the particles can be steered indirectly. If they collide with the star or leave the screen however, they are destroyed. Other cosmic objects such as black holes, antimatter-clouds or pulsars will show up and influence the particles' movement. Some will just emit forces on them while others are deadly upon collision. The player's task is it to keep at least one particle alive for as long as possible. 

# Game Objects

All Game objects that appear in the game can be configured with a variety of parameters such as size, velocity or strength and direction of emitted forces. Throughout the game,  these types of Objects will appear:
### Black Hole

A black hole is a static object with a limited lifetime and a great gravitational force. It will attract the particles and other moving objects if they are near enough and will destroy the player's particles if they crash into it.

### Pulsar
A pulsar is also a static object with limited lifetime. It frequently switches between attractional and repelling forces. As opposed to the black hole, it will not destroy particles if they collide with it.

### Magnetic Force Field
A magnetic Force field is an area where a constant unidirectional force acts on moving particles. The direction of that force can vary.

### Space Junk
Space Junk Objects are large moving objects that are constantly rotating. Because of their high density, forces affect them much less than particles. If a crowd of particles is hit by space junk, the particles will be shot unpredictably through space. To avoid this, the player can try to shoot the junk away with the star. 

### Antimatter
Antimatter particles are like the player's particles in many ways.  If a particle and an antimatter particle collide, they will erase each other. Luckily, the star can be used to erase antimatter without damage.

# Player Actions

The basic player action is simple: moving the mouse to move the star. Apart from attracting the particles, the star is also capable of pushing aside space junk and of destroying antimatter by collision.

# About program structure

The program is structured in different "scenes" that represent a logically enclosed component of the game. These scenes are namely the menu, the actual game, a high score screen, an explanation of the controls and the screen that is shown after the player looses the game. The main program always has one active scene at a time that is updated and displayed throughout the draw() function. Switching between these scenes is done by pressing keys. Screenshots of all scenes can be found in the appendix.

# About the actual game logic

The spawning and disappearance of Game Objects is handled by so called events whose data loaded from the events.json file.  
The game keeps track of a list of timestamp - event id pairings. If a timestamp matches the current second of the game, the game creates an Event from the associated event data and adds it to its active events.  
These events initiate the game objects at a certain chance with certain values and may keep track of them during the their lifetime. After an event is expired, it will remove its managed object from the game and will then be removed from the game itself.  
Event Objects spawn at one of several locations on the screen, called Slots. There is only one active Event at one Slot at a time; a new event will therefore only be added if there is a free Slot available. If there are multiple Slots available, the allocation happens randomly.  
An overview of the spawning locations on the screen can be found in the appendix.

# Credits

- *AWSOME background music* arranged and recorded by Jonas Jetzig  
- *sound effects* from the Digital SFX set by Kenney Vleugels and from 99Sounds Space Divers by Lukas Tvrodon  
- *Telegrama font* by Yamaoka Yashuhiro, 1992,


# Repository and Online Documentation

Gitlab Repository of the project:  
https://gitlab.informatik.uni-bremen.de/fschneid/matter_matters

### Online code documentation:

The detailed javadoc documentation of all classes/ functions and class hierarchy. (The javadoc is generated from the compiled Javacode of the program, so all classes are marked as subclasses of the main class) :  
*https://www.zellmemore.de/other/mattermatters*

# Apendix: Images and Screenshots



