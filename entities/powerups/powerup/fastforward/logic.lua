local template = require"entities/powerups/template"
local events = require"events"

require"entities/powerups/config"
require"globals/general"

local module = {}


local function camera_setup()
  camera.set_default_ease()

  camera.static_x = LEVEL_WIDTH / 2fx
  camera.static_y = LEVEL_HEIGHT / 5fx
  camera.static_z = -750fx
  camera.static_angle = -FX_TAU * 1fx/6fx

  camera.speed = 15fx
end


local function fastforward_player_collision(entity_id, player_id, ship_id)
  camera_setup()
end


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y)
  local colors = nil  -- make it rgb

  local outer_box, inner_box = template.spawn(ship_id, x, y, "entities/powerups/powerup/fastforward/icon",
    "fast forward!", colors, fastforward_player_collision)

  return outer_box, inner_box
end


return module
