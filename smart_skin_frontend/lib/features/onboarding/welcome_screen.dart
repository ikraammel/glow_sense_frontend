import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback? onFinished;
  const WelcomeScreen({super.key, this.onFinished});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Barre supérieure : logo + badge
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3),
                        children: [
                          TextSpan(
                              text: 'Glow',
                              style: TextStyle(color: AppColors.textDark)),
                          TextSpan(
                              text: 'Sense',
                              style: TextStyle(color: AppColors.primaryPink)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color:
                        AppColors.primaryPink.withOpacity(0.15),
                        border: Border.all(
                            color: AppColors.primaryPink
                                .withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'EXPERTISE IA',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: AppColors.deepPink),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Animation de scan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPink.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: Stack(
                        children: [
                          // AVANT
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/skin_before.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          
                          // Filtre "Avant"
                          Positioned.fill(
                            child: Container(color: Colors.brown.withOpacity(0.1)),
                          ),

                          // APRÈS — révélé par le scan
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (_, __) => ClipRect(
                              clipper: _ScanClipper(_controller.value),
                              child: SizedBox(
                                width: double.infinity,
                                height: 400,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        'assets/images/skin_after.jpeg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Effet Glow
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: RadialGradient(
                                            colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                                            center: const Alignment(-0.3, -0.4),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Center(
                                      child: Icon(Icons.auto_awesome, color: Colors.white70, size: 80),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // LIGNE LASER
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (_, __) => Positioned(
                              top: 400 * _controller.value - 2,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.transparent,
                                    AppColors.primaryPink.withOpacity(0.5),
                                    AppColors.primaryPink,
                                    Colors.white,
                                    AppColors.primaryPink,
                                    AppColors.primaryPink.withOpacity(0.5),
                                    Colors.transparent,
                                  ]),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryPink.withOpacity(0.7),
                                      blurRadius: 16,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // ÉTIQUETTES
                          const Positioned(
                            top: 14,
                            left: 14,
                            child: _ScanLabel('AVANT'),
                          ),
                          const Positioned(
                            top: 14,
                            right: 14,
                            child: _ScanLabel('APRÈS'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ── Ligne de stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: const [
                    Expanded(child: _StatCard('40K+', 'Utilisateurs', null)),
                    SizedBox(width: 10),
                    Expanded(
                        child:
                        _StatCard('98%', 'Satisfaction', '★★★★★')),
                    SizedBox(width: 10),
                    Expanded(
                        child: _StatCard('30s', 'Analyse IA', null)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Texte de présentation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const Text(
                      'RÉVÉLEZ VOTRE ÉCLAT NATUREL',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 3,
                          color: AppColors.deepPink),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textDark,
                            height: 1.15,
                            letterSpacing: -0.5),
                        children: [
                          TextSpan(text: 'Analysez.\n'),
                          TextSpan(
                            text: 'Transformez.\n',
                            style: TextStyle(color: AppColors.primaryPink),
                          ),
                          TextSpan(text: 'Éclatez.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Dites adieu aux imperfections. Notre IA analyse votre peau en 30 secondes et crée votre plan beauté sur-mesure.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                          height: 1.65),
                    ),
                    const SizedBox(height: 18),

                    // Badges fonctionnalités
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: const [
                        _FeatureBadge('Analyse IA précise'),
                        _FeatureBadge('Plan personnalisé'),
                        _FeatureBadge('Résultats prouvés'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Bouton d'action
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFinished?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: AppColors.primaryPink.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "COMMENCER L'AVENTURE",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                            color: AppColors.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                'Gratuit · Sans engagement · 40 000 utilisateurs satisfaits',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanClipper extends CustomClipper<Rect> {
  final double progress;
  const _ScanClipper(this.progress);

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width, size.height * progress);

  @override
  bool shouldReclip(_ScanClipper old) => old.progress != progress;
}

class _ScanLabel extends StatelessWidget {
  final String text;
  const _ScanLabel(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5),
    ),
  );
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final String? stars;
  const _StatCard(this.number, this.label, this.stars);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border:
      Border.all(color: AppColors.primaryPink.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Column(
      children: [
        Text(
          number,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryPink),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
              fontSize: 10,
              color: AppColors.textGrey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5),
        ),
        if (stars != null) ...[
          const SizedBox(height: 3),
          Text(
            stars!,
            style: const TextStyle(
                fontSize: 10, color: AppColors.primaryPink),
          ),
        ],
      ],
    ),
  );
}

class _FeatureBadge extends StatelessWidget {
  final String text;
  const _FeatureBadge(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white,
      border:
      Border.all(color: AppColors.primaryPink.withOpacity(0.2)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.primaryPink,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
