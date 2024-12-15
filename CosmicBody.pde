/**
 * A Game Object that can eiher attract or repel other game objects
 * Cosmic bodies can only emit forces but are not subject to forces themselves
 */
public class CosmicBody extends GameObject implements ForceEmitter
{
    /**
     * If false, the object will attract other objects, if true it repels them
     */
    protected boolean isRepelling;
    
    /**
     * The objects radius in pixels
     */
    private float _radius;
    /**
     * Constant multiplier for the emitted force -> determines its strength
     */
    private float G;

    /**
     * The displaying color of the body
     */
    protected color _color = color(255);

    /**
     * @param posX x-coordinate in pixels
     * @param posY y-coordinate in pixels
     * @param radius the object's radius in pixels
     * @param mode 0 if the object is attracting, 1 if it is repelling
     * @param g strength of the attracting force
     */
    public CosmicBody(float posX, float posY, float radius, boolean mode, float g)
    {
        super(posX, posY);
        isRepelling = mode;
        G = g;

        _radius = radius;
        CircleShape shape = new CircleShape();
        float worldRadius = box2d.scalarPixelsToWorld(_radius);
        shape.m_radius = worldRadius;

        FixtureDef fixDef = new FixtureDef();
        fixDef.shape = shape;
        fixDef.friction = 0.1;
        fixDef.restitution = 0.5;
        fixDef.density = 10000;

        body.createFixture(fixDef);
    }

    public void display() 
    {
        Vec2 position = box2d.getBodyPixelCoord(body);
        push();
            noStroke();
            fill(_color);
            ellipse(position.x, position.y, _radius * 2, _radius * 2);
        pop();
    }

    /**
     * @param o The GameObject on which the force is applied
     * @return The calculated attracting or repelling force as a vector
     */
    public Vec2 emitForce(GameObject o)
    {
        float direction = isRepelling ? -1 : 1;
        Vec2 position = body.getWorldCenter();
        Vec2 oPosition = o.getBody().getWorldCenter();
        Vec2 force = position.sub(oPosition);
        float distance = force.length();
        distance = constrain(distance, 1, 5);
        float strength = (G * o.getBody().m_mass) / (distance * distance);
        force.normalize();
        force.mulLocal(strength).mulLocal(direction);
        return force;
    } 

    protected void _destroy() {}

    
    public boolean checkAliveness() 
    {
        return isAlive;
    }

    /**
     * By default, cosmic bodies are not sujected to forces and don't move 
     * either
     *
     */
    protected BodyType getBodyType()
    {
        return BodyType.STATIC;
    }
}