import 'package:cms/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
      home: const ResultPage(),
    );
  }
}

// ----------------------- Result Page ------------------------

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

  final List<Map<String, dynamic>> students = [
    {
      "symbol_no": "79011472",
      "name": "AMIT MAHATO",
      "date_of_birth": "2062/05/10",
      "registration_no": "8056789333",
      "final_grade": "B+",
      "gpa": 3.09,
      "subjects": [
        ["CSC 114", "Introduction to IT(TH)", "3.33", "A"],
        ["CSC 114", "Introduction to IT(PR+IN)", "3.5", "A"],
        ["CSC 115", "C Programming(TH)", "3", "B+"],
        ["CSC 115", "C Programming(PR+IN)", "3", "B+"],
        ["CSC 116", "Digital Logic(TH)", "3.33", "A"],
        ["CSC 116", "Digital Logic(PR+IN)", "3.5", "A"],
        ["MTH 117", "Mathematics I(TH)", "3.33", "A"],
        ["MTH 117", "Mathematics I(IN)", "3", "B+"],
        ["PHY 118", "Physics(TH)", "2.33", "C"],
        ["PHY 118", "Physics(PR+IN)", "2.8", "C+"],
      ],
    },
    {
      "symbol_no": "79022433",
      "name": "MANDIP POKHEREL",
      "date_of_birth": "2061/11/20",
      "registration_no": "8056789444",
      "final_grade": "A",
      "gpa": 3.75,
      "subjects": [
        ["CSC 114", "Introduction to IT(TH)", "3.67", "A"],
        ["CSC 114", "Introduction to IT(PR+IN)", "3.75", "A"],
        ["CSC 115", "C Programming(TH)", "3.33", "A-"],
        ["CSC 115", "C Programming(PR+IN)", "3.3", "A-"],
        ["CSC 116", "Digital Logic(TH)", "3.33", "A"],
        ["CSC 116", "Digital Logic(PR+IN)", "3.5", "A"],
        ["MTH 117", "Mathematics I(TH)", "3.67", "A"],
        ["MTH 117", "Mathematics I(IN)", "3.5", "A-"],
        ["PHY 118", "Physics(TH)", "3.0", "B+"],
        ["PHY 118", "Physics(PR+IN)", "3.2", "B+"],
      ],
    },
    {
      "symbol_no": "79033444",
      "name": "SUSHANT NEPAL",
      "date_of_birth": "2060/02/15",
      "registration_no": "8056789555",
      "final_grade": "B",
      "gpa": 3.85,
      "subjects": [
        ["CSC 114", "Introduction to IT(TH)", "3.0", "B"],
        ["CSC 114", "Introduction to IT(PR+IN)", "3.0", "B"],
        ["CSC 115", "C Programming(TH)", "2.8", "B-"],
        ["CSC 115", "C Programming(PR+IN)", "2.7", "C+"],
        ["CSC 116", "Digital Logic(TH)", "3.0", "B+"],
        ["CSC 116", "Digital Logic(PR+IN)", "2.9", "B"],
        ["MTH 117", "Mathematics I(TH)", "3.0", "B+"],
        ["MTH 117", "Mathematics I(IN)", "2.8", "B-"],
        ["PHY 118", "Physics(TH)", "2.5", "C+"],
        ["PHY 118", "Physics(PR+IN)", "2.3", "C"],
      ],
    },
    {
      "symbol_no": "79044555",
      "name": "SITTAL LAMICHHANE",
      "date_of_birth": "2062/07/05",
      "registration_no": "8056789666",
      "final_grade": "A-",
      "gpa": 3.40,
      "subjects": [
        ["CSC 114", "Introduction to IT(TH)", "3.33", "A"],
        ["CSC 114", "Introduction to IT(PR+IN)", "3.4", "A"],
        ["CSC 115", "C Programming(TH)", "3.0", "B+"],
        ["CSC 115", "C Programming(PR+IN)", "3.1", "B+"],
        ["CSC 116", "Digital Logic(TH)", "3.33", "A"],
        ["CSC 116", "Digital Logic(PR+IN)", "3.5", "A"],
        ["MTH 117", "Mathematics I(TH)", "3.67", "A"],
        ["MTH 117", "Mathematics I(IN)", "3.5", "A-"],
        ["PHY 118", "Physics(TH)", "3.0", "B+"],
        ["PHY 118", "Physics(PR+IN)", "3.2", "B+"],
      ],
    },
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      Future.delayed(const Duration(milliseconds: 700), () {
        final matched = students.firstWhere(
          (s) =>
              s['symbol_no'] == _symbolNoController.text.trim() &&
              s['name'].toLowerCase() ==
                  _nameController.text.trim().toLowerCase() &&
              s['date_of_birth'] == _dobController.text.trim(),
          orElse: () => {},
        );

        setState(() => isLoading = false);

        if (matched.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GradeSheetPage(student: matched)),
          );
        } else {
          showDialog(
            context: context,
            builder:
                (dialogContext) => AlertDialog(
                  title: const Text("No Record Found"),
                  content: const Text(
                    "Please check your details and try again.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(
                          dialogContext,
                        ).pop(); // ✅ only closes dialog
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
          );
        }
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator, // Add this parameter
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      validator:
          validator ??
          (value) => value == null || value.trim().isEmpty ? 'Required' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: "Symbol No",
                icon: Icons.confirmation_number,
                controller: _symbolNoController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  if (!RegExp(r'^\d{8}$').hasMatch(value.trim())) {
                    return 'Enter exactly 8 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Full Name",
                icon: Icons.person,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  // Check at least two words
                  final nameParts = value.trim().split(RegExp(r'\s+'));
                  if (nameParts.length < 2) {
                    return 'Enter first and last name';
                  }
                  // Only alphabets and spaces allowed (no numbers or special chars)
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
                    return 'Only alphabets allowed';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Date of Birth",
                icon: Icons.date_range,
                controller: _dobController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  // Date format: yyyy/m/d
                  if (!RegExp(
                    r'^\d{4}/\d{1,2}/\d{1,2}$',
                  ).hasMatch(value.trim())) {
                    return 'Enter date as yyyy/m/d';
                  }
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
                        : const Icon(Icons.search),
                label: Text(
                  isLoading ? "Searching..." : "Find Result",
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
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

// ----------------------- GradeSheet Page ------------------------

class GradeSheetPage extends StatelessWidget {
  final Map<String, dynamic> student;

  GradeSheetPage({required this.student});

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
                    HeaderSection(),
                    SizedBox(height: 24),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    SizedBox(height: 16),
                    InfoSection(student: student),
                    SizedBox(height: 24),
                    GradeTable(data: data),
                    SizedBox(height: 16),
                    GPASection(gpa: student['gpa']),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                    SizedBox(height: 30),
                    NotesSection(),
                  ],
                ),
              ),
            ),
            Positioned(top: 16, right: 16, child: CloseButtonAnimated()),
          ],
        ),
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  final Map<String, dynamic> student;
  InfoSection({required this.student});

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(fontWeight: FontWeight.w500);

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
  GradeTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: Table(
        border: TableBorder.all(color: Colors.grey[300]!),
        columnWidths: {
          0: FixedColumnWidth(90),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(70),
          3: FixedColumnWidth(50),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.blueGrey[50]),
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
        style: TextStyle(
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
      child: Text(text, style: TextStyle(fontSize: 12.5)),
    );
  }
}

class GPASection extends StatelessWidget {
  final double gpa;
  GPASection({required this.gpa});

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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Color(0xFFEDF4FA),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NOTES:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blueGrey[900],
                ),
              ),
              SizedBox(height: 8),
              Text(
                "• ONE CREDIT HOUR EQUALS 32 CLOCK HOURS.\n"
                "• EACH SUBJECT CARRIES 3 CREDIT HOURS.\n"
                "• PR = PRACTICAL     TH = THEORY\n"
                "• AB = ABSENT        W = WITHHELD",
                style: TextStyle(fontSize: 13, height: 1.6, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset('assets/collage/logo.png', width: 90),
        ),
        SizedBox(width: 16),
        Expanded(
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
              Text('GRADE SHEET', style: TextStyle(fontSize: 15)),
              SizedBox(height: 6),
              Text(
                'www.cctdharan.edu.np | 025-570228 / 576530',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CloseButtonAnimated extends StatefulWidget {
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
      duration: Duration(milliseconds: 400),
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
        onTap: () => Navigator.pop(context), // ✅ Now this works
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(8),
          child: Icon(Icons.close, color: Colors.blue, size: 24),
        ),
      ),
    );
  }
}
