local module = {}

module.PRECISE_TIME = 0
module.TIME = 0
module.TICK = 0


-- Increment time
function module.fast_forward(delta)
  log.debug("time", "Incrementing time by", delta)
  module.PRECISE_TIME = module.PRECISE_TIME + (delta or 1)

  module.TIME = module.PRECISE_TIME//1
end


-- Set up tick incrementing callback
function module.init()
  log.debug("time", "Setting up tick counting callback (init time)", delta)
  add_update_callback(function()
    module.TICK = module.TICK + 1
  end)
end


return module
