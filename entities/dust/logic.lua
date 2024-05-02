local module = {}


-- Spawn entity, add update callback
function module.spawn(x, y, angle)

  local dust = new_entity(x, y)
  entity_start_spawning(dust, 2)
  entity_set_mesh(dust, "entities/dust/mesh")
  entity_set_radius(dust, 2fx)

  function dust_update_callback()
    -- [TODO: optimize, by calculating only once?]
    local dy, dx = fx_sincos(angle)
    entity_change_pos(dust, dx, dy)
  end

  function dust_wall_collision()
    entity_start_exploding(dust, 10)
  end

  function dust_player_collision(entity_id, player_id, ship_id)
    damage_player_ship(ship_id, 1)
    entity_start_exploding(entity_id, 10)
  end

  entity_set_update_callback(dust, dust_update_callback)
  entity_set_wall_collision(dust, false, dust_wall_collision)
  entity_set_player_collision(dust, dust_player_collision)

  return dust
end


return module
