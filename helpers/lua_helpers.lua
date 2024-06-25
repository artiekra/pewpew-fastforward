local helper = {}


-- Insert several elements into table at once
-- thanks so :з
-- https://stackoverflow.com/questions/13214926/lua-insert-multiple-variables-into-a-table
-- [TODO: can be remade with new features of lua? for i=1, (...)]
function table_insert_all(table, ...)

  for i = 1, select('#',...) do
    table[#table+1] = select(i,...)
  end

end


return helper
