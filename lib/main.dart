import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF2E2E38), // Fundo escuro
        fontFamily: 'Roboto',
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

@override
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];
  bool _isInitialScreen = true;
  late SharedPreferences _prefs;
  List<Map<String, dynamic>> _conversations = [];
  int _currentConversationIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String> loadedConversations =
        _prefs.getStringList('conversations') ?? [];
    setState(() {
      _conversations = loadedConversations
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();
      if (_conversations.isNotEmpty) {
        _currentConversationIndex = 0;
        _messages.addAll(List<String>.from(_conversations[0]['messages']));
        _isInitialScreen = _messages.isEmpty;
      }
    });
  }

  Future<void> _saveConversations() async {
    final List<String> jsonConversations = _conversations
        .map((conv) => jsonEncode(conv))
        .toList();
    await _prefs.setStringList('conversations', jsonConversations);
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) {
      return;
    }

    if (_isInitialScreen) {
      _startNewConversation();
    }
    _textController.clear();
    setState(() {
      _messages.add(text);
      _isInitialScreen = false;
      _conversations[_currentConversationIndex]['messages'].add(text);
    });
    _saveConversations();
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _isInitialScreen = true;
      if (_currentConversationIndex != -1) {
        _conversations.removeAt(_currentConversationIndex);
        _currentConversationIndex = -1;
      }
    });
    _saveConversations();
  }

  void _startNewConversation() {
    final newConversation = {
      'name': 'Conversa #${_conversations.length + 1}',
      'messages': [],
    };
    setState(() {
      _conversations.insert(0, newConversation);
      _currentConversationIndex = 0;
      _messages.clear();
      _isInitialScreen = true;
    });
    _saveConversations();
  }

  void _loadConversation(int index) {
    setState(() {
      _currentConversationIndex = index;
      _messages.clear();
      _messages.addAll(List<String>.from(_conversations[index]['messages']));
      _isInitialScreen = _messages.isEmpty;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFF2E2E38),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white10),
              child: Text(
                'Histórico',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  color: Colors.white,
                ),
              ),
            ),
            ..._conversations.asMap().entries.map((entry) {
              final index = entry.key;
              final conv = entry.value;
              return ListTile(
                title: Text(
                  conv['name'],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () => _loadConversation(index),
              );
            }),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E38),
        // Cor de fundo da AppBar
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Center(
          child: Image.asset(
            'assets/images/logo_darkmode.png',
            width: 40,
            //height: 150,
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          /*
          IconButton(
            icon: const Icon(
              Icons.nightlight_round,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              // TODO: Alternar modo noturno
            },
          ),
          */
          //Botão: Deletar conversa
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 24,
            ),
            onPressed: _clearChat,
          ),
          // Botão: Nova Conversa
          TextButton(
            onPressed: _startNewConversation,
            child: const Text(
              'Nova Conversa',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          if (_isInitialScreen)
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Como posso ajudar?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildModeButton('Modo Inclusivo', true),
                      const SizedBox(width: 10),
                      _buildModeButton('Modo Libras', false),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildStartConversationButton(),
                ],
              ),
            )
          else
            ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 80.0,
                top: 10.0,
                left: 16.0,
                right: 16.0,
              ),
              reverse: false,
              // Isso faz com que a lista role para baixo por padrão
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: Alignment.centerRight, // Mensagem do usuário
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B6BCF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              color: const Color(0xFF4C4C59),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      decoration: const InputDecoration(
                        hintText: 'Pergunte ao CHAMBA-AI...',
                        hintStyle: TextStyle(color: Color(0xFF8F8F99)),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF6B6BCF),
                      size: 28,
                    ),
                    onPressed: () => _handleSubmitted(_textController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF5D5D6E) : Colors.transparent,
        border: Border.all(color: const Color(0xFF5D5D6E)),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF8F8F99),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildStartConversationButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF5D5D6E),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Text(
        'Comece a Conversar !',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
