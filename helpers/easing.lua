require"helpers/coding"
require"globals/general"  -- to access cache


-- https://easings.net/en#easeInOutCubic
function ease_in_out_cubic(x, range_start, range_end)
  log.trace("hlpr", "Applying easeInOutCubic to", x)
  local cache_key = string.format("ease_in_out_cubic_%s", x)
  local color

  local function calculate(v)
    if v < 0.5 then
      return 4 * v * v * v
    else
      return 1 - ((-2 * v + 2) ^ 3) / 2
    end
  end

  result = CACHE:get(cache_key)

  if result == nil then
    local v = map_to_range(x, range_start, range_end, 0, 1)
    result = map_to_range(calculate(v), 0, 1,
      range_start, range_end)
    CACHE:set(cache_key, result, 8) 
  end

  return result
end
