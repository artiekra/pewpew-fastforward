-- thanks Flavour! :з

local scale = 1.25

local x0 = -8 * scale
local x1 = -4 * scale
local x2 = 13 * scale
local y0 = -11 * scale

meshes = {
  {
    vertexes = {{x0,y0}, {x2,0}, {x0,-y0}, {x1,0},
      {x0,0,y0}, {x2,0,0}, {x0,0,-y0}, {x1,0,0}},
    segments = {{0,1,2,3,0}, {4,5,6,7,4}}
  }
}
