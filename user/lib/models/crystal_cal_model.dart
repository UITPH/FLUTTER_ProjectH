class CrystalCalModel {
  final DateTime selectedDate;
  final int verlen;
  final int customCrys;
  final int currentCrys;
  final int abyssCrys;
  final int erCrys;
  final int bpCrys;
  final int signinClaimed;
  final int mpRemained;
  final int mpClaimed;

  CrystalCalModel({
    required this.selectedDate,
    required this.verlen,
    required this.customCrys,
    required this.currentCrys,
    required this.abyssCrys,
    required this.erCrys,
    required this.bpCrys,
    required this.signinClaimed,
    required this.mpRemained,
    required this.mpClaimed,
  });

  factory CrystalCalModel.fromJson(Map<String, dynamic> json) {
    List parts = json['selectedDate'].split('/');
    return CrystalCalModel(
      selectedDate: DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      ),
      verlen: json['verlen'],
      customCrys: json['customCrys'],
      currentCrys: json['currentCrys'],
      abyssCrys: json['abyssCrys'],
      erCrys: json['erCrys'],
      bpCrys: json['bpCrys'],
      signinClaimed: json['signinClaimed'],
      mpRemained: json['mpRemained'],
      mpClaimed: json['mpClaimed'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'selectedDate':
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
      'verlen': verlen,
      'customCrys': customCrys,
      'currentCrys': currentCrys,
      'abyssCrys': abyssCrys,
      'erCrys': erCrys,
      'bpCrys': bpCrys,
      'signinClaimed': signinClaimed,
      'mpRemained': mpRemained,
      'mpClaimed': mpClaimed,
    };
  }

  Map<String, int> compute() {
    DateTime currentComputeDate = selectedDate;
    int days = verlen * 7;
    int mpRemainedDays = mpRemained <= days ? mpRemained : days;
    int curmp = mpClaimed + 1;

    int totalshareCrys = 30 * verlen;
    int totaldailyCrys = 40 * days;
    int totalarmCrys = 25 * verlen;
    int totalarenaCrys = 140 * verlen;
    int totalabyssCrys = abyssCrys * 2 * verlen;
    int totalerCrys = erCrys * verlen;
    int totalmpCrys = 0;
    int totalsigninCrys = 0;
    int remainingDays =
        DateTime(
          currentComputeDate.year,
          currentComputeDate.month + 1,
          1,
        ).subtract(Duration(days: 1)).difference(currentComputeDate).inDays;
    for (int i = signinClaimed + 1; i <= signinClaimed + remainingDays; ++i) {
      --days;
      currentComputeDate = currentComputeDate.add(Duration(days: 1));

      //mp
      if (mpRemainedDays > 0) {
        if (curmp < 15) {
          totalmpCrys += 60;
          --mpRemainedDays;
          ++curmp;
        } else {
          totalmpCrys += 500;
          --mpRemainedDays;
          curmp = 1;
        }
      }

      //signin
      if (i == 27) continue;
      if (i % 7 == 1 || i % 7 == 6) {
        totalsigninCrys += 50;
      }
    }
    for (int i = 0; i < days; i++) {
      int day = currentComputeDate.day;
      currentComputeDate = currentComputeDate.add(Duration(days: 1));

      //mp
      if (mpRemainedDays > 0) {
        if (curmp < 15) {
          totalmpCrys += 60;
          --mpRemainedDays;
          ++curmp;
        } else {
          totalmpCrys += 500;
          --mpRemainedDays;
          curmp = 1;
        }
      }

      //signin
      if (day == 27) continue;
      if (day % 7 == 1 || day % 7 == 6) {
        totalsigninCrys += 50;
      }
    }

    int totalCrys =
        totalabyssCrys +
        totalarenaCrys +
        totalerCrys +
        totalarmCrys +
        totaldailyCrys +
        totalsigninCrys +
        totalmpCrys +
        bpCrys +
        totalshareCrys +
        600 +
        currentCrys +
        customCrys;
    return {
      'total': totalCrys,
      'abyss': totalabyssCrys,
      'arena': totalarenaCrys,
      'er': totalerCrys,
      'arm': totalarmCrys,
      'daily': totaldailyCrys,
      'signin': totalsigninCrys,
      'mp': totalmpCrys,
      'bp': bpCrys,
      'share': totalshareCrys,
      'maintainance': 600,
      'current': currentCrys,
      'custom': customCrys,
    };
  }
}
