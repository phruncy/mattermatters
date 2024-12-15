/**
 * Factory to produce an event of a specific type for the Game
 */
public class EventFactory {
    /**
     * @return The Event associated with the given id if the id is valid. 
     * Null if either the id or the event are invalid.
     * @param id The id to the event data
     * @param slot The allocated slot of the new event
     */
    public GameObjectEvent createEvent(String id, Slot slot) {
        JSONObject eventJson = jsonLoader.loadEventById(id);
        String eventType = jsonLoader.loadStringFromEvent(eventJson, "eventType");
        switch(eventType) {
            case "CosmicBody":
                return new CosmicBodyEvent(id, slot);
            case "SpaceJunk":
                return new SpaceJunkEvent(id, slot);
            case "ForceField":
                return new ForceFieldEvent(id, slot);
            case "AntiMatter":
                return new AntiMatterEvent(id, slot);
        }
        return null;
    }
}