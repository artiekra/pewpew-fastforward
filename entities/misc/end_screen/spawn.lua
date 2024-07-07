-- [TODO: fix score problems by making a separate score module]
-- [TODO: fix end screen..]
local underline = require"entities/misc/end_screen/underline/logic"
local helpers = require"entities/helpers/labels"
local events = require"events"

require"globals/general"
require"globals/end_screen"

local module = {}


-- Increase score slowly
function smooth_increase_score(delta, time)
  local per_tick = delta // time
  local last_tick_extra = delta % time

  for i=1, time-1 do
    events.register_event(i, function()
      increase_score(per_tick)
    end)
  end
  events.register_event(time, function()
    increase_score(per_tick+last_tick_extra)
  end)

end


-- Show end screen text
-- [NOTE: TILT_ANGLE multiplied, looks more natural that way]
function module.show()
  log.debug("endscr", "Request to trigger end screen..")

  local color = nil  -- make it rainbow
  local common_x = -LEVEL_WIDTH

  local main_label_text = "Well done >w<"
  helpers.create_bold_label(common_x, LEVEL_HEIGHT - 150fx,
    main_label_text, color, 5.2048fx, 0fx, -TILT_ANGLE*1.1500fx, 7)

  function create_sublabel(offset_x, text, color)
    helpers.create_bold_label(common_x, LEVEL_HEIGHT - 300fx - offset_x,
      text, color, 2fx, 0fx, -TILT_ANGLE*1.1500fx, 3)
  end

  local shield_bonus = SHIELD_BONUS * get_shield()
  local total_bonus = SURVIVAL_BONUS + shield_bonus

  local sb = tostring(SURVIVAL_BONUS)
  local hb = tostring(shield_bonus)
  local tb = tostring(total_bonus)
  create_sublabel(0fx, "Thanks for playing my level!", 0xffffffff)
  create_sublabel(75fx, "Here are some bonuses for you:", 0xffffffff)
  create_sublabel(250fx, "> Survival bonus  " .. sb , 0xff5900ff)
  create_sublabel(325fx, "> Shield bonus  " .. hb, 0x909090ff)
  create_sublabel(400fx, "> Total bonus  " .. tb, 0xffaf00ff)

  smooth_increase_score(total_bonus, 90)
  events.register_event(150, function()
    set_has_lost(true)
  end)

  -- underline the text
  -- [TODO: return it back, but add rainbow animation too]
  -- underline.spawn(common_x, LEVEL_HEIGHT - 230fx)

end


return module
