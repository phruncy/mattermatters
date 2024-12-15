/**
 * This class provides different methods to load data from the event.json and 
 * config.json files.
 */
public class JSONLoader
{
    /**
    * Reference to the config.json data
    */
    private JSONObject config;

    /**
    * Reference to events.json data. All Game events are loaded from there.
    */
    private JSONObject events;

    /**
     * Reference to eventKeys.json data. 
     * All event - time pairings are stored here.
     */
    private JSONArray eventKeys;
    
    /**
     * Loads the json files config.json and events.json
     */
    public JSONLoader()
    {
        config = loadJSONObject("config.json");
        events = loadJSONObject("events.json");
        eventKeys = loadJSONArray("eventKeys.json");
    }
    
    /**
     * loads the color information from the given JSON object and returns the 
     * equivalent processing color
     * 
     * @param jsonName: The string representation of the json Object from wich * the color should be loaded
     * @return The color with the values from the specified jsonObject. 
     * If there is no such Object in the config, 
     * the default color(255, 255, 255) is returned.
     */
    public color loadColorFromConfig(String jsonName)
    {
        JSONObject json = config.getJSONObject(jsonName);
        if (json != null) {
            JSONObject jsonColor = json.getJSONObject("color");
            int r = jsonColor.getInt("r");
            int g = jsonColor.getInt("g");
            int b = jsonColor.getInt("b");
            return color(r, g, b);
        }
        return color(255, 255, 255);
    }

    /**
     * Loads and returns a float value from an object from config.json   
     *
     * @param jsonObject The JsonObject where the float is loaded from
     * @param floatName The name of the floatto be loaded
     * @return The loaded value. 0.0 if jsonObject does not exist in config
     */
    public float loadFloatFromConfig(String jsonObject, String floatName)
    {
        JSONObject json = config.getJSONObject(jsonObject);
        if (json != null) {
            return(json.getFloat(floatName));
        }
        return 0.0;
    }

    /**
     * Loads an int value from an object from config.json
     *
     * @param jsonObject The JsonObject where the int is loaded from
     * @param intName The name of the int to be loaded
     * @return The loaded value. 0 if jsonObject does not exist in config
     */
    public int loadIntFromConfig(String jsonObject, String intName)
    {
        JSONObject json = config.getJSONObject(jsonObject);
        if (json != null) {
            return(json.getInt(intName));
        }
        return 0;
    }

    /**
     * Loads and returns json event data for a given second in the game from 
     * the specified category 
     * from events.json. 
     * 
     * @param id the event's id to be loaded
     */
    public JSONObject loadEventById (String id) {
        return events.getJSONObject(id);
    }

    /**
     * @return The eventId - time pairings from eventKeys as Hashmap
     */
    public HashMap<Integer, String> loadEventHashMap()
    {
        HashMap<Integer, String> map = new HashMap<Integer, String>();
        for (int i = 0; i < eventKeys.size(); i++) {
            JSONObject object = eventKeys.getJSONObject(i);
            int key = object.getInt("second");
            String value = object.getString("id");
            map.put(key, value);
        }
        return map;
    }

    /**
     * loads a String from an event JSONObject
     *
     * @param event the JSONObject the String is loaded from
     * @param key The yey to the String value
     * @return a String value
     */
    public String loadStringFromEvent(JSONObject event, String key) 
    {
        return event.getString(key);
    }

    /**
     * loads a float from an event JSONObject
     *
     * @param event the JSONObject the float is loaded from
     * @param key The yey to the float value
     * @return a float value from a event jsonObject
     */
    public float loadFloatFromEvent(JSONObject event, String key) 
    {
        return event.getFloat(key);
    }

    /**
     * loads an int from an event JSONObject
     *
     * @param event the JSONObject the int is loaded from
     * @param key The yey to the int value
     * @return an int value
     */
    public int loadIntFromEvent(JSONObject event, String key)
    {
        return event.getInt(key);
    }

    /**
     * loads all Data from spawningPositions.json into Slot Objects 
     * and returns them as Array.
     * @return All slot data as array
     */
    public Slot[] loadSlots()
    {
        JSONArray json = loadJSONArray("spawningPositions.json");
        Slot[] slots = new Slot[json.size()];
        for (int i = 0; i < slots.length; i++) {
            JSONObject slotJson = json.getJSONObject(i);
            String name = slotJson.getString("name");
            // the x and y value from the json data refer to the relative
            // position on Scrren and are therefore multiplied by
            // width and height
            float x = slotJson.getFloat("x") * width;
            float y = slotJson.getFloat("y") * height;
            Vec2 position = new Vec2(x, y);
            slots[i] = new Slot(name, position);
        }
        return slots;
    }

    /**
     * loads the highscore List from highscores.json
     * @return the Highscore Data as List
     */
    public ArrayList<Float> loadHighscoresAsList()
    {
        ArrayList<Float> scores = new ArrayList<Float>();
        JSONArray highscoresJson = loadJSONArray("highscores.json");
        for (int i = 0; i < highscoresJson.size(); i++) {
            JSONObject scoreObject = highscoresJson.getJSONObject(i);
            float value = scoreObject.getFloat("value");
            scores.add(value);
        }
        return scores;
    }

    /**
     * Loads and return a String from texts.json
     * @param object The key to the text object
     * @param key The key to the wanted String
     * @return The String associated with the key parameter
     */
    public String loadText(String object, String key) {
        JSONObject texts = loadJSONObject("texts.json");
        JSONObject obj = texts.getJSONObject(object);
        String str = obj.getString(key);
        return str;
    }
}