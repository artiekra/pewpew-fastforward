require"rays/config"

local module = {}


-- Create individual ray
function module.create_individual(x, y, angle)
  local ray = new_entity(x, y)
  entity_start_spawning(ray, 0)
  entity_set_mesh(ray, "rays/mesh")

  entity_add_mesh_angle(ray, angle, 0fx, 0fx, 1fx)

  return ray
end


-- Create rays (called one time, at the level creation moment)
function module.create(W, H, b, x, y)
  local ray1 = module.create_individual(x, y, 0fx)
  local ray2 = module.create_individual(x, y, FX_TAU/4fx)

  return ray1, ray2
end


-- Update the rays (called every tick)
-- Formulas for any bevel angle: https://jpcdn.it/img/2fe1c1bb54d7ea4810c4fb689041fb22.png
function module.update(ray1, ray2, W, H, b, x, y)
  entity_set_pos(ray1, x, y)
  entity_set_pos(ray2, x, y)

  -- Horizontal (x) ray
  local rd = W - x  -- right direction
  local ld = x  -- left direction
  local hr = rd + ld  -- total width (ray lenght)

  if y < b then
    diff = b - y
    hr = hr - diff
    entity_set_mesh_scale(ray1, hr/2fx, 1fx)
    entity_set_mesh_xyz(ray1, W/2fx-x-(diff/2fx), 0fx, 0fx)
  elseif y > H - b then
    diff = y - (H - b)
    hr = hr - diff
    entity_set_mesh_scale(ray1, hr/2fx, 1fx)
    entity_set_mesh_xyz(ray1, W/2fx-x+(diff/2fx), 0fx, 0fx)
  else
    entity_set_mesh_scale(ray1, hr/2fx, 1fx)
    entity_set_mesh_xyz(ray1, W/2fx-x, 0fx, 0fx)
  end

  -- Vertical (y) ray
  local ud = H - y  -- up direction
  local dd = y  -- down direction
  local vr = ud + dd  -- total height (ray lenght)

  if x < b then
    diff = b - x
    vr = vr - diff
    entity_set_mesh_scale(ray2, vr/2fx, 1fx)
    entity_set_mesh_xyz(ray2, 0fx, H/2fx-y-(diff/2fx), 0fx)
  elseif x > W - b then
    diff = x - (W - b)
    vr = vr - diff
    entity_set_mesh_scale(ray2, vr/2fx, 1fx)
    entity_set_mesh_xyz(ray2, 0fx, H/2fx-y+(diff/2fx), 0fx)
  else
    entity_set_mesh_scale(ray2, vr/2fx, 1fx)
    entity_set_mesh_xyz(ray2, 0fx, H/2fx-y, 0fx)
  end

end


return module
