import 'package:brazilian_perfect/src/data/repositories/tournament_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mockito/mockito.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Testando o LocalStorage no repository', () {
    final mockStorage = MockLocalStorage();
    final repository = TournamentRepository();
    repository.getTournaments();
  });
}
