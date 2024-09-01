sealed class BaseDataException implements Exception {
  final String message;
  const BaseDataException(this.message);
}

final class HttpDataException extends BaseDataException {
  final int? statusCode;
  final String? statusMessage;
  const HttpDataException(super.message, {this.statusCode, this.statusMessage});
  @override
  String toString() => 'ApiRequestException: $message'
      '${statusCode != null ? ' ($statusCode: $statusMessage)' : ''}';
}

/// {@template DataAccessException}
/// Indicates any [BaseDataException] that is not related to http protocol
/// or network exception.
/// {@endtemplate}
final class DataAccessException extends BaseDataException {
  /// {@macro DataAccessException}
  const DataAccessException(super.message);
  @override
  String toString() => 'DataAccessException: $message';
}
