local module = {}

module.TIME = 0
module.TICK = 0


-- Get current time
-- [TODO: remove and access variable directly instead?]
function module.get_time()
  log.extra("time", "Request to get time..")
  return module.TIME
end


-- Increment time
function module.fast_forward(delta)
  log.debug("time", "Incrementing time by", delta)
  module.TIME = module.TIME + (delta or 1)
end


-- Get current tick
-- [TODO: remove and access variable directly instead?]
function module.get_ticks()
  log.trace("time", "Request to get ticks passed..")
  return module.TICK
end


-- Set up tick incrementing callback
function module.init()
  log.debug("time", "Setting up tick counting callback (init time)", delta)
  add_update_callback(function()
    module.TICK = module.TICK + 1
  end)
end


return module
