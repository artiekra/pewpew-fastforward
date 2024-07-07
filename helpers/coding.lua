-- Insert several elements into table at once
-- stack overflow question 13214926, thanks :з
-- modified by glebi a bit
function table_insert_all(target_table, ...)
  log.trace("hlpr", "Inserting multiple values into a table..")

  for _, v in ipairs{...} do
    table.insert(target_table, v)
  end
end
