-- Conquest 2.0

-- This script requires that you run a CTF gametype.
-- You should probably create a custom gametype which doesn't have Nav points; they are confusing and misleading for this gametype when the Ball of Faith and Staff of Influence are in play.

-- The object of the game is to take control of the opponent's base before they take control of yours.
-- You regain control of your own base by standing in it unopposed and take control from the opposing base by standing in it unopposed.
-- If at any point one team's control percentage is 0 percent, the other team wins.
-- If there is a + next to a base's percentage, it is increasing.  If there is a - next to a base's percentage, it is decreasing.
-- A base is contested if players from opposing teams occupy the same control sphere.  This is denoted by a * next to a base's percentage.
-- There are also optional special items around the map: an oddball and a flagpole. The oddball is called the Ball of Faith; the flagpole is called the Staff of Influence.
-- One who holds the Ball of Faith gives extra regeneration to their own base and increases the maximum control percentage of their base while the holder stands in their own control sphere.
-- One who holds the Staff of Influence takes extra control from the opponent's base while standing in it.
-- I've written this script intentionally to make it easy for inexperienced scripters to edit and flexible for more experienced scripters to customize.
-- If any of my comments are confusing, or you have any questions about how the script works, you can PM me (Nuggets) at phasor.proboards.com


function GetRequiredVersion()

	return 200
end

