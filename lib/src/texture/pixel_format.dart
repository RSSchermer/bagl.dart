part of bagl.texture;

/// Enumerates the available pixel formats.
///
/// The following pixel formats are available:
///
/// - [RGB]: pixels stored in this format have 3 channels: a red, green and blue
///   channel, typically used to specify the intensity of these colors for the
///   pixel respectively.
/// - [RGBA]: pixels stored in this format have 4 channels: a red, green and
///   blue channel, typically used to specify the intensity of these colors for
///   the pixel respectively, and an alpha channel, typically used to specify
///   the opacity of the pixel.
/// - [luminance]: pixels stores in this format only have a single luminance
///   channel. This format is typically used for greyscale images.
/// - [luminanceAlpha]: pixels stored in this format have 2 channels: a
///   luminance channel, typically used to specify the intensity of the pixel,
///   and an alpha channel, typically sued to specify the opacity of the pixel.
/// - [alpha]: pixels stored in this format only have a single alpha channel.
enum PixelFormat { RGB, RGBA, luminance, luminanceAlpha, alpha }
