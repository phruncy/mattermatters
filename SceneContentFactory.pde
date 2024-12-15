/**
 * Abstract Factory that creates a new instance of Scene Content
 * @see SceneType
 */
public class SceneContentFactory
{
    /**
     * @param type the type of content to be created
     * @return a new instance of the class mapped to the given scene type
     */
    public SceneContent getSceneContent(SceneType type)
    {
        switch (type) {
            case UNSET:
                return null;
            case MENU:
                return new Menu();
            case GAME:
                return new Game();
            case TUTORIAL:
                return new Tutorial();
            case LOST:
                return new LostScreen();
            case HIGHSCORE:
                return new HighscoreScreen();
        }
        return null;
    }
}