/**
 * This class is the base calss for a wrapper around the spawning of one or more
 * GameObjects in the Game.
 * It contains the GameObjects themselves and manages their behaviour in the 
 * game. Managed properties are the chance of spawning, spawning location, the * objects' lifetime and values the objects are initiated with. The reason for 
 * this aproach is to seperate the GameObject's behaviour within the game flow * from the object logic itself and to allow for better control over the game 
 * flow. Values for all managed parameters are stored in events.json. 
 * Inheriting classes define special managed values and properies for 
 * different kinds of GameObjects.
 */
public abstract class GameObjectEvent
{
    /**
     * Reference to a serialized Data object from events.json
     * This is the source of the event data.
     */
    protected JSONObject eventJson;
    

    /**
     * The event duration aka the lifetime of the managed object
     */
    protected int lifeTime = 0;

    /**
     * Flag that is set to true when the event is past its lifetime and can 
     * be deleted
     */
    protected boolean _hasExpired = false;

    /**
     * Has Information if the event spawned an object.
     */
    protected boolean _hasObject = false;

    /**
     * The slot that is assigned to the event. In program, this is done by the * game.
     */
    protected Slot _slot;

    /**
     * This Flag states if the vent manages a Force Emitter. 
     */
    protected boolean _hasEmitter = false;

    /**
     * Loads Event data from events.json. 
     * Firstly, determines if an object will be spawned at a certain possibility
     * If so, the object associated with the event is created and initiated with
     * values specified in the event data.
     *
     * @param id Id of the json object from wich the event data is loaded
     * @param slot The Slot allocated to the event. Relevant for retrieving position data.
     */
    public GameObjectEvent(String id, Slot slot) {
        eventJson = loadEventJSONObject(id);
        float chance = eventJson.getFloat("chance");
        if (Math.random() <= chance) {
            _hasObject = true;
            _slot = slot;
            int duration = eventJson.getInt("duration");
            lifeTime = millis() + duration;
            createManagedGameObject();
        } else {
            _hasExpired = true;
        }
    } 

    /**
     * invokes the inhertiting classe's custom update function and updates the * timer. Marks the event as expired if lifetime has run out.
     */
    public final void update() {
        int currentLifeTime = lifeTime - millis();
        _update();
        if (currentLifeTime < 0) {
            _hasExpired = true;
        }
    }

    /**
     * gives the game access to the _hasExpired flag
     *
     * @return The value of _hasExpired.
     */
    public boolean hasExpired()
    {
        return _hasExpired;
    }

    /**
     * @return The Value of _hasObject.
     */
    public boolean hasObject() 
    {
        return _hasObject;
    }

    /**
     * @return The Value of _hasEmitter. Called by the game to check if the 
     * event object should be registered as Emitter.
     */
    public boolean hasEmitter()
    {
        return _hasEmitter;
    }

    /**
     * Events with Emitters override this method
     */
    public void tryAddToEmitters() {}

    /**
     * @param id the event's id 
     * 
     * @return The Event's JSON Data from event.json
     */
    protected JSONObject loadEventJSONObject(String id) 
    {
        return jsonLoader.loadEventById(id);
    }



    /**
     * @return The GameObject that the event manages
     */
    protected abstract void createManagedGameObject();

    /**
     * The inheriting classes' custom update method that is called after the 
     * timer update
     */
    protected abstract void _update();

    /**
     * @return the managed GameObject if it exists. Null otherwise.
     */
    //public abstract GameObject getObject();

    /**
     * Marks Objects managed by the Event as dead. This methos is called by a 
     * Game instance on an event when it has expired.
     */
    public abstract void markDeletables();

    /**
     * Adds the managed GameObject(s) to the list of active Game Objects
     */
    public abstract void addManagedObjectsToActiveObjects();
}