local helpers = require"entities/helpers"
local arrow = require"entities/powerups/arrow/logic"
local fm = require"helpers/floating_message"
local ch = require"helpers/color_helpers"
require"entities/powerups/config"

local module = {}


-- Spawn entity, add update callback
function module.spawn(ship_id, x, y, icon_mesh, text, colors, callback)
  local start_dissapearing = 240  -- 480 maybe or smth?
  local stop_dissapearing = 480

  local outer_colors = colors[1]
  local inner_colors = colors[2]
  local text_colors = colors[3]

  local box = new_entity(x, y)
  entity_start_spawning(box, 2)
  entity_set_mesh(box, "entities/powerups/mesh")
  entity_set_radius(box, to_fx(BOX_RADIUS))

  -- entity for inner shield icon
  local inner_box= new_entity(x, y)
  entity_start_spawning(inner_box, 2)
  entity_set_mesh(inner_box, icon_mesh)
  entity_set_radius(inner_box, to_fx(BOX_RADIUS))

  local box_time = 0
  function box_update_callback()
    box_time = box_time + 1
    local flicker_speed = 0.2

    local outer_color = outer_colors[1]
    local inner_color = inner_colors[1]

    if entity_get_is_alive(box) and
      entity_get_is_alive(inner_box) then

      -- not using helpers, so that color change is synced
      -- (still able to use different inner/outer colors)
      -- [TODO: refactor?]
      if LEVEL_MODE == 0 then
        outer_color = outer_colors[1]
        inner_color = inner_colors[1]
        entity_set_mesh_color(box, outer_color)
        entity_set_mesh_color(inner_box, inner_color)
      elseif LEVEL_MODE == 1 then
        n = random(0, 1)
        if time % (1//flicker_speed) == 0 then  -- make flickering a bit slower
          if n == 0 then
            outer_color = outer_colors[1]
            inner_color = inner_colors[1]
            entity_set_mesh_color(box, outer_color)
            entity_set_mesh_color(inner_box, inner_color)
          else
            outer_color = outer_colors[2]
            inner_color = inner_colors[2]
            entity_set_mesh_color(box, outer_color)
            entity_set_mesh_color(inner_box, inner_color)
          end
        end
      elseif LEVEL_MODE == 2 then
        outer_color = outer_colors[2]
        inner_color = inner_colors[2]
        entity_set_mesh_color(box, outer_color)
        entity_set_mesh_color(inner_box, inner_color)
      end

      if box_time >= start_dissapearing then
        local total = stop_dissapearing - start_dissapearing
        local time_left = stop_dissapearing - box_time
        local opacity = (time_left * 255) // total

        if opacity > 0 then
          entity_set_mesh_color(box, ch.make_color_with_alpha(outer_color, opacity))
          entity_set_mesh_color(inner_box, ch.make_color_with_alpha(inner_color, opacity))
        else
          entity_destroy(box)
          entity_destroy(inner_box)
          return
        end
      end

    end

  end

  function box_player_collision(entity_id, player_id, ship_id)
    x, y = entity_get_pos(ship_id)

    if LEVEL_MODE == 0 then    
      pu = fm.new(x, y, text, 1fx, text_colors[1], 16)
    else
      pu = fm.new(x, y, text, 1fx, text_colors[2], 16)
    end

    play_sound("entities/powerups/sounds/pickup")

    entity_start_exploding(entity_id, 11)
  end

  function inner_box_player_collision(entity_id, player_id, ship_id)
    callback(entity_id, player_id, ship_id)
    entity_destroy(inner_box)
  end

  arrow.add_arrow(ship_id, box, outer_colors)

  entity_set_update_callback(box, box_update_callback)
  entity_set_player_collision(box, box_player_collision)
  entity_set_player_collision(inner_box, inner_box_player_collision)

  return shield
end


return module
