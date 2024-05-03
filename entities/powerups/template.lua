fm = require"helpers/floating_message"

local module = {}


-- Spawn entity, add update callback
-- [TODO: make powerups dissapear]
function module.spawn(ship_id, x, y, mesh, icon_mesh, text, color, callback)

  local box = new_entity(x, y)
  entity_start_spawning(box, 2)
  entity_set_mesh(box, mesh)
  entity_set_radius(box, 22fx)

  -- entity for inner shield icon
  local inner_box= new_entity(x, y)
  entity_start_spawning(inner_box, 2)
  entity_set_mesh(inner_box, icon_mesh)
  entity_set_radius(inner_box, 22fx)

  function box_player_collision(entity_id, player_id, ship_id)
    x, y = entity_get_pos(ship_id)
    pu = fm.new(x, y, text, 1fx, color, 16)
    play_sound("entities/powerups/sounds/pickup")

    entity_start_exploding(entity_id, 11)
  end

  function inner_box_player_collision(entity_id, player_id, ship_id)
    callback(entity_id, player_id, ship_id)
    entity_destroy(inner_box)
  end

  -- [TODO: custom arrows?]
  add_arrow(ship_id, box, 0x002902ff)

  entity_set_player_collision(box, box_player_collision)
  entity_set_player_collision(inner_box, inner_box_player_collision)

  return shield
end


return module
