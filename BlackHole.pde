/**
 * A special kind of attractor that causes the destruction of objects colliding * with it. 
 */
public class BlackHole extends CosmicBody implements OnCollisionEnter
{
    /**
     * @param posX x-coordinate in pixels
     * @param posY y-coordinate in pixels
     * @param radius the object's radius in pixels
     * @param g strength of the attracting force
     */
    public BlackHole(float posX, float posY, float radius, float g) 
    {
        super(posX, posY, radius, false, g);
        _color = jsonLoader.loadColorFromConfig("blackHole");
    }

    /**
     * When a Black hole collides with another object, the other object is 
     * marked for deletion and will be destroyed in the next frame
     * @param collider The other object that is involved in the collision
     */
    public void onCollisionEnter(GameObject collider) {
        if (collider instanceof Particle) {
            collider.setDead();
        }
    }
}

