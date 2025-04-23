import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/widgets/topteams_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbyssBossDetailsPage extends ConsumerStatefulWidget {
  final String label;
  final String imageName;
  final String weatherLabel;
  final String weatherspecific;
  final String mechanics;
  final String resistance;
  final List<dynamic> teamrec;
  const AbyssBossDetailsPage({
    super.key,
    required this.label,
    required this.imageName,
    required this.weatherLabel,
    required this.weatherspecific,
    required this.mechanics,
    required this.resistance,
    required this.teamrec,
  });

  @override
  ConsumerState<AbyssBossDetailsPage> createState() =>
      _AbyssBossDetailsPageState();
}

class _AbyssBossDetailsPageState extends ConsumerState<AbyssBossDetailsPage> {
  String bossimagePath = '';

  @override
  void initState() {
    bossimagePath = ref.read(bossImagesPathProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          '${widget.label} - ${widget.weatherLabel}',
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('lib/assets/images/citybridge.jpg'),
              opacity: AlwaysStoppedAnimation(0.3),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 50,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.file(
                          height: 150,
                          File('$bossimagePath/${widget.imageName}'),
                          fit: BoxFit.fill,
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              spacing: 30,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: Text(
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        'Weathers',
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 600,
                                      ),
                                      child: Text(
                                        style: TextStyle(fontSize: 20),
                                        widget.weatherspecific,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: Text(
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        'Mechanics',
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 600,
                                      ),
                                      child: Text(
                                        style: TextStyle(fontSize: 20),
                                        widget.mechanics,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 170,
                                      child: Text(
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        'Resistance',
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 600,
                                      ),
                                      child: Text(
                                        style: TextStyle(fontSize: 20),
                                        widget.resistance,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Text(
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      'RECOMMENDED TEAMS',
                    ),
                    SizedBox(height: 50),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: List.generate(
                        widget.teamrec.length,
                        (index) => TopteamsWidget(
                          valk1: widget.teamrec[index][0],
                          valk2: widget.teamrec[index][1],
                          valk3: widget.teamrec[index][2],
                          elf: widget.teamrec[index][3],
                          note: widget.teamrec[index][4],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 350,
                    //   width: 1200,
                    //   child: GridView.builder(
                    //     itemCount: widget.teamrec.length,
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       childAspectRatio: 3.2,
                    //       crossAxisSpacing: 20,
                    //       mainAxisSpacing: 20,
                    //     ),
                    //     itemBuilder: (context, index) {
                    //       return TopteamsWidget(
                    //         valk1: widget.teamrec[index][0],
                    //         valk2: widget.teamrec[index][1],
                    //         valk3: widget.teamrec[index][2],
                    //         elf: widget.teamrec[index][3],
                    //         note: widget.teamrec[index][4],
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
