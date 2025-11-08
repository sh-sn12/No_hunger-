import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SharedExplorePage extends StatefulWidget {
  final String userType; // 'volunteer' or 'restaurant'

  const SharedExplorePage({
    super.key,
    required this.userType,
  });

  @override
  State<SharedExplorePage> createState() => _SharedExplorePageState();
}

class _SharedExplorePageState extends State<SharedExplorePage> {
  final List<Post> _posts = [
    Post(
      username: 'Restaurant A',
      userType: 'restaurant',
      imageUrl: 'https://picsum.photos/500/300',
      caption: 'Surplus food available for collection! 🍱',
      location: 'City Center',
      timeAgo: '2h ago',
      likes: 45,
    ),
    Post(
      username: 'Volunteer John',
      userType: 'volunteer',
      imageUrl: 'https://picsum.photos/500/301',
      caption: 'Successfully distributed food to 100 people today! 🙌',
      location: 'Downtown',
      timeAgo: '5h ago',
      likes: 89,
    ),
    // Add more sample posts
  ];

  Future<void> _handleNewPost() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    // Show post creation dialog
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => _CreatePostDialog(
        image: image,
        userType: widget.userType,
        onPost: (Post newPost) {
          setState(() {
            _posts.insert(0, newPost);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Show search functionality
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement refresh functionality
        },
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            return _PostCard(post: post);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleNewPost,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }
}

class Post {
  final String username;
  final String userType;
  final String imageUrl;
  final String caption;
  final String location;
  final String timeAgo;
  int likes;

  Post({
    required this.username,
    required this.userType,
    required this.imageUrl,
    required this.caption,
    required this.location,
    required this.timeAgo,
    required this.likes,
  });
}

class _PostCard extends StatefulWidget {
  final Post post;

  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.post.userType == 'restaurant'
                  ? Colors.orange
                  : Colors.blue,
              child: Icon(
                widget.post.userType == 'restaurant'
                    ? Icons.restaurant
                    : Icons.volunteer_activism,
                color: Colors.white,
              ),
            ),
            title: Text(
              widget.post.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(widget.post.location),
            trailing: Text(
              widget.post.timeAgo,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          Image.network(
            widget.post.imageUrl,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked;
                          if (_isLiked) {
                            widget.post.likes++;
                          } else {
                            widget.post.likes--;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {
                        // Show comments
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Share post
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${widget.post.likes} likes',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: widget.post.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(text: widget.post.caption),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatePostDialog extends StatefulWidget {
  final XFile image;
  final String userType;
  final Function(Post) onPost;

  const _CreatePostDialog({
    required this.image,
    required this.userType,
    required this.onPost,
  });

  @override
  State<_CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<_CreatePostDialog> {
  final _captionController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Post'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              widget.image.path,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: 'Caption',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final newPost = Post(
              username: widget.userType == 'restaurant'
                  ? 'Restaurant Name'
                  : 'Volunteer Name',
              userType: widget.userType,
              imageUrl: widget.image.path,
              caption: _captionController.text,
              location: _locationController.text,
              timeAgo: 'Just now',
              likes: 0,
            );
            widget.onPost(newPost);
            Navigator.pop(context);
          },
          child: const Text('Post'),
        ),
      ],
    );
  }
}
