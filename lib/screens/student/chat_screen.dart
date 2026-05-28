import 'package:flutter/material.dart';
import '../../services/message_service.dart';
import '../../services/report_service.dart';
import '../../models/message_model.dart';
import '../../main.dart';

class ChatScreen extends StatefulWidget {
  final String reportId;
  const ChatScreen({super.key, required this.reportId});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _msgService = MessageService();
  List<Message> _messages = [];
  bool _loading = true;
  String? _receiverId;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final report = await ReportService().getReportById(widget.reportId);
      _receiverId = report.userId;
      _messages = await _msgService.getMessages(widget.reportId);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _send() async {
    if (_msgCtrl.text.trim().isEmpty || _receiverId == null) return;
    await _msgService.sendMessage(
      reportId: widget.reportId,
      receiverId: _receiverId!,
      content: _msgCtrl.text.trim(),
    );
    _msgCtrl.clear();
    await _loadMessages();
  }

  @override
  void dispose() { _msgCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final myId = supabase.auth.currentUser?.id;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? Center(child: Text('No messages yet. Say hi!', style: theme.textTheme.bodySmall))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (_, i) {
                            final m = _messages[i];
                            final isMe = m.senderId == myId;
                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                decoration: BoxDecoration(
                                  color: isMe ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(m.content, style: TextStyle(color: isMe ? Colors.white : theme.colorScheme.onSurface)),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(top: BorderSide(color: theme.colorScheme.outline, width: 0.5)),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _msgCtrl,
                            decoration: const InputDecoration(hintText: 'Type a message...', border: InputBorder.none, filled: false),
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                        IconButton(icon: Icon(Icons.send, color: theme.colorScheme.primary), onPressed: _send),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
