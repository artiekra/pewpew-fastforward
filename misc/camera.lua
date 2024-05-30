local module = {}


-- Dynamically set camera z, based on movement joystic
-- (ship speed, without the speed factor account for;
--  the one, controlled by the player)
-- Uses current value of camera_z for smoothing
function module.set_camera_z(current)
  local max = 100fx
  local step = 20fx

  -- Why this formula? https://jpcdn.it/img/5f7a5cee79c493a2cd9c18467ca14944.png
  target_z = 1000fx - max * (1-inputs.md)

  if current < target_z then
    new_z = current + step
    if new_z > target_z then
      new_z = target_z
    end
  elseif current > target_z then
    new_z = current - step
    if new_z < target_z then
      new_z = target_z
    end
  else
    new_z = current
  end
  set_camera_z(new_z)

  return new_z
end


return module
