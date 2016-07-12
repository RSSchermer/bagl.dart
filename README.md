# BaGL.dart: Basic Graphics Library for Dart.

*WIP*: expect changes to public interfaces, missing features and bugs. Please
feel free to open issues on missing functionality and changes to public 
interfaces.

BaGL is a low-level abstraction on top of WebGL. It aims to provide a simpler,
safer and more declarative drawing alternative to plain WebGL. BaGL was inspired 
by [Glium](https://github.com/tomaka/glium) and [Elm WebGL](https://github.com/elm-community/elm-webgl).

# Usage

## Examples

Some basic examples are available in the [example](example) folder:

- [Triangle](example/triangle): the "hello world" of the graphics world, drawing
  a single triangle.
- [Animated triangle](example/triangle_animated): demonstrates an animation loop
  with a triangle whose size oscillates.
- [Textured triangle](example/triangle_textured): demonstrates "UV" texturing 
  with a 2D texture from a separate `png` file.

## Documentation

API documentation is available [here](https://www.dartdocs.org/documentation/bagl/latest/).
