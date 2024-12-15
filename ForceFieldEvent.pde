/**
 * Manages the Appearance of a Force Field in the Game.
 *
 * @see GameObjectEvent
 */
public class ForceFieldEvent extends GameObjectEvent
{
    protected ForceField forceField;
    
    public ForceFieldEvent(String id, Slot slot)
    {
        super(id, slot);
        _hasEmitter = true;
    }

    public void addManagedObjectsToActiveObjects()
    {
        activeObjects.addObject(forceField);
    }

    public void tryAddToEmitters()
    {
        activeObjects.addEmitter(forceField);
    }

    /**
     * Marks the managed ForceField as deletable
     */
    public void markDeletables() 
    {
        if (forceField != null) {
            forceField.setDead();
        }
    }

    protected void _update() {}

    /**
     * creates the ForceField from the data given by the event json. 
     * If no Object can be created, _hasObject will be set to false 
     * and the event will be marked as expired.
     */
    protected void createManagedGameObject()
    {
        float w = jsonLoader.loadFloatFromEvent(eventJson, "width");
        float h = jsonLoader.loadFloatFromEvent(eventJson, "height");
        float intensity = jsonLoader.loadFloatFromEvent(eventJson, "force");
        float posX = _slot.position.x;
        float posY = _slot.position.y;
        float directionX = jsonLoader.loadFloatFromEvent(eventJson, "directionX");
        float directionY = jsonLoader.loadFloatFromEvent(eventJson, "directionY");
        Vec2 direction = new Vec2(directionX, directionY);
        forceField = new ForceField(posX, posY, w, h, direction, intensity);
    }

}