local underline = require"entities/misc/end_screen/underline/logic"
local helpers = require"entities/helpers/labels"

require"globals/general"
require"globals/end_screen"

local module = {}


-- Show end screen text
function module.show()
  log.debug("endscr", "Request to trigger end screen..")

  local color = nil  -- make it rainbow
  local common_x = -LEVEL_WIDTH

  local main_label_text = "Well done >w<"
  helpers.create_bold_label(common_x, LEVEL_HEIGHT - 150fx,
    main_label_text, color, 5.2048fx, 0fx, -TILT_ANGLE*1.2048fx, 7)

  local text2 = "Thanks for playing my level!"
  helpers.create_bold_label(common_x, LEVEL_HEIGHT - 300fx,
    text2, 0xffffffff, 2fx, 0fx, -TILT_ANGLE*1.2048fx, 3)

  local text3 = "Here are some bonuses for you:"
  helpers.create_bold_label(common_x, LEVEL_HEIGHT - 375fx,
    text3, 0xffffffff, 2fx, 0fx, -TILT_ANGLE*1.2048fx, 3)

  -- underline the text
  underline.spawn(common_x, LEVEL_HEIGHT - 230fx)

end


return module
