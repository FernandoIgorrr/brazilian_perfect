class PlayerOnTheGameNotFoud implements Exception {
  final String message;
  PlayerOnTheGameNotFoud(this.message);

  @override
  String toString() => 'PlayerOnTheGameNotFoud: $message';
}
