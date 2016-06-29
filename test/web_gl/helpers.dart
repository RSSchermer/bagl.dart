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

  final CanvasElement _expectedCanvas;

  final num _mismatchThreshold;

  final int _rgbaThreshold;

  _ImageMatcher(expected,
      [this._mismatchThreshold = 0, this._rgbaThreshold = 0])
      : _expected = expected,
        _expectedCanvas = _resolveCanvas(expected);

  bool matches(item, Map matchState) {
    var canvas;

    try {
      canvas = _resolveCanvas(item);
    } catch (e) {
      return false;
    }

    final width = canvas.width;
    final height = canvas.height;
    final context = canvas.context2D;
    final imageData = context.getImageData(0, 0, width, height);

    if (width != _expectedCanvas.width) {
      return false;
    } else if (height != _expectedCanvas.height) {
      return false;
    } else {
      final data = imageData.data;
      final expectedData =
          _expectedCanvas.context2D.getImageData(0, 0, width, height).data;
      final pixelCount = width * height;
      final diffData = new Uint8ClampedList(width * height * 4);
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

            diffData[(i * width + j) * 4] = 256;
            diffData[(i * width + j) * 4 + 2] = 256;
            diffData[(i * width + j) * 4 + 3] = 256;
          }
        }
      }

      final mismatchRatio = mismatchCount / pixelCount;
      final diffImageData = new ImageData(diffData, width, height);
      final diff = new CanvasElement(width: width, height: height);

      diff.context2D.putImageData(diffImageData, 0, 0);

      matchState['mismatchRatio'] = mismatchRatio;
      matchState['diff'] = diff;

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
    if (item is ImageElement ||
        item is CanvasElement ||
        item is ImageData ||
        item is String && item.startsWith('data:image')) {
      final canvas = _resolveCanvas(item);

      if (canvas.width != canvas.width) {
        return mismatchDescription.add('does not have the expected width.');
      } else if (canvas.height != canvas.height) {
        return mismatchDescription.add('does not have the expected width.');
      } else {
        final mismatchRatio = matchState['mismatchRatio'] ?? 0;

        return mismatchDescription
            .add('differs at ${mismatchRatio * 100}% of pixels.\n')
            .add('Expected image: ${_expectedCanvas.toDataUrl()}\n')
            .add('  Actual image: ${canvas.toDataUrl()}\n')
            .add('    Diff image: ${matchState['diff'].toDataUrl()}\n');
      }
    } else {
      return mismatchDescription
          .add('is not a canvas element, image element, image data, or a valid '
              'image data url');
    }
  }
}

CanvasElement _resolveCanvas(value) {
  if (value is ImageData) {
    final canvas = new CanvasElement(width: value.width, height: value.height);
    final context = canvas.context2D;

    context.putImageData(value, 0, 0);

    return canvas;
  } else if (value is CanvasElement) {
    final width = value.width;
    final height = value.height;

    if (value.context2D != null) {
      return value;
    } else {
      final canvas = new CanvasElement(width: width, height: height);
      final context = canvas.context2D;

      context.drawImage(value, 0, 0);

      return canvas;
    }
  } else if (value is ImageElement) {
    final width = value.naturalWidth;
    final height = value.naturalHeight;
    final canvas = new CanvasElement(width: width, height: height);
    final context = canvas.context2D;

    context.drawImage(value, 0, 0);

    return canvas;
  } else {
    throw new ArgumentError('Cannot resolve image data for the given value. '
        'Value must be a CanvasElement, an ImageElement, ImageData or a valid '
        'image data url.');
  }
}
