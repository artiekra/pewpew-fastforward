-- [TODO: combine some of the functions with the ones from entities/misc/labels]

require"globals"
require"entities/misc/end_screen/data"

local helpers = require"entities/helpers/labels"

local module = {}


-- Show end screen text
function module.show()
  log.debug("endscr", "Request to trigger end screen..")

  -- [TODO: maybe change the responsibility for this to another module?]
  -- [TODO: make this smooth]
  camera.offset_z = -750fx

  local color = 0x5000ffff

  local main_label_text = MAIN_LABEL_VARIATIONS[random(1, 3)]
  helpers.create_bold_label(LEVEL_WIDTH/2fx, LEVEL_HEIGHT/2fx, main_label_text, color, 3fx, 0fx, 10)

end


return module
