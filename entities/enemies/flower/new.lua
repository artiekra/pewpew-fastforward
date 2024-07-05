rolling_spheresC = {}

local i_speed = 1
local i_angle = 2
local i_dx = 3
local i_dy = 4

local rolling_speed = 0.128fx

local function destroy(id)
  entity_start_exploding(id, 30)
  rolling_spheresC[id] = nil
end

local function wall_collision_callback(id, nx, ny)
  local e = rolling_spheresC[id]
  local dx, dy = e[i_dx], e[i_dy]
  local dot_product = dx * nx + dy * ny
  dx, dy = dx - 2fx * dot_product * nx, dy - 2fx * dot_product * ny
  local angle = fx_atan2(dy, dx)
  entity_set_mesh_angle(id, angle, 0fx, 0fx, 1fx)
  e[i_angle] = angle
  e[i_dx] = dx
  e[i_dy] = dy
end

local function player_collision_callback(id, _, ship_id)
  damage_player_ship(ship_id, 1)
  destroy(id)
end

function new_rolling_sphereC(x, y, angle, speed)
  local id = new_entity(x, y)
  local dy, dx = fx_sincos(angle)
  local e = {}
  e[i_angle] = angle
  e[i_speed] = speed
  e[i_dx] = dx * speed
  e[i_dy] = dy * speed
  entity_set_mesh(id, 'mesht')
  entity_set_wall_collision(id, true, wall_collision_callback)
  entity_set_player_collision(id, player_collision_callback)
  entity_set_weapon_collision(id, function() end)
  entity_set_mesh_angle(id, angle, 0fx, 0fx, 1fx)
  rolling_spheresC[id] = e
end

add_update_callback(function()
  for id, e in pairs(rolling_spheresC) do
    entity_change_pos(id, e[i_dx], e[i_dy])
    entity_add_mesh_angle(id, rolling_speed * e[i_speed], -e[i_dy], e[i_dx], 0fx)
  end
end)

set_level_size(200fx, 200fx)
new_rolling_sphereC(100fx, 100fx, 2fx, 3fx)
