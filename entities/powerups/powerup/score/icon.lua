-- [TODO: make unique icon]

r = 22
b = r/2.5
a = r/5

meshes = {
  {
    vertexes = {
      {b, -a}, {b, a}, {a, a}, {a, b}, {-a, b}, {-a, a}, {-b, a}, {-b, -a}, {-a, -a}, {-a, -b},
      {a, -b}, {a, -a},
    },
    segments = {{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 0}}
  }
}
