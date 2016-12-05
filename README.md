# BaGL.dart: Basic Graphics Library for Dart.

*WIP: expect changes to public interfaces, missing features and bugs. Please
feel free to open issues on missing functionality and changes to public 
interfaces.*

BaGL is a low-level abstraction on top of WebGL. It aims to provide a simpler,
safer and more declarative drawing alternative to plain WebGL. BaGL was inspired 
by [Glium](https://github.com/tomaka/glium) and [Elm WebGL](https://github.com/elm-community/elm-webgl).

# Usage

## Examples

Some basic examples are available in the [example](example) folder:

- Triangle ([dart](https://github.com/RSSchermer/bagl.dart/tree/master/example/triangle/main.dart),
  [html](https://github.com/RSSchermer/bagl.dart/tree/master/example/triangle/index.html)): 
  the "hello world" of the graphics world, drawing a single triangle.
- Animated triangle ([dart](https://github.com/RSSchermer/bagl.dart/tree/master/example/triangle_animated/main.dart),
  [html](https://github.com/RSSchermer/bagl.dart/tree/master/example/triangle_animated/index.html)): 
  demonstrates an animation loop with a triangle whose size oscillates.
- Textured triangle ([dart](https://github.com/RSSchermer/bagl.dart/tree/master/example/triangle_textured/main.dart),
  [html](https://github.com/RSSchermer/bagl.dart/tree/master/example/triangle_textured/index.html)): 
  demonstrates texturing with a 2D texture from a separate `png` file.
- Cube ([dart](https://github.com/RSSchermer/bagl.dart/tree/master/example/cube/main.dart),
  [html](https://github.com/RSSchermer/bagl.dart/tree/master/example/cube/index.html)): 
  demonstrates drawing a 3D mesh.
- Animated Cube ([dart](https://github.com/RSSchermer/bagl.dart/tree/master/example/cube_animated/main.dart),
  [html](https://github.com/RSSchermer/bagl.dart/tree/master/example/cube_animated/index.html)): 
  demonstrates an animation loop with a 3D mesh.
- Textured Cube ([dart](https://github.com/RSSchermer/bagl.dart/tree/master/example/cube_textured/main.dart),
  [html](https://github.com/RSSchermer/bagl.dart/tree/master/example/cube_textured/index.html)): 
  demonstrates texturing a 3D mesh with a 2D texture from a separate `png` file.

## Documentation

API documentation is available [here](https://www.dartdocs.org/documentation/bagl/latest/).
