import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

import 'api_service.dart';
import 'bloc/prediction_bloc.dart';
import 'bloc/prediction_event.dart';
import 'bloc/prediction_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Score Predictor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => PredictionBloc(apiService: ApiService()),
        child: const PredictionScreen(),
      ),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  String _gender = 'female';
  String _raceEthnicity = 'group A';
  String _parentalLevel = "bachelor's degree";
  String _lunch = 'standard';
  String _testPrep = 'none';

  final _readingScoreController = TextEditingController();
  final _writingScoreController = TextEditingController();

  final List<String> genders = ['female', 'male'];
  final List<String> races = ['group A', 'group B', 'group C', 'group D', 'group E'];
  final List<String> parentalLevels = [
    "bachelor's degree",
    "some college",
    "master's degree",
    "associate's degree",
    "high school",
    "some high school"
  ];
  final List<String> lunches = ['standard', 'free/reduced'];
  final List<String> testPreps = ['none', 'completed'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'gender': _gender,
        'race_ethnicity': _raceEthnicity,
        'parental_level_of_education': _parentalLevel,
        'lunch': _lunch,
        'test_preparation_course': _testPrep,
        'reading_score': int.parse(_readingScoreController.text),
        'writing_score': int.parse(_writingScoreController.text),
      };

      context.read<PredictionBloc>().add(PredictScoreEvent(data));
    }
  }

  @override
  void dispose() {
    _readingScoreController.dispose();
    _writingScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF3B359A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                  const Gap(16),
                  Text(
                    'Math Score Predictor',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    'Estimate your expected math score using machine learning.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(32),
                  _buildFormCard(),
                  const Gap(24),
                  _buildPredictionResult(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 12,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Student Details',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3B359A),
                ),
              ),
              const Gap(20),
              _buildDropdown(
                label: 'Gender',
                value: _gender,
                items: genders,
                onChanged: (val) => setState(() => _gender = val!),
                icon: Icons.person_outline,
              ),
              const Gap(16),
              _buildDropdown(
                label: 'Race/Ethnicity',
                value: _raceEthnicity,
                items: races,
                onChanged: (val) => setState(() => _raceEthnicity = val!),
                icon: Icons.public,
              ),
              const Gap(16),
              _buildDropdown(
                label: 'Parent Admin',
                value: _parentalLevel,
                items: parentalLevels,
                onChanged: (val) => setState(() => _parentalLevel = val!),
                icon: Icons.family_restroom,
              ),
              const Gap(16),
              _buildDropdown(
                label: 'Lunch Type',
                value: _lunch,
                items: lunches,
                onChanged: (val) => setState(() => _lunch = val!),
                icon: Icons.restaurant_menu,
              ),
              const Gap(16),
              _buildDropdown(
                label: 'Test Prep Course',
                value: _testPrep,
                items: testPreps,
                onChanged: (val) => setState(() => _testPrep = val!),
                icon: Icons.menu_book,
              ),
              const Gap(16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildNumberField(
                      controller: _readingScoreController,
                      label: 'Reading Score',
                      icon: Icons.chrome_reader_mode,
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: _buildNumberField(
                      controller: _writingScoreController,
                      label: 'Writing Score',
                      icon: Icons.edit_note,
                    ),
                  ),
                ],
              ),
              const Gap(32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Predict Score',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionResult() {
    return BlocBuilder<PredictionBloc, PredictionState>(
      builder: (context, state) {
        if (state is PredictionInitial) {
          return const SizedBox.shrink();
        } else if (state is PredictionLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (state is PredictionLoaded) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Predicted Math Score',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const Gap(8),
                Text(
                  state.score.toStringAsFixed(1),
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B359A),
                  ),
                ),
              ],
            ),
          );
        } else if (state is PredictionError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const Gap(12),
                Expanded(
                  child: Text(
                    state.message,
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
             item.length > 20 ? '${item.substring(0, 17)}...' : item, 
             style: GoogleFonts.poppins(fontSize: 14)
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Req';
        final val = int.tryParse(value);
        if (val == null || val < 0 || val > 100) return '0-100';
        return null;
      },
    );
  }
}
