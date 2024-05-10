local performance = require"misc/performance"
local helpers = require"entities/helpers"

local module = {}


-- Spawn entity, add update callback
function module.spawn(x, y, angle)
  local speed = 1fx
  local colors = {0x007a50ff, 0x0248abff,
    0xd17300ff, 0x808080ff}

  local dust = new_entity(x, y)
  entity_start_spawning(dust, 2)
  entity_set_mesh(dust, "entities/dust/mesh")
  entity_set_radius(dust, 2fx)

  local time = 0
  local dy, dx = fx_sincos(angle)
  function dust_update_callback()
    time = time + 1

    entity_change_pos(dust, dx*speed, dy*speed)

    local color = helpers.get_mesh_color(time, colors)
    if color ~= nil then
      entity_set_mesh_color(dust, color)
    end
  end

  function dust_wall_collision()
    entity_start_exploding(dust, 10)
  end

  function dust_player_collision(entity_id, player_id, ship_id)
    damage_player_ship(ship_id, 1)
    entity_start_exploding(entity_id, 10)

    performance.increase_player_score(1)
  end

  entity_set_update_callback(dust, dust_update_callback)
  entity_set_wall_collision(dust, true, dust_wall_collision)
  entity_set_player_collision(dust, dust_player_collision)

  return dust
end


return module
