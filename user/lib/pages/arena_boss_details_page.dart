import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/services/database_helper.dart';
import 'package:flutter_honkai/widgets/topteams_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArenaBossDetailsPage extends ConsumerStatefulWidget {
  final String id;
  final String name;
  final int rank;
  final List teamrec;

  const ArenaBossDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.rank,
    required this.teamrec,
  });

  @override
  ConsumerState<ArenaBossDetailsPage> createState() =>
      _ArenaBossDetailsPageState();
}

class _ArenaBossDetailsPageState extends ConsumerState<ArenaBossDetailsPage> {
  Widget getArenaBossImage(String id) {
    final version =
        ref
            .read(arenabossProvider)
            .bosses
            .firstWhere((boss) => boss.id == id)
            .version;
    final db = DatabaseHelper.supabase;
    final url =
        '${db.storage.from('data').getPublicUrl('images/arenabosses/$id.png')}?v=$version';

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
                    getArenaBossImage(widget.id),
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
