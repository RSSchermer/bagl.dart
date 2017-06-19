part of bagl.texture;

/// Enumerates the available pixel data types.
///
/// The following pixel data types are available:
///
/// - [unsignedByte]: each pixel channel is stored as a single unsigned byte
///   (8 bits).
/// - [unsignedShort_5_6_5]: each pixel has 3 channels and is stored as a single
///   unsigned short (16 bits). The first 5 bits store the value for the first
///   channel, the following 6 bits store the value for the second channel and
///   the final 5 bits store the value for the last channel.
/// - [unsignedShort_4_4_4_4]: each pixel has 4 channels and is stored as a
///   single unsigned short (16 bits). The first 4 bits store the value for the
///   first channel, the following 4 bits store the value for the second
///   channel, the next 4 bits store the value for the third channel, and the
///   final 4 bits store the value for the last channel.
/// - [unsignedShort_5_5_5_1]: each pixel has 4 channels and is stored as a
///   single unsigned short (16 bits). The first 5 bits store the value for the
///   first channel, the following 5 bits store the value for the second
///   channel, the next 5 bits store the value for the third channel, and the
///   final bit stores the value for the last channel.
enum PixelType {
  unsignedByte,
  unsignedShort_5_6_5,
  unsignedShort_4_4_4_4,
  unsignedShort_5_5_5_1
}
