require"/dynamic/libs/ppol/.lua"
require"entities/enemies/polygon/config"

meshes = {}


function make_mesh(angle_offset)
  local computed_vertexes, computed_segments = {}, {}

  local i = 0
  for angle = 0, PI * 2, PI * 2 / 6 do
    local y, x = sincos(angle - angle_offset)
    local y2, x2 = sincos(angle + angle_offset)

    table.insert(computed_vertexes, { x * RADIUS, y * RADIUS })
    table.insert(computed_vertexes, { x2 * INNER_RADIUS, y2 * INNER_RADIUS })

    table.insert(computed_segments, { i, i + 1 })
    table.insert(computed_segments, { i, i + 2 })
    table.insert(computed_segments, { i + 1, i + 3 })

    i = i + 2
  end

  table.remove(computed_segments, #computed_segments)
  table.remove(computed_segments, #computed_segments)
  table.remove(computed_segments, #computed_segments)

  local mesh = {
    vertexes = computed_vertexes,
    segments = computed_segments
  }

  return mesh
end


-- ability to slow down up to x8
local step = PI * 2 / (BASE_ANIMATION_TIME*60*8)
for angle_offset = 0, PI * 2, step do
  table.insert(meshes, make_mesh(angle_offset))
end
