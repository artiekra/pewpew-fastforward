require"globals/general"  -- to access cache


-- https://easings.net/en#easeInOutCubic
function ease_in_out_cubic(x)
  log.trace("hlpr", "Applying easeInOutCubic to", x)
  local cache_key = string.format("ease_in_out_cubic_%s", x)
  local color

  local function calculate(x)
    if x < 0.5 then
      return 4 * x * x * x
    else
      return 1 - ((-2 * x + 2) ^ 3) / 2
    end
  end

  result = CACHE:get(cache_key)
  if result == nil then
    result = calculate(x)
    CACHE:set(cache_key, result, 8) 
  end

  return result
end
