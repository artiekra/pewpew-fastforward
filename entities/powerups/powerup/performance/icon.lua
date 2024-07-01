r = 22
b = r/2.5
a = r/5
z = 0

meshes = {
  {
    vertexes = {
      {-b, 0, z}, {0, b, z},
      {b, 0, z}, {0, -b, z},
    },
    segments = {{0, 1, 2, 3, 0}}
  }
}

