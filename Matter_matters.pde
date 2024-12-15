/**
 * A physics based game using the Box2D physics engine
 * @author Franziska Schneider
 * @version 0.1
 * 
 */
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.util.HashMap;
import java.util.Collections;
import ddf.minim.*;
import processing.sound.*;

/**
 * Minim instance
 */
private Minim minim;

/**
 * Minim audio player for background music
 */
private AudioPlayer player;

/**
 * A spawn sound that is played when a new Object spawns
 */
SoundFile spawnSound;

/**
 * The sound of a pulsar changig mode
 */
SoundFile pulsarChange;

/**
 * The sound that is played when the game is lost
 */
SoundFile fail; 

/**
 * The game's instance of the Box2d Physics engine
 */
private Box2DProcessing box2d;

/**
 * Reference to a utility Object 
 * Providing nice non-static global utility methods for loading json data etc. * Used by multiple classes
 */
private JSONLoader jsonLoader;

/**
 * Score manager instance that provides the ability to share scores across scenes
 */
private ScoreManager scoreManager;

/**
 * All game scenes as Array List
 * @see Scene
 */
private ArrayList<Scene>scenes;

/**
 * The scene currently on display
 * @see scene
 */
private Scene activeScene;

/**
 * Contains and manages all currently active GameObjects
 */
public ActiveGameObjectsManager activeObjects; 


/**
 * Setup size int this function because the console said so
 */
void settings()
{
    size(1080, 720);
}

/**
 * Initiate the processing sketch and the box2D world and load configuration 
 * data. Also loads and initiates sound data.
 */
void setup()
{
    // load sound Files
    minim = new Minim(this);
    // Absolutely AWESOME music by Jonas Jestzig
    player = minim.loadFile("sounds/majorTom.mp3");
    player.loop();
    spawnSound = new SoundFile(this, "sounds/deepSpawn.wav");
    pulsarChange = new SoundFile(this, "sounds/pulsarchange.mp3");
    fail = new SoundFile(this, "sounds/fail.wav");
    // setup box2d engine
    box2d = new Box2DProcessing(this);
    box2d.createWorld();
    box2d.setGravity(0.0, 0.1);
    box2d.listenForCollisions();
    // initiate Serializer
    jsonLoader = new JSONLoader(); 
    scoreManager = new ScoreManager();
    scenes = new ArrayList<Scene>();
    activeScene = new Scene(SceneType.MENU);
    activeObjects = new ActiveGameObjectsManager();
}

/**
 * Update the box2d world and the currently active Scene
 */
void draw()
{
    box2d.step();
    activeScene.run();
}

/**
 * Called at the Beginning of a Box2d Collision Event.
 * Checks if the two colliding objects have a colliding
 * action and executes it
 * @param cp The Contact referencing the Collision to be handled
 */
void beginContact(Contact cp) 
{
    UserData datas = getCollidingObjectsUserData(cp);
    if (datas.getUserData1() != null && 
        datas.getUserData2() != null) {
        //check in both directions
        tryCallOnCollisionEnter(datas.getUserData1(), datas.getUserData2());
        tryCallOnCollisionEnter(datas.getUserData2(), datas.getUserData1());
    } 
}

/**
 * Called at the End of a Box2d Collision Event.
 * Checks if the two colliding objects have a Collision End Action 
 * and executes it
 * @param cp The Contact referencing the Collision to be handled
 */
void endContact(Contact cp) {
    UserData datas = getCollidingObjectsUserData(cp);
    if (datas.getUserData1() != null && 
        datas.getUserData2() != null) {
        //check in both directions
        tryCallOnCollisionExit(datas.getUserData1(), datas.getUserData2());
        tryCallOnCollisionExit(datas.getUserData2(), datas.getUserData1());
    }
}

/**
 * assignes the UserData of the two Fixtures involved in contact to o1 and o2 
 * @param cp The Contact referencing the Collision to be handled
 * @return 1 if userData from both Fixtures could be assigned, 0 otherwise
 * 
 */
public UserData getCollidingObjectsUserData(Contact contact)
{
    Fixture f1 = contact.getFixtureA();
    Fixture f2 = contact.getFixtureB();
    Body b1 = f1.getBody();
    Body b2 = f2.getBody();
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();
    return new UserData(o1, o2);
}

/**
 * invoked during endContact()
 * checks if o1 implements OnCollisionEnter and calls its method if that 
 * is the case 
 *
 * @param o1 the first Object involved in the collision
 * @param o2 the second object involved in the collision
 */
private void tryCallOnCollisionEnter(Object o1, Object o2)
{
    if (o1 instanceof OnCollisionEnter) {
        OnCollisionEnter collidable = (OnCollisionEnter)o1;
        GameObject collidingThing = (GameObject)o2;
        collidable.onCollisionEnter(collidingThing);
    }
}

/**
 * Invoked during beginContact()
 * checks if o1 implements OnCollisionExit and calls its method if that 
 * is the case 
 *
 * @param o1 the first Object involved in the collision
 * @param o2 the second object involved in the collision
 */
private void tryCallOnCollisionExit(Object o1, Object o2)
{
    if (o1 instanceof OnCollisionExit) {
        OnCollisionExit collidable = (OnCollisionExit)o1;
        GameObject exitingThing = (GameObject)o2;
        collidable.onCollisionExit(exitingThing);
    }
}

/**
 * Processes a key command to switch between scenes.
 */
void keyPressed() {
    SceneType type = null;
    switch (key) {
        case ENTER:
            type = SceneType.GAME;
            break;
        case 'm':
            type = SceneType.MENU;
            break;
        case 't': 
            type = SceneType.TUTORIAL;
            break;
        case 'h':
            type = SceneType.HIGHSCORE;
    }
    if (type != null) {
        changeScene(type);
    }
}

/**
 * destroys the active Scene and creates a new one
 * 
 * @param type the content type of the new scene
 */
public void changeScene(SceneType type)
{
    if (activeScene != null) {
        activeScene.destroy();
    }
    activeScene = new Scene(type);
}
