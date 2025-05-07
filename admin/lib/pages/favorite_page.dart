import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/abyssboss_model.dart';
import 'package:flutter_honkai/models/arenaboss_model.dart';
import 'package:flutter_honkai/models/elf_model.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/pages/abyss_boss_details_page.dart';
import 'package:flutter_honkai/pages/arena_boss_details_page.dart';
import 'package:flutter_honkai/pages/elf_overview_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_page.dart';
import 'package:flutter_honkai/providers/abyssboss_provider.dart';
import 'package:flutter_honkai/providers/arenaboss_provider.dart';
import 'package:flutter_honkai/providers/elf_provider.dart';
import 'package:flutter_honkai/providers/favorite_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/widgets/favorite_abyssboss_card.dart';
import 'package:flutter_honkai/widgets/favorite_arenaboss_card.dart';
import 'package:flutter_honkai/widgets/favorite_elf_card.dart';
import 'package:flutter_honkai/widgets/favorite_valk_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePage extends ConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weathers = ref.read(weatherProvider).weathers;
    final valkFavorites = ref.watch(favoriteProvider).valkFavorites;
    final elfFavorites = ref.watch(favoriteProvider).elfFavorites;
    final abyssbossFavorites = ref.watch(favoriteProvider).abyssbossFavorites;
    final arenabossFavorites = ref.watch(favoriteProvider).arenabossFavorites;
    final valkyries = ref.read(valkyrieProvider).valkyries;
    final elfs = ref.read(elfProvider).elfs;
    final abyssbosses = ref.read(abyssBossProvider).bosses;
    final arenabosses = ref.read(arenabossProvider).bosses;
    final List<ValkyrieModel> favoriteValkyries =
        valkyries.where((valk) => valkFavorites.contains(valk.id)).toList();
    final List<ElfModel> favoriteElfs =
        elfs.where((elf) => elfFavorites.contains(elf.id)).toList();
    final List<AbyssBossModel> favoriteAbyssBosses =
        abyssbosses
            .where((boss) => abyssbossFavorites.contains(boss.id))
            .toList();
    final List<ArenaBossModel> favoriteArenaBosses =
        arenabosses
            .where((boss) => arenabossFavorites.contains(boss.id))
            .toList();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('lib/assets/images/elybridge.jpg'),
              opacity: AlwaysStoppedAnimation(0.2),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            'Favorite Valkyries',
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              runSpacing: 30,
                              children: List.generate(
                                favoriteValkyries.length,
                                (index) {
                                  final String id = favoriteValkyries[index].id;
                                  final String name =
                                      favoriteValkyries[index].name;
                                  final List equipment =
                                      favoriteValkyries[index].equipment;
                                  final List note =
                                      favoriteValkyries[index].note;
                                  final List leader =
                                      favoriteValkyries[index].leader;
                                  final List firstvalkList =
                                      favoriteValkyries[index].firstvalkList;
                                  final List secondvalkList =
                                      favoriteValkyries[index].secondvalkList;
                                  final List elfList =
                                      favoriteValkyries[index].elfList;
                                  return SizedBox(
                                    width: 150,
                                    child: FavoriteValkCard(
                                      id: id,
                                      name: name,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    ValkyrieDetailsPage(
                                                      name: name,
                                                      id: id,
                                                      equipment: equipment,
                                                      note: note,
                                                      leader: leader,
                                                      firstvalkList:
                                                          firstvalkList,
                                                      secondvalkList:
                                                          secondvalkList,
                                                      elfList: elfList,
                                                    ),
                                          ),
                                        );
                                      },
                                      onSecondaryTap: () {
                                        ref
                                            .read(favoriteProvider)
                                            .toggleValk(
                                              favoriteValkyries[index].id,
                                            );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Text(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            'Favorite Elfs',
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 40,
                              runSpacing: 50,
                              children: List.generate(favoriteElfs.length, (
                                index,
                              ) {
                                final id = favoriteElfs[index].id;
                                final name = favoriteElfs[index].name;
                                final overview = favoriteElfs[index].overview;
                                return SizedBox(
                                  width: 110,
                                  child: FavoriteElfCard(
                                    id: id,
                                    name: name,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ElfOverviewPage(
                                              overview: overview,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    onSecondaryTap: () async {
                                      ref.read(favoriteProvider).toggleElf(id);
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Text(
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            'Favorite Abyss Bosses',
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: List.generate(
                                favoriteAbyssBosses.length,
                                (index) {
                                  final WeatherModel weather =
                                      weathers
                                          .where(
                                            (weather) =>
                                                weather.id ==
                                                favoriteAbyssBosses[index]
                                                    .idWeather,
                                          )
                                          .toList()[0];
                                  final String id =
                                      favoriteAbyssBosses[index].id;
                                  final String name =
                                      favoriteAbyssBosses[index].name;
                                  final String mechanic =
                                      favoriteAbyssBosses[index].mechanic;
                                  final String resistance =
                                      favoriteAbyssBosses[index].resistance;
                                  final List firstValk =
                                      favoriteAbyssBosses[index].firstValk;
                                  final List secondValk =
                                      favoriteAbyssBosses[index].secondValk;
                                  final List thirdValk =
                                      favoriteAbyssBosses[index].thirdValk;
                                  final List elf =
                                      favoriteAbyssBosses[index].elf;
                                  final List note =
                                      favoriteAbyssBosses[index].note;
                                  return SizedBox(
                                    width: 180,
                                    child: FavoriteAbyssbossCard(
                                      id: id,
                                      name: name,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    AbyssBossDetailsPage(
                                                      id: id,
                                                      name: name,
                                                      weatherName: weather.name,
                                                      weatherSpecific:
                                                          weather.specific,
                                                      mechanic: mechanic,
                                                      resistance: resistance,
                                                      firstValk: firstValk,
                                                      secondValk: secondValk,
                                                      thirdValk: thirdValk,
                                                      elf: elf,
                                                      note: note,
                                                    ),
                                          ),
                                        );
                                      },
                                      onSecondaryTap: () {
                                        ref
                                            .read(favoriteProvider)
                                            .toggleAbyssBoss(
                                              favoriteAbyssBosses[index].id,
                                            );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Text(
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            'Favorite Arena Bosses',
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: List.generate(
                                favoriteArenaBosses.length,
                                (index) {
                                  final String id =
                                      favoriteArenaBosses[index].id;
                                  final String name =
                                      favoriteArenaBosses[index].name;
                                  final int rank =
                                      favoriteArenaBosses[index].rank;
                                  final List firstValk =
                                      favoriteArenaBosses[index].firstValk;
                                  final List secondValk =
                                      favoriteArenaBosses[index].secondValk;
                                  final List thirdValk =
                                      favoriteArenaBosses[index].thirdValk;
                                  final List elf =
                                      favoriteArenaBosses[index].elf;
                                  return SizedBox(
                                    width: 180,
                                    child: FavoriteArenabossCard(
                                      id: id,
                                      name: name,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    ArenaBossDetailsPage(
                                                      id: id,
                                                      name: name,
                                                      rank: rank,
                                                      firstValk: firstValk,
                                                      secondValk: secondValk,
                                                      thirdValk: thirdValk,
                                                      elf: elf,
                                                    ),
                                          ),
                                        );
                                      },
                                      onSecondaryTap: () {
                                        ref
                                            .read(favoriteProvider)
                                            .toggleArenaBoss(
                                              favoriteArenaBosses[index].id,
                                            );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
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
