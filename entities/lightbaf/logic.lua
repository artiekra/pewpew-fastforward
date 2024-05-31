local performance = require"misc/performance"
local helpers = require"entities/helpers"

local module = {}


-- Spawn entity, add update callback
function module.spawn(x, y, angle)
  local speed = 8.5fx
  local spin_speed = 1fx/4fx
  local colors = {0xf9f5f0ff, 0xf5f0f4ff,
    0xf4fcf0ff, 0xf0f0f0ff}

  local lightbaf = new_entity(x, y)
  entity_start_spawning(lightbaf, 2)
  entity_set_mesh(lightbaf, "entities/lightbaf/mesh")
  entity_set_radius(lightbaf, 10fx)

  local time = 0
  local dy, dx = fx_sincos(angle)
  entity_set_mesh_angle(lightbaf, angle, 0fx, 0fx, 1fx)
  function lightbaf_update_callback()
    time = time + 1

    entity_change_pos(lightbaf, dx*speed, dy*speed)
    -- entity_add_mesh_angle(lightbaf, spin_speed, 1fx, 0fx, 0fx)

    helpers.set_entity_color(time, lightbaf, colors)
  end

  function lightbaf_wall_collision(entity_id, wall_normal_x, wall_normal_y)
    local dot_product_move = ((wall_normal_x * dx) + (wall_normal_y * dy)) * 2fx; 
    dx = dx - (wall_normal_x * dot_product_move)
    dy = dy - (wall_normal_y * dot_product_move); 
    angle = fx_atan2(dy,dx)
    entity_set_mesh_angle(lightbaf, angle, 0fx, 0fx, 1fx)
  end

  function lightbaf_player_collision(entity_id, player_id, ship_id)
    damage_player_ship(ship_id, 1)
    entity_start_exploding(entity_id, 10)

    performance.increase_player_score(1)
  end

  function lightbaf_weapon_collision(entity_id, player_index, weapon)
    if weapon == weapon_type.bullet then
      entity_start_exploding(entity_id, 7)
      performance.increase_player_score(1)
    end
    return true
  end

  entity_set_update_callback(lightbaf, lightbaf_update_callback)
  entity_set_wall_collision(lightbaf, true, lightbaf_wall_collision)
  entity_set_player_collision(lightbaf, lightbaf_player_collision)
  entity_set_weapon_collision(lightbaf, lightbaf_weapon_collision)

  return lightbaf
end


return module
