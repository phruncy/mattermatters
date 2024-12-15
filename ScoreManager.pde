/**
 * A class for managing score and highscore data accross scenes
 */
public class ScoreManager {
    /**
     * The most recent score that was achieved in the runtime
     */
    private float _currentScore = 0;

    /**
     * A lIst storing all highscores
     */
    private ArrayList<Float> highScores = new ArrayList<Float>();
    
    /**
     * The maximum length of the highscores list
     */
    private int maxEntries;

    public ScoreManager()
    {
        maxEntries = jsonLoader.loadIntFromConfig("highscores", "maxEntries");
        loadHighscores();
    }

    /**
     * @return The value of _currentScore
     */
    public float getCurrent()
    {
        return _currentScore;
    }

    /**
     * Sets the value of _currentScore to the parameter value
     * @param value The value to set
     */
    public void setCurrent(float value) {
        _currentScore = value;
        
    }

    /**
     * Sets _currentScore back to 0. Invoked when a new Game is started.
     */
    public void resetCurrent()
    {
        _currentScore = 0;
    }

    /**
     * load saved highscores
     */
    public void loadHighscores() 
    {
        highScores = jsonLoader.loadHighscoresAsList();
        // bring list in reverse Order
        Collections.sort(highScores);
        Collections.reverse(highScores);
    }

    /**
     * @return The highScore float Values as Array
     */
    public float[] getHighscoreValuesAsArray()
    {
        float[] values = new float[highScores.size()];
        for (int i = 0; i < highScores.size(); i++) {
            values[i] = highScores.get(i).floatValue();
        }
        return values;
    }

    /**
     * Checks if the given value is higher than at least one existing Highscore entry. if that is the case, it will be added and the lowest entry will be removed instead. The new Highscore list is then serialized.
     *
     * @param score The score value to be checked for insertion
     */
    public void tryInsertScore(float score) 
    {
        for (int i = 0; i < highScores.size(); i++) {
            if (score > highScores.get(i).floatValue()) {
                highScores.add(i, score);
                break;
            }
        }
        if (highScores.size() > maxEntries) {
            highScores.remove(highScores.size() - 1);
        }
        updateSerialzedHighscores();
    }

    /**
     * writes the current Highscores List back to highscores.json
     */
    private void updateSerialzedHighscores() {
        // serialize and save the data
        JSONArray serializedHighscores = new JSONArray();
        for(int i = 0; i < highScores.size(); i++) {
            JSONObject scoreObject = new JSONObject();
            scoreObject.setFloat("value", highScores.get(i).floatValue());
            serializedHighscores.setJSONObject(i, scoreObject);
        }
        saveJSONArray(serializedHighscores, "data/highscores.json");
    }       


}