/**
 * Manages the appearance of multiple SpaceJunk Objects in the Game.
 * Instances of this class don't control the lifespan of 
 * their managed SpaceJunk Objects,
 * meaning they don't get deleted after a fixed timespan.
 * The event simply spawns them at a location determined by the json data 
 * (with some random factor) and initiates their original impulse towards the 
 * center of the screen. Afterwards, the event's control over the junk ends.
 */
public class SpaceJunkEvent extends GameObjectEvent
{
    
    /**
     * Contains all SpaceJunk objects that are spawned by the event
     */
    private ArrayList<SpaceJunk> junkObjects;
    
    public SpaceJunkEvent(String id, Slot slot)
    {
        super(id, slot);
    }

    /**
     * Adds all managed SpaceJunk Objects to activeObjects
     */
    public void addManagedObjectsToActiveObjects()
    {
        for (SpaceJunk junk: junkObjects) {
            activeObjects.addObject(junk);
        }
    }

    /**
     * Because SpaceJunk events don't manage the lifetime 
     * of their objects, they don't get marked as deletable
     * on expiration here. 
     * (Refactor time-dependent object events into subclass?)
     */
    public void markDeletables() {}

    protected void _update() {}

    /**
     * creates several SpaceJunk Objects from the event json data and adds them 
     * junkObjects
     */
    protected void createManagedGameObject()
    {
        junkObjects = new ArrayList<SpaceJunk>();
        int counter = jsonLoader.loadIntFromEvent(eventJson, "counter");
        for (int i = 0; i < counter; i++) {
            //load json data and add some variance
            float w = jsonLoader.loadFloatFromEvent(eventJson, "width") + random(-10, 10) ;
            float h = jsonLoader.loadFloatFromEvent(eventJson, "height");
            String coordinate = jsonLoader.loadStringFromEvent(eventJson, "slotCoordinate");
            float x;
            float y;
            // determine from which of the four sides the object will spawn
            if (coordinate.equals("x")) {
                //object will spawn from top or bottom of the screen
                x = random(0, width);
                // determines wheter it will top or bottom with 50% chance
                // y is outside the screen
                if (Math.random() < 0.5) {
                    y = -30;
                } else {
                    y = height + 30;
                }
            }
            else if (coordinate.equals("y")) {
                // object will spawm from left or right
                y = random(0, height);
                // determine wheter it will be left or right with 50% chance
                if (Math.random() < 0.5) {
                    x = -20;
                } else {
                    x = height + 20;
                }
                // x origin is outside the screen
            } else {
                //if there is an error on the json data
                x = -20;
                y = -20;
            }
            Vec2 position = box2d.coordPixelsToWorld(x, y);
            Vec2 velocity = computeVelocity(position);
            // add new Object 
            SpaceJunk object = new SpaceJunk(x, y, w, h, velocity);
            junkObjects.add(object);
        }
    }

    /**
     * Calculates and returns a vector that is directed from the position given * in the parameter to the center of the screen. Used to get the impulse 
     * for newly created SpaceJunk objects.
     *
     * @param position The position of the object in the box2d world for which the velocity is calculated
     * @return a Vector directed at the center of the screen with variance
     */
    private Vec2 computeVelocity(Vec2 position)
    {
        float speed = jsonLoader.loadFloatFromEvent(eventJson, "speed") + random (-10, 10);
        float directionX = width / 2 + random(-10, 10);
        float directionY = height / 2 + random(-10, 10);
        Vec2 direction = box2d.coordPixelsToWorld(directionX, directionY);
        direction.subLocal(position);
        direction.normalize();
        direction.mulLocal(speed);
        return direction;
    }
}