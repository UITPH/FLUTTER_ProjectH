import 'package:flutter/material.dart';
import 'package:flutter_honkai/models/boss_model.dart';
import 'package:flutter_honkai/models/valkyrie_model.dart';
import 'package:flutter_honkai/models/weather_model.dart';
import 'package:flutter_honkai/pages/abyss_boss_details_page.dart';
import 'package:flutter_honkai/pages/valkyrie_details_page.dart';
import 'package:flutter_honkai/providers/boss_provider.dart';
import 'package:flutter_honkai/providers/favorite_provider.dart';
import 'package:flutter_honkai/providers/valkyrie_provider.dart';
import 'package:flutter_honkai/providers/weather_provider.dart';
import 'package:flutter_honkai/widgets/favorite_boss_card.dart';
import 'package:flutter_honkai/widgets/favorite_valk_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritePage extends ConsumerWidget {
  //dummy data
  // final List<String> overview = ['role.txt', 'pullrec.txt'];
  // //FWS PS LP TFM RS JDS HoH teri kiana ds
  // final List<Map<String, dynamic>> lineup = [
  //   {
  //     "note": "Ba-dum! Fiery Wishing Star DPS",
  //     "leader": "FWS.png",
  //     "firstvalks": [
  //       "PS.png",
  //       "LP.png",
  //       "TFM.png",
  //       "RS.png",
  //       "JDS.png",
  //       "HoH.png",
  //     ],
  //     "secondvalks": [],
  //     "elfs": ["teri.png", "kiana.png", "ds.png"],
  //   },
  //   {
  //     "note": "Reign Solaris DPS",
  //     "leader": "RS.png",
  //     "firstvalks": ["FWS.png"],
  //     "secondvalks": [
  //       "PS.png",
  //       "LP.png",
  //       "TFM.png",
  //       "RS.png",
  //       "JDS.png",
  //       "HoH.png",
  //     ],
  //     "elfs": ["teri.png", "sera.png", "bunny.png", "ds.png", "songque.png"],
  //   },
  // ];
  // final List<String> equip = [
  //   'fwsweap.png',
  //   'fwstop.png',
  //   'fwsmid.png',
  //   'fwsbot.png',
  // ];
  final String rankup = 'rankup.txt';
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weathers = ref.read(weatherProvider).weathers;
    final valkFavorites = ref.watch(favoriteProvider).valkFavorites;
    final bossFavorites = ref.watch(favoriteProvider).bossFavorites;
    final valkyries = ref.read(valkyrieProvider).valkyries;
    final bosses = ref.read(bossProvider).bosses;
    final List<ValkyrieModel> favoriteValkyries =
        valkyries.where((valk) => valkFavorites.contains(valk.id)).toList();
    final List<BossModel> favoriteBosses =
        bosses.where((boss) => bossFavorites.contains(boss.id)).toList();
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
            child: SingleChildScrollView(
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                              'Favorite Valkyries',
                            ),
                          ),
                          Wrap(
                            runSpacing: 30,
                            children: List.generate(favoriteValkyries.length, (
                              index,
                            ) {
                              final label = favoriteValkyries[index].label;
                              final String id = favoriteValkyries[index].id;
                              final String imageName =
                                  favoriteValkyries[index].imageName;
                              final List<dynamic> lineup =
                                  favoriteValkyries[index].lineup;
                              final List<dynamic> equip =
                                  favoriteValkyries[index].equip;
                              return SizedBox(
                                width: 150,
                                child: FavoriteValkCard(
                                  label: label,
                                  imageName: imageName,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ValkyrieDetailsPage(
                                              label: label,
                                              //sau nay goi theo model
                                              id: id,
                                              lineup: lineup,
                                              equip: equip,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                              'Favorite Abyss Bosses',
                            ),
                          ),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: List.generate(favoriteBosses.length, (
                              index,
                            ) {
                              final WeatherModel weather =
                                  weathers
                                      .where(
                                        (weather) =>
                                            weather.value ==
                                            favoriteBosses[index].weather,
                                      )
                                      .toList()[0];
                              final String label = favoriteBosses[index].label;
                              final String imageName =
                                  favoriteBosses[index].imageName;
                              final String mechanics =
                                  favoriteBosses[index].mechanics;
                              final String resistance =
                                  favoriteBosses[index].resistance;
                              final List<dynamic> teamrec =
                                  favoriteBosses[index].teamrec;
                              return SizedBox(
                                width: 200,
                                child: FavoriteBossCard(
                                  label: label,
                                  imageName: imageName,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => AbyssBossDetailsPage(
                                              label: label,
                                              imageName: imageName,
                                              weatherLabel: weather.label,
                                              weatherspecific:
                                                  weather.weatherspecific,
                                              mechanics: mechanics,
                                              resistance: resistance,
                                              teamrec: teamrec,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Text(
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                              'Favorite Arena Bosses',
                            ),
                          ),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: List.generate(favoriteBosses.length, (
                              index,
                            ) {
                              final WeatherModel weather =
                                  weathers
                                      .where(
                                        (weather) =>
                                            weather.value ==
                                            favoriteBosses[index].weather,
                                      )
                                      .toList()[0];
                              final String label = favoriteBosses[index].label;
                              final String imageName =
                                  favoriteBosses[index].imageName;
                              final String mechanics =
                                  favoriteBosses[index].mechanics;
                              final String resistance =
                                  favoriteBosses[index].resistance;
                              final List<dynamic> teamrec =
                                  favoriteBosses[index].teamrec;
                              return SizedBox(
                                width: 200,
                                child: FavoriteBossCard(
                                  label: label,
                                  imageName: imageName,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => AbyssBossDetailsPage(
                                              label: label,
                                              imageName: imageName,
                                              weatherLabel: weather.label,
                                              weatherspecific:
                                                  weather.weatherspecific,
                                              mechanics: mechanics,
                                              resistance: resistance,
                                              teamrec: teamrec,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
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
