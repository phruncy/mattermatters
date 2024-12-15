/**
 * Rectangular passive object with angular motion
 */
public class SpaceJunk extends PassiveObject
{
    private float _w;
    private float _h;
    private color _color;

    /**
     * @param x The x coordinate of the object in pixels
     * @param y The y coordinate of the object in pixels
     * @param w The object's width in pixels
     * @param h The object's height in pixels
     * @param velocity The initial velocity of the new object
     */
    public SpaceJunk(float x, float y, float w, float h, Vec2 velocity) 
    {
        super(x, y, velocity);
        _w = w;
        _h = h;
        _color = jsonLoader.loadColorFromConfig("spaceJunk");
        int angularVelocity = jsonLoader.loadIntFromConfig("spaceJunk", "angularVelocity");
        body.setAngularVelocity(angularVelocity);
        body.setFixedRotation(true);
        bindFixtureProperties();
    }

    public void display()
    {
        Vec2 position = box2d.getBodyPixelCoord(body);
        float angle = body.getAngle();
        push();
            noStroke();
            fill(_color);
            translate(position.x, position.y);
            rotate(angle);
            rectMode(CENTER);
            rect(0, 0, _w, _h);
        pop();
    }

    /**
     * @return a rectangular PolygonShape with width w and height h
     */
    protected Shape getShape()
    {
        PolygonShape shape = new PolygonShape();
        float boxWidth = box2d.scalarPixelsToWorld(_w / 2);
        float boxHeight = box2d.scalarPixelsToWorld(_h / 2);
        shape.setAsBox(boxWidth, boxHeight);
        return shape;
    }
}