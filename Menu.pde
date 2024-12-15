/**
 * The main menu of the game
 */
public class Menu extends SceneContent
{
    /**
     * A container for beautiful background decoration enhancing the mood of
     * the game. Very design. Yes, they are player particles spawning from a 
     * magic number. I have no regrets.
     */
    private ArrayList<PlayerParticle> particles;

    /**
     * Also a very beautiful little happyLittlePulsar to enhance the mood of the menu even further. In case I forget to delete this before I submit it: Sorry, it was very late and this is the last personal comment in this documentation. I swear.
     */
    private Pulsar happyLittlePulsar;

    private color _background = jsonLoader.loadColorFromConfig("background");
    private PFont font;
    private color fontColor;
    // load texts
    private String title = jsonLoader.loadText("menu", "title");
    private String subtitle = jsonLoader.loadText("menu", "subtitle");
    private String controls = jsonLoader.loadText("menu", "controls");

    public Menu() 
    {
        
        // Telegrama font by Yamaoka Yashuhiro, 1992
        font = createFont("fonts/telegrama_raw.otf", 20);
        textFont(font);
        fontColor = jsonLoader.loadColorFromConfig("font");
        // fill with lovely particles
        particles = new ArrayList<PlayerParticle>();
        for (int i = 0; i < 180; i++) {
            particles.add(new PlayerParticle(
                random(0, width),
                random(0, height),
                3
            ));
        }
        happyLittlePulsar = new Pulsar(width / 2, height / 2, 30, false, 50); 
    }
    
    public void update()
    {
        happyLittlePulsar.update();
        for (PlayerParticle particle: particles) {
            Vec2 force = happyLittlePulsar.emitForce(particle);
            particle.applyForce(force);
            particle.update();
        }
    }

    public void display()
    {
        background(_background);
        happyLittlePulsar.display();
        // display particles
        for (PlayerParticle particle: particles) {
            particle.display();
        }
        displayText();
    }

    /**
     * Formats and displays all the text
     */
    public void displayText()
    {
        fill(fontColor);
        textAlign(LEFT, TOP);
        textSize(70);
        text(title, 50, 50);
        textSize(20);
        text(subtitle, 50, 130);
        textAlign(LEFT, BOTTOM);
        textSize(30);
        text(controls, 50, height - 50);
    }

    protected void removeExternalLibraryReferences() {
        for (PlayerParticle particle: particles) {
            particle.destroy();
        }
        particles.clear();
        happyLittlePulsar.destroy();
    }
}