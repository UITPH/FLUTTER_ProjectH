import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_honkai/models/crystal_cal_model.dart';
import 'package:flutter_honkai/services/crystal_cal_service.dart';
import 'package:flutter_honkai/widgets/crystal_breakdown_textfield.dart';

class CrystalCalPage extends StatefulWidget {
  const CrystalCalPage({super.key});

  @override
  State<CrystalCalPage> createState() => _CrystalCalPageState();
}

class _CrystalCalPageState extends State<CrystalCalPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  int totalCrys = 0;
  int totalRolls = 0;

  String? date;
  int? verlen;
  int? customCrys;
  int? currentCrys;
  int? abyssCrys;
  int? erCrys;
  int? bpCrys;
  int? signinClaimed;
  int? mpRemained;
  int? mpClaimed;

  TextEditingController datecontroller = TextEditingController();
  TextEditingController inputverlenController = TextEditingController();
  int? inputabyssController;
  int? inputerController;
  int? inputbpController;
  TextEditingController inputsigninController = TextEditingController();
  TextEditingController inputmpremainedController = TextEditingController();
  TextEditingController inputmpclaimedController = TextEditingController();
  TextEditingController inputcurrentController = TextEditingController();
  TextEditingController inputcustomController = TextEditingController();

  TextEditingController abysscontroller = TextEditingController();
  TextEditingController arenacontroller = TextEditingController();
  TextEditingController ercontroller = TextEditingController();
  TextEditingController armcontroller = TextEditingController();
  TextEditingController dailycontroller = TextEditingController();
  TextEditingController signincontroller = TextEditingController(
    text: '${DateTime.now().day}',
  );
  TextEditingController mpcontroller = TextEditingController();
  TextEditingController bpcontroller = TextEditingController();
  TextEditingController maintainancecontroller = TextEditingController();
  TextEditingController customcontroller = TextEditingController();
  TextEditingController sharecontroller = TextEditingController();
  TextEditingController currencontroller = TextEditingController();

  final List<Map<String, dynamic>> abyssranks = [
    {'crys': 640, 'name': 'Myriad T50'},
    {'crys': 570, 'name': 'Myriad T100'},
    {'crys': 520, 'name': 'Nirvana'},
    {'crys': 500, 'name': 'Redlotus'},
    {'crys': 420, 'name': 'Agony III'},
    {'crys': 340, 'name': 'Agony II'},
    {'crys': 280, 'name': 'Agony I'},
    {'crys': 220, 'name': 'Sinful III'},
    {'crys': 200, 'name': 'Sinful II'},
    {'crys': 190, 'name': 'Sinful I'},
    {'crys': 180, 'name': 'Forbidden'},
  ];
  final List<Map<String, dynamic>> elysianranks = [
    {'crys': 500, 'name': 'x2.25'},
    {'crys': 450, 'name': 'x2'},
    {'crys': 360, 'name': 'x1.75'},
    {'crys': 280, 'name': 'x1.5'},
    {'crys': 120, 'name': 'x1'},
  ];

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        datecontroller.text =
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
        inputsigninController.text = '${_selectedDate.day}';
      });
    }
  }

  Future<void> _submit() async {
    CrystalCalModel data = CrystalCalModel(
      selectedDate: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ),
      verlen: verlen!,
      customCrys: customCrys!,
      currentCrys: currentCrys!,
      abyssCrys: abyssCrys!,
      erCrys: erCrys!,
      bpCrys: bpCrys!,
      signinClaimed: signinClaimed!,
      mpRemained: mpRemained!,
      mpClaimed: mpClaimed!,
    );
    Map<String, int> crys = data.compute();
    await saveCrystalHistory(data);
    setState(() {
      totalRolls = 0;
      totalCrys = crys['total']!;
      abysscontroller.text = '${crys['abyss']}';
      arenacontroller.text = '${crys['arena']}';
      ercontroller.text = '${crys['er']}';
      armcontroller.text = '${crys['arm']}';
      dailycontroller.text = '${crys['daily']}';
      signincontroller.text = '${crys['signin']}';
      mpcontroller.text = '${crys['mp']}';
      bpcontroller.text = '${crys['bp']}';
      sharecontroller.text = '${crys['share']}';
      maintainancecontroller.text = '${crys['maintainance']}';
      currencontroller.text = '${crys['current']}';
      customcontroller.text = '${crys['custom']}';
    });
  }

  int getDaysInCurrentMonth() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;

    DateTime firstDayThisMonth = DateTime(year, month, 1);
    DateTime firstDayNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);

    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  @override
  void initState() {
    datecontroller.text =
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';

    super.initState();
  }

  @override
  void dispose() {
    datecontroller.dispose();
    abysscontroller.dispose();
    arenacontroller.dispose();
    ercontroller.dispose();
    armcontroller.dispose();
    dailycontroller.dispose();
    signincontroller.dispose();
    mpcontroller.dispose();
    bpcontroller.dispose();
    maintainancecontroller.dispose();
    customcontroller.dispose();
    sharecontroller.dispose();
    currencontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              alignment: Alignment.centerRight,
              image: AssetImage('lib/assets/images/honkai-ai.png'),
              opacity: AlwaysStoppedAnimation(0.3),
              fit: BoxFit.none,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: datecontroller,
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      labelText: 'Version start from',
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        onPressed: () async {
                                          _pickDate();
                                        },
                                        icon: Icon(
                                          Icons.calendar_month_outlined,
                                        ),
                                      ),
                                    ),
                                    //onSaved: (value) {},
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: inputverlenController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    cursorColor: Colors.lightBlueAccent,
                                    decoration: InputDecoration(
                                      labelText: 'Version length (week)',
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == '') {
                                        return "Please enter Version length";
                                      }
                                      if (int.parse(value!) < 1) {
                                        return 'Version length must be larger than 0';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      verlen = int.parse(value!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: inputabyssController,
                                    decoration: InputDecoration(
                                      labelText: 'Abyss Tier',
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    menuMaxHeight: 200,
                                    items:
                                        abyssranks
                                            .map(
                                              (abyssrank) =>
                                                  DropdownMenuItem<int>(
                                                    value: abyssrank['crys'],
                                                    child: Text(
                                                      '${abyssrank['name']}',
                                                    ),
                                                  ),
                                            )
                                            .toList(),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please choose your abyss tier';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      abyssCrys = value;
                                    },
                                    onChanged: (value) {
                                      abyssCrys = value;
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: inputerController,
                                    decoration: InputDecoration(
                                      labelText: 'Elysian Realm',
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    menuMaxHeight: 200,
                                    items:
                                        elysianranks
                                            .map(
                                              (elysianrank) =>
                                                  DropdownMenuItem<int>(
                                                    value: elysianrank['crys'],
                                                    child: Text(
                                                      '${elysianrank['name']}',
                                                    ),
                                                  ),
                                            )
                                            .toList(),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please choose your ER difficulty';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      erCrys = value;
                                    },
                                    onChanged: (value) {
                                      erCrys = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int>(
                                    value: inputbpController,
                                    decoration: InputDecoration(
                                      labelText: 'Battle Pass',
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    menuMaxHeight: 200,
                                    items: [
                                      DropdownMenuItem(
                                        value: 3250,
                                        child: Text('Knight/Paladin'),
                                      ),
                                      DropdownMenuItem(
                                        value: 1250,
                                        child: Text('Vanguard (F2P)'),
                                      ),
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please choose your BP type';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      bpCrys = value;
                                    },
                                    onChanged: (value) {
                                      bpCrys = value;
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: inputsigninController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    cursorColor: Colors.lightBlueAccent,
                                    decoration: InputDecoration(
                                      labelText: 'Sign-in days claimed',
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == '') {
                                        return 'Please enter your Sign-in days claimed';
                                      }
                                      final dayscurmonth =
                                          getDaysInCurrentMonth();
                                      if (int.parse(value!) < 0 ||
                                          int.parse(value) > dayscurmonth) {
                                        return 'Please enter day in range 0 - $dayscurmonth';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      signinClaimed = int.parse(value!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: inputmpremainedController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    cursorColor: Colors.lightBlueAccent,
                                    decoration: InputDecoration(
                                      labelText: 'Monthly card remaining days',
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        mpRemained =
                                            value == '' ? 0 : int.parse(value);
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    enabled:
                                        mpRemained != null && mpRemained != 0,
                                    controller: inputmpclaimedController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    cursorColor: Colors.lightBlueAccent,
                                    decoration: InputDecoration(
                                      labelText: 'Monthly card days claimed',
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == '') {
                                        return 'Please enter your MP days claimed';
                                      }
                                      if (int.parse(value!) < 0 ||
                                          int.parse(value) > 15) {
                                        return 'Please enter day in range 0 - 15';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      mpClaimed = int.parse(value!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: inputcurrentController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    cursorColor: Colors.lightBlueAccent,
                                    decoration: InputDecoration(
                                      labelText: 'Current crystal',

                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (value) {
                                      currentCrys =
                                          value == '' ? 0 : int.parse(value!);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: inputcustomController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    cursorColor: Colors.lightBlueAccent,
                                    decoration: InputDecoration(
                                      labelText: 'Custom crystal',
                                      floatingLabelStyle: TextStyle(
                                        color: Colors.lightBlueAccent,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.lightBlueAccent,
                                          width: 2.0,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    onSaved: (value) {
                                      customCrys =
                                          value == '' ? 0 : int.parse(value!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        CrystalCalModel input =
                                            await loadCrystalHistory();
                                        setState(() {
                                          _selectedDate = input.selectedDate;
                                          datecontroller.text =
                                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
                                          inputverlenController.text =
                                              '${input.verlen}';
                                          inputcustomController.text =
                                              '${input.customCrys}';
                                          inputcurrentController.text =
                                              '${input.currentCrys}';
                                          inputabyssController =
                                              input.abyssCrys;
                                          inputerController = input.erCrys;
                                          inputbpController = input.bpCrys;
                                          inputsigninController.text =
                                              '${input.signinClaimed}';
                                          inputmpremainedController.text =
                                              '${input.mpRemained}';
                                          inputmpclaimedController.text =
                                              '${input.mpClaimed}';
                                        });
                                      },
                                      icon: Icon(
                                        color: Colors.black,
                                        Icons.history,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          await _submit();
                                        }
                                      },
                                      child: Text(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                        'Calculate',
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (totalRolls == 0) {
                                          setState(() {
                                            totalRolls = totalCrys ~/ 280;
                                            totalCrys -= totalRolls * 280;
                                          });
                                        } else {
                                          setState(() {
                                            totalCrys += totalRolls * 280;
                                            totalRolls = 0;
                                          });
                                        }
                                      },
                                      child: Text(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                        'Convert',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 50),
                            Text(
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              'Crystal breakdown',
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Abyss',
                                    controller: abysscontroller,
                                  ),
                                ),
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Arena',
                                    controller: arenacontroller,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Elysian Realm',
                                    controller: ercontroller,
                                  ),
                                ),
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Armada',
                                    controller: armcontroller,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Dailies',
                                    controller: dailycontroller,
                                  ),
                                ),
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Sign-in',
                                    controller: signincontroller,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Monthly card',
                                    controller: mpcontroller,
                                  ),
                                ),
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Battlepass',
                                    controller: bpcontroller,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Weekly share',
                                    controller: sharecontroller,
                                  ),
                                ),
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Maintainance',
                                    controller: maintainancecontroller,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Current',
                                    controller: currencontroller,
                                  ),
                                ),
                                Expanded(
                                  child: CrystalBreakdownTextfield(
                                    labelText: 'Custom',
                                    controller: customcontroller,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              width: 70,
                              height: 70,
                              image: AssetImage(
                                'lib/assets/images/crystal.png',
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                              '$totalCrys',
                            ),
                          ],
                        ),
                        Visibility(
                          visible: totalRolls != 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                width: 70,
                                height: 70,
                                image: AssetImage(
                                  'lib/assets/images/focused.png',
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                                '$totalRolls',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
