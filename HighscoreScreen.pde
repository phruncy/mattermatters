/**
 * Displays Highscores. That's it.
 */
public class HighscoreScreen extends SceneContent
{
    private color _fontColor;
    private color _background;
    /**
     * The displayed Score values
     */
    private float[] scores;

    private String controlLine = jsonLoader.loadText("controlLine", "controlLine");

    public HighscoreScreen() {
        _background = jsonLoader.loadColorFromConfig("highscores");
        _fontColor = jsonLoader.loadColorFromConfig("font");
        scores = scoreManager.getHighscoreValuesAsArray();
    }

    public void update() {}
    
    public void display() {
        background(_background);
        fill(_fontColor);
        textSize(70);
        textAlign(LEFT, TOP);
        text("HIGHSCORES", 50, 50);
        displayHighscores();
        textAlign(LEFT, BOTTOM);
        textSize(15);
        text(controlLine, 50, height - 50);
    }

    /**
     * Retrieves Highscore data from the score Manager and displays it
     */
    public void displayHighscores() {
        // formatting
        fill(_fontColor);
        textSize(30);
        textAlign(LEFT, TOP);
        // get score values from score manager
        float[] scores = scoreManager.getHighscoreValuesAsArray();
        for (int i = 0; i < scores.length; i++) {
            int posY = 150 + i * 50;
            int counter = i + 1;
            String value = String.format("%.3f", scores[i]);
            text(counter + ". " + value, 50, posY);
        }
    }

    protected void removeExternalLibraryReferences() {}
}