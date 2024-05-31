-- thanks Flavour! :з

local x0 = -8
local x1 = -4
local x2 = 13
local y0 = -11

meshes = {
  {
    vertexes = {{x0,y0}, {x2,0}, {x0,-y0}, {x1,0},
      {x0,0,y0}, {x2,0,0}, {x0,0,-y0}, {x1,0,0}},
    segments = {{0,1,2,3,0}, {4,5,6,7,4}}
  }
}
