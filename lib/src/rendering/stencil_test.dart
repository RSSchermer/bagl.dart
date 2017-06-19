part of bagl.rendering;

/// Provides instructions on how stencil testing should be performed.
///
/// In order to do a stencil test, a [Frame] must have a stencil buffer. A
/// stencil buffer stores two stencil values for each fragment:
///
/// - A `Front` stencil value: front-facing fragments will be tested against
///   this value. Fragments sampled from points or lines are always considered
///   front-facing. Triangles are considered to have a front face and a back
///   face, see [WindingOrder] for details on how this is decided. A fragment
///   originating from a triangle is considered front-facing if it was sampled
///   from the front face.
/// - A `Back` stencil value: back-facing fragments will be tested again this
///   value. A fragment is considered back-facing if it was sampled from the
///   back face of a triangle.
///
/// The stencil buffer stores these stencil values as unsigned integers. This
/// means that for an 8-bit stencil buffer, stencil values can range from `0`
/// (`00000000`) to 255 (`11111111`). Initially both the `Front` and the `Back`
/// stencil values are set to `0` for each fragment in the stencil buffer. When
/// rendering to a [Frame] with no stencil buffer attached, the stencil test
/// behaves as though stencil testing is disabled.
///
/// The stencil test is performed for each fragment. [testFunctionFront]
/// specifies the function that is used to test front-facing fragments;
/// [testFunctionBack] specifies the function that is used to test back-facing
/// fragments. For each fragment sampled from a primitive (a point, line or
/// triangle) the [referenceValue] may be compared to the relevant stencil
/// value (`Front` or `Back`) for this fragment in the stencil buffer. The
/// bitmask defined by [testMask] will be applied to both the [referenceValue]
/// and the stencil buffer value with the bitwise `AND` operation (`&`), before
/// the test function is evaluated. This allows masking off certain bits,
/// reserving them for different conditional tests. The following test functions
/// are available:
///
/// - `TestFunction.equal`: the test passes if `referenceValue & testMask` is
///   equal to `stencilValue & testMask`.
/// - `TestFunction.notEqual`: the test passes if `referenceValue & testMask` is
///   not equal to `stencilValue & testMask`.
/// - `TestFunction.less`: the test passes if `referenceValue & testMask` is
///   smaller than `stencilValue & testMask`.
/// - `TestFunction.greater`: the test passes if `referenceValue & testMask` is
///   greater than `stencilValue & testMask`.
/// - `TestFunction.lessOrEqual`: the test passes if `referenceValue & testMask`
///   is smaller than or equal to `stencilValue & testMask`.
/// - `TestFunction.greaterOrEqual`: the test passes if
///   `referenceValue & testMask` is greater than or equal to
///   `stencilValue & testMask`.
/// - `TestFunction.neverPass`: the test never passes, regardless of how
///   `referenceValue & testMask` compares to `stencilValue & testMask`.
/// - `TestFunction.alwaysPass`: the test always passes, regardless of how
///   `referenceValue & testMask` compares to `stencilValue & testMask`.
///
/// Typically, if the [DepthTest] or [StencilTest] fail, a fragment will be
/// discarded and a [Frame]'s output buffers will not be updated. However, the
/// stencil buffer is exceptional in that it may be updated even if the
/// [DepthTest] or the [StencilTest] fails, or both tests fail. There are 3
/// relevant cases:
///
/// 1.  The [StencilTest] fails. The [StencilTest] is performed before the
///     [DepthTest]. If the [StencilTest] fails the [DepthTest] will not be
///     performed.
/// 2.  The [StencilTest] passes, but the [DepthTest] fails. If depth testing
///     is disabled, then it is always assumed to pass and this case will never
///     occur.
/// 3.  The [StencilTest] passes and the [DepthTest] passes. If depth testing
///     is disabled, then it is always assumed to pass.
///
/// For each of these 3 cases the update operation that is performed on the
/// stencil buffer can be controlled. For the `Front` stencil value this
/// controlled by [failOperationFront] (case 1), [passDepthFailOperationFront]
/// (case 2), and [passOperationFront] (case 3) for each case respectively. For
/// the `Back` stencil value this is controlled by [failOperationBack] (case 1),
/// [passDepthFailOperationBack] (case 2), and [passOperationBack] (case 3) for
/// each case respectively. The following stencil update operations are
/// available:
///
/// - `StencilOperation.keep`: the stencil value in the stencil buffer is not
///   updated.
/// - `StencilOperation.zero`: the stencil value in the stencil buffer is set
///   to `0`.
/// - `StencilOperation.replace`: the stencil value in the stencil buffer is
///   replaced with the fragment's new stencil value.
/// - `StencilOperation.increment`: the stencil value in the stencil buffer is
///   incremented. If the current stencil value is the maximum value, don't do
///   anything.
/// - `StencilOperation.wrappingIncrement`: the stencil value in the stencil
///   buffer is incremented. If the current stencil value is the maximum value,
///   set the value to `0`.
/// - `StencilOperation.decrement`: the stencil value in the stencil buffer is
///   decremented. If the current stencil value is `0`, don't do anything.
/// - `StencilOperation.wrappingDecrement`: the stencil value in the stencil
///   buffer is decremented. If the current stencil value is `0`, set the value
///   to the maximum stencil value.
/// - `StencilOperation.invert`: inverts the bits of the stencil value in the
///   stencil buffer (for example: `10110011` becomes `01001100`).
///
/// Finally, the bitmask specified by [writeMask] controls which individual bits
/// can be written too. Suppose an 8-bit stencil buffer and a [writeMask] of
/// `0000011`, then only the final two bits will be updated; where `0` appears,
/// the bits are write-protected.
class StencilTest {
  /// The [TestFunction] used by this [StencilTest] for front-facing fragments.
  ///
  /// Only applies to fragments that originate from front-facing triangles,
  /// lines or points. For fragments originating from back-facing triangles
  /// [testFunctionBack] is used instead.
  ///
  /// See the class documentation for [StencilTest] for details on how the
  /// available functions are evaluated.
  final TestFunction testFunctionFront;

