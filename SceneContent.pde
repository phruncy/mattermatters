/**
 * Base class for actual implementations scene content enforcing the 
 * implementation of update, display and removal of box2d-references.
 */
public abstract class SceneContent 
{
    public abstract void update();
    public abstract void display();
    protected abstract void removeExternalLibraryReferences();
    
    /**
     * Removes all references to objects from external Libraries
     * called upon destruction of a scene
     */
    public void clear ()
    {
        removeExternalLibraryReferences();
    }


}