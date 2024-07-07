local level_time = require"misc/time/time"

events_module = {}

events_module.EVENTS = {}


-- Register an event to be executed at a particular time point
function events_module.register_event(time_delta, callback, ...)
  log.debug("event", "Registering event to be executed at time", time)
  args = {...}

  local time = level_time.TICK + time_delta
  table.insert(events_module.EVENTS, {time, callback, args})
end


function events_module.process_events()
  local time = level_time.TICK
  log.trace("event", "Processing events, time", time)

  for _, event in ipairs(events_module.EVENTS) do
    if event[1] == time then
      log.debug("event", "Found an event to execute")
      local result = event[2](table.unpack(event[3]))

      log.debug("event", "Event returned", result)
    end
  end

end


return events_module
