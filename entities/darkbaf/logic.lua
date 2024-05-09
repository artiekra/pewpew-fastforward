local performance = require"misc/performance"
local helpers = require"entities/helpers"

local module = {}


-- Spawn entity, add update callback
function module.spawn(x, y, angle)
  local speed = 8.5fx
  local spin_speed = 1fx/4fx
  local color1 = 0x094500ff
  local color2 = 0x450044ff
  local color3 = 0x000000ff

  local darkbaf = new_entity(x, y)
  entity_start_spawning(darkbaf, 2)
  entity_set_mesh(darkbaf, "entities/darkbaf/mesh")
  entity_set_radius(darkbaf, 10fx)

  local time = 0
  local dy, dx = fx_sincos(angle)
  entity_set_mesh_angle(darkbaf, angle, 0fx, 0fx, 1fx)
  function darkbaf_update_callback()
    time = time + 1

    entity_change_pos(darkbaf, dx*speed, dy*speed)
    -- entity_add_mesh_angle(darkbaf, spin_speed, 1fx, 0fx, 0fx)

    color = helpers.get_mesh_color(time, color1, color2)
    if color ~= nil then
      entity_set_mesh_color(darkbaf, color)
    end

  end

  function darkbaf_wall_collision(entity_id, wall_normal_x, wall_normal_y)
    local dot_product_move = ((wall_normal_x * dx) + (wall_normal_y * dy)) * 2fx; 
    dx = dx - (wall_normal_x * dot_product_move)
    dy = dy - (wall_normal_y * dot_product_move); 
    angle = fx_atan2(dy,dx)
    entity_set_mesh_angle(darkbaf, angle, 0fx, 0fx, 1fx)
  end

  function darkbaf_player_collision(entity_id, player_id, ship_id)
    damage_player_ship(ship_id, 1)
    entity_start_exploding(entity_id, 10)

    performance.increase_player_score(1)
  end

  function darkbaf_weapon_collision(entity_id, player_index, weapon)
    if weapon == weapon_type.bullet then
      entity_start_exploding(entity_id, 7)
      performance.increase_player_score(1)
    end
    return true
  end

  entity_set_update_callback(darkbaf, darkbaf_update_callback)
  entity_set_wall_collision(darkbaf, true, darkbaf_wall_collision)
  entity_set_player_collision(darkbaf, darkbaf_player_collision)
  entity_set_weapon_collision(darkbaf, darkbaf_weapon_collision)

  return darkbaf
end


return module
