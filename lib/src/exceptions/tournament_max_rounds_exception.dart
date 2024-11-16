class TournamentMaxRoundsException implements Exception {
  final String message;
  TournamentMaxRoundsException(this.message);

  @override
  String toString() => 'TournamentMaxRoundsException: $message';
}
