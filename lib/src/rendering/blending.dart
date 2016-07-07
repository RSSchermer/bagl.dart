part of rendering;

/// Provides instructions on how blending should be performed.
///
/// When [Blending] is enabled, a fragment's color output does not merely
/// overwrite the color buffer's current color value for this fragment, but
/// instead these two values are combined together using a [BlendingFunction].
/// The new color output for the fragment is referred to as the source color,
/// the value already in the color buffer is referred to as the destination
/// color. Separate blending functions may be used for the RGB portion and for
/// the alpha portion of the color value; the respective blending functions are
/// specified by [colorFunction] and [alphaFunction]. The following blending
/// functions are available:
///
/// - `BlendingFunction.addition`: the result of blending is calculated as
///   `F_s * S + F_d * D`.
/// - `BlendingFunction.subtraction`: the result of blending is calculated as
///   `F_s * S - F_d * D`.
/// - `BlendingFunction.reverseSubtraction`: the result of blending is
///   calculated as `F_d * D - F_s * S`.
///
/// Here `S` is the relevant portion of the source value: the [colorFunction]
/// will use the red, green and blue components of the source color as `S`, the
/// [alphaFunction] will use the alpha components of the source color as `S`.
/// `D` is the relevant portion of the destination value: the [colorFunction]
/// will use the red, green and blue components of the destination color as `D`
/// and the [alphaFunction] will use the alpha component of the destination
/// color as `D`. `F_s` and `F_d` are [BlendingFactor]s for `S` and `D`
/// respectively. The following blending factors are available:
///
/// - `BlendingFactor.zero`: all color components are multiplied by `0`.
/// - `BlendingFactor.one`: all color components are multiplied by `1`.
/// - `BlendingFactor.sourceColor`: the value of each color component is
///   multiplied by the value of the corresponding component of the source
///   color.
/// - `BlendingFactor.oneMinusSourceColor`: the value of each color component is
///   multiplied by the value of the corresponding component of the source color
///   subtracted from `1`. For example, the red component is multiplied by
///   `1 - R_s`, where `R_s` is the value of the red component of the source
///   color.
/// - `BlendingFactor.destinationColor`: the value of each color component is
///   multiplied by the value of the corresponding component of the destination
///   color.
/// - `BlendingFactor.oneMinusDestinationColor`: the value of each color
///   component is multiplied by the value of the corresponding component of the
///   destination color subtracted from `1`. For example, the red component is
///   multiplied by `1 - R_d`, where `R_d` is the value of the red component of
///   the destination color.
/// - `BlendingFactor.sourceAlpha`: all color components are multiplied by the
///   value of the alpha component of the source color.
/// - `BlendingFactor.oneMinusSourceAlpha`: all color components are multiplied
///   by `1 - A_s`, where `A_s` is the value of the alpha component of the
///   source color.
/// - `BlendingFactor.destinationAlpha`: all color components are multiplied by
///   the value of the alpha component of the destination color.
/// - `BlendingFactor.oneMinusDestinationAlpha`: all color components are
///   multiplied by `1 - A_s`, where `A_s` is the value of the alpha component
///   of the destination color.
/// - `BlendingFactor.sourceAlphaSaturate`: all color components are multiplied
///   by the smaller of either `A_s` or `1 - A_d`, where `A_s` is the value of
///   the alpha component of the source color and `A_d` is the value of the
///   alpha component of the destination color.
class Blending {
  /// The [BlendingFactor] that the [colorFunction] applies to the source value.
  ///
  /// See the class documentation for [Blending] for details on how each of the
  /// available blending factors act.
  final BlendingFactor sourceColorFactor;

  /// The [BlendingFactor] that the [alphaFunction] applies to the source value.
  ///
  /// See the class documentation for [Blending] for details on how each of the
  /// available blending factors act.
  final BlendingFactor sourceAlphaFactor;

  /// The [BlendingFactor] that the [colorFunction] applies to the destination
  /// value.
  ///
  /// See the class documentation for [Blending] for details on how each of the
  /// available blending factors act.
  final BlendingFactor destinationColorFactor;

  /// The [BlendingFactor] that the [alphaFunction] applies to the destination
  /// value.
  ///
  /// See the class documentation for [Blending] for details on how each of the
  /// available blending factors act.
  final BlendingFactor destinationAlphaFactor;

  /// The [BlendingFunction] used to combine the red, green and blue components
  /// or the source and destination colors.
  ///
  /// See the documentation for [Blending] for details on how each of the
  /// available blending functions act.
  final BlendingFunction colorFunction;

  /// The [BlendingFunction] used to combine the alpha components or the source
  /// and destination colors.
  ///
  /// See the documentation for [Blending] for details on how each of the
  /// available blending functions act.
  final BlendingFunction alphaFunction;

  /// Creates new instructions for [Blending].
  const Blending(
      {this.sourceColorFactor: BlendingFactor.one,
      this.sourceAlphaFactor: BlendingFactor.one,
      this.destinationColorFactor: BlendingFactor.one,
      this.destinationAlphaFactor: BlendingFactor.one,
      this.colorFunction: BlendingFunction.addition,
      this.alphaFunction: BlendingFunction.addition});

  bool operator ==(other) =>
      identical(other, this) ||
      other is Blending &&
          other.sourceColorFactor == sourceColorFactor &&
          other.sourceAlphaFactor == sourceAlphaFactor &&
          other.destinationColorFactor == destinationColorFactor &&
          other.destinationAlphaFactor == destinationAlphaFactor &&
          other.colorFunction == colorFunction &&
          other.alphaFunction == alphaFunction;

  int get hashCode => hash2(
      hash3(sourceColorFactor.hashCode, sourceAlphaFactor.hashCode,
          destinationColorFactor.hashCode),
      hash3(destinationAlphaFactor.hashCode, colorFunction.hashCode,
          alphaFunction.hashCode));
}

/// Enumerates the possible blending factors that can be applied to color
/// values during [Blending].
///
/// See the documentation for [Blending] for details on how these blending
/// factors are used and what their effects are.
enum BlendingFactor {
  zero,
  one,
  sourceColor,
  oneMinusSourceColor,
  destinationColor,
  oneMinusDestinationColor,
  sourceAlpha,
  oneMinusSourceAlpha,
  destinationAlpha,
  oneMinusDestinationAlpha,
  sourceAlphaSaturate
}

/// Enumerates the available functions that can be employed to perform
/// [Blending].
///
/// See the documentation for [Blending] for details on how these functions act.
enum BlendingFunction { addition, subtraction, reverseSubtraction }
