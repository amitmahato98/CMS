import 'package:cms/datatypes/datatypes.dart';
import 'package:cms/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const AppRoot(),
    ),
  );
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: const ResultHub(),
    );
  }
}

// ===================== Hub (Add / View) =====================
class ResultHub extends StatelessWidget {
  const ResultHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results'), backgroundColor: blueColor),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _HubCard(
              icon: Icons.addchart,
              title: 'Add Result',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddResultPage()),
                  ),
            ),
            _HubCard(
              icon: Icons.receipt_long,
              title: 'View Result',
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResultPage()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _HubCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [blueColor.withOpacity(0.1), blueColor.withOpacity(0.25)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: blueColor.withOpacity(0.2)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: blueColor),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== Result Page (VIEW) =====================
class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final _formKey = GlobalKey<FormState>();
  final _symbolNoController = TextEditingController();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();

  bool isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final result = await _fetchStudentAndLatestResult(
          roll: _symbolNoController.text.trim(),
          name: _nameController.text.trim(),
          dob: _dobController.text.trim(),
        );

        setState(() => isLoading = false);

        if (result != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GradeSheetPage(student: result)),
          );
        } else {
          _showNotFound();
        }
      } catch (_) {
        setState(() => isLoading = false);
        _showNotFound();
      }
    }
  }

  Future<Map<String, dynamic>?> _fetchStudentAndLatestResult({
    required String roll,
    required String name,
    required String dob,
  }) async {
    // 1) Find student by rollNumber, then verify name (case-insensitive) & dob
    final snap =
        await FirebaseFirestore.instance
            .collection('students')
            .where('rollNumber', isEqualTo: roll)
            .limit(1)
            .get();

    if (snap.docs.isEmpty) return null;

    final s = snap.docs.first.data();
    final matchesName =
        (s['name'] as String?)?.toLowerCase().trim() ==
        name.toLowerCase().trim();
    final matchesDob = (s['dateOfBirth'] as String?)?.trim() == dob;
    if (!matchesName || !matchesDob) return null;

    final studentId = s['studentId'];

    // 2) Fetch latest result under students/{studentId}/results (ordered by createdAt)
    final resultsSnap =
        await FirebaseFirestore.instance
            .collection('students')
            .doc(studentId)
            .collection('results')
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

    if (resultsSnap.docs.isEmpty) return null;

    final r = resultsSnap.docs.first.data();

    // subjects are stored as list of maps with: [code, name, gp, grade, part]
    final List<List<String>> subjects =
        (r['subjects'] as List)
            .map(
              (e) => [
                e['code'].toString(),
                e['name'].toString(),
                (e['gp'] as num).toStringAsFixed(2),
                e['grade'].toString(),
              ],
            )
            .toList();

    // compute GPA from gp values
    final gpa = _computeGpa(
      (r['subjects'] as List).map((e) => (e['gp'] as num).toDouble()).toList(),
    );
    final finalGrade = _gradeFromGpa(gpa);

    // return shape compatible with your existing GradeSheetPage
    return {
      "symbol_no": s['rollNumber'],
      "name": s['name'],
      "date_of_birth": s['dateOfBirth'],
      "registration_no": s['registrationNumber'],
      "final_grade": finalGrade,
      "gpa": gpa,
      "subjects": subjects,
    };
  }

  void _showNotFound() {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text("No Record Found"),
            content: const Text("Please check your details and try again."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text("OK", style: TextStyle(color: blueColor)),
              ),
            ],
          ),
    );
  }

  double _computeGpa(List<double> gps) {
    if (gps.isEmpty) return 0.0;
    final sum = gps.reduce((a, b) => a + b);
    return double.parse((sum / gps.length).toStringAsFixed(2));
  }

  String _gradeFromGpa(double gpa) {
    if (gpa >= 3.75) return 'A';
    if (gpa >= 3.60) return 'A-';
    if (gpa >= 3.25) return 'B+';
    if (gpa >= 2.85) return 'B';
    if (gpa >= 2.45) return 'C+';
    if (gpa >= 2.05) return 'C';
    if (gpa >= 1.65) return 'D';
    return 'F';
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormaters,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormaters,
      cursorColor: blueColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: blueColor),
        prefixIcon: Icon(icon, color: blueColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: blueColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: blueColor, width: 1.5),
        ),
        filled: true,
      ),
      validator:
          validator ??
          (value) => value == null || value.trim().isEmpty ? 'Required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Result"),
        backgroundColor: blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: "Roll Number",
                icon: Icons.confirmation_number,
                controller: _symbolNoController,
                keyboardType: TextInputType.number,
                inputFormaters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Required';
                  if (!RegExp(r'^\d{6,}$').hasMatch(value.trim()))
                    return 'Enter valid roll';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Full Name",
                icon: Icons.person,
                controller: _nameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Required';
                  final nameParts = value.trim().split(RegExp(r'\s+'));
                  if (nameParts.length < 2) return 'Enter first and last name';
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim()))
                    return 'Only alphabets allowed';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Date of Birth (yyyy/m/d)",
                icon: Icons.date_range,
                controller: _dobController,
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Required';
                  if (!RegExp(
                    r'^\d{4}/\d{1,2}/\d{1,2}\$',
                  ).hasMatch(value.trim()))
                    return 'Enter date as yyyy/m/d';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon:
                    isLoading
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.search, color: Colors.white),
                label: Text(
                  isLoading ? "Searching..." : "Find Result",
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== Add Result =====================
class AddResultPage extends StatefulWidget {
  const AddResultPage({super.key});

  @override
  State<AddResultPage> createState() => _AddResultPageState();
}

class _AddResultPageState extends State<AddResultPage> {
  final _formKey = GlobalKey<FormState>();
  final _rollCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();

  Map<String, dynamic>? _student; // fetched student doc
  final List<_SubjectRow> _rows = [];

  bool _saving = false;

  Future<void> _findStudent() async {
    FocusScope.of(context).unfocus();
    if (_rollCtrl.text.trim().isEmpty || _nameCtrl.text.trim().isEmpty) return;

    final snap =
        await FirebaseFirestore.instance
            .collection('students')
            .where('rollNumber', isEqualTo: _rollCtrl.text.trim())
            .limit(1)
            .get();

    if (snap.docs.isEmpty) {
      setState(() => _student = null);
      _toast('Student not found');
      return;
    }

    final s = snap.docs.first.data();
    final matchesName =
        (s['name'] as String?)?.toLowerCase().trim() ==
        _nameCtrl.text.toLowerCase().trim();
    final matchesDob =
        _dobCtrl.text.trim().isEmpty ||
        (s['dateOfBirth'] as String?)?.trim() == _dobCtrl.text.trim();
    if (!matchesName || !matchesDob) {
      setState(() => _student = null);
      _toast('Name / DOB mismatch');
      return;
    }

    setState(() => _student = s);
  }

  void _addRow() => setState(() => _rows.add(_SubjectRow()));
  void _removeRow(int i) => setState(() => _rows.removeAt(i));

  Future<void> _save() async {
    if (_student == null) {
      _toast('Find student first');
      return;
    }

    if (_rows.isEmpty) {
      _toast('Add at least one subject');
      return;
    }

    if (_rows.any((r) => !r.isValid)) {
      _toast('Complete all subject fields');
      return;
    }

    setState(() => _saving = true);

    try {
      final subjects = _rows.map((r) => r.toMap()).toList();
      final gpa = _computeGpa(_rows.map((r) => r.gp!).toList());

      await FirebaseFirestore.instance
          .collection('students')
          .doc(_student!['studentId'])
          .collection('results')
          .add({
            'createdAt': FieldValue.serverTimestamp(),
            'subjects': subjects,
            'computedGpa': gpa,
          });

      setState(() => _saving = false);
      _toast('Result saved');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _saving = false);
      _toast('Save failed: $e');
    }
  }

  double _computeGpa(List<double> gps) {
    if (gps.isEmpty) return 0.0;
    final sum = gps.reduce((a, b) => a + b);
    return double.parse((sum / gps.length).toStringAsFixed(2));
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Result'),
        backgroundColor: blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _rollCtrl,
                    decoration: const InputDecoration(labelText: 'Roll Number'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _dobCtrl,
                    decoration: const InputDecoration(
                      labelText: 'DOB (yyyy/m/d) (optional)',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _findStudent,
                  style: ElevatedButton.styleFrom(backgroundColor: blueColor),
                  child: const Text(
                    'Find',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_student != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: blueColor.withOpacity(0.3)),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    Text('ID: ${_student!['studentId']}'),
                    Text('Name: ${_student!['name']}'),
                    Text('Program: ${_student!['program']}'),
                    Text('Batch: ${_student!['batch']}'),
                    Text('Reg: ${_student!['registrationNumber']}'),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subjects',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addRow,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Subject'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _rows.length,
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _rows[index].build(
                        context,
                        onRemove: () => _removeRow(index),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon:
                    _saving
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Icon(Icons.save, color: Colors.white),
                label: Text(
                  _saving ? 'Saving...' : 'Save Result',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectRow {
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final gpCtrl = TextEditingController();
  String grade = '';

  bool get isValid =>
      codeCtrl.text.trim().isNotEmpty &&
      nameCtrl.text.trim().isNotEmpty &&
      double.tryParse(gpCtrl.text.trim()) != null &&
      grade.isNotEmpty;

  double? get gp => double.tryParse(gpCtrl.text.trim());

  Map<String, dynamic> toMap() => {
    'code': codeCtrl.text.trim(),
    'name': nameCtrl.text.trim(),
    'gp': gp,
    'grade': grade,
  };

  Widget build(BuildContext context, {required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Subject Code (e.g., CSC 114)',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Subject Name (with part e.g., (TH) or (PR+IN))',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: gpCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Grade Point (e.g., 3.33)',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: grade.isEmpty ? null : grade,
                  items: const [
                    DropdownMenuItem(value: 'A+', child: Text('A+')),
                    DropdownMenuItem(value: 'A', child: Text('A')),
                    DropdownMenuItem(value: 'A-', child: Text('A-')),
                    DropdownMenuItem(value: 'B+', child: Text('B+')),
                    DropdownMenuItem(value: 'B', child: Text('B')),
                    DropdownMenuItem(value: 'B-', child: Text('B-')),
                    DropdownMenuItem(value: 'C+', child: Text('C+')),
                    DropdownMenuItem(value: 'C', child: Text('C')),
                    DropdownMenuItem(value: 'C-', child: Text('C-')),
                    DropdownMenuItem(value: 'D', child: Text('D')),
                    DropdownMenuItem(value: 'F', child: Text('F')),
                  ],
                  onChanged: (v) => grade = v ?? '',
                  decoration: const InputDecoration(labelText: 'Grade'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===================== Existing grade sheet UI (unchanged except source) =====================
class GradeSheetPage extends StatelessWidget {
  final Map<String, dynamic> student;
  const GradeSheetPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final List<List<String>> data = List<List<String>>.from(
      student['subjects'],
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderSection(),
                    const SizedBox(height: 24),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    InfoSection(student: student),
                    const SizedBox(height: 24),
                    GradeTable(data: data),
                    const SizedBox(height: 16),
                    GPASection(gpa: student['gpa']),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            "CAMPUS CHIEF",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Admin. Amit M.",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const NotesSection(),
                  ],
                ),
              ),
            ),
            const Positioned(top: 16, right: 16, child: CloseButtonAnimated()),
          ],
        ),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final Map<String, dynamic> student;
  const InfoSection({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = const TextStyle(fontWeight: FontWeight.w500);

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${student['name']}", style: labelStyle),
              Text(
                "Date of Birth: ${student['date_of_birth']}",
                style: labelStyle,
              ),
              Text(
                "Registration No.: ${student['registration_no']}",
                style: labelStyle,
              ),
              Text("Symbol No.: ${student['symbol_no']}", style: labelStyle),
              Text("Grade: ${student['final_grade']}", style: labelStyle),
            ],
          ),
        ),
      ),
    );
  }
}

class GradeTable extends StatelessWidget {
  final List<List<String>> data;
  const GradeTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: Table(
        border: TableBorder.all(color: Colors.grey[300]!),
        columnWidths: const {
          0: FixedColumnWidth(90),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(90),
          3: FixedColumnWidth(70),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: grayColor.withOpacity(0.5)),
            children: [
              tableHeader("Subject Code"),
              tableHeader("Subjects"),
              tableHeader("Grade Point"),
              tableHeader("Grade"),
            ],
          ),
          for (var row in data)
            TableRow(children: row.map((cell) => tableCell(cell)).toList()),
        ],
      ),
    );
  }

  Widget tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Text(text, style: const TextStyle(fontSize: 12.5)),
    );
  }
}

