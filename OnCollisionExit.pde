/**
 * Implemented by Game Objects with actions that happen after
 */
public interface OnCollisionExit
{
    /**
     * Invoked by the endContact() Method
     * @param collider The other object involved in the ending collision
     */
    public void onCollisionExit(GameObject collider);
}