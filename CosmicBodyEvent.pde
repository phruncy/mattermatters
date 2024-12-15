/**
 * This class is a wrapper around the spawning of a NPC CosmicBody in the Game.
 * It contains the GameObjects itself and manages the CosmicBody's behaviour in 
 * the game. Managed properties are the chance of spawning, spawning location, * the object's lifetime and values the object is initiated with. The reason  
 * for this aproach is to seperate the GameObject's behaviour within the game 
 * flow from the object logic itself and to allow for better control over the 
 * game flow.
 * Event data is loaded from the events.json.
 */
public class CosmicBodyEvent extends GameObjectEvent {

    /**
     * Reference to the Object the Event is managing
     */
    private CosmicBody cosmicBody;

    /**
     * @param id the Id of the event data
     * @param slot The slot assigned to the event
     */
    public CosmicBodyEvent(String id, Slot slot)
    {
        super(id, slot);
        _hasEmitter = true;
    }

    /**
     * creates the CosmicBody from the data given by the event json. 
     * If no Object can be created, _hasObject will be set to false 
     * and the event will be marked as expired.
     */
    protected void createManagedGameObject()
    {
        String type = jsonLoader.loadStringFromEvent(eventJson, "type");
        float radius = jsonLoader.loadFloatFromEvent(eventJson, "radius");
        float force = jsonLoader.loadFloatFromEvent(eventJson, "force");
        float posX = _slot.position.x;
        float posY = _slot.position.y;
        if (type.equals("BlackHole")) {
            cosmicBody = new BlackHole(posX, posY, radius, force);
        } else if (type.equals("Pulsar")) {
            cosmicBody = new Pulsar(posX, posY, radius, true, force);
        } else {
            _hasObject = false;
            _hasExpired = true;
        }
    }

    public void addManagedObjectsToActiveObjects()
    {
        activeObjects.addObject(cosmicBody);
    }

    /**
     * Adds the event's object to active emitters
     */
    public void tryAddToEmitters()
    {
        activeObjects.addEmitter(cosmicBody);
    }

    protected void _update() {}

    /**
     * Marks the managed cosmic body as deletable
     */
    public void markDeletables() 
    {
        if (cosmicBody != null) {
            cosmicBody.setDead();
        }
    }
}