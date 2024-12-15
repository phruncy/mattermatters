/**
 * A class of particles that erase Player particles on collision and get erased * upon collision with other rigid game objects
 * move through space without damping
 */
public class AntiMatterParticle extends Particle implements OnCollisionEnter
{
    /**
     * @param posX x coordinate of center in pixels
     * @param posY y coordinate of center in pixels
     * @param radius the particle's radius
     * @param initDirection the direction of the initial velocity as Vec2
     * @param speed the length of the inital velocity vector
     */
    public AntiMatterParticle(float posX, float posY, float radius, Vec2 initDirection, float speed)
    {
        super(posX, posY, radius);
        _color = jsonLoader.loadColorFromConfig("antiMatterParticle");
        Vec2 velocity = initDirection.clone();
        float multiplier = jsonLoader.loadFloatFromConfig("antiMatterParticle", "initVelocity");
        initDirection.normalize();
        velocity.mulLocal(speed);
        // set initial velocity
        body.applyLinearImpulse(velocity, body.getWorldCenter(), true);
    }

    /**
     * invoked in Collision ContactBegin Callback
     *
     * @param collider the other object involved in the collision
     */
    public void onCollisionEnter(GameObject collider)
    {
        if (collider instanceof PlayerParticle) {
            collider.setDead();
            setDead();
        }
    }
}