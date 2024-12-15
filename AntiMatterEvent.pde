/**
 * Manages the appearance of a bunch of AntiMatterParticle objects.
 * The event only controls their initial spawn and velocity, but not the 
 * lifetime.
 */
public class AntiMatterEvent extends GameObjectEvent
{
    /**
     * Contains all managed AntiMatterParticles
     */
    private ArrayList<Particle> antiMatter;

    public AntiMatterEvent(String id, Slot slot)
    {
        super(id, slot);
    }

    protected void _update() {}
    public void markDeletables() {}

    /**
     * adds all managed Particles to activeGameObjects
     */
    public void addManagedObjectsToActiveObjects() 
    {
        for (Particle particle: antiMatter) {
            activeObjects.addObject(particle);
        }
    }

    protected void createManagedGameObject() 
    {
        // initiate List
        antiMatter = new ArrayList<Particle>();
        int counter = jsonLoader.loadIntFromEvent(eventJson, "counter");
        for (int i = 0; i < counter; i++) {
            // load event data
            float radius = jsonLoader.loadFloatFromEvent(eventJson, "radius");
            float speed = jsonLoader.loadFloatFromEvent(eventJson, "speed");
            String coordinate = jsonLoader.loadStringFromEvent(eventJson, "slotCoordinate");
            float x, y;
            // getting the spawning location and initial velocity
            // determine from which of the four sides the object will spawn
            if (coordinate == null) {
                // default values in case of errors
                x = -20 + random(-5, 5);
                y = -20 + random(-5, 5);
            }
            if (coordinate.equals("x")) {
                //object will spawn from top or bottom of the screen around the x position ot the slot + some variance
                x = _slot.position.x + random(-5, 5);
                // determines wheter it will top or bottom with 50% chance
                if (Math.random() < 0.5) {
                    y = - 20 + random(-5, 5);
                } else {
                    y = height + 20 + random(-5, 5);
                }
            }
            else if (coordinate.equals("y")) {
                // object will spawn from left or right of the screen at the height of the slot position + some variance
                y = _slot.position.y + random(-5, 5);
                // determine wheter it will be left or right with 50% chance
                if (Math.random() < 0.5) {
                    x = - 20 + random(-5, 5);
                } else {
                    x = height + 20 + random(-5, 5);
                }
            } else {
                //if there is an error in the json data values these default values are assigned
                x = -20 + random(-5, 5);
                y = -20 + random(-5, 5);
            }
            Vec2 position = box2d.coordPixelsToWorld(x, y);
            Vec2 direction = computeDirection(position);
            // add Particle
            AntiMatterParticle particle = new AntiMatterParticle(
                x, y, radius, direction, speed
            );
            assert(particle != null);
            antiMatter.add(particle);
        }    
    };
    
    /**
     * Calculates and return a vector that is directed at the center of the screen.
     * @param position The position of the object in the box2d world for which the direction is calculated
     * @return a Vector directed at the center of the screen
     */
    private Vec2 computeDirection(Vec2 position) 
    {
        Vec2 direction = box2d.coordPixelsToWorld(width / 2, height / 2);
        direction.subLocal(position);
        direction.normalize();
        return direction;
    }
}