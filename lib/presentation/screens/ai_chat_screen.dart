import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  static const _messages = [
    _AiMessage(
      text: 'Hola, soy EcoBot. ¿En qué puedo ayudarte hoy?',
      fromBot: true,
      time: '13:40',
    ),
    _AiMessage(
      text: 'Necesito ideas para reutilizar madera sobrante.',
      fromBot: false,
      time: '13:41',
    ),
    _AiMessage(
      text:
          'Claro. ¿Quieres inspiración de diseño o instrucciones paso a paso?',
      fromBot: true,
      time: '13:41',
    ),
    _AiMessage(
      text: 'Instrucciones para un panel decorativo.',
      fromBot: false,
      time: '13:42',
    ),
    _AiMessage(
      text:
          'Genial. Te propongo: lija ligera, aplica sellador, arma un marco con listones y fija las tablas en espiga. ¿Te comparto una lista de herramientas?',
      fromBot: true,
      time: '13:42',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFDFBF6),
                  Color(0xFFF4F7FA),
                  Color(0xFFEFF2F6),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Color(0xFF1A1A1A)),
                        onPressed: () => _openHistory(context),
                      ),
                      const SizedBox(width: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EcoBot',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          Text(
                            'Asistente AI circular',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.auto_awesome,
                                color: Colors.blueGrey[600], size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Mock',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _TipCard(),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final align = msg.fromBot
                          ? Alignment.centerLeft
                          : Alignment.centerRight;
                      final bubbleColor = msg.fromBot
                          ? Colors.white
                          : const Color(0xFFD4AF37).withOpacity(0.15);
                      final textColor = msg.fromBot
                          ? const Color(0xFF1A1A1A)
                          : Colors.black87;
                      return Align(
                        alignment: align,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          constraints: const BoxConstraints(maxWidth: 320),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (msg.fromBot)
                                Text(
                                  'EcoBot',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              if (msg.fromBot) const SizedBox(height: 6),
                              Text(
                                msg.text,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: textColor,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                msg.time,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mic_none, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Próximamente: escribe o habla con EcoBot.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFD4AF37), Color(0xFFF4D03F)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.send,
                              color: Colors.white, size: 18),
                        ),
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

  void _openHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Historial de chats',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 10),
              ...[
                'Ideas para panel decorativo',
                'Cotización de concreto reciclado',
                'Guía para reciclar vidrio',
              ].map(
                (title) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.chat_bubble_outline,
                      color: Color(0xFF1A1A1A)),
                  title: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  subtitle: Text(
                    'Mock - pronto podrás retomarlo.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome,
                color: Color(0xFF1A1A1A), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sugerencias rápidas',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pide tutoriales paso a paso, ideas de upcycling o resúmenes de producto.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[700],
                    height: 1.3,
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

class _AiMessage {
  final String text;
  final bool fromBot;
  final String time;

  const _AiMessage({
    required this.text,
    required this.fromBot,
    required this.time,
  });
}
