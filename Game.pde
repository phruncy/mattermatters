/**
 * This is where the actual game part of this game happens. This class manages initiates the active Game object with a player an player particles, handles the execution of game events loaded from event.json and manages a score.
 */
public class Game extends SceneContent
{
    /**
     * A direct reference to the current player object
     */
    private PlayerObject player;

    /**
     * Stores all Events that are currently active
     */
    private ArrayList<GameObjectEvent>activeEvents;

    /**
     * Stores all points in time where events happen as int values and matches * them with an event key. Event keys can than be matched with event data.
     * 
     * @see EventFactory
     */
    private HashMap<Integer, String>eventKeys;

    /**
     * Instance of EventFactroy that creates new Events from an id retrieved 
     * from a value from eventKeys
     *
     * @see eventKeys
     */
    private EventFactory eventFactory;

    /**
     * Stores all Spawning slots of the game
     */
    private Slot[] slots;

    /**
     * Helper variable for setting up the score 
     */
    private int timerStart;

    /**
     * The color of the background
     */
    private color backgroundColor;

    /**
     * The color of the score display
     */
    private color fontColor;

    /**
     * Sets up a new game with a fresh timer and new Particles
     */
    public Game()
    {
        activeEvents = new ArrayList<GameObjectEvent>();
        // Event related stuff
        eventKeys = jsonLoader.loadEventHashMap();
        eventFactory = new EventFactory();
        // load Slots
        slots = jsonLoader.loadSlots();
        // load config data
        backgroundColor = jsonLoader.loadColorFromConfig("background");
        fontColor = jsonLoader.loadColorFromConfig("font");
        // create player Particles and add them to activeObjects
        initiatePlayerParticles();
        // create Player object and add to active objects
        player = new PlayerObject(mouseX, mouseY);
        activeObjects.addObject(player);
        activeObjects.setPlayer(player);
        // initiate score
        scoreManager.resetCurrent();
        timerStart = millis();
    }

    /**
     * Called once every frame. Handles all the game logic:
     * updates Player, game objects, handles individual object type actions. 
     * updates the timer/score and checks if any objects can be deleted
     */
    public void update()
    {
        //update all GameObjects
        activeObjects.update();       
        //Timer and score update
        updateTimer();
        //update Event List and active Events
        checkForEvents();
        for (int i = 0; i < activeEvents.size(); i++) {
            GameObjectEvent event = activeEvents.get(i);
            event.update();
            if (event.hasExpired()) {
                event.markDeletables();
                activeEvents.remove(event);
                i--;
            }
        }
        // check if the game should continue or change to the lost screen
        if (!activeObjects.getParticleAliveness()) {
            changeScene(SceneType.LOST);
            fail.play();
            scoreManager.tryInsertScore(scoreManager.getCurrent());
        }
    }

    /**
     * Called once every frame. Handles all displaying logic.
     */
    public void display()
    {
        background(backgroundColor);
        activeObjects.display();
        displayScore();
    }

    /**
     * Formats and displays the score in the top left corner.
     */
    public void displayScore()
    {
        fill(fontColor);
        textSize(30);
        textAlign(LEFT, TOP);
        text(scoreManager.getCurrent(), 30, 30);
    }

    /**
     * adds the time that has passed since the last frame to the score
     */
    public void updateTimer()
    {
        int deltaTimer = millis() - timerStart;
        scoreManager.setCurrent(deltaTimer / 1000.0);
    }

    /**
     * Invoked when the scene containing the game is destroyed
     * Destroys and removes all Objeect from activeObjects.
     */
    public void removeExternalLibraryReferences() 
    {
        activeObjects.clearAllObjects();
        activeEvents.clear();
    }

    /**
     * checks the events Hashmap for entries at the current second of the   game's runtime. If one is found and there currently is a free slot available, the matching event is added to active events at that slot and the Hashmap entry is removed.
     */
    private void checkForEvents() 
    {
        int secondValue = (int)scoreManager.getCurrent();
        if (eventKeys.containsKey(secondValue)) {
            String id = eventKeys.get(secondValue);
            // try to assign a free slot
            Slot slot = getRandomFreeSlot();
            if (slot != null) {
                GameObjectEvent event = createEventFromID(id, slot);
                // add event to active events if event was created
                if (event != null) {
                    activeEvents.add(event);
                    // add Event's object to GameObjects
                    if (event.hasObject()) {
                        event.addManagedObjectsToActiveObjects();
                        event.tryAddToEmitters();
                        spawnSound.play();
                    }
                }
            }
            // remove event key from list
            eventKeys.remove(secondValue);
        }
    }

    /**
     * creates and returns a new GameObjectEvent From the given ID
     * @param id Key to the event data
     * @param slot the slot that is allocated to the event
     * @return The event created from the event data
     */
    private GameObjectEvent createEventFromID(String id, Slot slot)
    {
        return eventFactory.createEvent(id, slot);
    }

    /**
     * Collects all slots that are currently not locked by an event and 
     * randomly returns one of them.
     * 
     * @return A Slot that is currently not locked by any event. Null if none is available.
     */
    private Slot getRandomFreeSlot()
    {
        ArrayList<Slot> frees = new ArrayList<Slot>();
        for (int i = 0; i < slots.length; i++) {
            if (!slots[i].isLocked) {
                frees.add(slots[i]);
            }
        }
        if (frees.size() > 0) {
            return frees.get((int)random(0, frees.size() - 1));
        }
        return null;
    }

    /**
     * Initiates the amount of player Particles defined in the configuration
     * and adds them to the active objects.
     * Spawning location is the point on a radius around the mouse that is closest to the center. This avoids that the particles spawn to close too the screen edges already.
     */
    private void initiatePlayerParticles()
    {
        int playerParticleNumber = jsonLoader.loadIntFromConfig("playerParticle", "number");
        float particleRadius = jsonLoader.loadFloatFromConfig("playerParticle", "radius");
        Vec2 particleOrigin = getplayerParticleOrigin();
        for (int i=0; i < playerParticleNumber; i++) {        
            PlayerParticle p = new PlayerParticle(
                mouseX + particleOrigin.x + (float)Math.random(), 
                mouseY + particleOrigin.y + (float)Math.random(), 
                particleRadius);
             activeObjects.addObject(p);
             activeObjects.addPlayerParticle(p);
        }
    }

    /**
     * calculates and returns the spawning point for playerParticles at the 
     * beginning of a game. 
     *
     * @return The point on the radius specified in config.json that lies on the distance between the mouse and the screen center
     */
    private Vec2 getplayerParticleOrigin()
    {
        float originRadius = jsonLoader.loadFloatFromConfig("playerParticle", "originRadius");
        // calculate distance in world measurement first
        Vec2 mouse = box2d.coordPixelsToWorld(mouseX, mouseY);
        Vec2 center = box2d.coordPixelsToWorld(width / 2, height / 2);
        center.subLocal(mouse);
        // convert back to pixels
        Vec2 origin = box2d.coordWorldToPixels(center);
        origin.normalize();
        origin.mulLocal(originRadius);
        return origin;
    }
}