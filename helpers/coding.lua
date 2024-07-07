-- Insert several elements into table at once
-- stack overflow question 13214926, thanks :з
-- modified by glebi a bit
function table_insert_all(target_table, ...)
  log.trace("hlpr", "Inserting multiple values into a table..")

  for _, v in ipairs{...} do
    table.insert(target_table, v)
  end
end


-- Map a value from one range to another
-- https://forum.unity.com/threads/
-- re-map-a-number-from-one-range-to-another.119437/
function map_to_range(s, a1, a2, b1, b2)
  return b1 + (s-a1)*(b2-b1)/(a2-a1);
end
