import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_honkai/widgets/topteams_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbyssBossDetailsPage extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final String weatherName;
  final String weatherSpecific;
  final String mechanic;
  final String resistance;
  final List teamrec;

  const AbyssBossDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.weatherName,
    required this.weatherSpecific,
    required this.mechanic,
    required this.resistance,
    required this.teamrec,
  });

  @override
  ConsumerState<AbyssBossDetailsPage> createState() =>
      _AbyssBossDetailsPageState();
}

class _AbyssBossDetailsPageState extends ConsumerState<AbyssBossDetailsPage> {
  Widget getAbyssBossImage(String id) {
    final db = DatabaseHelper.supabase;
    final url = db.storage
        .from('data')
        .getPublicUrl('images/abyssbosses/$id.png');

    return CachedNetworkImage(
      height: 150,
      fit: BoxFit.fill,
      placeholder:
          (context, url) => LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error),
      imageUrl: url,
    );
  }

  @override
  void initState() {
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
          '${widget.name} - ${widget.weatherName}',
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
                      spacing: 10,
                      children: [
                        getAbyssBossImage(widget.id),
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
                                        widget.weatherSpecific,
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
                                        widget.mechanic,
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
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      'RECOMMENDED TEAMS',
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: List.generate(
                        widget.teamrec.length,
                        (index) => TopteamsWidget(
                          valk1: widget.teamrec[index]['first_valk'],
                          valk2: widget.teamrec[index]['second_valk'],
                          valk3: widget.teamrec[index]['third_valk'],
                          elf: widget.teamrec[index]['elf'],
                          note: widget.teamrec[index]['note'],
                        ),
                      ),
                    ),
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
