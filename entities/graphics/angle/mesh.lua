require"/dynamic/ppol/.lua"

local gh = require"helpers/graphics_helpers"
require"globals"


function mesh_add_dotted_line(mesh, point1, point2, color)
  local inzone = 5
  local exzone = 10

  local line_lenght = math.sqrt((point1[1] - point2[1])^2 + (point1[2] - point2[2])^2)
  local inzone_segments = line_lenght // (inzone+exzone)
  for inzone_id=0, inzone_segments-1 do

    -- line start
    local d = inzone_id * (inzone + exzone)
    local dp = line_lenght - d

    -- за т. Фалеса
    local start_x = (point2[1] - point1[1]) / (d+dp) * d
    local start_y = (point1[2] - point2[2]) / (d+dp) * d

    -- line end
    local d = inzone_id * (inzone + exzone) + inzone
    local dp = line_lenght - d

    -- за т. Фалеса
    local end_x = (point2[1] - point1[1]) / (d+dp) * d
    local end_y = (point1[2] - point2[2]) / (d+dp) * d

    gh.add_line_to_mesh(mesh, {{start_x, start_y}, {end_x, end_y}}, {color, color}, false)

  end

end


function make_mesh()
  local mesh = gh.new_mesh()

  local s = to_int(BEVEL_SIZE)/3
  local z = 0

  mesh_add_dotted_line(mesh, {s, s, z}, {s, -s, z}, 0xffffffff)
  mesh_add_dotted_line(mesh, {s, -s, z}, {-s, -s, z}, 0xffffffff)

  return mesh
end


meshes = {make_mesh()}
