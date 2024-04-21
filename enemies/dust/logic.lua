local module = {}


-- Spawn entity, add update callback
function module.spawn(x, y)

  local dust = new_entity(x, y)
  entity_start_spawning(dust, 2)
  entity_set_mesh(dust, "enemies/dust/mesh")
  entity_set_radius(dust, 2fx)

  local dy, dx = fx_sincos(fx_random(FX_TAU))
  entity_set_update_callback(dust, function()
    entity_change_pos(dust, dx, dy)
  end)

  entity_set_wall_collision(dust, false, function()
    entity_start_exploding(dust, 10)
  end)

  entity_set_player_collision(dust, function(entity_id, player_id, ship_id)
    damage_player_ship(ship_id, 3)
    entity_start_exploding(entity_id, 10)
  end)

  return dust
end


return module
