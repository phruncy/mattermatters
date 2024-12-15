/**
 * Game Objects subjected to all forces that are created in huge numbers
 */
public abstract class Particle extends GameObject
{
    /**
     * the particle's radius
     */
    private float _radius;

    /**
     * the particle's color
     */
    protected color _color = color(252, 3, 227);

    
    /**
     * @param posX x coordinate (in pixels) where the object will be initiated
     * @param posY y coordinate (in pixels) where the object will be initiated
     * @param radius radius of the default visual representation and circular shape
     */
    public Particle(float posX, float posY, float radius)
    {
        super(posX, posY);
        body.setLinearDamping(0.1f);
        _radius = radius;
        CircleShape shape = new CircleShape();
        float worldRadius = box2d.scalarPixelsToWorld(_radius);
        shape.m_radius = worldRadius;

        FixtureDef fixDef = new FixtureDef();
        fixDef.shape = shape;
        fixDef.friction = 0.5;
        fixDef.restitution = 0.1;
        fixDef.density = 50;

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
     * Checks and returns if the Object is to be removed from the scene
     * @return false if the object is outside the visible screen 
     * or marked as dead, true otherwise
     */
    public boolean checkAliveness() 
    {
        if (!isAlive) return false;
        Vec2 position = box2d.getBodyPixelCoord(body);
        if (position.x < -50 || position.x > width + 50) return false;
        if (position.y < -50 || position.y > height + 50) return false;
        return true;
    }

    protected void _destroy()
    {
        _deleted = true;
    }

    /**
     * @return BodyType.DYNAMIC as particles are dynamic objects
     */
    protected BodyType getBodyType()
    {
        return BodyType.DYNAMIC;
    }

    
}