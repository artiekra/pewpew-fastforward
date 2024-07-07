local lru = require"libs/lrulua/lru"

LOG_LEVEL = "info"
MEMORY_PRINT = false

LEVEL_WIDTH = 950fx 
LEVEL_HEIGHT = 950fx
BEVEL_SIZE = 150fx

WEAPON_HZ = 15

-- Level mode related variables (level theme, green/blue)
MODE_CHANGE_DURATION = 35
MODE_CHANGE_EVENTS = {3600, 10800}
-- MODE_CHANGE_EVENTS = {60, 10800}  -- for testing of transition
LEVEL_MODE_MAX = 4
LEVEL_MODE = 0  -- mutable by level components variable

TIME_FACTOR = 1  -- mutable by level components variable

CACHE = lru.new(100, 75000)  -- limit cache by 75kb