function OnScriptLoad(processId, game, persistent)

	-- Respawn Time
	respawn_time = 7  -- Player respawn time in seconds.
	
	-- Help Command
	help_command = "#help"  -- Chat command a player should use if they need help on how to play the gametype.
	
	-- Teams Table --
	teams = {}     -- Stores attributes about each team's base
	
	teams[0] = {}  -- Team 0 (Red)
	teams[1] = {}  -- Team 1 (Blue)
	
	-- Starting Percentages of Control --
	
	--  Team:            Percent:      Description:
	teams[0].start =       100         -- Amount of control the Red Team has over their own base at the beginning of the game.
	teams[1].start =       100          -- Amount of control the Blue Team has over their own base at the beginning of the game.
	
	-- Maximum Percentages of Control --
	
	--  Team:            Percent:      Description:
	teams[0].max =         100         -- Maximum control the Red Team can have over their own base.
	teams[1].max =         100         -- Maximum control the Blue Team can have over their own base.
	
	-- Sphere of Control Coordinates --
	
	--  Team:          Coordinates:    Description:
	teams[0].center =      nil         -- Centered coordinates of Red Team's control sphere {x, y, z} (use nil to default to centering around the CTF flag spawn).
	teams[1].center =      nil         -- Centered coordinates of Blue Team's control sphere {x, y, z} (use nil to default to centering around the CTF flag spawn).
	
	-- Control Sphere Radius --
	
	--  Team:             Radius:      Description:
	teams[0].radius =      nil         -- Radius of control sphere centered at Red Base CTF flag spawn (use nil to default to value of current map as defined below in Control Sphere Radius by Map).
	teams[1].radius =      nil         -- Radius of control sphere centered at Blue Base CTF flag spawn (use nil to default to value of current map as defined below in Control Sphere Radius by Map).
	
	-- Team Influence and Faith --
	
	-- Influence and Faith are values which define how much a team can change a control sphere's percentage by standing inside of it.
	-- Note that by default, these values are not dependent on the amount of players within a control sphere.
	-- If you want additional players to increase (or decrease) influence and faith, see "Presence".
	
	--  Team:         Percent/Second:  Description:
	teams[0].influence =   1.50        -- Percent of control per second a Red Team player will take from Blue Base.
	teams[1].influence =   1.50        -- Percent of control per second a Blue Team player will take from Red Base.
	
	teams[0].faith =       0.75        -- Percent of control per second a Red Team player will add to their own base.
	teams[1].faith =       0.75        -- Percent of control per second a Blue Team player will add to their own base.
	
	-- Presence --
	
	--  Team:             Bonus:       Description:
	teams[0].presence =    0.50        -- Bonus influence or faith applied per additional player of the Red Team within a control sphere (set to 0 if influence and faith should be the same no matter how many players are within a control sphere).
	teams[1].presence =    0.50        -- Bonus influence or faith applied per additional player of the Blue Team within a control sphere (set to 0 if influence and faith should be the same no matter how many players are within a control sphere).
	
	-- Control Sphere Radius by Map --
	
	radius = {}         -- Stores information regarding control sphere radii of each team depending on the map currently running.
	
	radius[0] = {}      -- Radius of Red Base control spheres.
	radius[1] = {}      -- Radius of Blue Base control spheres.
	
	--   Team:    Map:		   Radius:		Description:
	radius[0].beavercreek =     4.00        -- Radius of Red Base control sphere in beavercreek.
	radius[1].beavercreek =     4.00        -- Radius of Blue Base control sphere in beavercreek.
	
	radius[0].bloodgulch =      5.75        -- Radius of Red Base control sphere in bloodgulch.
	radius[1].bloodgulch =      5.75        -- Radius of Blue Base control sphere in bloodgulch.
	
	radius[0].boardingaction =  6.00        -- Radius of Red Base control sphere in boardingaction.
	radius[1].boardingaction =  6.00        -- Radius of Blue Base control sphere in boardingaction.
	
	radius[0].carousel =        4.50        -- Radius of Red Base control sphere in carousel.
	radius[1].carousel =        4.50        -- Radius of Blue Base control sphere in carousel.
	
	radius[0].chillout =        6.00        -- Radius of Red Base control sphere in chillout.
	radius[1].chillout =        6.00        -- Radius of Blue Base control sphere in chillout.
	
	radius[0].damnation =       7.00        -- Radius of Red Base control sphere in damnation.
	radius[1].damnation =       7.00        -- Radius of Blue Base control sphere in damnation.
	
	radius[0].dangercanyon =    6.00        -- Radius of Red Base control sphere in dangercanyon.
	radius[1].dangercanyon =    6.00        -- Radius of Blue Base control sphere in dangercanyon.
	
	radius[0].deathisland =     10.00       -- Radius of Red Base control sphere in deathisland.
	radius[1].deathisland =     10.00       -- Radius of Blue Base control sphere in deathisland.
	
	radius[0].gephyrophobia =   10.00       -- Radius of Red Base control sphere in gephyrophobia.
	radius[1].gephyrophobia =   10.00       -- Radius of Blue Base control sphere in gephyrophobia.
	
	radius[0].hangemhigh =      6.50        -- Radius of Red Base control sphere in hangemhigh.
	radius[1].hangemhigh =      6.50        -- Radius of Blue Base control sphere in hangemhigh.
	
	radius[0].icefields =       3.50        -- Radius of Red Base control sphere in icefields.
	radius[1].icefields =       3.50        -- Radius of Blue Base control sphere in icefields.
	
	radius[0].infinity =        6.00        -- Radius of Red Base control sphere in infinity.
	radius[1].infinity =        6.00        -- Radius of Blue Base control sphere in infinity.
	
	radius[0].longest =         4.00        -- Radius of Red Base control sphere in longest.
	radius[1].longest =         4.00        -- Radius of Blue Base control sphere in longest.
	
	radius[0].prisoner =        4.00        -- Radius of Red Base control sphere in prisoner.
	radius[1].prisoner =        4.00        -- Radius of Blue Base control sphere in prisoner.
	
	radius[0].putput =          5.00        -- Radius of Red Base control sphere in putput.
	radius[1].putput =          8.00        -- Radius of Blue Base control sphere in putput.
	
	radius[0].ratrace =         5.50        -- Radius of Red Base control sphere in ratrace.
	radius[1].ratrace =         5.50        -- Radius of Blue Base control sphere in ratrace.
	
	radius[0].sidewinder =      14.00       -- Radius of Red Base control sphere in sidewinder.
	radius[1].sidewinder =      14.00       -- Radius of Blue Base control sphere in sidewinder.
	
	radius[0].timberland =      14.00       -- Radius of Red Base control sphere in timberland.
	radius[1].timberland =      14.00       -- Radius of Blue base control sphere in timberland.
	
	radius[0].wizard =          5.00        -- Radius of Red Base control sphere in wizard.
	radius[1].wizard =          5.00        -- Radius of Blue Base control sphere in wizard.
	
	
	-- Control Sphere Exceptions by Map --
	
	except = {}  	-- Creates exceptions to the control sphere using highest and lowest x, y, and z coordinates the sphere can occupy.
					-- Any part of the sphere outside of these coordinates will be considered outside of the sphere.
					-- Use nil if there should be no exception to the sphere in the specific direction.
	
	except[0] = {}  -- Sphere exceptions for the red team.
	except[1] = {}  -- Sphere exceptions for the blue team.
	
	
	-- Don't edit the code below --
	for k,v in pairs(radius[0]) do
		except[0][k] = {}
		except[1][k] = {}
	end
	-- Don't edit the code above --
	
	
	--   Team:	Map:  Coord High/Low:	Coordinate:		Description:
	except[0].beavercreek.xlow =            27.20       -- Lowest X coordinate considered to be in the Red Base control sphere in beavercreek.
	except[0].beavercreek.xhigh =           30.50       -- Highest X coordinate considered to be in the Red Base control sphere in beavercreek.
	except[0].beavercreek.ylow =            9.90        -- Lowest Y coordinate considered to be in the Red Base control sphere in beavercreek.
	except[0].beavercreek.yhigh =           17.40       -- Highest Y coordinate considered to be in the Red Base control sphere in beavercreek.
	except[0].beavercreek.zlow =            nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in beavercreek.
	except[0].beavercreek.zhigh =           1.90        -- Highest Z coordinate considered to be in the Red Base control sphere in beavercreek.
	
	except[1].beavercreek.xlow =            -2.70       -- Lowest X coordinate considered to be in the Blue Base control sphere in beavercreek.
	except[1].beavercreek.xhigh =           1.03        -- Highest X coordinate considered to be in the Blue base control sphere in beavercreek.
	except[1].beavercreek.ylow =            9.90        -- Lowest Y coordinate considered to be in the Blue Base control sphere in beavercreek.
	except[1].beavercreek.yhigh =           17.40       -- Highest Y coordinate considered to be in the Blue Base control sphere in beavercreek.
	except[1].beavercreek.zlow =            nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in beavercreek.
	except[1].beavercreek.zhigh =           1.90        -- Highest Z coordinate considered to be in the Blue Base control sphere in beavercreek.
	
	except[0].bloodgulch.xlow =             nil         -- Lowest X coordinate considered to be in the Red Base control sphere in bloodgulch.
	except[0].bloodgulch.xhigh =            nil         -- Highest X coordinate considered to be in the Red Base control sphere in bloodgulch.
	except[0].bloodgulch.ylow =             nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in bloodgulch.
	except[0].bloodgulch.yhigh =            nil         -- Highest Y coordinate considered to be in the Red Base control sphere in bloodgulch.
	except[0].bloodgulch.zlow =             nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in bloodgulch.
	except[0].bloodgulch.zhigh =            nil         -- Highest Z coordinate considered to be in the Red Base control sphere in bloodgulch.
	
	except[1].bloodgulch.xlow =             nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in bloodgulch.
	except[1].bloodgulch.xhigh =            nil         -- Highest X coordinate considered to be in the Blue base control sphere in bloodgulch.
	except[1].bloodgulch.ylow =             nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in bloodgulch.
	except[1].bloodgulch.yhigh =            nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in bloodgulch.
	except[1].bloodgulch.zlow =             nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in bloodgulch.
	except[1].bloodgulch.zhigh =            nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in bloodgulch.
	
	except[0].boardingaction.xlow =         nil         -- Lowest X coordinate considered to be in the Red Base control sphere in boardingaction.
	except[0].boardingaction.xhigh =        nil         -- Highest X coordinate considered to be in the Red Base control sphere in boardingaction.
	except[0].boardingaction.ylow =         -3.7        -- Lowest Y coordinate considered to be in the Red Base control sphere in boardingaction.
	except[0].boardingaction.yhigh =        4.60        -- Highest Y coordinate considered to be in the Red Base control sphere in boardingaction.
	except[0].boardingaction.zlow =         -0.20       -- Lowest Z coordinate considered to be in the Red Base control sphere in boardingaction.
	except[0].boardingaction.zhigh =        2.30        -- Highest Z coordinate considered to be in the Red Base control sphere in boardingaction.
	
	except[1].boardingaction.xlow =         nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in boardingaction.
	except[1].boardingaction.xhigh =        nil         -- Highest X coordinate considered to be in the Blue base control sphere in boardingaction.
	except[1].boardingaction.ylow =         -4.50       -- Lowest Y coordinate considered to be in the Blue Base control sphere in boardingaction.
	except[1].boardingaction.yhigh =        3.74        -- Highest Y coordinate considered to be in the Blue Base control sphere in boardingaction.
	except[1].boardingaction.zlow =         -0.20       -- Lowest Z coordinate considered to be in the Blue Base control sphere in boardingaction.
	except[1].boardingaction.zhigh =        2.30        -- Highest Z coordinate considered to be in the Blue Base control sphere in boardingaction.
	
	except[0].carousel.xlow =               nil         -- Lowest X coordinate considered to be in the Red Base control sphere in carousel.
	except[0].carousel.xhigh =              nil         -- Highest X coordinate considered to be in the Red Base control sphere in carousel.
	except[0].carousel.ylow =               nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in carousel.
	except[0].carousel.yhigh =              nil         -- Highest Y coordinate considered to be in the Red Base control sphere in carousel.
	except[0].carousel.zlow =               nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in carousel.
	except[0].carousel.zhigh =              -1.30       -- Highest Z coordinate considered to be in the Red Base control sphere in carousel.
	
	except[1].carousel.xlow =               nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in carousel.
	except[1].carousel.xhigh =              nil         -- Highest X coordinate considered to be in the Blue base control sphere in carousel.
	except[1].carousel.ylow =               nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in carousel.
	except[1].carousel.yhigh =              nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in carousel.
	except[1].carousel.zlow =               nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in carousel.
	except[1].carousel.zhigh =              -1.30       -- Highest Z coordinate considered to be in the Blue Base control sphere in carousel.
	
	except[0].chillout.xlow =               5.60        -- Lowest X coordinate considered to be in the Red Base control sphere in chillout.
	except[0].chillout.xhigh =              11.20       -- Highest X coordinate considered to be in the Red Base control sphere in chillout.
	except[0].chillout.ylow =               nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in chillout.
	except[0].chillout.yhigh =              1.40        -- Highest Y coordinate considered to be in the Red Base control sphere in chillout.
	except[0].chillout.zlow =               1.80        -- Lowest Z coordinate considered to be in the Red Base control sphere in chillout.
	except[0].chillout.zhigh =              nil         -- Highest Z coordinate considered to be in the Red Base control sphere in chillout.
	
	except[1].chillout.xlow =               nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in chillout.
	except[1].chillout.xhigh =              -2.50       -- Highest X coordinate considered to be in the Blue base control sphere in chillout.
	except[1].chillout.ylow =               2.90        -- Lowest Y coordinate considered to be in the Blue Base control sphere in chillout.
	except[1].chillout.yhigh =              10.90       -- Highest Y coordinate considered to be in the Blue Base control sphere in chillout.
	except[1].chillout.zlow =               nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in chillout.
	except[1].chillout.zhigh =              nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in chillout.
	
	except[0].damnation.xlow =              4.70        -- Lowest X coordinate considered to be in the Red Base control sphere in damnation.
	except[0].damnation.xhigh =             nil         -- Highest X coordinate considered to be in the Red Base control sphere in damnation.
	except[0].damnation.ylow =              nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in damnation.
	except[0].damnation.yhigh =             -7.04       -- Highest Y coordinate considered to be in the Red Base control sphere in damnation.
	except[0].damnation.zlow =              nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in damnation.
	except[0].damnation.zhigh =             nil         -- Highest Z coordinate considered to be in the Red Base control sphere in damnation.
	
	except[1].damnation.xlow =              nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in damnation.
	except[1].damnation.xhigh =             nil         -- Highest X coordinate considered to be in the Blue base control sphere in damnation.
	except[1].damnation.ylow =              9.20        -- Lowest Y coordinate considered to be in the Blue Base control sphere in damnation.
	except[1].damnation.yhigh =             nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in damnation.
	except[1].damnation.zlow =              nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in damnation.
	except[1].damnation.zhigh =             2.90        -- Highest Z coordinate considered to be in the Blue Base control sphere in damnation.

	except[0].dangercanyon.xlow =           nil         -- Lowest X coordinate considered to be in the Red Base control sphere in dangercanyon.
	except[0].dangercanyon.xhigh =          nil         -- Highest X coordinate considered to be in the Red Base control sphere in dangercanyon.
	except[0].dangercanyon.ylow =           nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in dangercanyon.
	except[0].dangercanyon.yhigh =          2.70        -- Highest Y coordinate considered to be in the Red Base control sphere in dangercanyon.
	except[0].dangercanyon.zlow =           nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in dangercanyon.
	except[0].dangercanyon.zhigh =          nil         -- Highest Z coordinate considered to be in the Red Base control sphere in dangercanyon.
	
	except[1].dangercanyon.xlow =           nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in dangercanyon.
	except[1].dangercanyon.xhigh =          nil         -- Highest X coordinate considered to be in the Blue base control sphere in dangercanyon.
	except[1].dangercanyon.ylow =           nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in dangercanyon.
	except[1].dangercanyon.yhigh =          2.70        -- Highest Y coordinate considered to be in the Blue Base control sphere in dangercanyon.
	except[1].dangercanyon.zlow =           nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in dangercanyon.
	except[1].dangercanyon.zhigh =          nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in dangercanyon.
	
	except[0].deathisland.xlow =            -27.50      -- Lowest X coordinate considered to be in the Red Base control sphere in deathisland.
	except[0].deathisland.xhigh =           nil         -- Highest X coordinate considered to be in the Red Base control sphere in deathisland.
	except[0].deathisland.ylow =            -10.50      -- Lowest Y coordinate considered to be in the Red Base control sphere in deathisland.
	except[0].deathisland.yhigh =           -3.75       -- Highest Y coordinate considered to be in the Red Base control sphere in deathisland.
	except[0].deathisland.zlow =            9.00        -- Lowest Z coordinate considered to be in the Red Base control sphere in deathisland.
	except[0].deathisland.zhigh =           11.10       -- Highest Z coordinate considered to be in the Red Base control sphere in deathisland.
	
	except[1].deathisland.xlow =            nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in deathisland.
	except[1].deathisland.xhigh =           30.60       -- Highest X coordinate considered to be in the Blue base control sphere in deathisland.
	except[1].deathisland.ylow =            12.80       -- Lowest Y coordinate considered to be in the Blue Base control sphere in deathisland.
	except[1].deathisland.yhigh =           19.30       -- Highest Y coordinate considered to be in the Blue Base control sphere in deathisland.
	except[1].deathisland.zlow =            7.70        -- Lowest Z coordinate considered to be in the Blue Base control sphere in deathisland.
	except[1].deathisland.zhigh =           9.80        -- Highest Z coordinate considered to be in the Blue Base control sphere in deathisland.
	
	except[0].gephyrophobia.xlow =          22.45       -- Lowest X coordinate considered to be in the Red Base control sphere in gephyrophobia.
	except[0].gephyrophobia.xhigh =         31.23       -- Highest X coordinate considered to be in the Red Base control sphere in gephyrophobia.
	except[0].gephyrophobia.ylow =          nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in gephyrophobia.
	except[0].gephyrophobia.yhigh =         nil         -- Highest Y coordinate considered to be in the Red Base control sphere in gephyrophobia.
	except[0].gephyrophobia.zlow =          nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in gephyrophobia.
	except[0].gephyrophobia.zhigh =         nil         -- Highest Z coordinate considered to be in the Red Base control sphere in gephyrophobia.
	
	except[1].gephyrophobia.xlow =          22.45       -- Lowest X coordinate considered to be in the Blue Base control sphere in gephyrophobia.
	except[1].gephyrophobia.xhigh =         31.23       -- Highest X coordinate considered to be in the Blue base control sphere in gephyrophobia.
	except[1].gephyrophobia.ylow =          nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in gephyrophobia.
	except[1].gephyrophobia.yhigh =         nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in gephyrophobia.
	except[1].gephyrophobia.zlow =          nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in gephyrophobia.
	except[1].gephyrophobia.zhigh =         nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in gephyrophobia.
	
	except[0].hangemhigh.xlow =             11.50       -- Lowest X coordinate considered to be in the Red Base control sphere in hangemhigh.
	except[0].hangemhigh.xhigh =            17.50       -- Highest X coordinate considered to be in the Red Base control sphere in hangemhigh.
	except[0].hangemhigh.ylow =             7.50        -- Lowest Y coordinate considered to be in the Red Base control sphere in hangemhigh.
	except[0].hangemhigh.yhigh =            11.50       -- Highest Y coordinate considered to be in the Red Base control sphere in hangemhigh.
	except[0].hangemhigh.zlow =             nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in hangemhigh.
	except[0].hangemhigh.zhigh =            nil         -- Highest Z coordinate considered to be in the Red Base control sphere in hangemhigh.
	
	except[1].hangemhigh.xlow =             27.20       -- Lowest X coordinate considered to be in the Blue Base control sphere in hangemhigh.
	except[1].hangemhigh.xhigh =            33.60       -- Highest X coordinate considered to be in the Blue base control sphere in hangemhigh.
	except[1].hangemhigh.ylow =             -17.79      -- Lowest Y coordinate considered to be in the Blue Base control sphere in hangemhigh.
	except[1].hangemhigh.yhigh =            -12.50      -- Highest Y coordinate considered to be in the Blue Base control sphere in hangemhigh.
	except[1].hangemhigh.zlow =             -3.5        -- Lowest Z coordinate considered to be in the Blue Base control sphere in hangemhigh.
	except[1].hangemhigh.zhigh =            nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in hangemhigh.
	
	except[0].icefields.xlow =              nil         -- Lowest X coordinate considered to be in the Red Base control sphere in icefields.
	except[0].icefields.xhigh =             nil         -- Highest X coordinate considered to be in the Red Base control sphere in icefields.
	except[0].icefields.ylow =              nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in icefields.
	except[0].icefields.yhigh =             nil         -- Highest Y coordinate considered to be in the Red Base control sphere in icefields.
	except[0].icefields.zlow =              nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in icefields.
	except[0].icefields.zhigh =             nil         -- Highest Z coordinate considered to be in the Red Base control sphere in icefields.
	
	except[1].icefields.xlow =              nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in icefields.
	except[1].icefields.xhigh =             nil         -- Highest X coordinate considered to be in the Blue base control sphere in icefields.
	except[1].icefields.ylow =              nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in icefields.
	except[1].icefields.yhigh =             nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in icefields.
	except[1].icefields.zlow =              nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in icefields.
	except[1].icefields.zhigh =             nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in icefields.
	
	except[0].infinity.xlow =               nil         -- Lowest X coordinate considered to be in the Red Base control sphere in infinity.
	except[0].infinity.xhigh =              nil         -- Highest X coordinate considered to be in the Red Base control sphere in infinity.
	except[0].infinity.ylow =               nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in infinity.
	except[0].infinity.yhigh =              nil         -- Highest Y coordinate considered to be in the Red Base control sphere in infinity.
	except[0].infinity.zlow =               nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in infinity.
	except[0].infinity.zhigh =              nil         -- Highest Z coordinate considered to be in the Red Base control sphere in infinity.
	
	except[1].infinity.xlow =               nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in infinity.
	except[1].infinity.xhigh =              nil         -- Highest X coordinate considered to be in the Blue base control sphere in infinity.
	except[1].infinity.ylow =               nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in infinity.
	except[1].infinity.yhigh =              nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in infinity.
	except[1].infinity.zlow =               nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in infinity.
	except[1].infinity.zhigh =              nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in infinity.
	
	except[0].longest.xlow =                nil         -- Lowest X coordinate considered to be in the Red Base control sphere in longest.
	except[0].longest.xhigh =               nil         -- Highest X coordinate considered to be in the Red Base control sphere in longest.
	except[0].longest.ylow =                nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in longest.
	except[0].longest.yhigh =               nil         -- Highest Y coordinate considered to be in the Red Base control sphere in longest.
	except[0].longest.zlow =                nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in longest.
	except[0].longest.zhigh =               nil         -- Highest Z coordinate considered to be in the Red Base control sphere in longest.
	
	except[1].longest.xlow =                nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in longest.
	except[1].longest.xhigh =               nil         -- Highest X coordinate considered to be in the Blue base control sphere in longest.
	except[1].longest.ylow =                nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in longest.
	except[1].longest.yhigh =               nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in longest.
	except[1].longest.zlow =                nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in longest.
	except[1].longest.zhigh =               nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in longest.
	
	except[0].prisoner.xlow =               nil         -- Lowest X coordinate considered to be in the Red Base control sphere in prisoner.
	except[0].prisoner.xhigh =              nil         -- Highest X coordinate considered to be in the Red Base control sphere in prisoner.
	except[0].prisoner.ylow =               nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in prisoner.
	except[0].prisoner.yhigh =              nil         -- Highest Y coordinate considered to be in the Red Base control sphere in prisoner.
	except[0].prisoner.zlow =               5.00        -- Lowest Z coordinate considered to be in the Red Base control sphere in prisoner.
	except[0].prisoner.zhigh =              nil         -- Highest Z coordinate considered to be in the Red Base control sphere in prisoner.
	
	except[1].prisoner.xlow =               nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in prisoner.
	except[1].prisoner.xhigh =              nil         -- Highest X coordinate considered to be in the Blue base control sphere in prisoner.
	except[1].prisoner.ylow =               nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in prisoner.
	except[1].prisoner.yhigh =              nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in prisoner.
	except[1].prisoner.zlow =               5.00        -- Lowest Z coordinate considered to be in the Blue Base control sphere in prisoner.
	except[1].prisoner.zhigh =              nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in prisoner.
	
	except[0].putput.xlow =                 nil         -- Lowest X coordinate considered to be in the Red Base control sphere in putput.
	except[0].putput.xhigh =                nil         -- Highest X coordinate considered to be in the Red Base control sphere in putput.
	except[0].putput.ylow =                 nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in putput.
	except[0].putput.yhigh =                nil         -- Highest Y coordinate considered to be in the Red Base control sphere in putput.
	except[0].putput.zlow =                 nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in putput.
	except[0].putput.zhigh =                1.90        -- Highest Z coordinate considered to be in the Red Base control sphere in putput.
	
	except[1].putput.xlow =                 nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in putput.
	except[1].putput.xhigh =                nil         -- Highest X coordinate considered to be in the Blue base control sphere in putput.
	except[1].putput.ylow =                 nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in putput.
	except[1].putput.yhigh =                nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in putput.
	except[1].putput.zlow =                 nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in putput.
	except[1].putput.zhigh =                nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in putput.
	
	except[0].ratrace.xlow =                nil         -- Lowest X coordinate considered to be in the Red Base control sphere in ratrace.
	except[0].ratrace.xhigh =               nil         -- Highest X coordinate considered to be in the Red Base control sphere in ratrace.
	except[0].ratrace.ylow =                nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in ratrace.
	except[0].ratrace.yhigh =               nil         -- Highest Y coordinate considered to be in the Red Base control sphere in ratrace.
	except[0].ratrace.zlow =                nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in ratrace.
	except[0].ratrace.zhigh =               nil         -- Highest Z coordinate considered to be in the Red Base control sphere in ratrace.
	
	except[1].ratrace.xlow =                nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in ratrace.
	except[1].ratrace.xhigh =               nil         -- Highest X coordinate considered to be in the Blue base control sphere in ratrace.
	except[1].ratrace.ylow =                nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in ratrace.
	except[1].ratrace.yhigh =               nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in ratrace.
	except[1].ratrace.zlow =                nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in ratrace.
	except[1].ratrace.zhigh =               -1.60       -- Highest Z coordinate considered to be in the Blue Base control sphere in ratrace.
	
	except[0].sidewinder.xlow =             -34.65      -- Lowest X coordinate considered to be in the Red Base control sphere in sidewinder.
	except[0].sidewinder.xhigh =            -29.51      -- Highest X coordinate considered to be in the Red Base control sphere in sidewinder.
	except[0].sidewinder.ylow =             nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in sidewinder.
	except[0].sidewinder.yhigh =            -29.7       -- Highest Y coordinate considered to be in the Red Base control sphere in sidewinder.
	except[0].sidewinder.zlow =             nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in sidewinder.
	except[0].sidewinder.zhigh =            -2.48       -- Highest Z coordinate considered to be in the Red Base control sphere in sidewinder.
	
	except[1].sidewinder.xlow =             27.75       -- Lowest X coordinate considered to be in the Blue Base control sphere in sidewinder.
	except[1].sidewinder.xhigh =            32.93       -- Highest X coordinate considered to be in the Blue base control sphere in sidewinder.
	except[1].sidewinder.ylow =             nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in sidewinder.
	except[1].sidewinder.yhigh =            -34.5       -- Highest Y coordinate considered to be in the Blue Base control sphere in sidewinder.
	except[1].sidewinder.zlow =             nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in sidewinder.
	except[1].sidewinder.zhigh =            -2.78       -- Highest Z coordinate considered to be in the Blue Base control sphere in sidewinder.
	
	except[0].timberland.xlow =             14.70       -- Lowest X coordinate considered to be in the Red Base control sphere in timberland.
	except[0].timberland.xhigh =            19.90       -- Highest X coordinate considered to be in the Red Base control sphere in timberland.
	except[0].timberland.ylow =             nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in timberland.
	except[0].timberland.yhigh =            -49.15      -- Highest Y coordinate considered to be in the Red Base control sphere in timberland.
	except[0].timberland.zlow =             nil         -- Lowest Z coordinate considered to be in the Red Base control sphere in timberland.
	except[0].timberland.zhigh =            -16.90      -- Highest Z coordinate considered to be in the Red Base control sphere in timberland.
	
	except[1].timberland.xlow =             -18.96      -- Lowest X coordinate considered to be in the Blue Base control sphere in timberland.
	except[1].timberland.xhigh =            -13.76      -- Highest X coordinate considered to be in the Blue base control sphere in timberland.
	except[1].timberland.ylow =             48.70       -- Lowest Y coordinate considered to be in the Blue Base control sphere in timberland.
	except[1].timberland.yhigh =            nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in timberland.
	except[1].timberland.zlow =             nil         -- Lowest Z coordinate considered to be in the Blue Base control sphere in timberland.
	except[1].timberland.zhigh =            -16.90      -- Highest Z coordinate considered to be in the Blue Base control sphere in timberland.
	
	except[0].wizard.xlow =                 nil         -- Lowest X coordinate considered to be in the Red Base control sphere in wizard.
	except[0].wizard.xhigh =                nil         -- Highest X coordinate considered to be in the Red Base control sphere in wizard.
	except[0].wizard.ylow =                 nil         -- Lowest Y coordinate considered to be in the Red Base control sphere in wizard.
	except[0].wizard.yhigh =                nil         -- Highest Y coordinate considered to be in the Red Base control sphere in wizard.
	except[0].wizard.zlow =                 -3.15       -- Lowest Z coordinate considered to be in the Red Base control sphere in wizard.
	except[0].wizard.zhigh =                nil         -- Highest Z coordinate considered to be in the Red Base control sphere in wizard.
	
	except[1].wizard.xlow =                 nil         -- Lowest X coordinate considered to be in the Blue Base control sphere in wizard.
	except[1].wizard.xhigh =                nil         -- Highest X coordinate considered to be in the Blue base control sphere in wizard.
	except[1].wizard.ylow =                 nil         -- Lowest Y coordinate considered to be in the Blue Base control sphere in wizard.
	except[1].wizard.yhigh =                nil         -- Highest Y coordinate considered to be in the Blue Base control sphere in wizard.
	except[1].wizard.zlow =                 -3.15       -- Lowest Z coordinate considered to be in the Blue Base control sphere in wizard.
	except[1].wizard.zhigh =                nil         -- Highest Z coordinate considered to be in the Blue Base control sphere in wizard.
	
	
	-- Optional Gametype Modifiers --
	
	-- Modifier:         Boolean:          Description:
	ball_of_faith =        true            -- One who holds the Ball of Faith (an oddball) will regenerate extra control percentage and increase maximum control while standing in their own control sphere.
	staff_of_influence =   true            -- One who holds the Staff of Influence (a flagstaff) will take extra control percentage while standing in the opposing team's control sphere.
	
	
	-- Ball of Faith --
	
	-- The following only apply if ball_of_faith = true.
	
	ball = {}
	
	-- Attribute:         Value:           Description:
	ball.bonus =           1.00            -- Bonus faith applied to the player holding the Ball of Faith.
	ball.max_bonus =       50.00           -- Bonus maximum control a team can have over their own base when a team member holds the Ball of Faith in their own control sphere.
	ball.spawn_delay =     0.00            -- Amount of time (in seconds) before the Ball of Faith appears on the map.
	ball.respawn =         45.0            -- Amount of time (in seconds) before the Ball of Faith respawns (use math.inf for no respawn).
	
	-- These are the messages a player will receive when they pick up the Ball of Faith.
	ball.messages =        {"This is the Ball of Faith", "Stand in your own base with the ball to gain extra control percentage."}

	
	-- Staff of Influence --
	
	-- The following only apply if staff_of_influence = true.
	
	staff = {}
	
	-- Attribute:            Value:        Description:
	staff.bonus =             1.50         -- Bonus influence applied to the player holding the Staff of Influence.
	staff.spawn_delay =       0.00         -- Amount of time (in seconds) before the Staff of Influence appears on the map.
	staff.respawn =           45.0         -- Amount of time (in seconds) before the Staff of Influence respawns (use math.inf for no respawn).
	
	-- These are the messages a player will receive when they pick up the Staff of Influence.
	staff.messages =          {"This is the Staff of Influence.", "Stand in the opposing team's base to take extra control percentage."}
	
	
	-- Ball and Staff Spawn Options --
	
	shared_spawns =           false        -- If true, the Ball of Faith and Staff of Influence can spawn in the same place.  If false, they cannot.
	
	
	-- Ball of Faith Spawnpoints --
	
	ball.spawns = {}         -- Spawnpoints of Ball of Faith depending on the current map
							 -- Allows for multiple spawn points (if multiple spawnpoints are specified, they will be chosen at random at the beginning of each game).
	
	--    Map:                    {{x1, y1, z1}, {x2, y2, z2} ... etc}
	ball.spawns.beavercreek =     { {15.38, 5.23, 4.05},
									{14.13, 20.95, 3.37}
									}

	ball.spawns.bloodgulch =      { {60.5, -150.5, 6.28},
									{70.09, -88.32, 5.64}
									}

	ball.spawns.boardingaction =  { {15.85, 12.82, 7.72},
									{4.13, -12.78, 7.72}
									}
									
	ball.spawns.carousel =        { {7.41, -7.58, 0.86},
									{-8.07, 8.10, 0.86}
									}
									
	ball.spawns.chillout =        { {9.82, 2.67, 0.5},
									{-1.63, 11.08, 4.67}
									}
									
	ball.spawns.damnation =       { {-7.76, 7.28, 3.90},
									{-12.17, -6.04, 3.51}
									}
									
	ball.spawns.dangercanyon =    { {-10.78, 44.82, 0.63},
									{10.35, 44.2, 0.63}
									}
									
	ball.spawns.deathisland =     { {-34.73, 50.47, 18.76},
									{16.97, -32.19, 3.91}
									}
									
	ball.spawns.gephyrophobia =   { {39.41, -67.38, -12.21},
									{14.06, -76.64, -12.21}
									}
									
	ball.spawns.hangemhigh =      { {21.04, -6.24, -3.63},
									{20.46, -2.45, -8.75}
									}
									
	ball.spawns.icefields =       { {-17.13, 34.29, 1.18},
									{-35.86, 30.51, 1.18}
									}
									
	ball.spawns.infinity =        { {-15.37, -46.22, 28.97},
									{18.86, -81.41, 28.67}
									}
									
	ball.spawns.longest =         { {-6.86, -10.53, 2.56},
									{5.06, -18.55, 2.56}
									}
									
	ball.spawns.prisoner =        { {9.19, -5.09, 3.69},
									{-11.03, 5.01, 1.89}
									}
									
	ball.spawns.putput =          { {-5.29, -22.25, 1.4},
									{13.62, -32.25, 3.33}
									}
									
	ball.spawns.ratrace =         { {16.22, -19.57, -0.66},
									{-2.24, -12.94, 0.72}
									}
									
	ball.spawns.sidewinder =      { {-1.49, 56.58, -2.54},
									{6.6, 57.18, -2.36}
									}
									
	ball.spawns.timberland =      { {5.8, 5.6, -18.84},
									{-3.64, -6.4, -18.51}
									}
									
	ball.spawns.wizard =          { {7.95, 7.95, -2.25},
									{-7.95, -7.95, -2.25}
									}
									
									
	-- Staff of Influence Spawnpoints --
	
	staff.spawns = {}        -- Spawnpoints of Staff of Influence depending on the current map
							 -- Allows for multiple spawn points (if multiple spawnpoints are specified, they will be chosen at random at the beginning of each game).
	
	--    Map:                    {{x1, y1, z1}, {x2, y2, z2} ... etc}
	staff.spawns.beavercreek =     {{15.38, 5.23, 4.05},
									{14.13, 20.95, 3.37}
									}

	staff.spawns.bloodgulch =      {{60.5, -150.5, 6.28},
									{70.09, -88.32, 5.64}
									}

	staff.spawns.boardingaction =  {{15.85, 12.82, 7.72},
									{4.13, -12.78, 7.72}
									}
									
	staff.spawns.carousel =        {{7.41, -7.58, 0.86},
									{-8.07, 8.10, 0.86}
									}
									
	staff.spawns.chillout =        {{9.82, 2.67, 0.5},
									{-1.63, 11.08, 4.67}
									}
									
	staff.spawns.damnation =       {{-7.76, 7.28, 3.90},
									{-12.17, -6.04, 3.51}
									}
									
	staff.spawns.dangercanyon =    {{-10.78, 44.82, 0.63},
									{10.35, 44.2, 0.63}
									}
									
	staff.spawns.deathisland =     {{-34.73, 50.47, 18.76},
									{16.97, -32.19, 3.91}
									}
									
	staff.spawns.gephyrophobia =   {{39.41, -67.38, -12.21},
									{14.06, -76.64, -12.21}
									}
									
	staff.spawns.hangemhigh =      {{21.04, -6.24, -3.63},
									{20.46, -2.45, -8.75}
									}
									
	staff.spawns.icefields =       {{-17.13, 34.29, 1.18},
									{-35.86, 30.51, 1.18}
									}
									
	staff.spawns.infinity =        {{-15.37, -46.22, 28.97},
									{18.86, -81.41, 28.67}
									}
									
	staff.spawns.longest =         {{-6.86, -10.53, 2.56},
									{5.06, -18.55, 2.56}
									}
									
	staff.spawns.prisoner =        {{9.19, -5.09, 3.69},
									{-11.03, 5.01, 1.89}
									}
									
	staff.spawns.putput =          {{-5.29, -22.25, 1.4},
									{13.62, -32.25, 3.33}
									}
									
	staff.spawns.ratrace =         {{16.22, -19.57, -0.66},
									{-2.24, -12.94, 0.72}
									}
									
	staff.spawns.sidewinder =      { {-1.49, 56.58, -2.54},
									{6.6, 57.18, -2.36}
									}
									
	staff.spawns.timberland =      {{5.8, 5.6, -18.84},
									{-3.64, -6.4, -18.51}
									}
									
	staff.spawns.wizard =          {{7.95, 7.95, -2.25},
									{-7.95, -7.95, -2.25}
									}
	
