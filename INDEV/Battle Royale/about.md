# Battle Royale (WIP)

### Description:
Battle Royale is a game mode inspired by the popular game *PlayerUnknown's Battlegrounds* (PUBG).
The game mode is currently in development and is not ready for public release.

Eliminate all other opponents while avoiding being trapped outside a shrinking "safe area",
with the winner being the last player alive.

Players start with no weapons and must find them scattered around the map.
Loot crates will spawn randomly around the map, containing weapons, ammo, and other items.

## Planned features:

- [x] Shrinking "safe zone" boundary
    - [x] The safe zone will shrink over time, forcing players to move closer together.
    - [x] Players outside the safe zone will take damage over time.
    - [ ] The safe zone will be marked on the map with flag poles. (**WIP**)
- [x] Spectator mode:
    - [x] Players will be able to spectate other players after they die.
    - [x] They will be invisible, invulnerable, and unable to interact with the world.
- [x] Limited lives:
    - [x] Players will have a limited number of lives.
    - [x] Players will be able to spectate other players after they die.
- [x] Randomized loot
    - [x] Loot will be randomized and spawn in random locations
    - Loot includes ammo:
        - [x] Camo
        - [x] Overshield
        - [x] Nuke
        - [x] Stun grenades
        - [x] Weapon parts (for weapon repair system)
        - [x] Ammo (different types)
        - [x] Random Weapons (different types)
        - [x] Grenade launcher
        - [x] Health boost (50%, 100%, 150%, 200%)
        - [x] Speed boost (1.2, 1.3, 1.4, 1.5)
- [x] Sky spawn system:
    - [x] Players will spawn in the sky and fall to the ground.
    - [x] Players will be invulnerable until they land.
    - [x] No two players will spawn in the same location.
- [x] Weapon weights:
    - [x] Weapons will have weights, and players will have a weight limit.
    - [x] Players will be able to drop weapons to reduce their weight.
- [x] Weapon degradation:
    - [x] Weapons will degrade over time.
    - [x] Durability decreases when: *shooting*, *reloading* or *melee*.
- [x] Weapons (general):
    - [x] Players will start with no weapons.
    - [x] You will have to find weapon *parts* to repair damaged weapons.
- [x] Different types of ammo:
    - [x] Armoured-piercing bullets,
    - [x] Explosive bullets
    - [x] Golden bullets (one-shot kill)
- [x] Support for these stock maps:
    - `timberland`, `bloodgulch`,
    - `dangercanyon`, `icefields`
    - `infinity`, `sidewinder`
    - `deathisland`, `gephyrophobia`

# Coming in a future update:
- [ ] Custom commands to spawn loot crates on demand (for host testing purposes)
- [ ] Loot crate locations will be randomized every time they respawn.
- [ ] Tweaks to loot crate respawn time:<br/>
  *All loot crates currently have the same respawn time (albeit configurable), across all maps (30 seconds).
  Some spawn near weapons - these need to have a longer respawn time.*

# Known bugs:
- ~~Energy weapons from loot crates don't have battery power.~~
- ~~Receiving a weapon from a loot crate that you already have caused the server to crash.~~
- Game doesn't end with the last man standing
- ~~Time remaining HUD keeps resetting when the zone shrinks.~~
- ~~Nuke is crashing the server.~~
- When receiving an overshield from a loot crate, you won't see the shield bar change until you take damage.<br/>
  Unfortunately, this is a limitation of Halo's net code.

# [CODE](https://github.com/Chalwk77/HALO-SCRIPT-PROJECTS/tree/master/INDEV)

![alt text](https://progress-bar.dev/95/?title=Progress)