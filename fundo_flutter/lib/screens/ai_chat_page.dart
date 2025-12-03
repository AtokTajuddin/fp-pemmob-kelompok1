import 'package:flutter/material.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isTyping = false;
  bool _isSendActive = false;
  bool _showContextBadge = true;

  final List<Map<String, dynamic>> _messages = [];

  final List<String> _suggestions = [
    "How much did I spend on food?",
    "Can I afford a new phone?",
    "Analyze my savings",
    "Show my expenses trend"
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _isSendActive = _textController.text.trim().isNotEmpty;
      });
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"text": text, "isUser": true});
      _isTyping = true;
      _textController.clear();
      _isSendActive = false;
    });

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            "text": "Based on your transactions, you spent **Rp 1.200.000** on Food & Drinks this month. That's 20% less than last month! Great job saving money. 🍔💰",
            "isUser": false
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      
      // --- 1. APP BAR ---
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(6), 
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7EF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
            ),
            child: Image.asset('assets/images/fundoLogo.png'),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fundo Assistant",
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  "Powered by Gemini",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        children: [
          // --- 2. CONTEXT BADGE ---
          if (_showContextBadge)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFE0F7EF),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Using data from your last 50 transactions.",
                      style: TextStyle(fontSize: 12, color: Color(0xFF004D40)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showContextBadge = false),
                    child: const Icon(Icons.close, size: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),

          // --- 3. MAIN CHAT AREA ---
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : _buildChatList(),
          ),

          // --- 4. INPUT BAR ---
          _buildInputBar(),
        ],
      ),
    );
  }

  // Widget: Empty State
  Widget _buildEmptyState() {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Image.asset('assets/images/fundoLogo.png', width: 60, height: 60),
            ),
            const SizedBox(height: 20),
            Text(
              "Hi! I'm Fundo.",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 8),
            const Text(
              "Ask me anything about your money.\nI can analyze your spending habits!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _suggestions.map((suggestion) {
                return ActionChip(
                  label: Text(suggestion),
                  backgroundColor: cardColor,
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  labelStyle: TextStyle(color: textColor, fontSize: 13),
                  onPressed: () => _sendMessage(suggestion),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Message List
  Widget _buildChatList() {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isTyping && index == _messages.length) {
          return _buildTypingIndicator();
        }

        final message = _messages[index];
        final isUser = message['isUser'];

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF10B981) : cardColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                bottomRight: isUser ? Radius.zero : const Radius.circular(16),
              ),
              boxShadow: isUser ? [] : [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))
              ],
            ),
            child: Text(
              message['text'],
              style: TextStyle(
                color: isUser ? Colors.white : textColor,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget: Typing Indicator
  Widget _buildTypingIndicator() {
    final cardColor = Theme.of(context).cardColor;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/fundoLogo.png', width: 16, height: 16),
            const SizedBox(width: 8),
            Text(
              "Typing...",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  // Widget: Input Bar
  Widget _buildInputBar() {
    final cardColor = Theme.of(context).cardColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Text Field
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Ask a financial question...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                onSubmitted: _sendMessage,
              ),
            ),

            const SizedBox(width: 8),

            // Send Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _isSendActive ? const Color(0xFF10B981) : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                onPressed: _isSendActive ? () => _sendMessage(_textController.text) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}