class GPASection extends StatelessWidget {
  final double gpa;
  const GPASection({super.key, required this.gpa});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Grade Point Average (GPA): ${gpa.toStringAsFixed(2)}",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.teal[700],
      ),
    );
  }
}

class NotesSection extends StatelessWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.grey[300],
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Padding(
          padding: EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NOTES:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                "• ONE CREDIT HOUR EQUALS 32 CLOCK HOURS.\n"
                "• EACH SUBJECT CARRIES 3 CREDIT HOURS.\n"
                "• PR = PRACTICAL     TH = THEORY\n"
                "• AB = ABSENT        W = WITHHELD",
                style: TextStyle(fontSize: 13, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('assets/collage/logo.png', width: 90),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TRIBHUVAN UNIVERSITY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'Institute of Science & Technology',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'CENTRAL CAMPUS OF TECHNOLOGY',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'www.cctdharan.edu.np | 025-570228 / 576530',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text(
                'GRADE SHEET',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CloseButtonAnimated extends StatefulWidget {
  const CloseButtonAnimated({super.key});

  @override
  _CloseButtonAnimatedState createState() => _CloseButtonAnimatedState();
}

class _CloseButtonAnimatedState extends State<CloseButtonAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          decoration: BoxDecoration(
            color: blueColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.close, color: blueColor, size: 24),
        ),
      ),
    );
  }
}
