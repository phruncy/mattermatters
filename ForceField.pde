/**
 * a class for Game Objects that mark an area where a constant force is applied 
 * to objects that are in that area
 * basically acting as a 'wind zone'
 */
public class ForceField extends GameObject implements ForceEmitter, OnCollisionEnter, OnCollisionExit
{
    /***/
    private float _w;
    /***/
    private float _h;
    /***/
    private Vec2 _force;

    /**
     * A list of all objects that are currently in the forcefield's area
     */
    private ArrayList<GameObject> visitors; 

    /**
     * @param posX the x coordinate of the center of the area in pixels
     * @param posY the y coordinate of the center of the area in pixels
     * @param w the width of the forcefield's area
     * @param h the height of the forcefield's area
     * @param direction the direction of the forcefield's force
     * @param strength the strength of the forcefields force
     */
    public ForceField(float posX, float posY, float w, float h, Vec2 direction, float strength)
    {
        super(posX, posY);
        
        _w = w;
        _h = h;
        PolygonShape shape = new PolygonShape();
        float bodyW = box2d.scalarPixelsToWorld(_w / 2);
        float bodyH = box2d.scalarPixelsToWorld(_h / 2);
        shape.setAsBox(bodyW, bodyH);

        FixtureDef fixDef = new FixtureDef();
        fixDef.shape = shape;
        // sets the object not as rigid body but still enables collision detection
        fixDef.isSensor = true;
        body.createFixture(fixDef);

        direction.normalize();
        _force = direction.mulLocal(strength);
        visitors = new ArrayList<GameObject>();
    }

    /**
     * force it applied to all visitors in every frame
     */
    public void update()
    {
        for (GameObject visitor: visitors) {
            
            Vec2 force = emitForce(visitor);
            visitor.applyForce(force);
        }
    }

    public void display() 
    {
        Vec2 position = box2d.getBodyPixelCoord(body);
        push();
            noStroke();
            rectMode(CENTER);
            translate(position.x, position.y);
            fill(255, 25); 
            rect(0, 0, _w, _h);
        pop();
    }

    public boolean checkAliveness() 
    {
        return isAlive;
    }

    /**
     * when an object enters the forcefield's area it is added to 
     * the list of visitors
     */
    public void onCollisionEnter(GameObject collider) 
    {
        if (collider instanceof Particle) {
            visitors.add(collider);
        }
    }

    /**
     * When an object leaves the forcefield's area it is removed from the
     * list of visitors (with extra check if it was an that list in the 
     * first place), just to be sure
     */
    public void onCollisionExit(GameObject collider) 
    {
        if (visitors.contains(collider)) {
            visitors.remove(collider);
        }
    }

    protected void _destroy() {}

    /**
     * Invoked by the update() method on all objects in the visitors list
     *
     * @param o The object for wich the force is calculated
     * @return The calculated force as Vec2
     */
    public Vec2 emitForce(GameObject o)
    {
        Vec2 force = new Vec2(_force.x, _force.y);
        force.mulLocal(1 / o.getBody().m_mass);
        return force;
    }

    /**
     * Force fields are by default not moving and not subjected to forces
     */
    protected BodyType getBodyType()
    {
        return BodyType.STATIC;
    }
}