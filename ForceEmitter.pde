/**
 * implemented by all Objects that emit forces on other Objects (namely force 
 * fields and cosmic bodies)
 */
public interface ForceEmitter 
{
    /** 
     * @param o The target object for which the force is calculated
     */
    public Vec2 emitForce(GameObject o);
}