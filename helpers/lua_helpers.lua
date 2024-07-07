-- Convert color with hue to RGB colors
-- stack overflow question 68317097, thanks :з
function hsv_to_rgb(h, s, l)
  log.extra("hlpr", "Converting hsv to rgb:", h, s, v)
  local cache_key = string.format("hsv_to_rgb_%s_%s_%s", h, s, l)
  local color

  local function calculate(h, s, l)
    h = h / 360
    s = s / 100
    l = l / 100

    local r, g, b;

    if s == 0 then
      r, g, b = l, l, l; -- achromatic
    else
      local function hue2rgb(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1 / 6 then return p + (q - p) * 6 * t end
        if t < 1 / 2 then return q end
        if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
        return p;
      end

      local q = l < 0.5 and l * (1 + s) or l + s - l * s;
      local p = 2 * l - q;
      r = hue2rgb(p, q, h + 1 / 3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1 / 3);
    end

    if not a then a = 1 end
    return {r * 255, g * 255, b * 255, a * 255}
  end

  color = CACHE:get(cache_key)
  if color == nil then
    color = calculate(h, s, l)
    CACHE:set(cache_key, color, 32) 
  end

  return table.unpack(color)
end


-- Insert several elements into table at once
-- stack overflow question 13214926, thanks :з
-- modified by glebi a bit
function table_insert_all(target_table, ...)
  log.trace("hlpr", "Inserting multiple values into a table..")

  for _, v in ipairs{...} do
    table.insert(target_table, v)
  end
end
