/**
 * implemented by Game Objects that have a special action on collision with 
 * other game objects
 */
public interface OnCollisionEnter 
{
    /**
     * Special action of game object goes here
     * 
     * @param collider The object this object is collising with
     */
    public void onCollisionEnter(GameObject collider);
}