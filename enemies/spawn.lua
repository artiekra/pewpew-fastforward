local module = {}


-- Spawn enemies, given total level time
function module.spawn(time)
  if time == 1 then
    local dust = new_entity(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx)
    entity_set_mesh(dust, "enemies/dust/mesh")
  end
end


return module
