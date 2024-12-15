/**
 * a logically enclosed part of the program such as Menu, Main game etc.
 * This class works as a wrapper around the actual scene content to provide the * main program with a controlled interface for the interaction with 
 * the scene content.
 */
public class Scene
{
    /**
     * References the actual scene content
     */
    private SceneContent content;

    /**
     * For an overview over all content types: @see SceneType
     *
     * @param contentType Determines the content of the scene. 
     * @see SceneType
     */
    public Scene(SceneType contentType)
    {
        SceneContentFactory factory = new SceneContentFactory();
        content = factory.getSceneContent(contentType);
        assert content != null;
    }

    /**
     * Will cause the scene Content to update and display itself.
     * Called once per frame.
     */
    public void run()
    {
        content.update();
        content.display();
    }

    /**
     * Will 'clean up' the scene content before the scene is destroyed.
     * Deletes all Objects that are not removied automatically such as 
     * box2d bodies
     */
    public void destroy()
    {
        content.clear();
    }
}