-- **Do not edit the following code unless you know what you're doing** --

	Game = game

	game_end = false
	
	flag_respawn_addr = 0x488A7E

	if game == "PC" then
		gametype_base = 0x671340
	else
		gametype_base = 0x5F5498
	end
	
	writedword(flag_respawn_addr, 0, 0xFFFFFFFF)
	
	writedword(gametype_base, 0x48, respawn_time * 30)
	
	flags = {}
	vehicles = {}
	players = {}
	weapons = {}
	
	teams[0].rate = 0
	teams[1].rate = 0
	
	teams[0].prefix = ""
	teams[1].prefix = ""
	
	teams[0].control = teams[0].start
	teams[1].control = teams[1].start
	
	teams[0].previous_max = teams[0].max
	teams[1].previous_max = teams[1].max
	
	teams[0].friendly = {}
	teams[1].friendly = {}
	
	teams[0].enemy = {}
	teams[1].enemy = {}
	
	registertimer(10, "ControlRate")
	registertimer(1000, "CreationDelay")	
end

function OnNewGame(map)

	this_map = map
end

--[[function OnGameEnd(stage)

	if stage == 1 then
		if Game == "PC" then
			ctf_globals = 0x639B98
		else
			ctf_globals = 0x5BDBB8
		end
		
		if teams[1].control == 0 then
			writedword(ctf_globals, 0x10, 1)
		elseif teams[0].control == 0 then
			writedword(ctf_globals + 0x4, 0x10, 1)
		end
	elseif stage == 2 then
		game_end = true
		
		for i = 0,15 do
			if getplayer(i) then
				local hash = gethash(i)
				sendconsoletext(i, "Control Restored: " .. math.round(players[hash].restored, 2) .. " Percent")
				sendconsoletext(i, "Control Taken: " .. math.round(players[hash].taken, 2) .. " Percent")
			end
		end
	elseif stage == 3 then
		flag_respawn_addr = 0x488A7E
		writedword(flag_respawn_addr, 0, 17 * 30)
	end
end]]

