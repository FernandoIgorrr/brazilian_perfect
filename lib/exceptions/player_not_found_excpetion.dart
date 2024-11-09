class PlayerNotFoundException implements Exception {
  final String message;
  PlayerNotFoundException(this.message);

  @override
  String toString() => 'PlayerNotFoundException: $message';
}
