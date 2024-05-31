local performance = require"misc/performance"
local bullets = require"entities/polygon/bullets/logic"
local helpers = require"entities/helpers"
local ch = require"helpers/color_helpers"

require"entities/polygon/config"

local module = {}

-- [NOTE: cant have maximum alpha value,
--  its increased for effect, when hit by bullet]
local colors = {0x009a6590, 0xa700fd90,
  0xe0340090, 0x80808090}


function module.destroy_polygon(polygon_id, color)
  entity_start_exploding(polygon_id, 15)
  performance.increase_player_score(5)

  local x, y = entity_get_pos(polygon_id)
  create_explosion(x, y, color, 2fx, 50)

  local a = FX_TAU / TOTAL_BULLETS
  for i=1, TOTAL_BULLETS do
    local bullet1 = bullets.spawn(x, y, a * i - GROUP_SPREAD)
    local bullet2 = bullets.spawn(x, y, a * i + GROUP_SPREAD)
    entity_set_mesh_angle(bullet1, a * i - GROUP_SPREAD, 0fx, 0fx, 1fx)
    entity_set_mesh_angle(bullet2, a * i + GROUP_SPREAD, 0fx, 0fx, 1fx)
  end
end


-- Spawn entity, add update callback
function module.spawn(x, y, angle)
  local speed = 2fx
  local health = 5

  local explosion_color = colors[1]

  local polygon = new_entity(x, y)
  entity_start_spawning(polygon, 2)
  entity_set_mesh(polygon, "entities/polygon/mesh")
  entity_set_radius(polygon, 30fx)

  local time = 0
  local mesh_index = 0
  local highlight = 0
  local dy, dx = fx_sincos(angle)
  function polygon_update_callback()
    time = time + 1
    highlight = highlight - 1
    
    entity_change_pos(polygon, dx*speed, dy*speed)

    if mesh_index >= ANIMATION_TIME*60 then
      mesh_index = 0
    end

    entity_set_mesh(polygon, "entities/polygon/mesh", mesh_index, mesh_index + 1)
    mesh_index = mesh_index + 2

    local color_state = helpers.get_color_state(time)
    if color_state then
      color = colors[color_state]
      explosion_color = color
      if highlight > 0 then
        entity_set_mesh_color(polygon, ch.make_color_with_alpha(color, 255))
      else
        entity_set_mesh_color(polygon, color)
      end
    end
  end

  function polygon_wall_collision(entity_id, wall_normal_x, wall_normal_y)
    local dot_product_move = ((wall_normal_x * dx) + (wall_normal_y * dy)) * 2fx; 
    dx = dx - (wall_normal_x * dot_product_move)
    dy = dy - (wall_normal_y * dot_product_move); 
    angle = fx_atan2(dy,dx)
  end


  function polygon_player_collision(entity_id, player_id, ship_id)
    if health > 0 then
      if health > 3 then
        damage_player_ship(ship_id, 3)
      else
        damage_player_ship(ship_id, health)
      end
      module.destroy_polygon(entity_id, explosion_color)

      performance.increase_player_score(3)
    end
  end

  function polygon_weapon_collision(entity_id, player_index, weapon)
    if health > 0 then
      if weapon == weapon_type.bullet then
        health = health - 1
        highlight = 5
        if health <= 0 then
          module.destroy_polygon(entity_id, explosion_color)
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
