part of rendering;

/// Provides instructions on how depth testing should be performed.
///
/// In order to do a depth test, a [Frame] must have a depth buffer. A depth
/// buffer stores a depth value between `0.0` (close) and `1.0` (far) for each
/// fragment. Initially the depth value for each fragment is set to `1.0`. When
/// rendering to a [Frame] with no depth buffer attached, the depth test behaves
/// as though depth testing is disabled.
///
/// The depth test is performed for each fragment. The fragment's depth output
/// will be mapped onto the range defined by [rangeNear] and [rangeFar]. The
/// resulting depth value may then be compared to the depth buffer's current
/// depth value for this fragment using the [testFunction]. The [testFunction]
/// can be one of the following functions:
///
/// - `TestFunction.equal`: the test passes if the fragment's depth value is
///   equal to the depth buffer's current depth value for this fragment.
/// - `TestFunction.notEqual`: the test passes if the fragment's depth value is
///   not equal to the depth buffer's current depth value for this fragment.
/// - `TestFunction.less`: the test passes if the fragment's depth value is
///   smaller than the depth buffer's current depth value for this fragment.
/// - `TestFunction.greater`: the test passes if the fragment's depth value is
///   greater than the depth buffer's current depth value for this fragment.
/// - `TestFunction.lessOrEqual`: the test passes if the fragment's depth value
///   is smaller than or equal to the depth buffer's current depth value for
///   this fragment.
/// - `TestFunction.greaterOrEqual`: the test passes if the fragment's depth
///   value is greater than or equal to the depth buffer's current depth value
///   for this fragment.
/// - `TestFunction.neverPass`: the test never passes, regardless of how the
///   fragment's depth value compares to the depth buffer's current depth value
///   for this fragment.
/// - `TestFunction.alwaysPass`: the test always passes, regardless of how the
///   fragment's depth value compares to depth buffer's current depth value for
///   this fragment.
///
/// If the test fails, the fragment will be discarded: none of the [Frame]'s
/// output buffers will be updated. If the test passes and [write] is `true`,
/// then the depth buffer's depth value for this fragment will be replaced with
/// the new depth value.
class DepthTest {
  /// The [TestFunction] used to decide if the [DepthTest] passes or fails.
  ///
  /// Can be set to employ one of the following functions:
  ///
  /// - `TestFunction.equal`: the test passes if the fragment's depth value is
  ///   equal to the current depth value in the depth buffer.
  /// - `TestFunction.notEqual`: the test passes if the fragment's depth value
  ///   is not equal to the current depth value in the depth buffer.
  /// - `TestFunction.less`: the test passes if the fragment's depth value is
  ///   smaller than the current depth value in the depth buffer.
  /// - `TestFunction.greater`: the test passes if the fragment's depth value is
  ///   greater than the current depth value in the depth buffer.
  /// - `TestFunction.lessOrEqual`: the test passes if the fragment's depth
  ///   value is smaller than or equal to the current depth value in the depth
  ///   buffer.
  /// - `TestFunction.greaterOrEqual`: the test passes if the fragment's depth
  ///   value is greater than or equal to the current depth value in the depth
  ///   buffer.
  /// - `TestFunction.neverPass`: the test never passes, regardless of how the
  ///   fragment's depth value compares to the current depth value in the depth
  ///   buffer.
  /// - `TestFunction.alwaysPass`: the test always passes, regardless of how the
  ///   fragment's depth value compares to the current depth value in the depth
  ///   buffer.
  final TestFunction testFunction;

  /// Whether or not the depth buffer will be updated when the depth test
  /// passes.
  ///
  /// When set to `false`, the depth buffer will not be updated when the depth
  /// test passes.
  final bool write;

  /// The value onto which the near clipping plane will be mapped.
  ///
  /// Must be between 0.0 and 1.0 and must be smaller than [rangeFar], otherwise
  /// rendering will result in an error.
  final double rangeNear;

  /// The value onto which the far clipping plane will be mapped.
  ///
  /// Must be between 0.0 and 1.0 and must be greater than [rangeNear],
  /// otherwise rendering will result in an error.
  final double rangeFar;

  /// Specifies the scaling factor and units for polygon depth values.
  ///
  /// See [PolygonOffset] for details.
  final PolygonOffset polygonOffset;

  /// Returns new instructions for the [DepthTest].
  ///
  /// Takes 4 optional parameters:
  ///
  /// - [testFunction]: the function used to determine if the [DepthTest]
  ///   passes. See [testFunction] for details. Defaults to `TestFunction.less`.
  /// - [write]: whether or not the depth buffer will be updated if the
  ///   [DepthTest] passes. See [write] for details. Defaults to `true`.
  /// - [rangeNear]: the value onto which the near clipping plane will be
  ///   mapped. See [rangeNear] for details. Defaults to `0.0`.
  /// - [rangeFar]: the value onto which the far clipping plane will be mapped.
  ///   See [rangeFar] for details. Defaults to `1.0`.
  /// - [polygonOffset]: the scaling factor and units for polygon depth values.
  ///   See [PolygonOffset] for details. Default to `null`, in which case
  ///   polygon offsetting will be disabled.
  const DepthTest(
      {this.testFunction: TestFunction.less,
      this.write: true,
      this.rangeNear: 0.0,
      this.rangeFar: 1.0,
      this.polygonOffset});

  bool operator ==(other) =>
      identical(other, this) ||
      other is DepthTest &&
          other.testFunction == testFunction &&
          other.write == write &&
          other.rangeNear == rangeNear &&
          other.rangeFar == rangeFar;

  int get hashCode => hash4(testFunction.hashCode, write.hashCode,
      rangeNear.hashCode, rangeFar.hashCode);

  String toString() => 'DepthTest(testFunction: $testFunction, write: $write, '
      'rangeNear: $rangeNear, rangeFar: $rangeFar)';
}

/// Specifies the scaling factor and units for polygon depth values.
///
/// The value of the offset is `factor * DZ + r * units`, where `DZ` is a
/// measurement of the change in depth relative to the screen area of the
/// polygon, and `r` is the smallest value that is guaranteed to produce a
/// resolvable offset for a given implementation.
///
/// The polygon offset is applied before the depth test is performed and before
/// the depth value is written to the depth buffer.
///
/// Useful for rendering coplanar primitives. Can be used to prevent what is
/// called "stitching", "bleeding" or "Z-fighting", where fragments with very
/// similar z-values do not always produce predictable results.
///
/// Only applies to fragments from polygonal primitives (triangles); ignored
/// for fragments from other primitives (points, lines). If you are rendering
/// e.g. a coplanar triangle and line, specify a polygon offset to push back
/// the triangle, rather than attempting to push forward the line.
class PolygonOffset {
  /// A scale factor that is used to create a variable depth offset for each
  /// polygon.
  final double factor;

  /// Is multiplied by an implementation-specific value to create a constant
  /// depth offset.
  final double units;

  /// Returns a new [PolygonOffset] specification.
  ///
  /// Takes 2 optional parameters:
  ///
  /// - [factor]: specifies a scale factor that is used to create a variable
  ///   depth offset for each polygon.
  /// - [units]: is multiplied by an implementation-specific value to create a
  ///   constant depth offset.
  const PolygonOffset([this.factor = 0.0, this.units = 0.0]);

  bool operator ==(other) =>
      identical(other, this) ||
      other is PolygonOffset && other.factor == factor && other.units == units;

  int get hashCode => hash2(factor, units);

  String toString() => 'PolygonOffset($factor, $units)';
}
