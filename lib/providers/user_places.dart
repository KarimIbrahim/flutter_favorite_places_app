import 'dart:io';

import 'package:favorite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute('''CREATE TABLE user_places(
                                      id TEXT PRIMARY KEY,
                                      title TEXT,
                                      image TEXT,
                                      lat REAL,
                                      long REAL,
                                      address TEXT)''');
    }, version: 1);
  }

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (e) => Place(
            id: e['id'] as String,
            name: e['title'] as String,
            image: File(e['image'] as String),
            location: PlaceLocation(
              latitude: e['lat'] as double,
              longitude: e['long'] as double,
              address: e['address'] as String,
            ),
          ),
        )
        .toList();

    state = places;
  }

  void addPlace(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$filename');

    final newPlace =
        Place(name: place.name, image: copiedImage, location: place.location);

    final db = await _getDatabase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'long': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [
      newPlace,
      ...state,
    ];
  }

  void removePlace(Place place) async {
    await place.image.delete();

    final db = await _getDatabase();
    await db.delete('user_places', where: 'id = ?', whereArgs: [place.id]);

    state = state.where((element) => element != place).toList();
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
