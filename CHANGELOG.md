# BaGL Change Log

## 0.6.0

This version includes a refactor of the geometry APIs and several related 
breaking changes:

- BREAKING: `IndexGeometry` has been renamed to `PrimitiveSequence`.
- BREAKING: the default constructor signature of all `PrimitiveSequence`
  implementations (`Points`, `Lines`, `LineStrip`, `LineLoop`, `Triangles`,
  `TriangleStrip`, `TriangleFan`) has changed; the `indexList`, `offset` and 
  `count` are now optional named parameters.
- BREAKING: `TrianglesTriangleView`, `LinesLineView` and `PointsPointView` no
  longer allow updates of their vertex indices directly. Instead the index list
  of the `PrimitiveSequence` on which they are defined needs to be updated.
- BREAKING: the `index_geometry` library has been renamed to `geometry`.
- BREAKING: the `geometric_primitives` library has been removed; its contents
  were merged into the new `geometry` library.
- All `PrimitiveSequence` implementations (`Points`, `Lines`, `LineStrip`, 
  `LineLoop`, `Triangles`, `TriangleStrip`, `TriangleFan`) now allow 
  modification of the `count` after instantiation. This should help implement 
  dynamic geometry, in which the index list size is overprovisioned initially 
  such that later additional data can be added and the primitive sequence 
  expanded (by increasing the `count`) without having to recreate and rebind a 
  new buffer for each change.
- Adds `magnitude`, `unitVector` and `isUnit` fields to `Vector2`, `Vector3` and
  `Vector4`.

## 0.5.0

`LineLoopIterator`, `LineStripIterator`, `LinesIterator`, `PointsIterator`,
`TriangleFanIterator`, `TriangleStripIterator`, `TrianglesIterator`,
`AttributeDataTableIterator`, `AttributeDataRowViewIterator` and 
`VertexArrayIterator` were made private. These iterators provide nothing beyond
the expected `Iterator` API and were cluttering the API documentation.

## 0.4.0

- BREAKING: `deprovisionGeometry`, `deprovisionProgram` and `deprovisionSampler`
  have been removed from `RenderingContext`. Use 
  `context.geometryResource.deprovision`, `context.programResources.deprovision` 
  and 'context.samplerResources.deprovision` instead.  
- `RenderingContext` now exposes `geometryResources`, `programResources` and
  `samplerResources` fields to allow manual management of resource provisioning/
  deprovisioning.
- `Frame.draw` now takes `autoProvisioning` as an optional named parameter. When
  set to `false`, BaGL will not automagically provision GPU resources for you.
  Instead resources should have been provisioned manually prior to the draw
  call (see change above).
  
This version refactors the rendering internals to make heavy use of `Expando`s
so as to only hold on to weak references to geometry, programs and samplers.
This means that once geometry, program and sampler objects become inaccessible
in your code, these objects may be garbage collected by the Dart/Javascript 
runtime. Importantly, any GPU resources that BaGL previously provisioned
for these objects will then also be freed by the runtime. This means that in
most cases, you do not have to worry about deprovisioning these resources
manually.

## 0.3.0

- BREAKING: the `translation` constructors on `Matrix3` and `Matrix4` now take
  separate `double` values for each translation direction rather than a single 
  vector. This aligns the signature with the `scale` constructor signature.
- BREAKING: removes `withValues` and `withValuesTranspose` from `Vector2`, 
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
