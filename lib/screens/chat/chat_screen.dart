import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/message.dart';
import '../../providers/data_provider.dart';
import '../../theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(BuildContext context) {
    if (_messageController.text.trim().isEmpty) return;

    final provider = context.read<DataProvider>();
    final currentUser = provider.currentUser;
    final userName = currentUser?.name ?? 'User';
    final userId = currentUser?.uid ?? '';

    final msg = ChatMessage(
      id: const Uuid().v4(),
      senderId: userId,
      senderName: userName,
      text: _messageController.text.trim(),
      timestamp: DateTime.now(),
      clubId: provider.activeClubId,
    );

    provider.sendMessage(msg);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();
    final messages = provider.chatMessages;
    final currentUser = provider.currentUser;
    final currentUserId = currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: ClubOsTheme.solarBase,
      body: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(ClubOsTheme.gutterLarge, 60, ClubOsTheme.gutterLarge, 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMMUNICATIONS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Text('INTEL STREAM', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text('NO DATA IN STREAM', style: TextStyle(color: ClubOsTheme.onSurfaceVariant, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: ClubOsTheme.gutterLarge, vertical: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == currentUserId;
                      return _buildMessageBubble(msg, isMe);
                    },
                  ),
          ),
          
          // Input Area
          Container(
            padding: EdgeInsets.fromLTRB(ClubOsTheme.gutter, ClubOsTheme.gutter, ClubOsTheme.gutter, 40),
            decoration: BoxDecoration(
              color: ClubOsTheme.solarSurfaceLowest,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: ClubOsTheme.onSurfaceMain),
                    decoration: InputDecoration(
                      hintText: 'Transmit message...',
                      hintStyle: TextStyle(color: ClubOsTheme.onSurfaceVariant),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ClubOsTheme.outlineVariant.withOpacity(0.05)),
                      ),
                      filled: true,
                      fillColor: ClubOsTheme.solarSurfaceLow.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(context),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: ClubOsTheme.primaryCommand,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    onPressed: () => _sendMessage(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: ClubOsTheme.primaryCommand.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(msg.senderName[0].toUpperCase(), style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ClubOsTheme.primaryCommand)),
              ),
            ),
          if (!isMe) const SizedBox(width: 8),
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isMe ? ClubOsTheme.primaryCommand : ClubOsTheme.solarSurfaceLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ClubOsTheme.outlineVariant.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(color: (isMe ? ClubOsTheme.primaryCommand : Colors.black).withOpacity(0.04), blurRadius: 10),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(msg.senderName.toUpperCase(), style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ClubOsTheme.onSurfaceVariant, letterSpacing: 0.5)),
                  ),
                Text(
                  msg.text,
                  style: TextStyle(color: isMe ? Colors.white : ClubOsTheme.onSurfaceMain, fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
