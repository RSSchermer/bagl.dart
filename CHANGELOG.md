# BaGL Change Log

## 0.3.0

- Breaking: the `translation` constructors on `Matrix3` and `Matrix4` now take
  separate `double` values for each translation direction rather than a single 
  vector. This aligns the signature with the `scale` constructor signature.
- Breaking: removes `withValues` and `withValuesTranspose` from `Vector2`, 
  `Vector3`, `Vector4`, `Matrix2`, `Matrix3` and `Matrix4`. These methods are no
  longer necessary with rl_matrix 0.6.0 and had no real function in BaGL. Use
  the `fromList` constructors instead.
- Adds a `Struct` type. `Frame.draw` now accepts uniform values of type `Struct`
  and `List<Struct>`. These map to user defined struct types in GLSL shaders.

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
