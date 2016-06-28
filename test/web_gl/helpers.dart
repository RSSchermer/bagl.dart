import 'dart:html';
import 'dart:typed_data';

import 'package:test/test.dart';

/// Returns a matcher which matches if the match argument is an image that
/// resembles the [image].
///
/// A [mismatchThreshold] may be specified to allow a certain ratio of different
/// pixels between the matched image and the expected [image]. If the pixel
/// mismatch ratio is below this threshold, the matcher matches. If the pixel
/// mismatch ratio is above this threshold, the matches does not match. The
/// [mismatchThreshold] defaults to `0`.
///
/// An [rgbaThreshold] may be specified to allow a certain difference between
/// a pixel value in the matched image and the corresponding pixel value in the
/// expected [image]. Each color component (red, green, blue, alpha) is compared
/// separately. If the difference between the matched value and the expected
/// value is greater than the [rgbaThreshold], then a mismatch is counted.
closeToImage(image, [num mismatchThreshold = 0, int rgbaThreshold = 0]) {
  return new _ImageMatcher(image, mismatchThreshold, rgbaThreshold);
}

class _ImageMatcher extends Matcher {
  final _expected;

  final _PixelData _expectedPixelData;

  final num _mismatchThreshold;

  final int _rgbaThreshold;

  _ImageMatcher(expected,
      [this._mismatchThreshold = 0, this._rgbaThreshold = 0])
      : _expected = expected,
        _expectedPixelData = _resolvePixelData(expected);

  bool matches(item, Map matchState) {
    var pixelData;

    try {
      pixelData = _resolvePixelData(item);
    } catch (e) {
      return false;
    }

    final width = pixelData.width;
    final height = pixelData.height;

    if (width != _expectedPixelData.width) {
      return false;
    } else if (height != _expectedPixelData.height) {
      return false;
    } else {
      final data = pixelData.data;
      final expectedData = _expectedPixelData.data;
      final pixelCount = width * height;
      var mismatchCount = 0;

      for (var i = 0; i < height; i++) {
        for (var j = 0; j < width; j++) {
          var mismatch = false;

          for (var k = 0; k < 4; k++) {
            final actual = data[(i * width + j) * 4 + k];
            final expected = expectedData[(i * width + j) * 4 + k];

            if ((actual - expected).abs() > _rgbaThreshold) {
              mismatch = true;
            }
          }

          if (mismatch) {
            mismatchCount++;
          }
        }
      }

      final mismatchRatio = mismatchCount / pixelCount;

      matchState['mismatchRatio'] = mismatchRatio;

      if (mismatchCount / pixelCount < _mismatchThreshold) {
        return true;
      } else {
        return false;
      }
    }
  }

  Description describe(Description description) => description
      .add('an image which differs in at most ${_mismatchThreshold * 100}% '
          'of pixels from ')
      .addDescriptionOf(_expected);

  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is ImageElement || item is CanvasElement || item is ImageData) {
      final pixelData = _resolvePixelData(item);

      if (pixelData.width != _expectedPixelData.width) {
        return mismatchDescription.add('does not have the expected width.');
      } else if (pixelData.height != _expectedPixelData.height) {
        return mismatchDescription.add('does not have the expected width.');
      } else {
        final mismatchRatio = matchState['mismatchRatio'] ?? 0;

        return mismatchDescription
            .add('differs at ${mismatchRatio * 100}% of pixels.');
      }
    } else {
      return mismatchDescription
          .add('is not a canvas element, image element, or image data');
    }
  }
}

class _PixelData {
  final Uint8List data;

  final int width;

  final int height;

  _PixelData(this.width, this.height, this.data);
}

_PixelData _resolvePixelData(value) {
  if (value is ImageData) {
    return new _PixelData(value.width, value.height, value.data);
  } else if (value is CanvasElement) {
    final width = value.width;
    final height = value.height;

    if (value.context2D != null) {
      final imageData = value.context2D.getImageData(0, 0, width, height);
      final data = new Uint8List.fromList(imageData.data);

      return new _PixelData(width, height, data);
    } else {
      final canvas = new CanvasElement(width: width, height: height);
      final context = canvas.context2D;

      context.drawImage(value, 0, 0);

      final imageData = context.getImageData(0, 0, width, height);
      final data = new Uint8List.fromList(imageData.data);

      return new _PixelData(width, height, data);
    }
  } else if (value is ImageElement) {
    final width = value.naturalWidth;
    final height = value.naturalHeight;
    final canvas = new CanvasElement(width: width, height: height);
    final context = canvas.context2D;

    context.drawImage(value, 0, 0);

    final imageData = context.getImageData(0, 0, width, height);
    final data = new Uint8List.fromList(imageData.data);

    return new _PixelData(width, height, data);
  } else {
    throw new ArgumentError('Cannot resolve image data for the given value. '
        'Value must be a CanvasElement or an ImageElement or ImageData');
  }
}
