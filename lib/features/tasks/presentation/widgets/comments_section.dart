import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/comment.dart';

/// Comments section widget
class CommentsSection extends StatefulWidget {
  const CommentsSection({
    super.key,
    required this.comments,
    required this.onAddComment,
    this.currentUserId,
    this.currentUserName,
  });

  final List<Comment> comments;
  final ValueChanged<String> onAddComment;
  final String? currentUserId;
  final String? currentUserName;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.comment),
            const SizedBox(width: 8),
            Text(
              'Comments (${widget.comments.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        if (widget.comments.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Text(
                'No comments yet. Be the first to comment!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ),
          )
        else
          ...widget.comments.map((comment) {
            final isCurrentUser = comment.authorId == widget.currentUserId;
            return _CommentCard(
              comment: comment,
              isCurrentUser: isCurrentUser,
            );
          }),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () {
                final text = _commentController.text.trim();
                if (text.isNotEmpty) {
                  widget.onAddComment(text);
                  _commentController.clear();
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({
    required this.comment,
    required this.isCurrentUser,
  });

  final Comment comment;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: isCurrentUser
                      ? context.colorScheme.primary
                      : Colors.grey,
                  child: Text(
                    (comment.authorName ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.authorName ?? 'Anonymous',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (comment.createdAt != null)
                        Text(
                          comment.createdAt!.toFormattedString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              comment.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

