require"/dynamic/ppol/.lua"
require"entities/polygon/config"

meshes = {}

for angle_offset = 0, math.pi * 2, math.pi * 2 / 120 do
  local computed_vertexes, computed_segments, computed_colors = {}, {}, {}

  local i = 0
  for angle = 0, math.pi * 2, math.pi * 2 / 6 do
    local y, x = math.sincos(angle - angle_offset)
    local y2, x2 = math.sincos(angle + angle_offset)

    table.insert(computed_vertexes, { x * RADIUS, y * RADIUS })
    table.insert(computed_vertexes, { x2 * INNER_RADIUS, y2 * INNER_RADIUS })

    table.insert(computed_colors, COLOR)
    table.insert(computed_colors, COLOR)

    table.insert(computed_segments, { i, i + 1 })
    table.insert(computed_segments, { i, i + 2 })
    table.insert(computed_segments, { i + 1, i + 3 })

    i = i + 2
  end

  table.remove(computed_segments, #computed_segments)
  table.remove(computed_segments, #computed_segments)
  table.remove(computed_segments, #computed_segments)

  table.insert(meshes, {
    vertexes = computed_vertexes,
    segments = computed_segments,
    colors = computed_colors
  })
end
