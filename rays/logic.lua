require"rays/config"

local module = {}


-- Create rays (called one time, at the level creation moment)
function module.create(W, H, b, x, y)
  local ray = new_entity(x, y)
  entity_start_spawning(ray, 0)
  entity_set_mesh(ray, "rays/mesh")

  return ray
end


-- Update the rays (called every tick)
function module.update(ray, W, H, b, x, y)
  entity_set_pos(ray, x, y)

  -- Ray, which goes to the right of the ship
  rd = W - x
  entity_set_mesh_scale(ray, rd/2fx, 1fx)
  entity_set_mesh_xyz(ray, rd/2fx, 0fx, 0fx)
end


return module
