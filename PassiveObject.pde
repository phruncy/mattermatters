
/**
 * Dynamic objects with variable shape that are subject to forces and can 
 * collide with other objects but 
 * have no interaction upon collision
 */
public abstract class PassiveObject extends GameObject
{
    public Vec2 _velocityImpulse;

    public PassiveObject(float x, float y, Vec2 velocityImpulse) {
        super(x, y);
        _velocityImpulse = velocityImpulse;
    }

    public abstract void display();
    public void update() {}

    /**
     * @return false if the object is either already marked as dead more than 
     * 50 pixels out of the screen
     */
    public boolean checkAliveness() {
        if (!isAlive) return false;
        Vec2 position = box2d.getBodyPixelCoord(body);
        if (position.x < -50 || position.x > width + 50) {
            isAlive = false;
            return false;
        }    
        if (position.y < -50 || position.y > height + 50) {
            isAlive = false;
            return false;
        }  
        return true;
    }

    protected void _destroy() {}

    /**
     * overrides the default return of BodyType.STATIC
     * @return BodyType.DYNAMIC
     */
    protected BodyType getBodyType() 
    {
        return BodyType.DYNAMIC;
    }

    /**
     * @return The object's instance of Box2d.Shape
     */
    protected abstract Shape getShape();

    /**
     * sets up shape and fixture of the object. Called by the constructors of 
     * inheriting classes after variables needed for the execution of 
     * getShape() have been initiated
     */
    protected void bindFixtureProperties() 
    {
        Shape shape = getShape();

        FixtureDef fixDef = new FixtureDef();
        fixDef.shape = shape;
        fixDef.friction = 0;
        fixDef.restitution = 0.1;
        fixDef.density = 10000;
        Vec2 force = _velocityImpulse.mulLocal(fixDef.density);

        body.createFixture(fixDef);
        body.applyLinearImpulse(force, body.getWorldCenter(), false);
    }
}