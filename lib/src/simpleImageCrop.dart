part of image_crop;

class ImageOptions {
  final int width;
  final int height;

  ImageOptions({required this.width, required this.height})
      : assert(width != null),
        assert(height != null);

  @override
  int get hashCode => hashValues(width, height);

  @override
  bool operator ==(other) {
    return other is ImageOptions &&
        other.width == width &&
        other.height == height;
  }

  @override
  String toString() {
    return '$runtimeType(width: $width, height: $height)';
  }
}

class ImageCrop {
  static const _channel =
      const MethodChannel('plugins.lykhonis.com/image_crop');

  static Future<bool> requestPermissions() {
    return _channel
        .invokeMethod('requestPermissions')
        .then<bool>((result) => result);
  }

  static Future<ImageOptions> getImageOptions({required File file}) async {
    assert(file != null);
    final result =
        await _channel.invokeMethod('getImageOptions', {'path': file.path});
    return ImageOptions(
      width: result['width'],
      height: result['height'],
    );
  }

  static Future<File> cropImage({
    required File file,
    required Rect area,
    double? scale,
  }) {
    assert(file != null);
    assert(area != null);
    return _channel.invokeMethod('cropImage', {
      'path': file.path,
      'left': area.left,
      'top': area.top,
      'right': area.right,
      'bottom': area.bottom,
      'scale': scale ?? 1.0,
    }).then<File>((result) => File(result));
  }

  static Future<File> sampleImage({
    required File file,
    required int preferredWidth,
    required int preferredHeight,
  }) async {

    final String path = await (_channel.invokeMethod('sampleImage', {
      'path': file.path,
      'maximumWidth': preferredWidth,
      'maximumHeight': preferredHeight,
    }) as FutureOr<String>);
    return File(path);
  }
}
