public class PlayerObject extends BlackHole
{
    /**
     * the strength of the force that pulls the player object towards the mouse
     */
    private float _attractionMultiplier;
    
    public PlayerObject(float posX, float posY) 
    {
        super(posX, 
            posY, 
            jsonLoader.loadFloatFromConfig("player", "radius"), 
            jsonLoader.loadFloatFromConfig("player", "attraction")
        );
        _color = jsonLoader.loadColorFromConfig("player");
        _attractionMultiplier = jsonLoader.loadFloatFromConfig("player", "attractionMultiplier");
    }

    /**
     * The player object is steered by a constant strong attracting force in the direction of the mouse
     */
    public void update()
    {
        Vec2 velocity = getMouseAttraction();
        body.setLinearVelocity(velocity);
    }

    /**
     * sets the objects position to the coordinates given as arguments
     * @param x the x coordinate in pixels
     * @param y the y coordinate in pixels
     */
    public void updatePosition(float x, float y)
    {
        body.setTransform(box2d.coordPixelsToWorld(x, y), 0);
    }

    /**
     * overrides the default return of STATIC
     * @return BodyType.DYNAMIC
     */
    protected BodyType getBodyType()
    {
        return BodyType.KINEMATIC;
    }

    /**
     * calculates the attraction to the mouse proportional to the distance 
     * between object center and mouse position
     * @return The object's velocity as Vec2 pointing from object center to the 
     * mouse position
     */
    private Vec2 getMouseAttraction()
    {
        Vec2 position = body.getWorldCenter();
        Vec2 mouse = box2d.coordPixelsToWorld(mouseX, mouseY);
        mouse.subLocal(position);
        float difference = mouse.length();
        mouse.normalize();
        mouse.mulLocal(difference * _attractionMultiplier);
        return mouse;
    }
}