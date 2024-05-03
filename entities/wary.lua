c_vertexes={}
c_colors={}
c_segments={}
c_vertexes1={}
c_colors1={}
c_segments1={}

local mn1=6
local fk=2*math.pi
local r1=22
local r2=22
local index1 = 0
local c1=0x0000ffff
local c2=0x9900ffff
local segm1 =fk/mn1

for k=1,mn1 do

local x=math.sin(k*segm1)*r1
local y=math.cos(k*segm1)*r2
table.insert(c_vertexes,{x,y})
table.insert(c_colors,c1)
if k~=mn1 then table.insert(c_segments,{index1,index1+1}) else table.insert(c_segments,{index1,index1+1-mn1}) end
index1=index1+1

end
table.insert(c_vertexes,{-1/3,-1/3})
table.insert(c_vertexes,{1/3,-1/3})
table.insert(c_vertexes,{1/3,1/3})
table.insert(c_vertexes,{-1/3,1/3})
table.insert(c_colors,c2)
table.insert(c_colors,c2)
table.insert(c_segments,{mn1,mn1+1,mn1+2,mn1+3,mn1})
meshes = {
  {
    vertexes = c_vertexes,
    segments = c_segments,
    colors = c_colors
  },
}