  /// The [StencilOperation] that will be used to update the stencil buffer when
  /// a front-facing fragment passes neither the [DepthTest], nor
  /// [testFunctionFront].
  ///
  /// Only applies to fragments that originate from front-facing triangles,
  /// lines or points. For fragments originating from back-facing triangles
  /// [failOperationBack] is used instead.
  final StencilOperation failOperationFront;

  /// The [StencilOperation] that will be used to update the stencil buffer when
  /// a front-facing fragment passes the [DepthTest], but fails
  /// [testFunctionFront].
  ///
  /// Only applies to fragments that originate from front-facing triangles,
  /// lines or points. For fragments originating from back-facing triangles
  /// [passDepthFailOperationBack] is used instead.
  final StencilOperation passDepthFailOperationFront;

  /// The [StencilOperation] that will be used to update the stencil buffer when
  /// a front-facing fragment passes both the [DepthTest] and
  /// [testFunctionFront].
  ///
  /// Only applies to fragments that originate from front-facing triangles,
  /// lines or points. For fragments originating from back-facing triangles
  /// [passOperationBack] is used instead.
  final StencilOperation passOperationFront;

  /// The function that will be used by the stencil test to test back-facing
  /// fragments.
  ///
  /// Only applies to fragments that originate from back-facing triangles. For
  /// fragments originating from lines, points and front-facing triangles
  /// [testFunctionFront] is used instead.
  ///
  /// See the class documentation for [StencilTest] for details on how the
  /// available functions are evaluated.
  final TestFunction testFunctionBack;

  /// The [StencilOperation] that will be used to update the stencil buffer when
  /// a back-facing fragment passes neither the [DepthTest], nor
  /// [testFunctionBack].
  ///
  /// Only applies to fragments that originate from back-facing triangles. For
  /// fragments originating from lines, points and front-facing triangles
  /// [failOperationFront] is used instead.
  final StencilOperation failOperationBack;

  /// The [StencilOperation] that will be used to update the stencil buffer when
  /// a back-facing fragment passes the [DepthTest], but fails
  /// [testFunctionBack].
  ///
  /// Only applies to fragments that originate from back-facing triangles. For
  /// fragments originating from lines, points and front-facing triangles
  /// [passDepthFailOperationFront] is used instead.
  final StencilOperation passDepthFailOperationBack;

  /// The [StencilOperation] that will be used to update the stencil buffer when
  /// a back-facing fragment passes both the [DepthTest] and [testFunctionBack].
  ///
  /// Only applies to fragments that originate from back-facing triangles. For
  /// fragments originating from lines, points and front-facing triangles
  /// [passOperationFront] is used instead.
  final StencilOperation passOperationBack;

  /// The value that is compared to a fragment's stencil values in the stencil
  /// buffer, in order to decide if the fragment passes the stencil test.
  ///
  /// See the class documentation for [StencilTest] class for details on how
  /// this [referenceValue] is used in stencil testing.
  final int referenceValue;

  /// The bitmask that is applied to both the [referenceValue] and the stencil
  /// value in the stencil buffer to which it is compared, before a stencil
  /// test is evaluated.
  ///
  /// Can be used to mask off certain bits, reserving them for different
  /// conditional tests.
  ///
  /// See the class documentation for [StencilTest] for details on how the
  /// [testMask] is applied.
  final int testMask;

  /// The bitmask that controls which of a stencil value's individual bits may
  /// be updated in the stencil buffer.
  ///
  /// Suppose an 8-bit stencil buffer and a [writeMask] of `0000011`, then only
  /// the final two bits will be updated; where `0` appears, the bits are
  /// write-protected.
  final int writeMask;

