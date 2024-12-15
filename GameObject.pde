/**
 * The base class for every physical Object in the game.
 */
public abstract class GameObject
{
    /**
     * references the objects Box2d representation 
     */
    protected Body body;

    /**
     * flag that determines if the object should continue to exist in the next frame. if set to false, it will be deleted by the scene in the next frame.
     */
    protected boolean isAlive = true;

    /**
     * true if the object has been actively deleted by the game. 
     * false otherwise. Used only for assertion/ debugging purposes. 
     */
    protected boolean _deleted = false;
    /**
     * will initiate the object with a box2d body with no collider
     * @param posX x coordinate (in pixels) where the object will be initiated
     * @param posY y coordinate (in pixels) where the object will be initiated
     */


    /**
     * @param posX The x coordinate of the initial position in pixels
     * @param posY The y coordinate of the initial position in pixels
     */
    public GameObject(float posX, float posY)
    {
        BodyDef bodyDef = new BodyDef();
        bodyDef.type = getBodyType();
        bodyDef.position.set(box2d.coordPixelsToWorld(posX, posY));
        //assign userdata to get a reference to object in collision callback
        bodyDef.userData = this;
        body = box2d.createBody(bodyDef);
    }

    /**
     * applies a force to the object's body in the box2d world
     * @param force the force to be applied as vector
     */
    public void applyForce(Vec2 force)
    {
        body.applyForce(force, body.getWorldCenter());
    }

    /**
     * @return the object's Body instance in the box2d world
     */
    public Body getBody()
    {
        return body;
    }

    /**
     * called once every frame.
     * updates properties of the object that are not part of the box2d 
     * simulation. Child classes override this method if necessary.
     * Updates the objects lifetime as the most basic function.
     */
    public void update() {}

    /**
     * marks an object as ready for removal
     * invoked during Collision callback
     */
    public void setDead() 
    {
        isAlive = false;
    }

    /**
     * removes the reference to the object from the box2d world and invokes a 
     * custom destroy method for additional cleanup of child classes
     */
    public final void destroy()
    {
        try {
            _destroy();
            box2d.destroyBody(body);
        } catch (Throwable e) {
            e.printStackTrace();
        }
        
    }

    /**
     * space for custom tasks that are executed when a Game object is destroyed
     * only called from within the public destroy method to ensure the box2d 
     * body is always removed on destroy
     */
    protected abstract void _destroy();

    /**
     * checks and returns if the Object is to be removed frome the scene
     * @return true if the object can be removed from the scene, false otherwise
     */
    public abstract boolean checkAliveness();

    /**
     * the object's method to display itself. Called once every frame.
     */
    public abstract void display();

    /**
     * @return either DYNAMIC, STATIC or KINEMATIC depending on the inheriting class
     * used solely by the constructor for the body definition
     */
    protected abstract BodyType getBodyType();

    /**
     * used for debugging and assertion purposes
     * 
     * @return the value of @see _deleted
     */
    public boolean isDeleted() 
    {
        return _deleted;
    }
}