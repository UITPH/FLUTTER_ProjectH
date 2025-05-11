import 'package:flutter/material.dart';
import 'package:flutter_honkai/widgets/topteams_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArenabossPreviewDetailsPage extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final Widget image;
  final int rank;
  final List teamrec;

  const ArenabossPreviewDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.rank,
    required this.teamrec,
  });

  @override
  ConsumerState<ArenabossPreviewDetailsPage> createState() =>
      _ArenabossPreviewDetailsPageState();
}

class _ArenabossPreviewDetailsPageState
    extends ConsumerState<ArenabossPreviewDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textRank = widget.rank == 2 ? 'SS' : 'SSS';
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          '${widget.name} - $textRank',
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 100,
                ),
                child: Column(
                  children: [
                    widget.image,
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
                          note: '',
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
