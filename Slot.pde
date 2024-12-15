/**
 * A container for information about a spawning area in the game.
 * A slot is a specified position on the Screen where Objects can spawn.
 * In a game, one slot can only be occupied by one object at a time.
 */
public class Slot
{
    public Vec2 position;
    public boolean isLocked = false;
    private String _name;

    public Slot(String name, Vec2 pos)
    {
        _name = name;
        position = pos;
    }

    /**
     * @return the slots name
     */
    public String getName() 
    {
        return _name;
    }
}