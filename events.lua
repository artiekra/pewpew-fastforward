events_module = {}

events_module.EVENTS = {}


-- Register an event to be executed at a particular time point
function events_module.register_event(time, callback)
  log.debug("Registering event to be executed at time", time)
  table.insert(events_module.EVENTS, {time, callback})
end


function events_module.process_events(time)
  log.trace("Processing events..")

  for _, event in ipairs(events_module.EVENTS) do
    if event[1] == time then
      log.debug("Found an event to execute")
      local result = event[2]()

      log.debug("Event returned", result)
    end
  end

end


return events_module
