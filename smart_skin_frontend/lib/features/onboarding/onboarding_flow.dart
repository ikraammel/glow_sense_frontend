import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../constants/colors.dart';
import '../../data/services/api_service.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});
  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _pageCtrl = PageController();
  int _currentPage = 0;
  static const int _totalPages = 10;
  bool _isLoading = false;
  bool _showWelcome = false;

  // ── Étape 1 : Nom ─────────────────────────────────────────────────────────
  final _nameCtrl = TextEditingController();

  // ── Étape 2 : À propos de vous ──────────────────────────────────────────────
  final _ageCtrl = TextEditingController();
  String? _gender;        // 'Femme' | 'Homme'
  String? _skinType;      // 'Sèche' | 'Grasse' | 'Mixte' | 'Normale' | 'Sensible' | 'Pas sûr'

  // ── Étape 3 : Ethnicité ───────────────────────────────────────────────────
  String? _ethnicity;

  // ── Étape 4 : Problèmes de peau ──────────────────────────────────────────────
  final List<String> _concerns = [];

  // ── Étape 5 : Votre peau aujourd'hui ──────────────────────────────────────────
  String? _sensitivity;
  String? _tiredness;
  String? _stress;

  // ── Étape 6 : Exposition au soleil ──────────────────────────────────────────
  String? _sunExposure;

  // ── Étape 7 : Préférence de routine ─────────────────────────────────────────
  String? _routinePreference;

  // ── Étape 8 : Ingrédients à éviter ─────────────────────────────────────────
  final List<String> _ingredientsToAvoid = [];

  // ── Étape 9 : Niveau d'effort ──────────────────────────────────────────────
  String? _effortLevel;

  // ── Étape 10 : Bénéfices souhaités ──────────────────────────────────────────
  final List<String> _benefits = [];

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage++);
    } else {
      _submitOnboarding();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage--);
    }
  }

  Future<void> _submitOnboarding() async {
    setState(() => _isLoading = true);
    try {
      await context.read<ApiService>().completeOnboarding({
        'name': _nameCtrl.text.trim(),
        'age': int.tryParse(_ageCtrl.text.trim()) ?? 0,
        'gender': _gender ?? '',
        'skinType': _mapSkinType(_skinType),
        'ethnicity': _ethnicity ?? '',
        'skinConcerns': _concerns.join(','),
        'skinSensitivity': _sensitivity ?? '',
        'tirednessLevel': _tiredness ?? '',
        'stressLevel': _stress ?? '',
        'sunExposure': _mapSunExposure(_sunExposure),
        'routinePreference': _mapRoutine(_routinePreference),
        'ingredientsToAvoid': _ingredientsToAvoid.join(','),
        'effortLevel': _mapEffort(_effortLevel),
        'desiredBenefits': _benefits.join(','),
      });
      setState(() { _isLoading = false; _showWelcome = true; });
      await Future.delayed(const Duration(seconds: 4));
      if (mounted) context.read<AuthBloc>().add(const CheckAuthStatus());
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    }
  }

  // ── Mappers label → valeur backend ────────────────────────────────────────
  String _mapSkinType(String? v) {
    const m = {
      'Sèche': 'SEC', 'Grasse': 'GRAS', 'Mixte': 'MIXTE',
      'Normale': 'NORMAL', 'Sensible': 'SENSIBLE', 'Pas sûr': 'NORMAL',
    };
    return m[v] ?? 'NORMAL';
  }

  String _mapSkinConcern(String? v) {
    const m = {
      'Pas sûr': 'NOT_SURE', 'Acné': 'ACNE', 'Rides et ridules': 'WRINKLES',
      'Peau grasse': 'OILY', 'Pores dilatés': 'PORES', 'Rougeurs': 'REDNESS',
      'Taches brunes': 'DARK_SPOTS', 'Cernes': 'DARK_CIRCLES',
      'Déshydratation': 'DEHYDRATION', 'Sensibilité': 'SENSITIVITY', 'Teint irrégulier': 'UNEVEN_TONE'
    };
    return m[v] ?? 'NOT_SURE';
  }

  String _mapSunExposure(String? v) {
    if (v == null) return 'moderate';
    if (v.startsWith('Rarement')) return 'rare';
    if (v.startsWith('Un peu')) return 'moderate';
    if (v.startsWith('Souvent')) return 'frequent';
    return 'moderate';
  }

  String _mapRoutine(String? v) {
    if (v == null) return 'moderate';
    if (v.startsWith('Produits courants')) return 'common';
    if (v.startsWith('Tout naturel')) return 'natural';
    if (v.startsWith('Qualité médicale')) return 'medical';
    return 'moderate';
  }

  String _mapEffort(String? v) {
    if (v == null) return 'medium';
    if (v.startsWith('Minimaliste')) return 'low';
    if (v.startsWith('Modéré')) return 'medium';
    if (v.startsWith('Enthousiaste')) return 'high';
    return 'medium';
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) return _buildWelcomeScreen();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildNamePage(),           // 0
                  _buildAboutPage(),          // 1
                  _buildEthnicityPage(),      // 2
                  _buildConcernsPage(),       // 3
                  _buildSkinTodayPage(),      // 4
                  _buildSunExposurePage(),    // 5
                  _buildRoutinePrefPage(),    // 6
                  _buildIngredientsPage(),    // 7
                  _buildEffortPage(),         // 8
                  _buildBenefitsPage(),       // 9
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── Header (flèche retour + barre de progression) ───────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          if (_currentPage > 0)
            GestureDetector(
              onTap: _prevPage,
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.black87),
              ),
            )
          else
            const SizedBox(width: 38),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / _totalPages,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPink),
              ),
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  // ── Barre du bas ─────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryPink,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primaryPink.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(height: 22, width: 22,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : Text(_currentPage < _totalPages - 1 ? 'Suivant' : 'Commencer',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 0 — Quel est votre nom ?
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildNamePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quel est votre nom ?",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: 10),
          const Text(
            "Commençons par personnaliser votre parcours de soins de la peau ; apprenons à nous connaître !",
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 56),
          TextField(
            controller: _nameCtrl,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryPink, width: 2)),
              hintText: 'Votre nom',
              hintStyle: TextStyle(fontSize: 26, color: Colors.black26, fontWeight: FontWeight.bold),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 1 — Parlez-nous de vous
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAboutPage() {
    final skinTypes = ['Sèche', 'Grasse', 'Mixte', 'Normale', 'Sensible', 'Pas sûr'];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Parlez-nous de vous",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text("Nous utilisons ces informations pour personnaliser vos recommandations de soins.",
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4)),
          const SizedBox(height: 22),

          // Âge
          _sectionCard(
            label: 'Âge',
            child: TextField(
              controller: _ageCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Tapez votre âge...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryPink, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Genre
          _sectionCard(
            label: 'Genre',
            child: Row(
              children: ['Femme', 'Homme'].map((g) {
                final sel = _gender == g;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _gender = g),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primaryPink.withOpacity(0.12) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? AppColors.primaryPink : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Text(g,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                            color: sel ? AppColors.deepPink : Colors.black87,
                          )),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Type de peau
          _sectionCard(
            label: 'Type de peau',
            child: Wrap(
              spacing: 8, runSpacing: 8,
              children: skinTypes.map((s) {
                final sel = _skinType == s;
                return GestureDetector(
                  onTap: () => setState(() => _skinType = s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primaryPink.withOpacity(0.12) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel ? AppColors.primaryPink : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(s,
                        style: TextStyle(
                          fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                          color: sel ? AppColors.deepPink : Colors.black87,
                          fontSize: 14,
                        )),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 2 — Ethnicité
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEthnicityPage() {
    final options = [
      'Asie de l\'Est',
      'Asie du Sud',
      'Noir / Origine Africaine',
      'Moyen-Orient / Afrique du Nord',
      'Latino / Hispanique',
      'Blanc / Caucasien',
      'Préfère ne pas répondre',
    ];
    return _buildRadioListPage(
      title: 'Quelle est votre ethnicité ?',
      subtitle: 'Différents types de peau ont des attributs uniques – nous avons ce qu\'il vous faut, peu importe les vôtres.',
      options: options,
      selected: _ethnicity,
      onSelect: (v) => setState(() => _ethnicity = v),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 3 — Problèmes de peau
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildConcernsPage() {
    final concerns = [
      'Pas sûr',
      'Acné',
      'Rides et ridules',
      'Peau grasse',
      'Pores dilatés',
      'Rougeurs',
      'Taches brunes',
      'Cernes',
      'Déshydratation',
      'Sensibilité',
      'Teint irrégulier',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Quels sont vos\nproblèmes de peau ?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.25)),
          const SizedBox(height: 10),
          const Text(
            "Concentrez-vous sur ce qui compte le plus pour vous, nous approfondirons au fil de votre progression.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 28),
          // Face image + chips layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: decorative face illustration placeholder
              Container(
                width: 120, height: 320,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.face_retouching_natural,
                      size: 80, color: AppColors.primaryPink),
                ),
              ),
              const SizedBox(width: 14),
              // Right: concern chips
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: concerns.map((c) {
                    final sel = _concerns.contains(c);
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (c == 'Pas sûr') {
                          _concerns.clear();
                          if (!sel) _concerns.add(c);
                        } else {
                          _concerns.remove('Pas sûr');
                          if (sel) _concerns.remove(c); else _concerns.add(c);
                        }
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
                        decoration: BoxDecoration(
                          color: sel
                              ? const Color(0xFFFFF9E6)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: sel ? const Color(0xFFE8C97A) : Colors.grey.shade200,
                            width: sel ? 1.5 : 1,
                          ),
                        ),
                        child: Text(c,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                              color: sel ? const Color(0xFF7A6020) : Colors.black87,
                            )),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 4 — Votre peau aujourd'hui
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSkinTodayPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Comment est votre peau aujourd'hui ?",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.25)),
          const SizedBox(height: 8),
          const Text("Les facteurs quotidiens affectent votre peau. Connaissez sa sensibilité en quelques secondes.",
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4)),
          const SizedBox(height: 24),
          _subQuestion(
            "À quel point votre peau semble-t-elle sensible ?",
            ['Pas sensible', 'Légèrement sensible', 'Modérément sensible', 'Très sensible'],
            _sensitivity,
                (v) => setState(() => _sensitivity = v),
          ),
          const SizedBox(height: 22),
          _subQuestion(
            "À quel point vous sentez-vous fatigué ?",
            ['Bien reposé', 'Légèrement fatigué', 'Modérément fatigué', 'Très fatigué'],
            _tiredness,
                (v) => setState(() => _tiredness = v),
          ),
          const SizedBox(height: 22),
          _subQuestion(
            "Quel est votre niveau de stress ?",
            ['Calme', 'Légèrement stressé', 'Modérément stressé', 'Très stressé'],
            _stress,
                (v) => setState(() => _stress = v),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 5 — Exposition au soleil
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSunExposurePage() {
    final options = [
      'Rarement (0-1 heure par jour)',
      'Un peu (2-3 heures par jour)',
      'Souvent (Plus de 3 heures par jour)',
      'Pas sûr',
    ];
    return _buildRadioListPage(
      title: 'Quelle est votre exposition au soleil ?',
      subtitle: 'Nous aimons aussi les journées ensoleillées, mais il est important de protéger votre peau.',
      options: options,
      selected: _sunExposure,
      onSelect: (v) => setState(() => _sunExposure = v),
      titleAlign: TextAlign.center,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 6 — Préférence de routine
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildRoutinePrefPage() {
    final options = [
      'Produits courants',
      'Tout naturel uniquement',
      'Produits de qualité médicale',
      "Je ne sais pas",
    ];
    return _buildRadioListPage(
      title: 'Préférence de routine',
      subtitle: 'Si vous deviez en choisir une, comment décririez-vous votre routine de soins idéale ?',
      options: options,
      selected: _routinePreference,
      onSelect: (v) => setState(() => _routinePreference = v),
      titleAlign: TextAlign.center,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 7 — Ingrédients à éviter
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildIngredientsPage() {
    final options = [
      'Pas sûr',
      'Parabènes',
      'Parfums synthétiques',
      'Formaldéhyde',
      'Sulfates (SLS & SLES)',
      'Phtalates',
      'Rétinol (pendant la grossesse)',
      'Talc',
      'Triclosan',
      'Ingrédients à base d\'alcool',
      'Hydroquinone',
      'Oxybenzone',
      'Autre',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Quels ingrédients\nsouhaitez-vous éviter ?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.25)),
          const SizedBox(height: 10),
          const Text(
            "Nous vous aiderons à les éviter dans votre routine et vos recommandations.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 10, runSpacing: 10,
            alignment: WrapAlignment.center,
            children: options.map((ing) {
              final sel = _ingredientsToAvoid.contains(ing);
              return GestureDetector(
                onTap: () => setState(() {
                  if (ing == 'Pas sûr') {
                    _ingredientsToAvoid.clear();
                    if (!sel) _ingredientsToAvoid.add(ing);
                  } else {
                    _ingredientsToAvoid.remove('Pas sûr');
                    if (sel) _ingredientsToAvoid.remove(ing);
                    else _ingredientsToAvoid.add(ing);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primaryPink.withOpacity(0.12) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: sel ? AppColors.primaryPink : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Text(ing,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                        color: sel ? AppColors.deepPink : Colors.black87,
                      )),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 8 — Niveau d'effort
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEffortPage() {
    final options = [
      'Minimaliste (1-3 étapes)',
      'Modéré (3-5 étapes)',
      'Enthousiaste (5 étapes ou plus)',
      'Pas sûr - décidez pour moi',
    ];
    return _buildRadioListPage(
      title: 'Quel niveau d\'effort\nsouhaitez-vous fournir ?',
      subtitle: 'Pensez au temps que vous souhaitez idéalement consacrer à votre routine.',
      options: options,
      selected: _effortLevel,
      onSelect: (v) => setState(() => _effortLevel = v),
      titleAlign: TextAlign.center,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  PAGE 9 — Bénéfices
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildBenefitsPage() {
    final options = [
      'Anti-âge',
      'Éclat',
      'Hydratation',
      'Contrôle du sébum',
      'Prévention de l\'acné',
      'Teint uniforme',
      'Réduction des pores',
      'Apaisant et calmant',
      'Protection solaire',
      'Raffermissant',
    ];

    return _buildRadioListPage(
      title: 'Quels bénéfices\nrecherchez-vous ?',
      subtitle: 'Imaginez votre routine de soins parfaite.',
      options: options,
      selected: _benefits.isEmpty ? null : _benefits.first,
      onSelect: (v) => setState(() {
        if (_benefits.contains(v)) _benefits.remove(v);
        else _benefits.add(v);
      }),
      multiSelected: _benefits,
      titleAlign: TextAlign.center,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  ÉCRAN DE BIENVENUE (après soumission)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildWelcomeScreen() {
    final authState = context.read<AuthBloc>().state;
    final name = authState is AuthAuthenticated
        ? authState.user.firstName
        : _nameCtrl.text.isNotEmpty ? _nameCtrl.text : '';

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 900),
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.scale(scale: value, child: child),
              ),
              child: const Icon(Icons.check_circle_outline, size: 100, color: Colors.white),
            ),
            const SizedBox(height: 40),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(offset: Offset(0, 30 * (1 - value)), child: child),
              ),
              child: Column(
                children: [
                  Text("Salut $name 🌸",
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  const Text("Bienvenue dans ton univers skincare !",
                      style: TextStyle(
                          fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  const Text(
                    "On est là pour comprendre ta peau et t'aider à révéler son meilleur éclat.",
                    style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  WIDGETS PARTAGÉS
  // ─────────────────────────────────────────────────────────────────────────

  /// Une page complète avec des rangées de listes de style radio (sélection unique ou multiple)
  Widget _buildRadioListPage({
    required String title,
    required String subtitle,
    required List<String> options,
    required String? selected,
    required Function(String) onSelect,
    List<String>? multiSelected,
    TextAlign titleAlign = TextAlign.left,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        crossAxisAlignment: titleAlign == TextAlign.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(title,
              textAlign: titleAlign,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.25)),
          const SizedBox(height: 10),
          Text(subtitle,
              textAlign: titleAlign,
              style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5)),
          const SizedBox(height: 26),
          ...options.map((opt) {
            final isSelected = multiSelected != null
                ? multiSelected.contains(opt)
                : selected == opt;
            return GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryPink.withOpacity(0.08)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryPink : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(opt,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? AppColors.deepPink : Colors.black87,
                          )),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AppColors.primaryPink : Colors.white,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryPink : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, size: 13, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  /// Carte de section groupée avec étiquette
  Widget _sectionCard({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  /// Sous-question avec des puces wrap (pour la page d'état de la peau du jour)
  Widget _subQuestion(String question, List<String> opts, String? selected, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: opts.map((opt) {
            final sel = selected == opt;
            return GestureDetector(
              onTap: () => onSelect(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primaryPink.withOpacity(0.10) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: sel ? AppColors.primaryPink : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(opt,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                      color: sel ? AppColors.deepPink : Colors.black87,
                    )),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
