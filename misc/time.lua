local module = {}

module.TIME = 0


-- Get current time
-- [TODO: remove and access variable directly instead?]
function module.get_time()
  return module.TIME
end


-- Increment time
function module.fast_forward(delta)
  module.TIME = module.TIME + (delta or 1)
end


return module
