sealed class DomainException implements Exception {
  final String message;
  const DomainException(this.message);
}

final class GetCompaniesException extends DomainException {
  const GetCompaniesException(super.message);
  @override
  String toString() => 'GetCompaniesException: $message';
}
