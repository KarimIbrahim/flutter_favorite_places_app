import 'package:favorite_places_app/screens/place_detail.dart';
import 'package:flutter/material.dart';

import '../models/place.dart';

class PlaceItem extends StatelessWidget {
  const PlaceItem({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 26,
        backgroundImage: FileImage(place.image),
      ),
      title: Text(
        place.name,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
      subtitle: Text(
        place.location.address,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => PlaceDetailScreen(place: place),
        ),
      ),
    );
  }
}