function OnServerChat(player, type, message)
	
	if player then
		if message == help_command then
			sendconsoletext(player, "Conquest:", 15, order.help)
			sendconsoletext(player, "Take control of opposing base before the other team takes control of yours.", 15, order.help)
			sendconsoletext(player, "Regain control of your base by standing in it unopposed.", 15, order.help)
			sendconsoletext(player, "Take control from the other team by standing in their base unopposed.", 15, order.help)
			sendconsoletext(player, "If at any point one team's control percentage is 0 percent, the other team wins.", 15, order.help)
			return false
		end
	end
end

function OnPlayerJoin(player)

	newplayer(player)
	sendconsoletext(player, "Red Base Control: " .. math.round(teams[0].control, 2) .. " percent", math.inf, order.redcontrol, "right", notgameover)
	sendconsoletext(player, "Blue Base Control: " .. math.round(teams[1].control, 2) .. " percent", math.inf, order.bluecontrol, "right", notgameover)
end

function OnPlayerLeave(player)

	for i = 0,3 do
		if weapons[player][i] then
			OnWeaponDrop(player, weapons[player][i].weapId, i, weapons[player][i].mapId)
			weapons[player][i] = nil
		end
	end
end

function OnObjectCreation(objId)

	local m_object = getobject(objId)
	local mapId = readdword(m_object)
	local tagname, tagtype = gettaginfo(mapId)
	if tagtype == "weap" and tagname == "weapons\\flag\\flag" then
		local team = readbyte(m_object, 0xB8)
		if teams[team] then
			if not teams[team].center then
				teams[team].center = {getobjectcoords(objId)}
			end
			if #flags < 2 then
				table.insert(flags, objId)
			end
		end
	end
