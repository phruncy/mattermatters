/**
 * The "How to play section" showing explaining the different objects.
 * The objects are just for visualization, meaning that they don't show their full behaviour
 */
public class Tutorial extends SceneContent 
{    
    private color _background = jsonLoader.loadColorFromConfig("background");
    private String starControl = jsonLoader.loadText("tutorial", "control");
    private String blackHoleControl = jsonLoader.loadText("tutorial", "blackHole");
    private String forceFieldControl  = jsonLoader.loadText("tutorial", "forceField");
    private String antiMatterControl = jsonLoader.loadText("tutorial", "antiMatter");
    private String pulsarControl = jsonLoader.loadText("tutorial", "pulsar");
    private String spaceJunkControl = jsonLoader.loadText("tutorial", "spaceJunk");
    private String controlLine = jsonLoader.loadText("controlLine", "controlLine");
    // Example Objects
    private Pulsar pulsar = new Pulsar(700, 330, 20, true, 100);
    private BlackHole blackHole = new BlackHole(200, 330, 20, 100);
    private SpaceJunk junk = new SpaceJunk(180, 530, 50, 10, new Vec2(0, 0));
    private ForceField forceField = new ForceField(700, 500, 310, 80, new Vec2(0,0), 0);
    private ArrayList<Particle> particles = new ArrayList<Particle>();
    private PlayerObject star = new PlayerObject(mouseX, mouseY);

    public Tutorial() 
    {
        // ads all the objects to activeObjects
        activeObjects.addObject(pulsar);
        activeObjects.addObject(blackHole);
        activeObjects.addObject(junk);
        activeObjects.addObject(forceField);
        for (int i = 0; i < 30; i++) {
            activeObjects.addObject(new AntiMatterParticle(random(60, 200), random(630, 700), 3, new Vec2(1, 0), 0.01));
        }
        for (int i = 0; i < 30; i++) {
            PlayerParticle p = new PlayerParticle(random(30, 80), random(30, 80), 3);
            activeObjects.addObject(p);
            activeObjects.addPlayerParticle(p);
        }
        activeObjects.addObject(star);
        activeObjects.setPlayer(star);
    }

    public void update() {
        // update game Objects
        activeObjects.update();
    }

    public void display() {
        background(_background);
        fill(255);
        textAlign(LEFT, TOP);
        textSize(20);
        text(starControl, 50, 100);
        // individual objects
        // black hole
        text(blackHoleControl, 50, 200);
        // space junk
        text(spaceJunkControl, 50, 400);
        // antimatter
        text(antiMatterControl, 50, 600);
        
        // pulsar
        text(pulsarControl, width / 2, 200);
        // force Field
        text(forceFieldControl, width / 2, 400);
        
        
        // control Line
        textAlign(LEFT, BOTTOM);
        textSize(15);
        text(controlLine, 50, 50);

        //objects
        activeObjects.display();
    }

    protected void removeExternalLibraryReferences() {
        activeObjects.clearAllObjects();
    }
}