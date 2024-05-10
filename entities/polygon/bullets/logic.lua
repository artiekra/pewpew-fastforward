local performance = require"misc/performance"
local helpers = require"entities/helpers"

local module = {}


-- Spawn entity, add update callback
function module.spawn(x, y, angle)
  local speed = 10fx

  local colors = {0x00ff00ff, 0x8000ffff,
    0xff0000ff, 0x808080ff}

  local bullet = new_entity(x, y)
  entity_start_spawning(bullet, 2)
  entity_set_mesh(bullet, "entities/polygon/bullets/mesh")
  entity_set_radius(bullet, 4fx)

  local time = 0
  local dy, dx = fx_sincos(angle)
  function bullet_update_callback()
    time = time + 1

    entity_change_pos(bullet, dx*speed, dy*speed)

    helpers.set_entity_color(time, bullet, colors)
  end

  function bullet_wall_collision()
    entity_start_exploding(bullet, 10)
  end

  function bullet_player_collision(entity_id, player_id, ship_id)
    damage_player_ship(ship_id, 1)
    entity_start_exploding(entity_id, 10)

    performance.increase_player_score(1)
  end

  entity_set_update_callback(bullet, bullet_update_callback)
  entity_set_wall_collision(bullet, true, bullet_wall_collision)
  entity_set_player_collision(bullet, bullet_player_collision)

  return bullet
end


return module