end

function OnObjectInteraction(player, objId, mapId)

	if table.find(flags, objId) then
		return false
	end
	
	local tagname, tagtype = gettaginfo(mapId)
	local hash = gethash(player)
	
	if players[hash].ball then
		if tagtype == "weap" and tagname == "weapons\\flag\\flag" then
			return false
		end
	end
	
	if players[hash].staff then
		if tagtype == "weap" and tagname == "weapons\\ball\\ball" then
			return false
		end
	end
end

function OnWeaponPickup(player, weapId, slot, mapId)

	local hash = gethash(player)
	local tagname = gettaginfo(mapId)
	if tagname == "weapons\\ball\\ball" then
		players[hash].ball = true
		players[hash].faith = players[hash].faith + ball.bonus
		ball.player = player
		local messages = getmessageblock(player, order.ballmessage)
		if not messages then
			for k,v in ipairs(messages) do
				v:append(ball.messages[k], true)
			end
		else
			for k,v in ipairs(ball.messages) do
				sendconsoletext(player, ball.messages[k], 10, order.ballmessage, "left", holdingball)
			end
		end
	elseif tagname == "weapons\\flag\\flag" then
		players[hash].staff = true
		players[hash].influence = players[hash].faith + staff.bonus
		staff.player = player
		local messages = getmessageblock(player, order.staffmessage)
		if not messages then
			for k,v in ipairs(messages) do
				v:append(staff.messages[k], true)
			end
		else
			for k,v in ipairs(staff.messages) do
				sendconsoletext(player, staff.messages[k], 10, order.staffmessage, "left", holdingflag)
			end
		end
	end
