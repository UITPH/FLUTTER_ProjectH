import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_honkai/providers/path_provider.dart';
import 'package:flutter_honkai/widgets/topteams_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArenabossPreviewDetailsPage extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final String imagePath;
  final int rank;
  final List firstValk;
  final List secondValk;
  final List thirdValk;
  final List elf;

  const ArenabossPreviewDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.imagePath,
    required this.rank,
    required this.firstValk,
    required this.secondValk,
    required this.thirdValk,
    required this.elf,
  });

  @override
  ConsumerState<ArenabossPreviewDetailsPage> createState() =>
      _ArenabossPreviewDetailsPageState();
}

class _ArenabossPreviewDetailsPageState
    extends ConsumerState<ArenabossPreviewDetailsPage> {
  String bossimagePath = '';

  @override
  void initState() {
    bossimagePath = ref.read(arenabossImagesPathProvider);
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
                    Image.file(
                      height: 150,
                      File(widget.imagePath),
                      fit: BoxFit.fill,
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
                        widget.firstValk.length,
                        (index) => TopteamsWidget(
                          valk1: widget.firstValk[index],
                          valk2: widget.secondValk[index],
                          valk3: widget.thirdValk[index],
                          elf: widget.elf[index],
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
