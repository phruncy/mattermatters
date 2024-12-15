/**
 * class for the particles the player must protect in the game
 */
public class PlayerParticle extends Particle
{
    
    /**
     * @param posX The x coordinate of the particle's center in pixels
     * @param posY The y coordinate of the particle's center in pixels
     * @param radius The particle's radius
     */
    public PlayerParticle(float posX, float posY, float radius)
    {
        super(posX, posY, radius);
        _color = jsonLoader.loadColorFromConfig("playerParticle");
        // damp the particles a little so they don't become too uncontrollable
        float damping = jsonLoader.loadFloatFromConfig("playerParticle", "damping");
        body.setLinearDamping(damping);
    }

    /**
     * Applies the attraction force emitted by a player object ont he particle
     * @param player the player object whose force is applied
     */
    public void applyPlayerAttraction(PlayerObject player) 
    {
        Vec2 playerForce = player.emitForce(this);
        applyForce(playerForce);
    }
}