import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/provider/auth_provider.dart';
import 'package:story_app_flutter_intermediate/provider/story_provider.dart';

class ListStoryPage extends StatelessWidget {
  const ListStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, child) {
          switch (storyProvider.state) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.hasData:
              return ListView.builder(
                itemCount: storyProvider.stories.length,
                itemBuilder: (context, index) {
                  final story = storyProvider.stories[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        context.push('/story/${story.id}');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            story.photoUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 200,
                                child: Center(child: Icon(Icons.error, color: Colors.red)),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              story.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            case ResultState.noData:
              return Center(child: Text(storyProvider.message));
            case ResultState.error:
              return Center(child: Text(storyProvider.message));
            default: // initial state
                return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
