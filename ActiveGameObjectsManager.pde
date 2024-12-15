/**
 * A wrapper around all GameObjects that are currently existing in the program. 
 * Provides public functions that manage all behaviour of game objects that is * unrelated to the active scene * they are displayed in, 
 * namely update and display
 */
public class ActiveGameObjectsManager 
{
    /**
     * All objects that are active and are still alive.
     */
    private ArrayList<GameObject> activeGameObjects = new ArrayList<GameObject>();

    /**
     * This List holds a reference to all ForceEmitters
     */
    private ArrayList<ForceEmitter> emitters = new ArrayList<ForceEmitter>(); 

    /**
     * This list holds references to all PlayerParticle Objects that are in the activeGameObjects List
     */
    private ArrayList<PlayerParticle> playerParticles = new ArrayList<PlayerParticle>();

    /**
     * a reference to a player Object from ActiveGameObjects 
     */
    private PlayerObject player;

    /**
     * Contains all Objects that have been given 
     * free for deletion during update(). Gets cleared once every frame.
     */
    private ArrayList<GameObject> deletables = new ArrayList<GameObject>();

     /**
     * Update all active Objects. Check if any objects have left 
     * the screen and mark them as destroyed. Destroyed objects are moved to 
     * deletables. Then perforems update tasks on specific types of objects 
     * such as player particles or emitters
     */
    public void update() {
        clearDeletables();

        for (GameObject o: activeGameObjects) {
            o.update();
            applyEmitterForces(o);
        }
        // player particle specific task
        for (PlayerParticle p: playerParticles) {
            p.applyPlayerAttraction(player);
        }
        //check for deletion
        for (int i = 0; i < activeGameObjects.size(); i++) {
            GameObject o = activeGameObjects.get(i);
            if (!o.checkAliveness()) {
                assert(!deletables.contains(o));
                deletables.add(o);
                activeGameObjects.remove(o);
                if (emitters.contains(o)) {
                    emitters.remove(o);
                }
                if (playerParticles.contains(o)) {
                    playerParticles.remove(o);
                }
                i--;
            }
        }
    }

    /**
     * Displays all elements from activeGameObjects
     */
    public void display() 
    {
        for (GameObject o: activeGameObjects) {
            o.display();
        }
    }

    /**
     * Adds a GameObject to activeGameObjects
     * 
     * @param o The Game Object to be added
     */
    public void addObject(GameObject o) {
        activeGameObjects.add(o);
    }

    /**
     * Adds a Force Emitter that is already in Game object to the list of emitters;
     * @param emitter The Emitter Object to be added
     */
    public void addEmitter(ForceEmitter emitter) 
    {
        assert (activeGameObjects.contains(emitter));
        emitters.add(emitter);
    }

    /**
     * Sets the player varaiable to the reference given by the parameter
     * @param p The object reference player should be set to
     */
    public void setPlayer(PlayerObject p) 
    {
        assert (activeGameObjects.contains(p));
        player = p;
    }

    /**
     * Adds an entry to the list of player particles
     * @param particle The particle object to be added to the list
     */
    public void addPlayerParticle(PlayerParticle particle) {
        assert (activeGameObjects.contains(particle));
        playerParticles.add(particle);
    }

    /**
     * @return true if at least one Player particle is among the 
     * active game objects, false otherwise 
     */
    public boolean getParticleAliveness() {
        boolean statement = (playerParticles.size() > 0);
        return statement;
    }

    /**
     * calculates and applies all Forces from the emitters on a target
     *
     * @param target The GameObject on which the force is applied
     */
    private void applyEmitterForces(GameObject target) {
        for (ForceEmitter e: emitters) {
            Vec2 force = e.emitForce(target);
            target.applyForce(force);
        }
    }

    /**
     * Destroys all box to 2d bodies linked to any active object and clears all lists managed by this class
     */
    public void clearAllObjects()
    {
        for (GameObject o: activeGameObjects) {
            o.destroy();
        }
        activeGameObjects.clear();
        playerParticles.clear();
        emitters.clear();
        player = null;
    }

    /**
     * removes all Objects marked as deletable from the scene by invoking 
     * destroy() on every object in deletables and then clearing the list.
     * called once every frame at the very beginning of the update() method
     */
    private void clearDeletables() 
    {
        for (GameObject o: deletables) {
            assert(!o.isDeleted());
            o.destroy();
        }
        deletables.clear();
    }
}    