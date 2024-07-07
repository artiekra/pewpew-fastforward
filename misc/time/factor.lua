local events = require"events"

require"globals/general"

local module = {}


-- Smoothly change time factor
-- [TODO: deal with potential overrides of effects]
function module.change_time_factor(new_tf, change_duration)
  log.debug("time", "Smoothly changing TIME_FACTOR to", new_tf,
    "in time", change_duration)

  -- slowly revert the changes
  local sf = TIME_FACTOR
  local ef = new_tf
  local et = change_duration
  -- local st = 0  -- start duration (delay the change for future)
  -- for i=st, et do
  for i=0, et do
    -- [NOTE: https://jpcdn.it/img/a5f4af01882a096a2decffce3c20cf26.png]
    events.register_event(i, function()
      -- local new_factor = ((i-st)*(ef-sf))/(et-st)+sf
      local new_factor = (i*(ef-sf))/et + sf
      TIME_FACTOR = ease_in_out_cubic(new_factor, sf, ef)
    end)
  end

end


return module