end

function OnWeaponDrop(player, weapId, slot, mapId)

	local hash = gethash(player)
	local tagname = gettaginfo(mapId)
	if tagname == "weapons\\ball\\ball" then
		players[hash].ball = false
		players[hash].faith = players[hash].faith - ball.bonus
		ball.player = nil
	elseif tagname == "weapons\\flag\\flag" then
		players[hash].staff = false
		players[hash].influence = players[hash].influence - staff.bonus
		staff.player = nil
	end
end

function OnControlEnter(sphereteam, player)

	local hash = gethash(player)
	if players[hash].team == sphereteam then
		teams[sphereteam].friendly[hash] = players[hash].faith
		if players[hash].ball then
			teams[sphereteam].max = teams[sphereteam].max + ball.max_bonus
		end
	else
		teams[sphereteam].enemy[hash] = players[hash].influence
	end
end

function OnControlExit(sphereteam, player)

	local hash = gethash(player)
	if players[hash].team == sphereteam then
		teams[sphereteam].friendly[hash] = nil
		if players[hash].ball then
			teams[sphereteam].max = teams[sphereteam].max - ball.max_bonus
		end
	else
		teams[sphereteam].enemy[hash] = nil
	end
end

spheres = {}
spheres.__index = spheres

function controlsphere(team, radius, x, y, z)

	spheres[team] = {}
	spheres[team].radius = radius
	spheres[team].x = x
	spheres[team].y = y
	spheres[team].z = z
	spheres[team].team = team
	spheres[team].players = {}
	
	setmetatable(spheres[team], spheres)
	teams[team].sphere = spheres[team]
	
	return spheres[team]
