part of rendering;

/// Enumerates the functions [DepthTest] or a [StencilTest] can use to decide if
/// the test passes.
///
/// See the documentation for [DepthTest] and [StencilTest] for details on how
/// both these tests apply these functions.
enum TestFunction {
  equal,
  notEqual,
  less,
  greater,
  lessOrEqual,
  greaterOrEqual,
  neverPass,
  alwaysPass
}
