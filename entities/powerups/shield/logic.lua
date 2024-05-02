fm = require"helpers/floating_message"

local module = {}


-- Spawn entity, add update callback
-- [TODO: make shields dissapear]
function module.spawn(ship_id, x, y)

  local shield = new_entity(x, y)
  entity_start_spawning(shield, 2)
  entity_set_mesh(shield, "entities/powerups/shield/mesh")
  entity_set_radius(shield, 22fx)  -- [TODO: make this global in config?]

  -- entity for inner shield icon
  local inner_shield = new_entity(x, y)
  entity_start_spawning(inner_shield, 2)
  entity_set_mesh(inner_shield, "entities/powerups/shield/icon")

  -- [TODO: custom arrows?]
  add_arrow(ship_id, shield, 0x002902ff)

  function shield_player_collision(entity_id, player_id, ship_id)
    set_shield(get_shield() + 1)
  
    x, y = entity_get_pos(ship_id)
    pu = fm.new(x, y, "+1 shield", 1fx, 0x209a70ff, 16)  -- [TODO: make this global in config?]
    play_sound("entities/powerups/sounds/pickup")

    entity_start_exploding(entity_id, 11)
    entity_destroy(inner_shield)
  end

  entity_set_player_collision(shield, shield_player_collision)

  return shield
end


return module
