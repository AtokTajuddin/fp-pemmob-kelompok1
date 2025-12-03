import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/support_chat_providers.dart';
import '../domain/support_chat_message.dart';

class SupportChatScreen extends ConsumerStatefulWidget {
  const SupportChatScreen({super.key});

  @override
  ConsumerState<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends ConsumerState<SupportChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) {
      return;
    }
    setState(() => _sending = true);
    try {
      await ref.read(supportChatServiceProvider).sendUserMessage(text);
      if (!mounted) return;
      _messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) {
          return;
        }
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send message: $error')));
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(supportChatMessagesProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Row(
                children: [
                  const Icon(Icons.support_agent_outlined, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Support chat',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Talk to the finance team, they typically reply within a few minutes.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const _EmptyConversation();
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      return _SupportBubble(message: message);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, __) => _ChatErrorView(error: error),
              ),
            ),
            _Composer(
              controller: _messageController,
              sending: _sending,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onSend,
    required this.sending,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool sending;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 3,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Send a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: sending ? null : onSend,
              child: sending
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportBubble extends StatelessWidget {
  const _SupportBubble({required this.message});

  final SupportChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isSupport = message.fromSupport;
    final alignment = isSupport ? Alignment.centerLeft : Alignment.centerRight;
    final color = isSupport
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : Theme.of(context).colorScheme.primary;
    final textColor = isSupport ? Colors.black87 : Colors.white;

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSupport ? 0 : 16),
            bottomRight: Radius.circular(isSupport ? 16 : 0),
          ),
        ),
        child: Column(
          crossAxisAlignment: isSupport
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(message.text, style: TextStyle(color: textColor)),
            const SizedBox(height: 4),
            Text(
              _timeLabel(message.sentAt),
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeLabel(DateTime dateTime) {
    final now = DateTime.now();
    if (now.difference(dateTime).inDays == 0) {
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

class _EmptyConversation extends StatelessWidget {
  const _EmptyConversation();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.forum_outlined, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Ask the finance team anything about your account. They will respond shortly.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatErrorView extends StatelessWidget {
  const _ChatErrorView({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            'Unable to load chat',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text('$error', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
