fm = require"helpers/floating_message"

local module = {}


-- Spawn entity, add update callback
function module.spawn(x, y)

  local shield = new_entity(x, y)
  entity_start_spawning(shield, 2)
  entity_set_mesh(shield, "powerups/shield/mesh")
  entity_set_radius(shield, 22fx)  -- [TODO: make this global in config?]

  function shield_player_collision(entity_id, player_id, ship_id)
    set_shield(get_shield() + 1)
  
    x, y = entity_get_pos(ship_id)
    pu = fm.new(x, y, "+1 shield", 1fx, 0x209a70ff, 16)  -- [TODO: make this global in config?]
    play_sound("powerups/sounds/pickup")

    entity_start_exploding(entity_id, 11)
  end

  entity_set_player_collision(shield, shield_player_collision)

  return shield
end


return module