end

function insphere(objId, sphere)

	local m_object = getobject(objId)
	if m_object then
		local vehiId = readdword(m_object, 0x11C)
		local m_vehicle = getobject(vehiId)
		if m_vehicle then
			objId = vehiId
		end
		
		local x, y, z = getobjectcoords(objId)
		local dist = math.sqrt((x - sphere.x) ^  2 + (y - sphere.y) ^ 2 + (z - sphere.z) ^ 2)
		if dist <= sphere.radius then
			if x > (except[sphere.team][this_map].xlow or -math.inf) and x < (except[sphere.team][this_map].xhigh or math.inf) and y > (except[sphere.team][this_map].ylow or -math.inf) and y < (except[sphere.team][this_map].yhigh or math.inf) and z > (except[sphere.team][this_map].zlow or -math.inf) and z < (except[sphere.team][this_map].zhigh or math.inf) then
				return true
			end
		end
	end
	
	return false
end

function newplayer(player)

	local hash = gethash(player)
	local team = getteam(player)
	
	players[hash] = players[hash] or {}
	players[hash].team = team
	players[hash].influence = teams[team].influence
	players[hash].faith = teams[team].faith
	players[hash].presence = teams[team].presence
	players[hash].ball = false
	players[hash].staff = false
	players[hash].inred = false
	players[hash].inblue = false
	players[hash].restored = 0
	players[hash].taken = 0
end

function setscore(player, score)

	local m_player = getplayer(player)
	if m_player then
		writeword(m_player, 0xC8, score)
	end
end

registertimer(10, "SphereMonitor")

function SphereMonitor(id, count)

	for player = 0,15 do
		local m_player = getplayer(player)
		if m_player then
			local hash = gethash(player)
			local objId = readdword(m_player, 0x34)
			local m_object = getobject(objId)
			if m_object then
				if insphere(objId, teams[0].sphere) then
					if not players[hash].inred then
						OnControlEnter(0, player)
						players[hash].inred = true
					end
				else
					if players[hash].inred then
						OnControlExit(0, player)
						players[hash].inred = false
					end
				end
				
				if insphere(objId, teams[1].sphere) then
					if not players[hash].inblue then
						OnControlEnter(1, player)
						players[hash].inblue = true
					end
				else
					if players[hash].inblue then
						OnControlExit(1, player)
						players[hash].inblue = false
					end
				end
			else
				if players[hash].inred then
					OnControlExit(0, player)
				end
				
				if players[hash].inblue then
					OnControlExit(1, player)
				end
			end
		end
	end
	
	return true
end

registertimer(10, "ControlTimer")

function ControlTimer(id, count)

	local difference = {}

	for team = 0,1 do
	
		teams[team].owned = false
	
		if table.len(teams[team].friendly) > 0 and table.len(teams[team].enemy) > 0 then
			teams[team].rate = 0
			for hash,_ in pairs(teams[team].enemy) do
				if players[hash].staff then
					teams[team].rate = -(teams[1 - team].influence + table.len(teams[team].enemy) * teams[1 - team].presence)
					teams[team].owned = true
				end
			end
		elseif table.len(teams[team].friendly) > 0 then
			local maxhash = table.max(teams[team].friendly)
			local sum = players[maxhash].faith
			for hash,_ in pairs(teams[team].friendly) do
				if hash ~= maxhash then
					sum = sum + teams[team].presence
				end
				
				if players[hash].ball then
					teams[team].max = teams[team].previous_max + ball.max_bonus
				else
					teams[team].max = math.max(teams[team].previous_max, teams[team].control)
				end
			end
			
			teams[team].rate = sum
		elseif table.len(teams[team].enemy) > 0 then
			if teams[team].control > 0 then
				local maxhash = table.max(teams[team].enemy)
				local sum = players[maxhash].influence
				for hash,_ in pairs(teams[team].enemy) do
					if hash ~= maxhash then
						sum = sum + teams[team].presence
					end
				end
				
				teams[team].rate = -sum
			else
				teams[team].control = 0
				svcmd("sv_map_next")
				if team == 1 then
					say("Red Team wins!")
				else
					say("Blue Team wins!")
				end
				
				return false
			end
		else
			teams[team].rate = nil
		end
		
		local new_control = math.min(teams[team].max, teams[team].control + (teams[team].rate or 0) / 50)
		difference[team] = math.abs(new_control - teams[team].control)
		teams[team].control = new_control
	end
	
	for player = 0,15 do
		local m_player = getplayer(player)
		if m_player then
			local hash = gethash(player)
			local objId = readdword(m_player, 0x34)
			local m_object = getobject(objId)
			
			if m_object then
				if getobject(readdword(m_object, 0x11C)) then
					objId = readdword(m_object, 0x11C)
				end
				
				for team = 0,1 do
					if insphere(objId, teams[team].sphere) then
						if players[hash].team == team then
							players[hash].restored = players[hash].restored + difference[team]
						else
							players[hash].taken = players[hash].taken + difference[team]
						end
					end
				end
			end

			setscore(player, math.floor(players[hash].restored + players[hash].taken))
		end
	end
	
	return true
end

registertimer(10, "PrintTimer")

function PrintTimer(id, count)

	for i = 0,15 do
		if getplayer(i) then
			local redmessage = getmessage(i, order.redcontrol)
			local bluemessage = getmessage(i, order.bluecontrol)
			if redmessage and bluemessage then
				if not teams[0].rate then
					redmessage:append("Red Base Control: " .. math.round(teams[0].control, 2) .. " percent")
				else
					if teams[0].rate > 0 then
						redmessage:append("+ Red Base Control: " .. math.round(teams[0].control, 2) .. " percent")
					elseif teams[0].rate < 0 then
						if teams[0].owned then
							redmessage:append("*- Red Base Control: " .. math.round(teams[0].control, 2) .. " percent")
						else
							redmessage:append("- Red Base Control: " .. math.round(teams[0].control, 2) .. " percent")
						end
					else
						redmessage:append("* Red Base Control: " .. math.round(teams[0].control, 2) .. " percent (Contested)")
					end
				end
				
				if not teams[1].rate then
					bluemessage:append("Blue Base Control: " .. math.round(teams[1].control, 2) .. " percent")
				else
					if teams[1].rate > 0 then
						bluemessage:append("+ Blue Base Control: " .. math.round(teams[1].control, 2) .. " percent")
					elseif teams[1].rate < 0 then
						if teams[1].owned then
							bluemessage:append("*- Blue Base Control: " .. math.round(teams[1].control, 2) .. " percent")
						else
							bluemessage:append("- Blue Base Control: " .. math.round(teams[1].control, 2) .. " percent")
						end
					else
						bluemessage:append("* Blue Base Control: " .. math.round(teams[1].control, 2) .. " percent (Contested)")
					end
				end
			end
		end
	end
	
	return not game_end
