import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/home/home_bottom_nav_bar.dart';

class ChatTabScreen extends StatelessWidget {
  const ChatTabScreen({super.key});

  static const _threads = [
    _ChatThread(
      name: 'Ana Constructora',
      preview: 'Perfecto, ¿puedes enviarme fotos del lote?',
      time: '14:32',
      unread: 2,
      product: 'Ladrillos reutilizables',
      location: 'Tlalpan',
      imageUrl:
          'https://images.unsplash.com/photo-1503389152951-9f343605f61e?auto=format&fit=crop&w=500&q=60',
      accent: Color(0xFFD4AF37),
      status: 'Negociando',
      messages: [
        _MockMessage(
            text: 'Hola Ana, aún disponible.', fromMe: true, time: '14:20'),
        _MockMessage(
            text: '¡Genial! ¿precio por palé?', fromMe: false, time: '14:25'),
        _MockMessage(
            text: 'Podría dejarlo en \$950.', fromMe: true, time: '14:27'),
        _MockMessage(
            text: 'Perfecto, ¿puedes enviarme fotos del lote?',
            fromMe: false,
            time: '14:32'),
      ],
    ),
    _ChatThread(
      name: 'Carlos Reciclador',
      preview: '¿Haces entrega en CDMX centro?',
      time: '12:10',
      unread: 0,
      product: 'Barra de acero reciclado',
      location: 'Benito Juárez',
      imageUrl:
          'https://images.unsplash.com/photo-1451976426598-a7593bd6d0b2?auto=format&fit=crop&w=500&q=60',
      accent: Color(0xFF2E8B57),
      status: 'Consulta',
      messages: [
        _MockMessage(
            text: 'Hola Carlos, tengo 3 barras listas.',
            fromMe: true,
            time: '12:02'),
        _MockMessage(
            text: '¿Haces entrega en CDMX centro?',
            fromMe: false,
            time: '12:10'),
      ],
    ),
    _ChatThread(
      name: 'María Arquitecta',
      preview: 'Confirmado, paso mañana por la tarde.',
      time: '09:05',
      unread: 1,
      product: 'Puertas de madera',
      location: 'Coyoacán',
      imageUrl:
          'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?auto=format&fit=crop&w=500&q=60',
      accent: Color(0xFF1A73E8),
      status: 'Recogida',
      messages: [
        _MockMessage(
            text: 'Quedan 4 puertas sin daño.', fromMe: true, time: '08:50'),
        _MockMessage(
            text: 'Confirmado, paso mañana por la tarde.',
            fromMe: false,
            time: '09:05'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final totalUnread = _threads.fold<int>(0, (sum, t) => sum + t.unread);

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
                  Color(0xFFF5F7FB),
                  Color(0xFFEFF2F6),
                ],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFE0F2E9),
                          child: Icon(Icons.chat_bubble_outline,
                              color: Color(0xFF1A1A1A)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bandeja de chat',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_threads.length} conversaciones • $totalUnread sin leer',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome,
                                  color: Colors.blueGrey[600], size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Mock chats',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: _SummaryCard(unread: totalUnread),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final thread = _threads[index];
                        final isLast = index == _threads.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 120 : 14),
                          child: _ChatThreadCard(
                            thread: thread,
                            onOpen: () => _openMockChat(context, thread),
                          ),
                        );
                      },
                      childCount: _threads.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          HomeBottomNavBar(
            activeIndex: 2,
            onHomePressed: () =>
                Navigator.pushReplacementNamed(context, '/home'),
            onFavoritesPressed: () =>
                Navigator.pushReplacementNamed(context, '/favorites'),
            onChatPressed: () {},
            onAddPressed: () => Navigator.pushNamed(context, '/addMaterial'),
            onImpactPressed: () => Navigator.pushNamed(context, '/impact'),
          ),
        ],
      ),
    );
  }

  void _openMockChat(BuildContext context, _ChatThread thread) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: thread.accent.withOpacity(0.12),
                        child: Text(
                          thread.name[0].toUpperCase(),
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            thread.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            thread.product,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: thread.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          thread.status,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: thread.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: thread.messages.length,
                      itemBuilder: (context, index) {
                        final msg = thread.messages[index];
                        final align = msg.fromMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft;
                        final bubbleColor = msg.fromMe
                            ? thread.accent.withOpacity(0.14)
                            : Colors.grey[200];
                        final textColor = msg.fromMe
                            ? const Color(0xFF1A1A1A)
                            : Colors.black87;
                        return Align(
                          alignment: align,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: bubbleColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg.text,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
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
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.eco, color: thread.accent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Próximamente: respuestas en tiempo real.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Icon(Icons.send, color: Colors.grey[500], size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int unread;

  const _SummaryCard({required this.unread});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFF4D03F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.handshake, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Intercambios en curso',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  unread == 0
                      ? 'Todo al día, sin mensajes pendientes.'
                      : '$unread mensaje(s) sin leer. Responde y asegura tu trato.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios,
              size: 16, color: Colors.grey.withOpacity(0.8)),
        ],
      ),
    );
  }
}

class _ChatThreadCard extends StatelessWidget {
  final _ChatThread thread;
  final VoidCallback onOpen;

  const _ChatThreadCard({
    required this.thread,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final subtitleColor = Colors.grey[700];

    return GestureDetector(
      onTap: onOpen,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: Image.network(
                thread.imageUrl,
                width: 105,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            thread.name,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        Text(
                          thread.time,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      thread.product,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      thread.preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: subtitleColor,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _chip(
                          icon: Icons.place,
                          text: thread.location,
                          color: thread.accent,
                          textColor: const Color(0xFF1A1A1A),
                          background: thread.accent.withOpacity(0.12),
                        ),
                        _chip(
                          icon: Icons.layers,
                          text: thread.status,
                          color: Colors.black87,
                          textColor: Colors.black87,
                          background: Colors.black.withOpacity(0.06),
                        ),
                        if (thread.unread > 0)
                          _chip(
                            text: '${thread.unread} nuevo',
                            color: Colors.red[700]!,
                            textColor: Colors.red[700]!,
                            background: Colors.red.withOpacity(0.12),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({
    IconData? icon,
    required String text,
    required Color color,
    required Color textColor,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ChatThread {
  final String name;
  final String preview;
  final String time;
  final int unread;
  final String product;
  final String location;
  final String imageUrl;
  final Color accent;
  final String status;
  final List<_MockMessage> messages;

  const _ChatThread({
    required this.name,
    required this.preview,
    required this.time,
    required this.unread,
    required this.product,
    required this.location,
    required this.imageUrl,
    required this.accent,
    required this.status,
    required this.messages,
  });
}

class _MockMessage {
  final String text;
  final bool fromMe;
  final String time;

  const _MockMessage({
    required this.text,
    required this.fromMe,
    required this.time,
  });
}
