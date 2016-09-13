-- RandomWeapon 3.0

-- Every time you spawn, you will spawn with random attributes.
-- This includes weapons, grenades, ammo, and special abilities.
-- I've written this script intentionally to make it easy for inexperienced scripters to edit and flexible for more experienced scripters to customize.
-- If any of my comments are confusing, or you have any questions about how the script works, you can PM me (Nuggets) at phasor.proboards.com

function GetRequiredVersion()

	return 200
end

function OnScriptLoad(processId, game, persistent)

	-- Probabilities --
	
	probability = {}
		
	-- In each probabilities table, you may create new entries in the same syntax as I've written them, remove any entries I've included, and easily change the probabilities of all attributes.
	-- If you add any probabilities, make sure you give them entries under Player Multipliers, Messages, and Recurrence or they will not work correctly.
	
	-- **If you are using Player Multipliers (see next section entitled "Player Multipliers")**:
	-- Keep in mind these probabilities are for when there are 0 players in your server.
	-- Probabilities that should increase as the number of players increases should therefore be set decently lower than their desired value and vice versa.

	
	-- Primary Weapon Probabilities --

	probability.primary = {}

	--                    Tag:                                      Probability:     Description:
	probability.primary[false] =                                          0          -- No Weapon
	probability.primary["weapons\\assault rifle\\assault rifle"] =        14         -- Assault Rifle
	probability.primary["weapons\\plasma pistol\\plasma pistol"] =        13         -- Plasma Pistol
	probability.primary["weapons\\needler\\mp_needler"] =                 13         -- Needler
	probability.primary["weapons\\plasma rifle\\plasma rifle"] =          13         -- Plasma Rifle
	probability.primary["weapons\\shotgun\\shotgun"] =                    14         -- Shotgun
	probability.primary["weapons\\pistol\\pistol"] =                      13         -- Pistol
	probability.primary["weapons\\sniper rifle\\sniper rifle"] =          12         -- Sniper Rifle
	probability.primary["weapons\\flamethrower\\flamethrower"] =          4          -- Flamethrower
	probability.primary["weapons\\rocket launcher\\rocket launcher"] =    2          -- Rocket Launcher
	probability.primary["weapons\\plasma_cannon\\plasma_cannon"] =        2          -- Fuel Rod

	-- Secondary Weapon Probabilities --
	
	probability.secondary = {}

	--                    Tag:                                       Probability:     Description:
	probability.secondary[false] =                                        15          -- No Weapon
	probability.secondary["weapons\\assault rifle\\assault rifle"] =      14          -- Assault Rifle
	probability.secondary["weapons\\plasma pistol\\plasma pistol"] =      13          -- Plasma Pistol
	probability.secondary["weapons\\needler\\mp_needler"] =               11          -- Needler
	probability.secondary["weapons\\plasma rifle\\plasma rifle"] =        12          -- Plasma Rifle
	probability.secondary["weapons\\shotgun\\shotgun"] =                  13          -- Shotgun
	probability.secondary["weapons\\pistol\\pistol"] =                    10          -- Pistol
	probability.secondary["weapons\\sniper rifle\\sniper rifle"] =        7           -- Sniper Rifle
	probability.secondary["weapons\\flamethrower\\flamethrower"] =        3           -- Flamethrower
	probability.secondary["weapons\\rocket launcher\\rocket launcher"] =  1           -- Rocket Launcher
	probability.secondary["weapons\\plasma_cannon\\plasma_cannon"] =      1           -- Fuel Rod
	
	-- Tertiary Weapon Probabilities --

	probability.tertiary = {}

	--                    Tag:                                       Probability:     Description:
	probability.tertiary[false] =                                         100         -- No Weapon
	probability.tertiary["weapons\\assault rifle\\assault rifle"] =       0           -- Assault Rifle
	probability.tertiary["weapons\\plasma pistol\\plasma pistol"] =       0           -- Plasma Pistol
	probability.tertiary["weapons\\needler\\mp_needler"] =                0           -- Needler
	probability.tertiary["weapons\\plasma rifle\\plasma rifle"] =         0           -- Plasma Rifle
	probability.tertiary["weapons\\shotgun\\shotgun"] =                   0           -- Shotgun
	probability.tertiary["weapons\\pistol\\pistol"] =                     0           -- Pistol
	probability.tertiary["weapons\\sniper rifle\\sniper rifle"] =         0           -- Sniper Rifle
	probability.tertiary["weapons\\flamethrower\\flamethrower"] =         0           -- Flamethrower
	probability.tertiary["weapons\\rocket launcher\\rocket launcher"] =   0           -- Rocket Launcher
	probability.tertiary["weapons\\plasma_cannon\\plasma_cannon"] =       0           -- Fuel Rod
	
	-- Quartenary Weapon Probabilities --

	probability.quartenary = {}

	--                    Tag:                                       Probability:     Description:
	probability.quartenary[false] =                                       100         -- No Weapon
	probability.quartenary["weapons\\assault rifle\\assault rifle"] =     0           -- Assault Rifle
	probability.quartenary["weapons\\plasma pistol\\plasma pistol"] =     0           -- Plasma Pistol
	probability.quartenary["weapons\\needler\\mp_needler"] =              0           -- Needler
	probability.quartenary["weapons\\plasma rifle\\plasma rifle"] =       0           -- Plasma Rifle
	probability.quartenary["weapons\\shotgun\\shotgun"] =                 0           -- Shotgun
	probability.quartenary["weapons\\pistol\\pistol"] =                   0           -- Pistol
	probability.quartenary["weapons\\sniper rifle\\sniper rifle"] =       0           -- Sniper Rifle
	probability.quartenary["weapons\\flamethrower\\flamethrower"] =       0           -- Flamethrower
	probability.quartenary["weapons\\rocket launcher\\rocket launcher"] = 0           -- Rocket Launcher
	probability.quartenary["weapons\\plasma_cannon\\plasma_cannon"] =     0           -- Fuel Rod

	-- Grenade Probabilities --

	probability.grenades = {}  -- Formatted as probability.grenades[{amount of frag grenades, amount of plasma grenades}] = probability
						       -- This format allows you to add custom grenade loadouts by just adding another entry in the same syntax with whatever numbers you like.
	
	--                  Frag,Plasma:    Probability:   Description:
	probability.grenades[{0, 0}] =          30         -- No grenades
	probability.grenades[{1, 0}] =          20         -- 1 frag, no plasmas
	probability.grenades[{2, 0}] =          10         -- 2 frags, no plasmas
	probability.grenades[{0, 1}] =          20         -- no frags, 1 plasma
	probability.grenades[{0, 2}] =          10         -- no frags, 2 plasmas
	probability.grenades[{2, 2}] =          7          -- 2 frags, 2 plasmas
	probability.grenades[{4, 4}] =          3          -- 4 frags, 4 plasmas
	
	-- Ammo Probabilities --
	
	probability.ammo = {}      -- Formatted as probability.ammo[multiplier] = probability
						       -- This format allows you to add custom ammo multipliers by just adding another entry in the same syntax with whatever number you like.
	
	--             Mult:        Probability:    Description:        Multiplier Description:
	probability.ammo[1] =             60        -- Normal Ammo      (Multiplier x1)
	probability.ammo[2] =             20        -- Double Ammo      (Multiplier x2)
	probability.ammo[3] =             12        -- Triple Ammo      (Multiplier x3)
	probability.ammo[4] =             7.8       -- Quadruple Ammo   (Multiplier x4)
	probability.ammo[math.inf] =      0.2       -- Infinite Ammo    (Mulitplier xInf)
	
	-- Special Probabilities --
	
	probability.special = {}   -- Formatted as probability.special[{function to be called <, args...>}] = probability
					           -- The function specified should take in a player's memory id as its first argument; all other arguments are defined by the optional <, args...> in the above syntax.
					           -- This function should also return a boolean which specifies if the attribute should be considered (for example, overshield shouldn't be considered in a no-shields gametype).
					           -- Keep in mind your function can have more than the amount of arguments than the functions I've listed below; it just happened that none of my functions exceeded two.
					           -- This format allows you to add custom probability.special spawns by just adding another entry in the same syntax with whatever function you like.
	
	--                        Function:       arg1:     arg2:          Probability:    Description:                            Function Description:
	probability.special[{    "setspeed",       1               }] =         90         -- No Special Attributes                (uses setspeed(player, 1) to reset a player's speed if they received a speed bonus_ammo previously)
	probability.special[{    "applycamo",      0               }] =         2          -- Camo                                 (uses applycamo(player, 0) to give a player camo until death)
	probability.special[{    "applyos"                         }] =         3.25       -- Overshield                           (uses applyos(player) to give the player overshield)
	probability.special[{    "setspeed",       2               }] =         1.5        -- Double Speed                         (uses setspeed(player, 2) to double a player's speed)
	probability.special[{    "oscamo",         0               }] =         1          -- Camo and Overshield                  (uses oscamo(player, 0) to give a player overshield and camo until death)
	probability.special[{    "camospeed",      0,         2    }] =         0.5        -- Camo and Double Speed                (uses camospeed(player, 0, 2) to give a player camo until death and double speed)
	probability.special[{    "speedos",        2               }] =         0.75       -- Overshield and Double Speed          (uses speedos(player, 2) to give a player overshield and double speed)
	probability.special[{    "speedoscamo",    0,         2    }] =         0.25       -- Camo, Overshield and Double Speed    (uses speedoscamo(player, 0, 2) to give a player camo until death, overshield, and double speed)
	probability.special[{    "damagemultiply", 2               }] =         0.5        -- Double Damage                        (uses damagemultiply(player, 2) to give a player double damage
	probability.special[{    "healthmultiply", 2               }] =         0.25       -- Double Health and Shields            (uses healthmultiply(player, 2) to give a player double health and shields
	
	
	-- Player Multipliers --
	
	multiplier = {}             -- Changes attribute probabilities based on the amount of players in the server.
								-- Value specifies percentage of probability per player in the server.
								-- For example, multiplier.ammo[2] = 0.5 will divide Double Ammo's probability in half per player who joins (if ammo[2] = 10, 2 players = 5, 3 players = 2.5, 4 players = 1.25, etc)
								-- Keep in mind that increasing every attribute's probability by the same amount will do nothing since the probability of each attribute is dependent on the probability of every other attribute in that category.
								-- In general, 1.0000 ± 0.0025 is a slow increase/decrease, 1.0000 ± 0.0050 is a moderate increase/decrease, and 1.0000 ± 0.0075 is a sharp increase/decrease in probability per joining player.
								
								-- The variable player_multipliers must be true in order to see how the multipliers affect the percentage probabilities.
								
								-- Keep in mind that for the most part, these numbers should be extremely close to 1.  Probabilities change drastically faster than you may think.
								
								-- If you don't want to use Player Multipliers, make player_multipliers = false.

	player_multipliers = true   -- Use to toggle the use of Player Multipliers.  If false, all values in the multipliers table below are completely ignored (therefore, 1.0000).
	
	multiplier.primary = {}    -- Player Multipliers for Primary Weapons
	
	--                                Tag:                                Multiplier:         Description:
	multiplier.primary[false] =                                             1.0000            -- No Weapon:  We never want this probability to be anything but zero.
	multiplier.primary["weapons\\assault rifle\\assault rifle"] =           1.0050            -- Assault Rifle:  We want this probability to moderately increase as more players join.
	multiplier.primary["weapons\\plasma pistol\\plasma pistol"] =           1.0025            -- Plasma Pistol:  We want this probability to slowly increase as more players join.
	multiplier.primary["weapons\\needler\\mp_needler"] =                    1.0025            -- Needler:  We want this probability to moderately increase as more players join.
	multiplier.primary["weapons\\plasma rifle\\plasma rifle"] =             1.0050            -- Plasma Rifle:  We want this probability to moderately increase as more players join.
	multiplier.primary["weapons\\shotgun\\shotgun"] =                       1.0025            -- Shotgun:  We want this probability to slowly increase as more players join.
	multiplier.primary["weapons\\pistol\\pistol"] =                         1.0000            -- Pistol:  We want this probability to remain the same no matter how many players join.
	multiplier.primary["weapons\\sniper rifle\\sniper rifle"] =             0.9975            -- Sniper Rifle:  We want this probability to slowly decrease as more players join.
	multiplier.primary["weapons\\flamethrower\\flamethrower"] =             0.9950            -- Flamethrower:  We want this probability to moderately decrease as more players join.
	multiplier.primary["weapons\\rocket launcher\\rocket launcher"] =       0.9900            -- Rocket Launcher:  We want this probability to very sharply decrease as more players join.
	multiplier.primary["weapons\\plasma_cannon\\plasma_cannon"] =           0.9875            -- Fuel Rod:  We want this probability to very sharply decrease as more players join.
	
	multiplier.secondary = {}    -- Player Multipliers for Secondary Weapons
	
		--                                Tag:                            Multiplier:         Description:
	multiplier.secondary[false] =                                           1.0125            -- No Weapon:  We want this probability to very sharply increase as more players join.
	multiplier.secondary["weapons\\assault rifle\\assault rifle"] =         1.0050            -- Assault Rifle:  We want this probability to moderately increase as more players join.
	multiplier.secondary["weapons\\plasma pistol\\plasma pistol"] =         1.0000            -- Plasma Pistol:  We want this probability to remain the same as more players join.
	multiplier.secondary["weapons\\needler\\mp_needler"] =                  1.0025            -- Needler:  We want this probability to moderately increase as more players join.
	multiplier.secondary["weapons\\plasma rifle\\plasma rifle"] =           1.0025            -- Plasma Rifle:  We want this probability to slowly increase as more players join.
	multiplier.secondary["weapons\\shotgun\\shotgun"] =                     0.9975            -- Shotgun:  We want this probability to remain the same as more players join.
	multiplier.secondary["weapons\\pistol\\pistol"] =                       0.9950            -- Pistol:  We want this probability to remain the same no matter how many players join.
	multiplier.secondary["weapons\\sniper rifle\\sniper rifle"] =           0.9975            -- Sniper Rifle:  We want this probability to slowly decrease as more players join.
	multiplier.secondary["weapons\\flamethrower\\flamethrower"] =           0.9900            -- Flamethrower:  We want this probability to slowly decrease as more players join.
	multiplier.secondary["weapons\\rocket launcher\\rocket launcher"] =     0.9850            -- Rocket Launcher:  We want this probability to sharply decrease as more players join.
	multiplier.secondary["weapons\\plasma_cannon\\plasma_cannon"] =         0.9800            -- Fuel Rod:  We want this probability to very sharply decrease as more players join.
	
	multiplier.tertiary = {}    -- Player Multipliers for Tertiary Weapons
								-- I've set this script up to not include Tertiary Weapon probabilities (other than No Weapon), therefore I have made all of these multipliers 1.0000.
								-- Use Primary and Secondary Weapon Player Multipliers for reference if you wish to change these values.
	
	--                                Tag:                                Multiplier:         Description:
	multiplier.tertiary[false] =                                             1.0000           -- No Weapon
	multiplier.tertiary["weapons\\assault rifle\\assault rifle"] =           1.0000           -- Assault Rifle
	multiplier.tertiary["weapons\\plasma pistol\\plasma pistol"] =           1.0000           -- Plasma Pistol
	multiplier.tertiary["weapons\\needler\\mp_needler"] =                    1.0000           -- Needler
	multiplier.tertiary["weapons\\plasma rifle\\plasma rifle"] =             1.0000           -- Plasma Rifle
	multiplier.tertiary["weapons\\shotgun\\shotgun"] =                       1.0000           -- Shotgun
	multiplier.tertiary["weapons\\pistol\\pistol"] =                         1.0000           -- Pistol
	multiplier.tertiary["weapons\\sniper rifle\\sniper rifle"] =             1.0000           -- Sniper Rifle
	multiplier.tertiary["weapons\\flamethrower\\flamethrower"] =             1.0000           -- Flamethrower
	multiplier.tertiary["weapons\\rocket launcher\\rocket launcher"] =       1.0000           -- Rocket Launcher
	multiplier.tertiary["weapons\\plasma_cannon\\plasma_cannon"] =           1.0000           -- Fuel Rod
	
	multiplier.quartenary = {}    -- Player Multipliers for Quartenary Weapons
								-- See Tertiary Weapon Player Multipliers if you wish to change these values.
	
	--                                Tag:                                Multiplier:        Description:
	multiplier.quartenary[false] =                                           1.0000           -- No Weapon
	multiplier.quartenary["weapons\\assault rifle\\assault rifle"] =         1.0000           -- Assault Rifle
	multiplier.quartenary["weapons\\plasma pistol\\plasma pistol"] =         1.0000           -- Plasma Pistol
	multiplier.quartenary["weapons\\needler\\mp_needler"] =                  1.0000           -- Needler
	multiplier.quartenary["weapons\\plasma rifle\\plasma rifle"] =           1.0000           -- Plasma Rifle
	multiplier.quartenary["weapons\\shotgun\\shotgun"] =                     1.0000           -- Shotgun
	multiplier.quartenary["weapons\\pistol\\pistol"] =                       1.0000           -- Pistol
	multiplier.quartenary["weapons\\sniper rifle\\sniper rifle"] =           1.0000           -- Sniper Rifle
	multiplier.quartenary["weapons\\flamethrower\\flamethrower"] =           1.0000           -- Flamethrower
	multiplier.quartenary["weapons\\rocket launcher\\rocket launcher"] =     1.0000           -- Rocket Launcher
	multiplier.quartenary["weapons\\plasma_cannon\\plasma_cannon"] =         1.0000           -- Fuel Rod
	
	multiplier.grenades = {}    -- Player Multipliers for Grenades
	
	--                 Frag,Plasma:    Multiplier:        Description:
	multiplier.grenades[{0, 0}] =         1.0075            -- No Grenades
	multiplier.grenades[{1, 0}] =         0.9975            -- One Frag
	multiplier.grenades[{2, 0}] =         0.9975            -- Two Frags
	multiplier.grenades[{0, 1}] =         0.9975            -- One Plasma
	multiplier.grenades[{0, 2}] =         0.9975            -- Two Plasmas
	multiplier.grenades[{2, 2}] =         0.9950            -- Two of Each
	multiplier.grenades[{4, 4}] =         0.9925            -- Four of Each
	
	multiplier.ammo = {}        -- Player Multipliers for Ammo
	
	--    Ammo Multiplier:    Probability Multiplier:        Description:
	multiplier.ammo[1] =                 0.9950                -- Normal Ammo
	multiplier.ammo[2] =                 1.0050                -- Double Ammo
	multiplier.ammo[3] =                 1.0075                -- Triple Ammo
	multiplier.ammo[4] =                 1.0075                -- Ammotacular
	multiplier.ammo[math.inf] =          0.9250                -- Infinite Ammo
	
	multiplier.special = {}        -- Player Multipliers for Special Attributes
	
	--                     Function:                Multiplier:         Description:
	multiplier.special[{"setspeed", 1}] =             1.0075            -- No Special
	multiplier.special[{"applycamo", 0}] =            0.9975            -- Camo
	multiplier.special[{"applyos"}] =                 0.9975            -- Overshield
	multiplier.special[{"setspeed", 2}] =             1.0000            -- Double Speed
	multiplier.special[{"oscamo", 0}] =               0.9975            -- Overshield and Camo
	multiplier.special[{"camospeed", 0, 2}] =         0.9950            -- Double Speed and Camo
	multiplier.special[{"speedos", 2}] =              0.9925            -- Double Speed and Overshield
	multiplier.special[{"speedoscamo", 0, 2}] =       0.9900            -- Double Speed, Overshield and Camo
	multiplier.special[{"damagemultiply", 2}] =       0.9950            -- Double Damage
	multiplier.special[{"healthmultiply", 2}] =       1.0050            -- Double Health and Shields
	
	
	-- Messages --
		
	messages = {}   -- If you add any custom probabilities above, make sure a message accompanies it.
					-- Use nil as the message if you don't want a message sent.
					-- All table indexing syntaxes are the same as above.
	
	messages.primary = {}
	
	--                            Tag:                                    Message:
	messages.primary[false] =                                             "No Weapon."
	messages.primary["weapons\\assault rifle\\assault rifle"] =           "Assault Rifle."
	messages.primary["weapons\\plasma pistol\\plasma pistol"] =           "Plasma Pistol."
	messages.primary["weapons\\needler\\mp_needler"] =                    "Needler."
	messages.primary["weapons\\plasma rifle\\plasma rifle"] =             "Plasma Rifle."
	messages.primary["weapons\\shotgun\\shotgun"] =                       "Shotgun."
	messages.primary["weapons\\pistol\\pistol"] =                         "Pistol."
	messages.primary["weapons\\sniper rifle\\sniper rifle"] =             "Sniper."
	messages.primary["weapons\\flamethrower\\flamethrower"] =             "Flamethrower."
	messages.primary["weapons\\rocket launcher\\rocket launcher"] =       "Rocket."
	messages.primary["weapons\\plasma_cannon\\plasma_cannon"] =           "Fuel Rod."
	
	messages.secondary = {}
	
	--                            Tag:                                    Message:
	messages.secondary[false] =                                            nil
	messages.secondary["weapons\\assault rifle\\assault rifle"] =         "Secondary: Assault Rifle"
	messages.secondary["weapons\\plasma pistol\\plasma pistol"] =         "Secondary: Plasma Pistol"
	messages.secondary["weapons\\needler\\mp_needler"] =                  "Secondary: Needler"
	messages.secondary["weapons\\plasma rifle\\plasma rifle"] =           "Secondary: Plasma Rifle"
	messages.secondary["weapons\\shotgun\\shotgun"] =                     "Secondary: Shotgun"
	messages.secondary["weapons\\pistol\\pistol"] =                       "Secondary: Pistol"
	messages.secondary["weapons\\sniper rifle\\sniper rifle"] =           "Secondary: Sniper"
	messages.secondary["weapons\\flamethrower\\flamethrower"] =           "Secondary: Flamethrower"
	messages.secondary["weapons\\rocket launcher\\rocket launcher"] =     "Secondary: Rocket"
	messages.secondary["weapons\\plasma_cannon\\plasma_cannon"] =         "Secondary: Fuel Rod"
	
	messages.tertiary = {}
	
	--                            Tag:                                    Message:
	messages.tertiary[false] =                                             nil
	messages.tertiary["weapons\\assault rifle\\assault rifle"] =          "Tertiary: Assault Rifle"
	messages.tertiary["weapons\\plasma pistol\\plasma pistol"] =          "Tertiary: Plasma Pistol"
	messages.tertiary["weapons\\needler\\mp_needler"] =                   "Tertiary: Needler"
	messages.tertiary["weapons\\plasma rifle\\plasma rifle"] =            "Tertiary: Plasma Rifle"
	messages.tertiary["weapons\\shotgun\\shotgun"] =                      "Tertiary: Shotgun"
	messages.tertiary["weapons\\pistol\\pistol"] =                        "Tertiary: Pistol"
	messages.tertiary["weapons\\sniper rifle\\sniper rifle"] =            "Tertiary: Sniper"
	messages.tertiary["weapons\\flamethrower\\flamethrower"] =            "Tertiary: Flamethrower"
	messages.tertiary["weapons\\rocket launcher\\rocket launcher"] =      "Tertiary: Rocket"
	messages.tertiary["weapons\\plasma_cannon\\plasma_cannon"] =          "Tertiary: Fuel Rod"
	
	messages.quartenary = {}
	
	--                            Tag:                                    Message:
	messages.quartenary[false] =                                           nil
	messages.quartenary["weapons\\assault rifle\\assault rifle"] =        "Quartenary: Assault Rifle"
	messages.quartenary["weapons\\plasma pistol\\plasma pistol"] =        "Quartenary: Plasma Pistol"
	messages.quartenary["weapons\\needler\\mp_needler"] =                 "Quartenary: Needler"
	messages.quartenary["weapons\\plasma rifle\\plasma rifle"] =          "Quartenary: Plasma Rifle"
	messages.quartenary["weapons\\shotgun\\shotgun"] =                    "Quartenary: Shotgun"
	messages.quartenary["weapons\\pistol\\pistol"] =                      "Quartenary: Pistol"
	messages.quartenary["weapons\\sniper rifle\\sniper rifle"] =          "Quartenary: Sniper"
	messages.quartenary["weapons\\flamethrower\\flamethrower"] =          "Quartenary: Flamethrower"
	messages.quartenary["weapons\\rocket launcher\\rocket launcher"] =    "Quartenary: Rocket"
	messages.quartenary["weapons\\plasma_cannon\\plasma_cannon"] =        "Quartenary: Fuel Rod"
	
	messages.grenades = {}
	
	--            Grenades:         Message:
	messages.grenades[{0, 0}] =      nil
	messages.grenades[{1, 0}] =     "A Frag Grenade."
	messages.grenades[{2, 0}] =     "Two Frag Grenades."
	messages.grenades[{0, 1}] =     "A Plasma Grenade."
	messages.grenades[{0, 2}] =     "Two Plasma Grenades."
	messages.grenades[{2, 2}] =     "Two of each Grenade."
	messages.grenades[{4, 4}] =     "Four of each Grenade!"
	
	messages.ammo = {}
	
	--        Multiplier:          Message:
	messages.ammo[1] =              nil
	messages.ammo[2] =             "Double Ammo."
	messages.ammo[3] =             "Triple Ammo."
	messages.ammo[4] =             "Ammotacular!"
	messages.ammo[math.inf] =      "Infinite Ammo!!"
	
	messages.special = {}
	
	--        Function:                            Message:
	messages.special[{"setspeed", 1}] =             nil
	messages.special[{"applycamo", 0}] =           "Invisibility!"
	messages.special[{"applyos"}] =                "Overshield!"
	messages.special[{"setspeed", 2}] =            "Double Speed!"
	messages.special[{"oscamo", 0}] =              "Invisibility and Overshield!"
	messages.special[{"camospeed", 0, 2}] =        "Invisibility and Double Speed!"
	messages.special[{"speedos", 2}] =             "Double Speed and Overshield!"
	messages.special[{"speedoscamo", 0, 2}] =      "Invisibility, Overshield and Double Speed!!"
	messages.special[{"damagemultiply", 2}] =      "Double Damage!"
	messages.special[{"healthmultiply", 2}] =      "Double Health and Shields!"
	
	
	-- Attribute Recurrence Multipliers --
	
	recurrence = {}                            -- Multiplier used to change a player's probability of receiving the same attribute twice.
	                                           -- For example, if the recurrence multiplier of an Assault Rifle is 0.5 and a player spawns with an Assault Rifle, they will be half as likely to spawn with one next time.
											   -- The attribute recurrence multiplier is reversed when a player does not spawn with any given attribute twice in a row.
											   -- Set to 0 if you want it to be impossible to have the same exact attribute twice in a row; set it to 1 for attribute recurrence to have no effect.
											   -- These values should probably be below 1 unless you want to make it more likely to spawn with an attribute the more you spawn with it.
	
	recurrence.primary = {}    -- Attribute Recurrence Multipliers for Primary Weapons
	
	--                                Tag:                                Multiplier:       Description:
	recurrence.primary[false] =                                             1.00            -- No Weapon
	recurrence.primary["weapons\\assault rifle\\assault rifle"] =           0.60            -- Assault Rifle
	recurrence.primary["weapons\\plasma pistol\\plasma pistol"] =           0.60            -- Plasma Pistol
	recurrence.primary["weapons\\needler\\mp_needler"] =                    0.60            -- Needler
	recurrence.primary["weapons\\plasma rifle\\plasma rifle"] =             0.65            -- Plasma Rifle
	recurrence.primary["weapons\\shotgun\\shotgun"] =                       0.65            -- Shotgun
	recurrence.primary["weapons\\pistol\\pistol"] =                         0.60            -- Pistol
	recurrence.primary["weapons\\sniper rifle\\sniper rifle"] =             0.55            -- Sniper Rifle
	recurrence.primary["weapons\\flamethrower\\flamethrower"] =             0.40            -- Flamethrower
	recurrence.primary["weapons\\rocket launcher\\rocket launcher"] =       0.30            -- Rocket Launcher
	recurrence.primary["weapons\\plasma_cannon\\plasma_cannon"] =           0.15            -- Fuel Rod
	
	recurrence.secondary = {}    -- Attribute Recurrence Multipliers for Secondary Weapons
	
		--                                Tag:                            Multiplier:       Description:
	recurrence.secondary[false] =                                           1.00            -- No Weapon
	recurrence.secondary["weapons\\assault rifle\\assault rifle"] =         0.60            -- Assault Rifle
	recurrence.secondary["weapons\\plasma pistol\\plasma pistol"] =         0.60            -- Plasma Pistol
	recurrence.secondary["weapons\\needler\\mp_needler"] =                  0.60            -- Needler
	recurrence.secondary["weapons\\plasma rifle\\plasma rifle"] =           0.65            -- Plasma Rifle
	recurrence.secondary["weapons\\shotgun\\shotgun"] =                     0.65            -- Shotgun
	recurrence.secondary["weapons\\pistol\\pistol"] =                       0.60            -- Pistol
	recurrence.secondary["weapons\\sniper rifle\\sniper rifle"] =           0.55            -- Sniper Rifle
	recurrence.secondary["weapons\\flamethrower\\flamethrower"] =           0.40            -- Flamethrower
	recurrence.secondary["weapons\\rocket launcher\\rocket launcher"] =     0.30            -- Rocket Launcher
	recurrence.secondary["weapons\\plasma_cannon\\plasma_cannon"] =         0.15            -- Fuel Rod
	
	recurrence.tertiary = {}    -- Attribute Recurrence Multipliers for Tertiary Weapons
								-- I've set this script up to not include Tertiary Weapon probabilities (other than No Weapon), therefore I have made all of these recurrences 1.0000.
								-- Use Primary and Secondary Weapon Attribute Recurrence Multipliers for reference if you wish to change these values.
	
	--                                Tag:                                Multiplier:       Description:
	recurrence.tertiary[false] =                                             1.00           -- No Weapon
	recurrence.tertiary["weapons\\assault rifle\\assault rifle"] =           1.00           -- Assault Rifle
	recurrence.tertiary["weapons\\plasma pistol\\plasma pistol"] =           1.00           -- Plasma Pistol
	recurrence.tertiary["weapons\\needler\\mp_needler"] =                    1.00           -- Needler
	recurrence.tertiary["weapons\\plasma rifle\\plasma rifle"] =             1.00           -- Plasma Rifle
	recurrence.tertiary["weapons\\shotgun\\shotgun"] =                       1.00           -- Shotgun
	recurrence.tertiary["weapons\\pistol\\pistol"] =                         1.00           -- Pistol
	recurrence.tertiary["weapons\\sniper rifle\\sniper rifle"] =             1.00           -- Sniper Rifle
	recurrence.tertiary["weapons\\flamethrower\\flamethrower"] =             1.00           -- Flamethrower
	recurrence.tertiary["weapons\\rocket launcher\\rocket launcher"] =       1.00           -- Rocket Launcher
	recurrence.tertiary["weapons\\plasma_cannon\\plasma_cannon"] =           1.00           -- Fuel Rod
	
	recurrence.quartenary = {}    -- Attribute Recurrence Multipliers for Quartenary Weapons
								  -- See Tertiary Weapon Attribute Recurrence Multipliers if you wish to change these values.
	
	--                                Tag:                                Multiplier:       Description:
	recurrence.quartenary[false] =                                           1.00           -- No Weapon
	recurrence.quartenary["weapons\\assault rifle\\assault rifle"] =         1.00           -- Assault Rifle
	recurrence.quartenary["weapons\\plasma pistol\\plasma pistol"] =         1.00           -- Plasma Pistol
	recurrence.quartenary["weapons\\needler\\mp_needler"] =                  1.00           -- Needler
	recurrence.quartenary["weapons\\plasma rifle\\plasma rifle"] =           1.00           -- Plasma Rifle
	recurrence.quartenary["weapons\\shotgun\\shotgun"] =                     1.00           -- Shotgun
	recurrence.quartenary["weapons\\pistol\\pistol"] =                       1.00           -- Pistol
	recurrence.quartenary["weapons\\sniper rifle\\sniper rifle"] =           1.00           -- Sniper Rifle
	recurrence.quartenary["weapons\\flamethrower\\flamethrower"] =           1.00           -- Flamethrower
	recurrence.quartenary["weapons\\rocket launcher\\rocket launcher"] =     1.00           -- Rocket Launcher
	recurrence.quartenary["weapons\\plasma_cannon\\plasma_cannon"] =         1.00           -- Fuel Rod
	
	recurrence.grenades = {}    -- Attribute Recurrence Multipliers for Grenades
	
	--                 Frag,Plasma:    Multiplier:        Description:
	recurrence.grenades[{0, 0}] =         1.00            -- No Grenades
	recurrence.grenades[{1, 0}] =         0.95            -- One Frag
	recurrence.grenades[{2, 0}] =         0.95            -- Two Frags
	recurrence.grenades[{0, 1}] =         0.95            -- One Plasma
	recurrence.grenades[{0, 2}] =         0.95            -- Two Plasmas
	recurrence.grenades[{2, 2}] =         0.90            -- Two of Each
	recurrence.grenades[{4, 4}] =         0.85            -- Four of Each
	
	recurrence.ammo = {}        -- Attribute Recurrence Multipliers for Ammo
	
	--    Ammo Multiplier:    Probability Multiplier:        Description:
	recurrence.ammo[1] =                 1.00                -- Normal Ammo
	recurrence.ammo[2] =                 0.90                -- Double Ammo
	recurrence.ammo[3] =                 0.90                -- Triple Ammo
	recurrence.ammo[4] =                 0.90                -- Ammotacular
	recurrence.ammo[math.inf] =          0.05                -- Infinite Ammo
	
	recurrence.special = {}        -- Attribute Recurrence Multipliers for Special Attributes
	
	--                     Function:                Multiplier:       Description:
	recurrence.special[{"setspeed", 1}] =             1.00            -- No Special
	recurrence.special[{"applycamo", 0}] =            0.25            -- Camo
	recurrence.special[{"applyos"}] =                 0.60            -- Overshield
	recurrence.special[{"setspeed", 2}] =             0.25            -- Double Speed
	recurrence.special[{"oscamo", 0}] =               0.20            -- Overshield and Camo
	recurrence.special[{"camospeed", 0, 2}] =         0.10            -- Double Speed and Camo
	recurrence.special[{"speedos", 2}] =              0.40            -- Double Speed and Overshield
	recurrence.special[{"speedoscamo", 0, 2}] =       0.05            -- Double Speed, Overshield and Camo
	recurrence.special[{"damagemultiply", 2}] =       0.10            -- Double Damage
	recurrence.special[{"healthmultiply", 2}] =       0.05            -- Double Health and Shields
	
	
	-- Ammo for Kills --
	
	ammo_for_kills =             true          -- Determines if a player receives an ammo prize for killing a player.  If this is false, all values in the bonus_ammo table are treated as 0.
	
	bonus_ammo = {}                            -- Bonus ammo for kills
											   -- Determines the amount of bonus_ammo ammo a player will receive for a kill depending on what weapon they are carrying.
	
	--       Tag:                                              Bonus Ammo:
	bonus_ammo["weapons\\assault rifle\\assault rifle"] =          45
	bonus_ammo["weapons\\needler\\mp_needler"] =                   15
	bonus_ammo["weapons\\shotgun\\shotgun"] =                      8
	bonus_ammo["weapons\\pistol\\pistol"] =                        8
	bonus_ammo["weapons\\sniper rifle\\sniper rifle"] =            4
	bonus_ammo["weapons\\flamethrower\\flamethrower"] =            25
	bonus_ammo["weapons\\rocket launcher\\rocket launcher"] =      1
	
	-- Grenade Pickup Booleans --
	
	grenade_pickup =             false         -- Determines if players are able to pick up grenades found around the map.  If this is false, grenade_spawnmax is also treated as false.
	grenade_spawnmax =           false         -- If true, players may only pick up grenades up to the amount they spawned with.  If false, players are not restricted to how many grenades they may pick up.
	
	
	-- Jackpot Percentage --
	
	jackpot_percentage =         0.01          -- If the percentage probability of this attribute is less than or equal to the value specified, the word "Jackpot" will be printed before the default message (use 0 to disable).
	
	
	-- Vehicle Weapon Operable Boolean --
	
	vehicle_weapon_operabale =   false         -- Determines if vehicle weapons are able to be used.  Return true if they should be, return false if they shouldn't be.
	
	
	-- Vehicle Entry Booleans --
	
	enter_vehicle =              true         -- Determines if players should be able to enter vehicles.  If this is false, all other vehicle booleans are treated as false.
	enter_vehicle_driver =       true         -- Determines if players should be able to enter vehicle driver's seats.
	enter_vehicle_passenger =    true         -- Determines if players should be able to enter vehicle passenger's seats.
	enter_vehicle_gunner =       true         -- Determines if players should be able to enter vehicle gunner's seats.
	
	
	-- Object Spawn Booleans --
	
	objects = {}                               -- Determines if the specified tag will be spawned in the map.  Use true if you want the object to spawn normally, false if you don't want it to appear.
	                                           -- Note that these values are always treated as true when using createobject.
	
	-- Equipment --
	
	objects.eqip = {}
	
	--         Tag:                                              Boolean:         Description:
	objects.eqip["powerups\\active camouflage"] =                true             -- Active Camouflage
	objects.eqip["powerups\\over shield"] =                      true             -- Overshield
	objects.eqip["powerups\\health pack"] =                      true             -- Health Pack
	objects.eqip["weapons\\frag grenade\\frag grenade"] =        false            -- Frag Grenade
	objects.eqip["weapons\\plasma grenade\\plasma grenade"] =    false            -- Plasma Grenade
	
	-- Projectiles --
	
	objects.proj = {}
	
	--         Tag:                                              Boolean:         Description:
	objects.proj["weapons\\frag grenade\\frag grenade"] =        true             -- Frag Grenade
	objects.proj["weapons\\plasma grenade\\plasma grenade"] =    true             -- Plasma Grenade
	objects.proj["vehicles\\banshee\\banshee bolt"] =            true             -- Banshee Bolt
	objects.proj["vehicles\\banshee\\mp_banshee fuel rod"] =     true             -- Banshee Fuel Rod
	objects.proj["vehicles\\c gun turret\\mp gun turret"] =      true             -- Covenant Turret Bolt
	objects.proj["vehicles\\ghost\\ghost bolt"] =                true             -- Ghost Bolt
	objects.proj["vehicles\\scorpion\\bullet"] =                 true             -- Scorpion Bullet
	objects.proj["vehicles\\scorpion\\tank shell"] =             true             -- Scorpion Shell
	objects.proj["vehicles\\warthog\\bullet"] =                  true             -- Warthog Bullet
	objects.proj["weapons\\assault rifle\\bullet"] =             true             -- Assault Rifle Bullet
	objects.proj["weapons\\flamethrower\\flame"] =               true             -- Flamethrower Flame
	objects.proj["weapons\\needler\\mp_needle"] =                true             -- Needler Needle
	objects.proj["weapons\\pistol\\bullet"] =                    true             -- Pistol Bullet
	objects.proj["weapons\\plasma pistol\\bolt"] =               true             -- Plasma Pistol Bolt
	objects.proj["weapons\\plasma rifle\\bolt"] =                true             -- Plasma Rifle Bolt
	objects.proj["weapons\\plasma rifle\\charged bolt"] =        true             -- Plasma Pistol Charged Bolt
	objects.proj["weapons\\plasma_cannon\\plasma_cannon"] =      true             -- Fuel Rod Projectile
	objects.proj["weapons\\rocket launcher\\rocket"] =           true             -- Rocket Launcher Rocket
	objects.proj["weapons\\shotgun\\pellet"] =                   true             -- Shotgun Pellet
	objects.proj["weapons\\sniper rifle\\sniper bullet"] =       true             -- Sniper Rifle Bullet
	
	-- Weapons --
	
	objects.weap = {}
	
	--         Tag:                                              Boolean:         Description:
	objects.weap["vehicles\\banshee\\mp_banshee gun"] =          true             -- Banshee Gun
	objects.weap["vehicles\\c gun turret\\mp gun turret gun"] =  true             -- Covenant Turret Gun
	objects.weap["vehicles\\ghost\\mp_ghost gun"] =              true             -- Ghost Gun
	objects.weap["vehicles\\rwarthog\\rwarthog_gun"] =           true             -- Rocket Warthog Gun
	objects.weap["vehicles\\scorpion\\scorpion cannon"] =        true             -- Scorpion Cannon
	objects.weap["vehicles\\warthog\\warthog gun"] =             true             -- Warthog Gun
	objects.weap["weapons\\assault rifle\\assault rifle"] =      true             -- Assault Rifle
	objects.weap["weapons\\ball\\ball"] =                        true             -- Oddball
	objects.weap["weapons\\flag\\flag"] =                        true             -- Flag
	objects.weap["weapons\\flamethrower\\flamethrower"] =        true             -- Flamethrower
	objects.weap["weapons\\gravity rifle\\gravity rifle"] =      true             -- Gravity Rifle
	objects.weap["weapons\\needler\\mp_needler"] =               true             -- Needler
	objects.weap["weapons\\needler\\needler"] =                  true             -- Campaign Needler
	objects.weap["weapons\\pistol\\pistol"] =                    true             -- Pistol
	objects.weap["weapons\\plasma pistol\\plasma pistol"] =      true             -- Plasma Pistol
	objects.weap["weapons\\plasma rifle\\plasma rifle"] =        true             -- Plasma Rifle
	objects.weap["weapons\\plasma_cannon\\plasma_cannon"] =      true             -- Fuel Rod
	objects.weap["weapons\\rocket launcher\\rocket launcher"] =  true             -- Rocket Launcher
	objects.weap["weapons\\shotgun\\shotgun"] =                  true             -- Shotgun
	objects.weap["weapons\\sniper rifle\\sniper rifle"] =        true             -- Sniper Rifle
	
	-- Vehicles by Map --
	
	vehicles = {}          -- Specifies if any vehicles spawn on the map.
                           -- If this is false, all values in the objects.vehi table are ignored.
	
	--       Map:                  Boolean:      Description:
	vehicles.beavercreek =          false        -- Battle Creek
	vehicles.bloodgulch =           false        -- Bloodgulch
	vehicles.boardingaction =       false        -- Boarding Action
	vehicles.carousel =             false        -- Derelict
	vehicles.chillout =             false        -- Chillout
	vehicles.damnation =            false        -- Damnation
	vehicles.dangercanyon =         true         -- Danger Canyon
	vehicles.deathisland =          true         -- Death Island
	vehicles.gephyrophobia =        true         -- Gephyrophobia
	vehicles.hangemhigh =           false        -- Hang 'em High
	vehicles.icefields =            true         -- Ice Fields
	vehicles.infinity =             true         -- Infinity
	vehicles.longest =              false        -- Longest
	vehicles.prisoner =             false        -- Prisoner
	vehicles.putput =               false        -- Chiron TL34
	vehicles.ratrace =              false        -- Rat Race
	vehicles.sidewinder =           true         -- Sidewinder
	vehicles.timberland =           true         -- Timberland
	vehicles.wizard =               false        -- Wizard
	
	-- Vehicles --
	
	objects.vehi = {}
	
	--         Tag:                                              Boolean:         Description:
	objects.vehi["vehicles\\banshee\\banshee_mp"] =              true             -- Banshee
	objects.vehi["vehicles\\c gun turret\\c gun turret_mp"] =    true             -- Covenant Turret
	objects.vehi["vehicles\\ghost\\ghost_mp"] =                  true             -- Ghost
	objects.vehi["vehicles\\rwarthog\\rwarthog"] =               true             -- Rocket Warthog
	objects.vehi["vehicles\\scorpion\\scorpion_mp"] =            true             -- Scorpion
	objects.vehi["vehicles\\warthog\\mp_warthog"] =              true             -- Warthog
	
	
-- **Don't mess with anything below this line unless you know what you're doing** --

	Game = game
	
	-- Individual Probabilities --
	
	players = {}
	attributes = {}
	
	-- Gametype Information --
	
	gametypeinfo()
end

function OnNewGame(map)

	this_map = map
end

function OnPlayerJoin(player)

	local hash = gethash(player)
	newplayer(hash)
	generate(player)
end

function OnPlayerLeave(player)

	local hash = gethash(player)
	playerleave(hash)
end

function OnPlayerKill(killer, victim, mode)

	setspeed(victim, 1)
	damagemultiply(victim, 1)
	healthmultiply(victim, 1)
	generate(victim)
	
	if killer then
		if ammo_for_kills then
			local hash = gethash(killer)
			for type,key in pairs(attributes[hash]) do
				if bonus_ammo[key] then
					if type == "primary" or type == "secondary" or type == "tertiary" or type == "quartenary" then
						local slot = 0x2F8
						if type == "secondary" then
							slot = 0x2F8 + 4
						elseif type == "tertiary" then
							slot = 0x2F8 + 8
						elseif type == "quartenary" then
							slot = 0x2F8 + 12
						end
						local m_player = getplayer(killer)
						if m_player then
							local objId = readdword(m_player, 0x34)
							local m_object = getobject(objId)
							if m_object then
								local weapId = readdword(m_object, slot)
								local m_weapon = getobject(weapId)
								if m_weapon then
									local cur_ammo = readword(m_weapon, 0x2B6)
									writeword(m_weapon, 0x2B6, cur_ammo + bonus_ammo[key])
									updateammo(weapId)
								end
							end
						end
					end
				end
			end
		end
	end
end

function OnPlayerSpawn(player)
	
	local hash = gethash(player)
	
	local frags = attributes[hash].grenades[1]
	local plasmas = attributes[hash].grenades[2]
	
	local m_player = getplayer(player)
	local objId = readdword(m_player, 0x34)
	local m_object = getobject(objId)
	
	writebyte(m_object, 0x31E, frags)
	writebyte(m_object, 0x31F, plasmas)
end

function OnPlayerSpawnEnd(player)

	local hash = gethash(player)
	
	-- Additional Weapon Assignments --
	
	if attributes[hash].tertiary and attributes[hash].quartenary then
		local weapId1 = createobject(gettagid("weap", attributes[hash].quartenary), 0, 0, false, 0, 0, -100)
		local m_weapon1 = getobject(weapId1)
		if m_weapon1 then
			assignweapon(player, weapId1)
		end
		local weapId2 = createobject(gettagid("weap", attributes[hash].primary), 0, 0, false, 0, 0, -100)
		local m_weapon2 = getobject(weapId2)
		if m_weapon2 then
			assignweapon(player, weapId2)
		end
	elseif attributes[hash].tertiary then
		local weapId = createobject(gettagid("weap", attributes[hash].primary), 0, 0, false, 0, 0, -100)
		local m_weapon = getobject(weapId)
		if m_weapon then
			assignweapon(player, weapId)
		end
	end
	
	attributeprint(player, "primary", attributes[hash].primary)
	
	if attributes[hash].primary ~= attributes[hash].secondary then
		attributeprint(player, "secondary", attributes[hash].secondary)
	end
	
	if attributes[hash].primary ~= attributes[hash].tertiary and attributes[hash].secondary ~= attributes[hash].tertiary then
		attributeprint(player, "tertiary", attributes[hash].tertiary)
	end
	
	if attributes[hash].primary ~= attributes[hash].quartenary and attributes[hash].secondary ~= attributes[hash].quartenary and attributes[hash].tertiary ~= attributes[hash].quartenary then
		attributeprint(player, "quartenary", attributes[hash].quartenary)
	end
	
	-- Ammo Assignments --
	
	local m_player = getplayer(player)
	local objId = readdword(m_player, 0x34)
	local m_object = getobject(objId)
	
	-- Plasma weapon check
	
	local plasma = false
	
	for i = 0,3 do
		local weapId = readdword(m_object, 0x2F8 + (i * 4))
		local m_weapon = getobject(weapId)
		if m_weapon then
			local mapId = readdword(m_weapon)
			local tagname = gettaginfo(mapId)
			if string.find(tagname, "plasma") then
				plasma = true
				break
			end
		end
	end
	
	for i = 0,3 do
		local weapId = readdword(m_object, 0x2F8 + (i * 4))
		local m_weapon = getobject(weapId)
		if m_weapon then
			if attributes[hash].ammo == 0 then
				writefloat(m_weapon, 0x240, 1)
				writeword(m_weapon, 0x2B6, 0)
				writeword(m_weapon, 0x2B8, 0)
			end
			
			if not plasma then
				if attributes[hash].ammo == math.inf then
					writeword(m_weapon, 0x2B6, 9999)
					writeword(m_weapon, 0x2B8, 9999)
					infiniteammo(player)
				else
					local ammo = readword(m_weapon, 0x2B6)
					writeword(m_weapon, 0x2B6, ammo * attributes[hash].ammo)
				end
			end
			
			updateammo(weapId)
		end
	end
	
	if not plasma or attributes[hash].ammo == 0 then
		attributeprint(player, "ammo", attributes[hash].ammo)
	end
	
	-- Grenade Message --
	
	attributeprint(player, "grenades", attributes[hash].grenades)
	
	-- Special Assignments --
	
	local foo = _G[attributes[hash].special[1]]
	local executed = foo(player, table.unpack(attributes[hash].special, 2, #attributes[hash].special))
	
	if executed then
		attributeprint(player, "special", attributes[hash].special)
	end
end

function OnWeaponAssignment(player, objId, slot, weapId)
	
	if player then
		local hash = gethash(player)
		
		if slot == 0 then
			if attributes[hash].tertiary then
				return gettagid("weap", attributes[hash].secondary)
			else
				return gettagid("weap", attributes[hash].primary)
			end
		elseif slot == 1 then
			if attributes[hash].tertiary then
				return gettagid("weap", attributes[hash].tertiary)
			else
				if attributes[hash].secondary then
					return gettagid("weap", attributes[hash].secondary)
				end
			end
		end
		
		return -1
	else
		if not vehicle_weapon_operable then
			return -1
		end
	end
end

function OnObjectCreationAttempt(mapId, parentId, player)
	
	local tagname, tagtype = gettaginfo(mapId)
	if tagtype == "vehi" then
		return vehicles[this_map]
	end
	
	if objects[tagtype] then
		return objects[tagtype][tagname]
	end
end

function OnObjectInteraction(player, objId, mapId)


	local hash = gethash(player)
	
	local tagname, tagtype = gettaginfo(mapId)
	if tagtype == "weap" then
		if tagname == attributes[hash].primary or tagname == attributes[hash].secondary or tagname == attributes[hash].tertiary or tagname == attributes[hash].quartenary or tagname == "weapons\\flag\\flag" or tagname == "weapons\\ball\\ball" then
			return true
		else
			return false
		end
	elseif tagtype == "eqip" then
		if string.find(tagname, "grenade") then
			if grenade_pickup then
				if grenade_spawnmax then
					local max_frags = attributes[hash].grenades[1]
					local max_plasmas = attributes[hash].grenades[2]
					local m_player = getplayer(player)
					if m_player then
						local objId = readdword(m_player, 0x34)
						local m_object = getobject(objId)
						if m_object then
							local frags = readbyte(m_object, 0x31E)
							local plasmas = readbyte(m_object, 0x31F)
							if tagname == "weapons\\frag grenade\\frag grenade" then
								if frags < max_frags then
									return true
								else
									return false
								end
							elseif tagname == "weapons\\plasma grenade\\plasma grenade" then
								if plasmas < max_plasmas then
									return true
								else
									return false
								end
							end
						end
					end
					
					return true
				end
				
				return true
			else
				return false
			end
		end
	end
end

damage_multiplier = {}
health_multiplier = {}

function OnDamageLookup(receiver, causer, mapId)
	
	if causer then
		local c_player = objectidtoplayer(causer)
		if c_player then
			local m_player = getplayer(c_player)
			if m_player then
				local hash = gethash(c_player)
				if hash then
					for k,v in pairs(damage_multiplier) do
						if k == hash then
							odl_multiplier(2)
							return true
						end
					end
				end
			end
		end
	end
	
	if receiver then
		local r_player = objectidtoplayer(receiver)
		if r_player then
			local m_player = getplayer(r_player)
			if m_player then
				local hash = gethash(r_player)
				if hash then
					for k,v in pairs(health_multiplier) do
						if k == hash then
							odl_multiplier(0.5)
							return true
						end
					end
				end
			end
		end
	end
end

function OnVehicleEntry(player, vehiId, seat, mapId, voluntary)
	
	if enter_vehicle then
		if seat == 0 then
			return enter_vehicle_driver
		elseif seat == 2 then
			local tagname = gettaginfo(mapId)
			if tagname == "vehicles\\warthog\\mp_warthog" or tagname == "vehicles\\rwarthog\\rwarthog" then
				return enter_vehicle_gunner
			else
				return enter_vehicle_passenger
			end
		else
			return enter_vehicle_passenger
		end
	else
		return false
	end
end

-- Global Variables --

cur_players = 0
math.inf = 1 / 0
math.randomseed(os.time())

function gametypeinfo()

	local gametype_base
	if Game == "PC" then
		gametype_base = 0x671340
	else
		gametype_base = 0x5F5498
	end
	
	local gametype_game = readbyte(gametype_base, 0x30)
	local gametype_parameters = readbyte(gametype_base, 0x38)
	local binary = convertbase(gametype_parameters, 2)
	gametype_shields = false
	gametype_speed = false
	gametype_phantom = false

	if string.sub(binary, -4, -4) == "0" then
		gametype_shields = true
	end
	
	if string.sub(binary, -5, -5) == "1" then
		gametype_phantom = true
	end
	
	if gametype_game == 1 or gametype_game == 2 or gametype_game == 4 then
		gametype_speed = true
	end
end

-- General Functions --

phasor_createobject = createobject

function createobject(mapId, parentId, respawn_time, respawn_bool, x, y, z)

	local tagname, tagtype = gettaginfo(mapId)
	if tagname then
		local orig = objects[tagtype][tagname]
		objects[tagtype][tagname] = true
		local objId = phasor_createobject(mapId, parentId, respawn_time, respawn_bool, x, y, z)
		objects[tagtype][tagname] = orig
		return objId
	end
end

function newplayer(hash)

	players[hash] = {}
	players[hash].probability = probability
	players[hash].messages = messages
	players[hash].multiplier = multiplier
	players[hash].recurrence = recurrence
	
	for type,_ in pairs(players[hash].probability) do
		for key,v in pairs(players[hash].probability[type]) do
			local mult = getinfo(nil, "multiplier", type, key)
			local prob = getinfo(hash, "probability", type, key)
			setinfo(hash, "probability", type, key, prob * (mult ^ cur_players))
		end
	end
	
	cur_players = cur_players + 1
	
	for i = 0,15 do
		if getplayer(i) then
			local hash = gethash(i)
			for type,_ in pairs(players[hash].probability) do
				for key,v in pairs(players[hash].probability[type]) do
					local mult = getinfo(nil, "multiplier", type, key)
					local prob = getinfo(hash, "probability", type, key)
					setinfo(hash, "probability", type, key, prob * mult)
				end
			end
		end
	end
end

function playerleave(hash)

	for i = 0,15 do
		if getplayer(i) then
			local hash = gethash(i)
			for type,_ in pairs(players[hash].probability) do
				for key,v in pairs(players[hash].probability[type]) do
					local mult = getinfo(nil, "multiplier", type, key)
					local prob = getinfo(hash, "probability", type, key)
					setinfo(hash, "probability", type, key, prob / mult)
				end
			end
		end
	end
	
	players[hash] = nil
	cur_players = cur_players - 1
end

function getinfo(hash, table, type, key)

	if hash then
		if players[hash] then
			if players[hash][table] then
				if players[hash][table][type] then
					for k,v in pairs(players[hash][table][type]) do
						if equals(k, key) then
							return players[hash][table][type][k]
						end
					end
				end
			end
		end
	else
		for k,v in pairs(_G[table][type]) do
			if equals(k, key) then
				return _G[table][type][k]
			end
		end
	end
end

function setinfo(hash, table, type, key, val)

	if hash then
		if players[hash] then
			if players[hash][table] then
				if players[hash][table][type] then
					for k,v in pairs(players[hash][table][type]) do
						if equals(k, key) then
							players[hash][table][type][k] = val
						end
					end
				end
			end
		end
	else
		for k,v in pairs(_G[table][type]) do
			if equals(k, key) then
				_G[table][type][k] = val
			end
		end
	end
end

function equals(val1, val2)

	if type(val1) == type(val2) then
		if type(val1) == "number" or type(val1) == "string" or type(val1) == "boolean" then
			return val1 == val2
		elseif type(val1) == "table" then
			for k,v in pairs(val1) do
				local found = false
				for k2,v2 in pairs(val2) do
					if equals(k, k2) then
						found = true
						if not equals(v, v2) then
							return false
						end
						break
					end
				end

				if not found then
					return false
				end
			end

			return true
		end
	end
end

function generate(player)

	local hash = gethash(player)
	
	attributes[hash] = attributes[hash] or {}
	
	local temp = {}
	local override = {}
	
	temp.primary = {}
	temp.secondary = {}
	temp.tertiary = {}
	temp.quartenary = {}
	temp.grenades = {}
	temp.ammo = {}
	temp.special = {}
	
	for type,_ in pairs(players[hash].probability) do
		
		if attributes[hash][type] then
			-- Attribute Recurrence Multiplier
			local prob = getinfo(hash, "probability", type, attributes[hash][type])
			local attribute_recurrence = getinfo(hash, "recurrence", type, attributes[hash][type])
			if attribute_recurrence == 0 then
				temp[type][attributes[hash][type]] = getinfo(hash, "probability", type, attributes[hash][type])
			end
			setinfo(hash, "probability", type, attributes[hash][type], prob * attribute_recurrence)
		end
		
		local sum = table.sum(players[hash].probability[type])
		local rand = randomnumber(0, sum)		
		local max = 0
		local found = false
		
		for key,v in pairs(players[hash].probability[type]) do
			if v ~= 0 then
				max = max + v
				if rand < max then
					if not found then
						attributes[hash][type] = key
						found = true
					end
				else
					-- Attribute Recurrence Cooldown
					local attribute_recurrence = getinfo(hash, "recurrence", type, key)
					if attribute_recurrence < 1 then
						setinfo(hash, "probability", type, key, math.min(getinfo(hash, "probability", type, key) / attribute_recurrence, getinfo(nil, "probability", type, key)))
					elseif attribute_recurrence > 1 then
						setinfo(hash, "probability", type, key, math.max(getinfo(hash, "probability", type, key) / attribute_recurrence, getinfo(nil, "probability", type, key)))
					end
				end
			end
		end
		
		if type == "primary" then
			if attributes[hash][type] == false then
				override.secondary = false
				override.tertiary = false
				override.quartenary = false
			else
				temp.secondary[attributes[hash][type]] = getinfo(hash, "probability", "secondary", attributes[hash][type])
				temp.tertiary[attributes[hash][type]] = getinfo(hash, "probability", "tertiary", attributes[hash][type])
				temp.quartenary[attributes[hash][type]] = getinfo(hash, "probability", "quartenary", attributes[hash][type])
				setinfo(hash, "probability", "secondary", attributes[hash][type], 0)
				setinfo(hash, "probability", "tertiary", attributes[hash][type], 0)
				setinfo(hash, "probability", "quartenary", attributes[hash][type], 0)
			end
		elseif type == "secondary" then
			if attributes[hash][type] == false then
				override.tertiary = false
				override.quartenary = false
			else
				temp.tertiary[attributes[hash][type]] = getinfo(hash, "probability", "tertiary", attributes[hash][type])
				temp.quartenary[attributes[hash][type]] = getinfo(hash, "probability", "quartenary", attributes[hash][type])
				setinfo(hash, "probability", "tertiary", attributes[hash][type], 0)
				setinfo(hash, "probability", "quartenary", attributes[hash][type], 0)
			end
		elseif type == "tertiary" then
			if attributes[hash][type] == false then
				override.quartenary = false
			else
				temp.quartenary[attributes[hash][type]] = getinfo(hash, "probability", "quartenary", attributes[hash][type])
				setinfo(hash, "probability", "quartenary", attributes[hash][type], 0)
			end
		end
	end
	
	for type,_ in pairs(temp) do
		for key,v in pairs(temp) do
			setinfo(hash, "probability", type, key, v)
		end
	end
	
	for type,v in pairs(override) do
		attributes[hash][type] = v
	end
end

function attributeprint(player, type, key)

	local hash = gethash(player)
	
	local message = getinfo(hash, "messages", type, key)
	if message then
		local percent = getinfo(hash, "probability", type, key) / table.sum(players[hash].probability[type])
		if percent < jackpot_percentage and percent > 0 then
			message = "JACKPOT: " .. message .. " [" .. math.round(percent * 100, 2) .. "%]"
		end
		
		sendconsoletext(player, message, 10, order[type], "center", isalive)
	end
end

order = {}
order.primary = 1
order.secondary = 2
order.tertiary = 3
order.quartenary = 4
order.grenades = 5
order.ammo = 6
order.special = 7

console = {}
console.__index = console
registertimer(100, "ConsoleTimer")
phasor_sendconsoletext = sendconsoletext
math.inf = 1 / 0

function sendconsoletext(player, message, time, order, align, func)

	console[player] = console[player] or {}
	
	local temp = {}
	temp.player = player
	temp.id = nextid(player, order)
	temp.message = message or ""
	temp.time = time or 5
	temp.remain = temp.time
	temp.align = align or "left"
	
	if type(func) == "function" then
		temp.func = func
	elseif type(func) == "string" then
		temp.func = _G[func]
	end
	
	console[player][temp.id] = temp
	setmetatable(console[player][temp.id], console)
	return console[player][temp.id]
end

function nextid(player, order)

	if not order then
		local x = 0
		for k,v in pairs(console[player]) do
			if k > x + 1 then
				return x + 1
			end
			
			x = x + 1
		end
		
		return x + 1
	else
		local original = order
		while console[player][order] do
			order = order + 0.001
			if order == original + 0.999 then break end
		end
		
		return order
	end
end

function getmessage(player, order)

	if console[player] then
		if order then
			return console[player][order]
		end
	end
end

function getmessages(player)

	return console[player]
end

function getmessageblock(player, order)

	local temp = {}
	
	for k,v in pairs(console[player]) do
		if k >= order and k < order + 1 then
			table.insert(temp, console[player][k])
		end
	end
	
	return temp
end

function console:getmessage()

	return self.message
end

function console:append(message, reset)

	if console[self.player] then
		if console[self.player][self.id] then
			if getplayer(self.player) then
				if reset then
					if reset == true then
						console[self.player][self.id].remain = console[self.player][self.id].time
					elseif tonumber(reset) then
						console[self.player][self.id].time = tonumber(reset)
						console[self.player][self.id].remain = tonumber(reset)
					end
				end
				
				console[self.player][self.id].message = message or ""
				return true
			end
		end
	end
end

function console:shift(order)

	local temp = console[self.player][self.id]
	console[self.player][self.id] = console[self.player][order]
	console[self.player][order] = temp
end

function console:pause(time)

	console[self.player][self.id].pausetime = time or 5
end

function console:delete()

	console[self.player][self.id] = nil
end

function ConsoleTimer(id, count)

	for i,_ in opairs(console) do
		if tonumber(i) then
			if getplayer(i) then
				for k,v in opairs(console[i]) do
					if console[i][k].pausetime then
						console[i][k].pausetime = console[i][k].pausetime - 0.1
						if console[i][k].pausetime <= 0 then
							console[i][k].pausetime = nil
						end
					else
						if console[i][k].func then
							if not console[i][k].func(i) then
								console[i][k] = nil
							end
						end
						
						console[i][k].remain = console[i][k].remain - 0.1
						if console[i][k].remain <= 0 then
							console[i][k] = nil
						end
					end
				end
				
				if table.len(console[i]) > 0 then
					
					local paused = 0
					for k,v in pairs(console[i]) do
						if console[i][k].pausetime then
							paused = paused + 1
						end
					end
					
					if paused < table.len(console[i]) then
						local str = ""
						for i = 0,30 do
							str = str .. " \n"
						end
						
						phasor_sendconsoletext(i, str)
						
						for k,v in opairs(console[i]) do
							if not console[i][k].pausetime then
								if console[i][k].align == "right" or console[i][k].align == "center" then
									phasor_sendconsoletext(i, consolecenter(console[i][k].message))
								else
									phasor_sendconsoletext(i, console[i][k].message)
								end
							end
						end
					end
				end
			else
				console[i] = nil
			end
		end
	end
	
	return true
end

function consolecenter(text)

	if text then
		local len = string.len(text)
		for i = len + 1, 78 do
			text = " " .. text
		end
		
		return text
	end
end

function isalive(player)

	local m_player = getplayer(player)
	if m_player then
		local objId = readdword(m_player, 0x34)
		local m_object = getobject(objId)
		if m_object then
			return true
		end
	end
end

function infiniteammo(player)

	registertimer(1000, "InfiniteAmmo", player)
end

function InfiniteAmmo(id, count, player)

	local m_player = getplayer(player)
	if m_player then
		local objId = readdword(m_player, 0x34)
		local m_object = getobject(objId)
		if m_object then
			for i = 0,3 do
				local weapId = readdword(m_object, 0x2F8 + (i * 4))
				local m_weapon = getobject(weapId)
				if m_weapon then
					writeword(m_weapon, 0x2B6, 9999)
					writeword(m_weapon, 0x2B8, 9999)
					updateammo(weapId)
				end
			end
			
			return true
		end
	end
	
	return false
end

function convertbase(input, base)

	if not base or base == 10 then return tostring(input) end

	local digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local answer = {}

	repeat
		local digit = (input % base) + 1
		input = math.floor(input / base)
		table.insert(answer, 1, string.sub(digits, digit, digit))
	until input == 0

	return table.concat(answer, "")
end

function math.round(input, precision)

	return math.floor(input * (10 ^ precision) + 0.5) / (10 ^ precision)
end

function table.len(t)

	local count = 0
	
	for k,v in pairs(t) do
		count = count + 1
	end
	
	return count
end

function table.sum(t)

	local sum = 0
	for k,v in pairs(t) do
		if type(v) == "number" then
			sum = sum + v
		end
	end
	
	return sum
end

function randomnumber(min, max)

	local diff = max - min
	local rand = math.random()
	local weighted = rand * diff
	return weighted + min
end

function opairs(t)
	
	local keys = {}
	for k,v in pairs(t) do
		table.insert(keys, k)
	end    
	table.sort(keys, 
	function(a,b)
		if type(a) == "number" and type(b) == "number" then
			return a < b
		end
		an = string.lower(tostring(a))
		bn = string.lower(tostring(b))
		if an ~= bn then
			return an < bn
		else
			return tostring(a) < tostring(b)
		end
	end)
	local count = 1
	return function()
		if table.unpack(keys) then
			local key = keys[count]
			local value = t[key]
			count = count + 1
			return key,value
		end
	end
end

function attpairs(t)

	local count = 0
	local temp = {"primary", "secondary", "tertiary", "quartenary", "ammo", "grenades", "special"}
	return function()
		count = count + 1
		return temp[count]
	end
end

-- Special Attributes Functions --

phasor_setspeed = setspeed
phasor_applycamo = applycamo

function applycamo(player, duration)

	duration = tonumber(duration or 0) or 0
	
	if not gametype_phantom then
		local m_player = getplayer(player)
		if m_player then
			local objId = readdword(m_player, 0x34)
			local m_object = getobject(objId)
			if m_object then
				phasor_applycamo(player, duration)
				return true
			end
		end
	end
	
	return false
end

function setspeed(player, speed)

	speed = tonumber(speed or 1) or 1
	
	if gametype_speed then
		local m_player = getplayer(player)
		if m_player then
			local objId = readdword(m_player, 0x34)
			local m_object = getobject(objId)
			if m_object then
				phasor_setspeed(player, speed)
				return true
			end
		end
	end
	
	return false
end

function applyos(player)

	if gametype_shields then
		local m_player = getplayer(player)
		if m_player then
			local objId = readdword(m_player, 0x34)
			local m_object = getobject(objId)
			if m_object then
				local x, y, z = getobjectcoords(objId)
				local mapId = gettagid("eqip", "powerups\\over shield")
				local eqipId = createobject(mapId, 0, 0, false, x, y, z)
				if eqipId then
					return true
				end
			end
		end
	end
	
	return false
end

function oscamo(player, duration)
	
	if gametype_shields and not gametype_phantom then
		local bool = applyos(player)
		if bool then
			applycamo(player, duration)
			return true
		end
	end
	
	return false
end

function camospeed(player, duration, speed)

	if not gametype_phantom then
		local bool = setspeed(player, speed)
		if bool then
			applycamo(player, duration)
			return true
		end
	end
	
	return false
end

function speedos(player, speed)

	if gametype_speed and gametype_shields then
		local bool = setspeed(player, speed)
		if bool then
			applyos(player)
			return true
		end
	end
	
	return false
end

function speedoscamo(player, duration, speed)

	if gametype_speed and gametype_shields and not gametype_phantom then
		local bool = setspeed(player, speed)
		if bool then
			local bool2 = oscamo(player, duration)
			if bool2 then
				return true
			end
		end
	end
	
	return false
end

function damagemultiply(player, multiplier)

	if getplayer(player) then
		local hash = gethash(player)
		if hash then
			damage_multiplier[hash] = tonumber(multiplier)
			return true
		end
	end
	
	return false
end

function healthmultiply(player, multiplier)

	if getplayer(player) then
		local hash = gethash(player)
		if hash then
			health_multiplier[hash] = tonumber(multiplier)
			return true
		end
	end
	
	return false
end