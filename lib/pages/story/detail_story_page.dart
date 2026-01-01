import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/provider/story_provider.dart';

class DetailStoryPage extends StatefulWidget {
  final String id;

  const DetailStoryPage({super.key, required this.id});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoryProvider>(context, listen: false)
          .fetchDetailStory(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Story'),
      ),
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, child) {
          switch (storyProvider.detailState) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.hasData:
              final story = storyProvider.detailStory;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      story.photoUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(
                          height: 250,
                          child: Center(
                            child: Icon(Icons.error, color: Colors.red, size: 50),
                          ),
                        );
                      },
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
            case ResultState.error:
              return Center(child: Text(storyProvider.detailMessage));
            default:
              return const Center(child: Text(''));
          }
        },
      ),
    );
  }
}
