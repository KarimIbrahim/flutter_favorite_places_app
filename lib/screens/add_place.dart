import 'dart:io';

import 'package:favorite_places_app/models/place.dart';
import 'package:favorite_places_app/providers/user_places.dart';
import 'package:favorite_places_app/widgets/image_input.dart';
import 'package:favorite_places_app/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  File? _pickedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ref.read(userPlacesProvider.notifier).addPlace(Place(
          name: _enteredName,
          image: _pickedImage!,
          location: _selectedLocation!));

      Navigator.of(context).pop();
    }
  }

  String? _validateName(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.trim().length <= 1 ||
        value.trim().length > 50) {
      return 'Must be between 1 and 50 characters.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                validator: _validateName,
                onSaved: (value) => _enteredName = value!,
              ),
              const SizedBox(
                height: 10,
              ),
              ImageInput(
                onPickImage: (image) => _pickedImage = image,
              ),
              const SizedBox(
                height: 10,
              ),
              LocationInput(
                  onSelectLocation: (location) => _selectedLocation = location),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _formKey.currentState!.reset(),
                    child: const Text('Reset'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _savePlace,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Place'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
