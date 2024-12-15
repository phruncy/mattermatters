/**
 * This class managed the Screen the player sees when the game is lost.
 * To make it more fun to watch, some particle clash is happening in the 
 * background.
 */
public class LostScreen extends SceneContent
{
    private color _background = jsonLoader.loadColorFromConfig("lost");
    private PFont font;
    private int particleNumber = 100;
    private float displayedScore;
    private color fontColor;
    private String title = jsonLoader.loadText("lost", "title");
    private String message = jsonLoader.loadText("lost", "message");

    public LostScreen()
    {
        // Telegrama font by Yamaoka Yashuhiro, 1992
        font = createFont("fonts/telegrama_raw.otf", 20);
        textFont(font);
        fontColor = jsonLoader.loadColorFromConfig("font");
        displayedScore = scoreManager.getCurrent();
        // initiate some lovely particles and add them to active objects
        for (int i = 0; i < particleNumber; i++) {
            AntiMatterParticle left = new AntiMatterParticle(
                -20 + random(-3, 3), 
                height / 2 + random(-3, 3), 
                3, new Vec2(1, 0), 600
            );
            AntiMatterParticle right = new AntiMatterParticle(
                width + 20 - random(-3, 3),
                height / 2 + random(-3, 3),
                3, new Vec2(-1, 0), 600
            );
            activeObjects.addObject(left);
            activeObjects.addObject(right);
        }
    }

    public void update() {
        activeObjects.update();
    }

    public void display()
    {
        background(_background);
        activeObjects.display();
        fill(fontColor);
        textSize(70);
        textAlign(CENTER, CENTER);
        text(title, width / 2, 100);
        textSize(35);
        text("Your score is: " + displayedScore, width / 2, 250);
        text(message, width / 2, height - 120);
    }
    /**
     * Destroy all GameObjects from the Scene
     */
    protected void removeExternalLibraryReferences() {
        activeObjects.clearAllObjects();
    }
}