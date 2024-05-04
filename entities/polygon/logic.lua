local performance = require"misc/performance"
local bullets = require"entities/polygon/bullets/logic"

local module = {}


function module.destroy_polygon(polygon_id)
  local total_bullets = 12

  entity_start_exploding(polygon_id, 15)
  performance.increase_player_score(5)

  local x, y = entity_get_pos(polygon_id)

  local a = FX_TAU / total_bullets
  for i=1, total_bullets do
    -- [TODO: refactor, make configurable]
    local bullet1 = bullets.spawn(x, y, a * i - 1fx)
    local bullet2 = bullets.spawn(x, y, a * i + 1fx)
    entity_set_mesh_angle(bullet1, a * i - 1fx, 0fx, 0fx, 1fx)
    entity_set_mesh_angle(bullet2, a * i + 1fx, 0fx, 0fx, 1fx)
  end
end


-- Spawn entity, add update callback
-- [TODO: make it more natural (angle after collision, movement/animation speed, etc)]
-- [NOTE: use explosions separately, instead of entity_start_exploding()?]
function module.spawn(x, y, angle)
  local speed = 2fx
  local health = 5

  local polygon = new_entity(x, y)
  entity_start_spawning(polygon, 2)
  entity_set_mesh(polygon, "entities/polygon/mesh")
  entity_set_radius(polygon, 30fx)

  local mesh_index = 0
  local dy, dx = fx_sincos(angle)
  function polygon_update_callback()
    entity_change_pos(polygon, dx*speed, dy*speed)
    if mesh_index > 119 then
      mesh_index = 0
    end
    entity_set_mesh(polygon, "entities/polygon/mesh", mesh_index, mesh_index + 1)
    mesh_index = mesh_index + 2
  end

  function polygon_wall_collision()
    dy = -dy
    dx = -dx
  end

  function polygon_player_collision(entity_id, player_id, ship_id)
    if health > 0 then
      if health > 3 then
        damage_player_ship(ship_id, 3)
      else
        damage_player_ship(ship_id, health)
      end
      module.destroy_polygon(entity_id)

      performance.increase_player_score(3)
    end
  end

  function polygon_weapon_collision(entity_id, player_index, weapon)
    if health > 0 then
      if weapon == weapon_type.bullet then
        health = health - 1
        if health <= 0 then
          module.destroy_polygon(entity_id)
        end
      end
    end
    return true
  end

  entity_set_update_callback(polygon, polygon_update_callback)
  entity_set_wall_collision(polygon, true, polygon_wall_collision)
  entity_set_player_collision(polygon, polygon_player_collision)
  entity_set_weapon_collision(polygon, polygon_weapon_collision)

  return polygon
end


return module
