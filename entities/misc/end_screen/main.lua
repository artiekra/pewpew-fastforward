-- [TODO: combine some of the functions with the ones from entities/misc/labels]

require"globals/general"
require"globals/end_screen"
require"entities/misc/end_screen/data"

local helpers = require"entities/helpers/labels"

local module = {}


-- Show end screen text
function module.show()
  log.debug("endscr", "Request to trigger end screen..")

  -- [TODO: maybe change the responsibility for this to another module?]
  -- [TODO: make this smooth]
  camera.offset_z = -750fx

  local color = nil  -- make it rainbow
  local common_x = -LEVEL_WIDTH

  local main_label_text = MAIN_LABEL_VARIATIONS[random(1, 3)]
  helpers.create_bold_label(common_x, LEVEL_HEIGHT - 150fx,
    main_label_text, color, 5.2048fx, 0fx, -TILT_ANGLE*1.2048fx, 7)

  local text2 = "Thanks for playing my level!"
  helpers.create_bold_label(common_x, LEVEL_HEIGHT - 300fx,
    text2, 0xffffffff, 2fx, 0fx, -TILT_ANGLE*1.2048fx, 3)

  local text3 = "Here are some bonuses for you:"
  helpers.create_bold_label(common_x, LEVEL_HEIGHT - 375fx,
    text3, 0xffffffff, 2fx, 0fx, -TILT_ANGLE*1.2048fx, 3)

end


return module
