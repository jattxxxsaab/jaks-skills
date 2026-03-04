# Home Assistant Skill

Control Jimmy's smart home via Home Assistant REST API.

## Connection

- **URL**: `YOUR_HA_URL`
- **Auth**: Long-lived access token (stored in `ha-token.txt` in this skill directory)

## Usage

Use the `ha` script in this directory for all Home Assistant interactions.

### Commands

```bash
# Get all states (full dump)
./ha states

# Get specific entity state
./ha state <entity_id>

# List entities by domain (light, switch, climate, lock, media_player, etc.)
./ha list <domain>

# Turn on/off an entity
./ha on <entity_id>
./ha off <entity_id>

# Toggle an entity
./ha toggle <entity_id>

# Set climate temperature
./ha climate <entity_id> <temp>

# Call any HA service
./ha call <domain> <service> <entity_id> [json_data]

# Lock/unlock
./ha lock <entity_id>
./ha unlock <entity_id>

# Get entity history (last 24h)
./ha history <entity_id>

# List scenes
./ha scenes

# Activate a scene
./ha scene <scene_entity_id>

# List automations
./ha automations

# Trigger an automation
./ha trigger <automation_entity_id>
```

## Quick Reference — Jimmy's Home

### Lights
- `light.living_room` — Living room
- `light.outdoor` — Outdoor lights
- `light.patio` — Patio
- `light.family_room_lights` — Family room
- `light.kirpas_light` — Kirpa's light
- `light.hue_sideyard` — Sideyard
- `light.string_lights_light` — String lights
- `light.front_door_led_strip` — Front door LED strip
- `light.hue_play_left` / `light.hue_play_right` — TV ambient
- `light.hue_color_behind_tv` — Behind TV
- `light.backyard_retaining_wall` — Backyard retaining wall

### Switches
- `switch.master_light_switch` — Master bedroom light
- `switch.master_fan_switch` — Master bedroom fan
- `switch.kids_shower_light` — Kids shower
- `switch.shed_light` — Shed
- `switch.garage_light` — Garage
- `switch.front_door` — Front door
- `switch.fan` — Fan
- `switch.family_room_lights` — Family room (switch)
- `switch.kirpas_fan` — Kirpa's fan
- `switch.attic_fan` — Attic fan
- `switch.front_door_plug` — Front door plug
- `switch.christmas_tree` — Christmas tree

### Climate
- `climate.pool` — Pool heater
- `climate.spa` — Spa heater

### Media Players
- `media_player.living_room_tv` — Living Room TV
- `media_player.hallway_speaker` — Hallway speaker
- `media_player.nesthubmaxbe99` — Family Room Display
- `media_player.office_display` — Office Display

### Locks
- Check with `./ha list lock`

## Notes
- Many Hue retaining wall / pool lights show as "unavailable" — likely a Hue bridge issue
- Automations exist for sunrise lights off and garden lights at sunset
