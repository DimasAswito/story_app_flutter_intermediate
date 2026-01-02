import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/provider/story_provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

class DetailStoryPage extends StatefulWidget {
  final String id;

  const DetailStoryPage({super.key, required this.id});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {
  String _address = 'Loading address...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storyProvider = Provider.of<StoryProvider>(context, listen: false);
      storyProvider.fetchDetailStory(widget.id).then((_) {
        final story = storyProvider.detailStory;
        if (story != null && story.lat != null && story.lon != null) {
          _getAddressFromLatLng(LatLng(story.lat!, story.lon!));
        }
      });
    });
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        setState(() {
          _address =
              '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}';
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Could not get address';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Story')),
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, child) {
          switch (storyProvider.detailState) {
            case ResultState.loading:
            case ResultState.initial:
              return const Center(child: CircularProgressIndicator());
            case ResultState.hasData:
              final story = storyProvider.detailStory;
              if (story == null) {
                return const Center(child: Text('Story not found.'));
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      story.photoUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            height: 250,
                            child: Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            story.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (story.lat != null && story.lon != null)
                            _buildMap(story.lat!, story.lon!),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            case ResultState.error:
              return Center(child: Text(storyProvider.detailMessage));
            default:
              return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }

  Widget _buildMap(double lat, double lon) {
    final position = LatLng(lat, lon);
    final marker = Marker(
      markerId: const MarkerId('story_location'),
      position: position,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(_address),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: position, zoom: 15),
              markers: {marker},
              mapType: MapType.normal, // Use normal map type to show POIs
            ),
          ),
        ],
      ),
    );
  }
}
