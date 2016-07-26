# BaGL Change Log

## 0.2.0

BREAKING: `IndexGeometry` now takes a type parameter `Primitive` (should be of 
type `Point`, `Line` or `Triangle`) and extends `Iterable<Primitive>`.

BREAKING: `VertexArrayBuilder` and `VertexArray.toBuilder()` have been removed.
For the moment I'm not sure they belong in this library and they introduce a lot
of complexity. May be added back in at a later point in time.
