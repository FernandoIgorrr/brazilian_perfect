class TournamentCreationDto {
  late String name;
  late String type;
  late DateTime date;

  TournamentCreationDto() {
    name = '';
    type = '';
    date = DateTime.now();
  }

  setName(String value) {
    name = value;
  }

  setType(String value) {
    type = value;
  }

  setDate(DateTime value) {
    date = value;
  }

  bool get minFilledDatas => name.isNotEmpty && type.isNotEmpty;
}
