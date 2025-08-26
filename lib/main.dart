import 'package:flutter/material.dart';

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

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
            ListTile(),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E38),
        // Cor de fundo da AppBar
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_darkmode.png',
              width: 40,
              height: 150,
            ),
            //TODO: Ajustar imagem
          ],
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
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              // TODO: Limpar conversa
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Conteúdo central
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
                // Botões de modo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildModeButton('Modo Inclusivo', true),
                    const SizedBox(width: 10),
                    _buildModeButton('Modo Libras', false),
                  ],
                ),
                const SizedBox(height: 15),
                // Botão "Comece a Conversar !"
                _buildStartConversationButton(),
              ],
            ),
          ),
          // Input fixo na parte inferior
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              color: const Color(0xFF4C4C59), // Fundo do campo de entrada
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Pergunte ao CHAMBA-IA...',
                        hintStyle: TextStyle(color: Color(0xFF8F8F99)),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF6B6BCF),
                      size: 28,
                    ),
                    onPressed: () {
                      // TODO: Implementar envio da mensagem
                    },
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
