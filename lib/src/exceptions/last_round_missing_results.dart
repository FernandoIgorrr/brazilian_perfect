class LastRoundMissingResults implements Exception {
  final String message;

  LastRoundMissingResults(this.message);

  @override
  String toString() => 'LastRoundMissingResults: $message';
}
