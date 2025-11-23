import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/impact_provider.dart';

class ImpactScreen extends StatefulWidget {
  const ImpactScreen({super.key});

  @override
  State<ImpactScreen> createState() => _ImpactScreenState();
}

class _ImpactScreenState extends State<ImpactScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<ImpactProvider>().loadUserImpact(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final impactProvider = context.watch<ImpactProvider>();
    final impact = impactProvider.aggregatedImpact;

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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: currentUser == null
                  ? _EmptyState(
                      title: 'Inicia sesión para ver tu impacto.',
                      subtitle:
                          'Registra tus materiales recuperados y mira tus ahorros ambientales.',
                    )
                  : impactProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios_new,
                                        color: Color(0xFF1A1A1A)),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const SizedBox(width: 6),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mi impacto ambiental',
                                        style: GoogleFonts.playfairDisplay(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      Text(
                                        'Seguimiento eco de tus intercambios',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              _ProfileCard(
                                  name: currentUser.name,
                                  email: currentUser.email),
                              const SizedBox(height: 18),
                              if (impact != null) ...[
                                _ImpactSummaryCard(
                                  co2: impact.co2Saved,
                                  energy: impact.energySaved,
                                  water: impact.waterSaved,
                                ),
                                const SizedBox(height: 16),
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 1.1,
                                  children: [
                                    _MetricTile(
                                      icon: Icons.cloud,
                                      label: 'CO₂ evitado',
                                      value:
                                          '${impact.co2Saved.toStringAsFixed(1)} kg',
                                      color: const Color(0xFF2E8B57),
                                    ),
                                    _MetricTile(
                                      icon: Icons.bolt,
                                      label: 'Energía ahorrada',
                                      value:
                                          '${impact.energySaved.toStringAsFixed(1)} kWh',
                                      color: const Color(0xFFE67E22),
                                    ),
                                    _MetricTile(
                                      icon: Icons.water_drop,
                                      label: 'Agua conservada',
                                      value:
                                          '${impact.waterSaved.toStringAsFixed(1)} L',
                                      color: const Color(0xFF1A73E8),
                                    ),
                                    _MetricTile(
                                      icon: Icons.recycling,
                                      label: 'Intercambios',
                                      value: 'Próximamente',
                                      color: const Color(0xFFD4AF37),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                _EmptyState(
                                  title: 'No hay registros de impacto aún.',
                                  subtitle:
                                      'Publica o rescata tu primer material para ver tus ahorros ambientales.',
                                ),
                              ],
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
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
                                        color: const Color(0xFFD4AF37)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.info_outline,
                                          color: Color(0xFF1A1A1A)),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Valores estimados basados en factores promedio de la industria de la construcción.',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileCard({required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFD4AF37).withOpacity(0.15),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
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
                name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactSummaryCard extends StatelessWidget {
  final double co2;
  final double energy;
  final double water;

  const _ImpactSummaryCard({
    required this.co2,
    required this.energy,
    required this.water,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFF4D03F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Impacto total',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${co2.toStringAsFixed(1)} kg CO₂ evitados',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${energy.toStringAsFixed(1)} kWh | ${water.toStringAsFixed(1)} L',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.eco_outlined,
              color: Color(0xFF1A1A1A), size: 30),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
