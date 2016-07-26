# BaGL Change Log

## 0.2.0

- BREAKING: `IndexGeometry` now takes a type parameter `Primitive` (should be of 
  type `Point`, `Line` or `Triangle`) and extends `Iterable<Primitive>`.
- BREAKING: `VertexArrayBuilder` and `VertexArray.toBuilder()` have been 
  removed. For the moment I'm not sure they belong in this library and they 
  introduce a lot of complexity. May be added back in at a later point in time.
- BREAKING: the keys and values for the draw parameter `attributeNameMap` have
  been reversed: keys should now be names as they appear in the shader program,
  values should be the name of the attribute on the geometry.
- BREAKING: `Frame.draw` no longer allows missing attributes. If an attribute is
  active on the shader program, then the geometry must define a matching 
  attribute (either by defining an attribute with the same name, or through a 
  mapping provided by the `attributeNameMap` draw parameter).
- The `geometry` provided to a `Frame.draw` call may now define attributes that 
  are not used by the shader program without raising an error.