end

function CreationDelay(id, count)
	
	teams[0].radius = teams[0].radius or radius[0][this_map]
	teams[1].radius = teams[1].radius or radius[1][this_map]
	
	controlsphere(0, teams[0].radius, table.unpack(teams[0].center))
	controlsphere(1, teams[1].radius, table.unpack(teams[1].center))
	
	if ball_of_faith then
		if #ball.spawns[this_map] > 0 then
			local mapId = gettagid("weap", "weapons\\ball\\ball")
			local rand = getrandomnumber(1, #ball.spawns[this_map] + 1)
			ball.x = ball.spawns[this_map][rand][1]
			ball.y = ball.spawns[this_map][rand][2]
			ball.z = ball.spawns[this_map][rand][3]
			ball.objId = createobject(mapId, 0, 0, false, ball.x, ball.y, ball.z)
			ball.respawn_remain = ball.respawn
			
			registertimer(1000, "Respawn", "ball")
			
			if not shared_spawns then
				for k,t in ipairs(staff.spawns[this_map]) do
					if t[1] == ball.x and t[2] == ball.y and t[3] == ball.z then
						table.remove(staff.spawns[this_map], k)
						break
					end
				end
			end
		else
			hprintf("There are no Ball of Faith spawn points for " .. this_map)
		end
	end
	
	local ctf_globals = 0x639B98
	for i = 0,1 do
		ctf_flag_coords_pointer = readdword(ctf_globals + i * 4, 0x0)
		writefloat(ctf_flag_coords_pointer, 0)
		writefloat(ctf_flag_coords_pointer + 4, 0)
		writefloat(ctf_flag_coords_pointer + 8, -1000)
	end
	
	if staff_of_influence then
		if #staff.spawns[this_map] > 0 then
			local mapId = gettagid("weap", "weapons\\flag\\flag")
			local rand = getrandomnumber(1, #staff.spawns[this_map] + 1)
			staff.x = staff.spawns[this_map][rand][1]
			staff.y = staff.spawns[this_map][rand][2]
			staff.z = staff.spawns[this_map][rand][3]
			staff.objId = createobject(mapId, 0, staff.respawn, true, staff.x, staff.y, staff.z)
			staff.respawn_remain = staff.respawn
			
			registertimer(1000, "Respawn", "staff")
		else
			hprintf("There are no Staff of Influence spawn points for " .. this_map)
		end
	end
	
	registertimer(10, "SphereMonitor")
	
	return false
end

function Respawn(id, count, item)

	if _G[item].player then
		_G[item].respawn_remain = _G[item].respawn
	else
		local objId = _G[item].objId
		local m_object = getobject(objId)
		if m_object then
			local x, y, z = getobjectcoords(objId)
			if math.round(x, 1) == math.round(_G[item].x, 1) and math.round(y, 1) == math.round(_G[item].y, 1) and math.round(z, 1) == math.round(_G[item].z, 1) then
				_G[item].respawn_remain = _G[item].respawn
			else
				_G[item].respawn_remain = _G[item].respawn_remain - 1
				if _G[item].respawn_remain <= 0 then
					movobjectcoords(objId, _G[item].x, _G[item].y, _G[item].z)
					local m_object = getobject(_G[item].objId)
					writebit(m_object, 0x10, 5, 0)
					_G[item].respawn_remain = _G[item].respawn
				end
			end
		else
			_G[item].respawn_remain = _G[item].respawn_remain - 1
			if _G[item].respawn_remain <= 0 then
				local mapId
				if item == "ball" then
					mapId = gettaginfo("weap", "weapons\\ball\\ball")
				elseif item == "staff" then
					mapId = gettaginfo("weap", "weapons\\flag\\flag")
				end
				
				_G[item].objId = createobject(mapId, 0, 0, false, _G[item].x, _G[item].y, _G[item].z)
				_G[item].respawn_remain = _G[item].respawn
			end
		end
	end
	
	return true
end

registertimer(10, "WeaponMonitor")

function WeaponMonitor(id, count)

	for player = 0,15 do
		weapons[player] = weapons[player] or {}
		local m_player = getplayer(player)
		if m_player then
			local temp = {}
			local objId = readdword(m_player, 0x34)
			local m_object = getobject(objId)
			if m_object then
				for i = 0,3 do
					local weapId = readdword(m_object, 0x2F8 + (i * 4))
					local m_weapon = getobject(weapId)
					if m_weapon then
						local mapId = readdword(m_weapon)
						if weapons[player][i] then
							if weapons[player][i].weapId ~= weapId then
								OnWeaponDrop(player, weapons[player][i].weapId, i, weapons[player][i].mapId)
								weapons[player][i] = {}
								weapons[player][i].weapId = weapId
								weapons[player][i].mapId = mapId
								OnWeaponPickup(player, weapId, i, mapId)
							end
						else
							weapons[player][i] = {}
							weapons[player][i].weapId = weapId
							weapons[player][i].mapId = mapId
							OnWeaponPickup(player, weapId, i, mapId)
						end
					else
						if weapons[player][i] then
							OnWeaponDrop(player, weapons[player][i].weapId, i, weapons[player][i].mapId)
							weapons[player][i] = nil
						end
					end
				end
			else
				for i = 0,3 do
					if weapons[player][i] then
						OnWeaponDrop(player, weapons[player][i].weapId, i, weapons[player][i].mapId)
						weapons[player][i] = nil
					end
				end
			end
		end	
	end
	
	return true
end

order = {}
order.help = 0
order.ballmessage = 1
order.staffmessage = 2
order.redcontrol = 3
order.bluecontrol = 4

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
						
						if console[i][k] then
							console[i][k].remain = console[i][k].remain - 0.1
							if console[i][k].remain <= 0 then
								console[i][k] = nil
							end
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
									phasor_sendconsoletext(i, consolecenter(string.sub(console[i][k].message, 1, 78)))
								else
									phasor_sendconsoletext(i, string.sub(console[i][k].message, 1, 78))
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

function table.len(t)

	local count = 0
	for k,v in pairs(t) do
		count = count + 1
	end
	
	return count
end

function math.round(input, precision)

	return math.floor(input * (10 ^ precision) + 0.5) / (10 ^ precision)
end

function table.find(t, v, case)

	if case == nil then case = true end

	for k,val in pairs(t) do
		if case then
			if v == val then
				return k
			end
		else
			if string.lower(v) == string.lower(val) then
				return k
			end
		end
	end
end

function table.max(t)

	local max = -math.inf
	local key
	for k,v in pairs(t) do
		if type(v) == "number" then
			if v > max then
				key = k
				max = v
			end
		end
	end
	
	return key, max
end

function holdingball(player)

	local m_player = getplayer(player)
	if m_player then
		local hash = gethash(player)
		if players[hash].ball then
			return true
		end
	end
	
	return false
end

function holdingflag(player)

	local m_player = getplayer(player)
	if m_player then
		local hash = gethash(player)
		if players[hash].staff then
			return true
		end
	end
	
	return false
end

function notgameover()

	return not game_end
end