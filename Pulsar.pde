/**
 * A force emitting static game object that frequently switches between 
 * attracting and repelling force
 */
public class Pulsar extends CosmicBody
{
    /**
     * the color in which the pulsar is rendered when in attracting mode
     */
    private color _attractColor;

    /**
     * the color in which the pulsar is displayed when in repelling mode
     */
    private color _repelColor;

    /**
     * stores the value of millis() at the time of object creation
     * + the timer duration of 5000 milliseconds
     */
    private int _timerStart;
    
    /**
     * @param posX the x coordinate of the pulsar's center in pixels
     * @param posY the y coordinate of the pulsar's center in pixels
     * @param radius the pulsar's radius
     * @param mode determines whether the pulsar starts attracting or repelling
     * @param g the strength of the force emitted by the pulsar
     */
    public Pulsar(float posX, float posY, float radius, boolean mode, float g)
    {
        super(posX, posY, radius, mode, g);
        _attractColor = jsonLoader.loadColorFromConfig("pulsarDefault");
        _repelColor = jsonLoader.loadColorFromConfig("pulsarRepelling");
        _color = isRepelling ? _repelColor : _attractColor;
        int timerValue = jsonLoader.loadIntFromConfig("pulsarRepelling", "timer");
        _timerStart = millis() + 5000;
    }

    /**
     * Toggles the isRepelling flag
     */
    public void toggle()
    {
        isRepelling = !isRepelling;
        _color = isRepelling ? _repelColor : _attractColor;
        pulsarChange.play();
    }

    /**
     * Updates the pulsar's countdown timer. after every 5 seconds it will 
     * toggle its mode and reset the timer.
     */
    public void update() 
    {
        int currentTimer = updateTimer();
        if (currentTimer <= 0) {
            toggle();
            resetTimer();
        }
    }

    /**
     * Updates the countdown timer by the time passed since the last call.
     * Invoked once per frame.
     *
     * @return the time passed since the last call of updateTimer() in milliseconds
     */
    public int updateTimer ()
    {
        return _timerStart - millis();
    }

    /**
     * resets the timer to 5000 milliseconds
     */
    public void resetTimer()
    {
        _timerStart = millis() + 5000;
    }
}