  /// Returns new instructions for the [StencilTest].
  ///
  /// Takes 11 optional parameters:
  ///
  /// - [testFunctionFront]: the function used to test front-facing fragments.
  ///   See [testFunctionFront] for details. Defaults to
  ///   `TestFunction.alwaysPass`.
  /// - [failOperationFront]: the [StencilOperation] that will be used to update
  ///   the stencil buffer when a front-facing fragment passes neither the
  ///   [DepthTest], nor [testFunctionFront]. See [failOperationFront] for
  ///   details. Defaults to `StencilOperation.keep`.
  /// - [passDepthFailOperationFront]: the [StencilOperation] that will be used
  ///   to update the stencil buffer when a front-facing fragment passes the
  ///   [DepthTest], but fails [testFunctionFront]. See
  ///   [passDepthFailOperationFront] for details. Defaults to
  ///   `StencilOperation.keep`.
  /// - [passOperationFront]: the [StencilOperation] that will be used to update
  ///   the stencil buffer when a front-facing fragment passes both the
  ///   [DepthTest] and [testFunctionFront]. See [passOperationFront] for
  ///   details. Defaults to `StencilOperation.keep`.
  /// - [testFunctionBack]: the function used to test back-facing fragments. See
  ///   [testFunctionBack] for details. Defaults to `TestFunction.alwaysPass`.
  /// - [failOperationBack]: the [StencilOperation] that will be used to update
  ///   the stencil buffer when a back-facing fragment passes neither the
  ///   [DepthTest], nor [testFunctionBack]. See [failOperationBack] for
  ///   details. Defaults to `StencilOperation.keep`.
  /// - [passDepthFailOperationBack]: the [StencilOperation] that will be used
  ///   to update the stencil buffer when a back-facing fragment passes the
  ///   [DepthTest], but fails [testFunctionBack]. See
  ///   [passDepthFailOperationBack] for details. Defaults to
  ///   `StencilOperation.keep`.
  /// - [passOperationBack]: the [StencilOperation] that will be used to update
  ///   the stencil buffer when a back-facing fragment passes both the
  ///   [DepthTest] and [testFunctionBack]. See [passOperationBack] for
  ///   details. Defaults to `StencilOperation.keep`.
  /// - [referenceValue]: the value that is compared to a fragment's stencil
  ///   values in the stencil buffer, in order to decide if the fragment passes
  ///   the stencil test. See [referenceValue] for details. Defaults to `0`.
  /// - [testMask]: the bitmask that is applied to both the [referenceValue] and
  ///   the stencil value in the stencil buffer to which it is compared, before
  ///   a stencil test is evaluated. See [testMask] for details. Defaults to
  ///   all 1s (e.g. `1111111` for an 8-bit stencil buffer).
  /// - [writeMask]: the bitmask that controls which of a stencil value's
  ///   individual bits may be updated in the stencil buffer. See [writeMask]
  ///   for details. Defaults to all 1s (e.g. `1111111` for an 8-bit stencil
  ///   buffer).
  const StencilTest(
      {this.testFunctionFront: TestFunction.alwaysPass,
      this.failOperationFront: StencilOperation.keep,
      this.passDepthFailOperationFront: StencilOperation.keep,
      this.passOperationFront: StencilOperation.keep,
      this.testFunctionBack: TestFunction.alwaysPass,
      this.failOperationBack: StencilOperation.keep,
      this.passDepthFailOperationBack: StencilOperation.keep,
      this.passOperationBack: StencilOperation.keep,
      this.referenceValue: 0,
      this.testMask: 0xffffffff,
      this.writeMask: 0xffffffff});

  bool operator ==(other) =>
      identical(other, this) ||
      other is StencilTest &&
          other.testFunctionFront == testFunctionFront &&
          other.failOperationFront == failOperationFront &&
          other.passDepthFailOperationFront == passDepthFailOperationFront &&
          other.passOperationFront == passOperationFront &&
          other.testFunctionBack == testFunctionBack &&
          other.failOperationBack == failOperationBack &&
          other.passDepthFailOperationBack == passDepthFailOperationBack &&
          other.passOperationBack == passOperationBack &&
          other.referenceValue == referenceValue &&
          other.testMask == testMask &&
          other.writeMask == writeMask;

  int get hashCode => hash3(
      hash4(testFunctionFront.hashCode, failOperationFront.hashCode,
          passDepthFailOperationFront.hashCode, passOperationFront.hashCode),
      hash4(testFunctionBack.hashCode, failOperationBack.hashCode,
          passDepthFailOperationBack.hashCode, passOperationBack.hashCode),
      hash3(referenceValue.hashCode, testMask.hashCode, writeMask.hashCode));

  String toString() => 'StencilTest(testFunctionFront: $testFunctionFront, '
      'failOperationFront: $failOperationFront, passDepthFailOperationFront: '
      '$passDepthFailOperationFront, passOperationFront: $passOperationFront, '
      'testFunctionBack: $testFunctionBack, failOperationBack: '
      '$failOperationBack, passDepthFailOperationBack: '
      '$passDepthFailOperationBack, passOperationBack: $passOperationBack, '
      'referenceValue: $referenceValue, testMask: $testMask, writeMask: '
      '$writeMask)';
}

/// Enumerates the operations that can be performed on a stencil fragment as a
/// result of the [StencilTest].
///
/// See the documentation for [StencilTest] for details.
enum StencilOperation {
  keep,
  zero,
  replace,
  increment,
  wrappingIncrement,
  decrement,
  wrappingDecrement,
  invert
}
