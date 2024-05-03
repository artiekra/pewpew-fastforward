local performance = require"misc/performance"

local module = {}


-- Spawn entity, add update callback
function module.spawn(x, y, angle)

  local polygon = new_entity(x, y)
  entity_start_spawning(polygon, 2)
  entity_set_mesh(polygon, "entities/polygon/mesh")
  entity_set_radius(polygon, 2fx)

  local mesh_index = 0
  function polygon_update_callback()
    -- [TODO: optimize, by calculating only once?]
    local dy, dx = fx_sincos(angle)
    entity_change_pos(polygon, dx, dy)
    if mesh_index > 119 then
      mesh_index = 0
    end
    entity_set_mesh(polygon, "entities/polygon/mesh", mesh_index, mesh_index + 1)
    mesh_index = mesh_index + 2
  end

  function polygon_wall_collision()
    angle = FX_TAU/2fx - angle
  end

  function polygon_player_collision(entity_id, player_id, ship_id)
    damage_player_ship(ship_id, 1)
    entity_start_exploding(entity_id, 10)

    performance.increase_player_score(1)
  end

  entity_set_update_callback(polygon, polygon_update_callback)
  entity_set_wall_collision(polygon, false, polygon_wall_collision)
  entity_set_player_collision(polygon, polygon_player_collision)

  return polygon
end


return module
