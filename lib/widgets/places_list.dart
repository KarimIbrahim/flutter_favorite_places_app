import 'package:flutter/material.dart';

import '../models/place.dart';
import 'place_item.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places, required this.removeItem});

  final List<Place> places;
  final Function(Place) removeItem;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          'Please add favorites to the list.',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      );
    }

    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) => Dismissible(
        onDismissed: (direction) => removeItem(places[index]),
        key: ValueKey(places[index].name),
        child: PlaceItem(place: places[index]),
      ),
    );
  }
}
