import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class Subject {
  String code = '';
  String name = '';
}

class AdmitCardGenerator extends StatefulWidget {
  const AdmitCardGenerator({super.key});
  @override
  State<AdmitCardGenerator> createState() => _AdmitCardGeneratorState();
}

class _AdmitCardGeneratorState extends State<AdmitCardGenerator> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // Controllers
  final _fullName = TextEditingController();
  final _fatherName = TextEditingController();
  final _address = TextEditingController();
  final _mobile = TextEditingController();
  final _symbol = TextEditingController();
  final _email = TextEditingController();
  final _year = TextEditingController();
  final _dob = TextEditingController();
  final _registrationNumber = TextEditingController();

  String? _selectedCourse;
  String? _selectedExamType;
  Uint8List? _studentImage;
  Uint8List? _signatureImage;
  List<Subject> _subjects = [Subject()];

  bool _showPreview = false;

  Future<void> _pickImage(Function(Uint8List) callback) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          ),
    );

    if (source != null) {
      final img = await _picker.pickImage(source: source, imageQuality: 85);
      if (img != null) callback(await img.readAsBytes());
    }
  }

  void _addSubject() {
    if (_subjects.length < 6) setState(() => _subjects.add(Subject()));
  }

  void _removeSubject(int index) {
    if (_subjects.length > 1) setState(() => _subjects.removeAt(index));
  }

  bool _validateFullName(String? value) {
    final parts = value?.trim().split(' ') ?? [];
    return parts.length >= 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admit Card Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _textField(
                _fullName,
                'Full Name',
                required: true,
                validator:
                    (v) =>
                        !_validateFullName(v)
                            ? 'Enter first and last name'
                            : null,
              ),
              _textField(
                _fatherName,
                'Father\'s Name',
                required: true,
                validator:
                    (v) =>
                        !_validateFullName(v)
                            ? 'Enter first and last name'
                            : null,
              ),

              _textField(
                _symbol,
                'Symbol No.',
                type: TextInputType.number,
                required: true,
                validator:
                    (v) =>
                        RegExp(r'^(7|8|9)\d{7}$').hasMatch(v ?? '')
                            ? null
                            : 'Enter valid 8-digit number starting with 7/8/9',
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              _textField(_address, 'Address', required: true),
              GestureDetector(
                onTap: () async {
                  final todayBs = NepaliDateTime.now();

                  // Max date 18 years before today (in BS)
                  final maxBsDate = NepaliDateTime(
                    todayBs.year - 18,
                    todayBs.month - 2,
                    todayBs.day - 3,
                  );

                  final picked = await picker.showAdaptiveDatePicker(
                    context: context,
                    initialDate: maxBsDate,
                    firstDate: NepaliDateTime(2000, 1, 1), // or older if needed
                    lastDate: maxBsDate,
                  );

                  if (picked != null) {
                    setState(() {
                      _dob.text = NepaliDateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: _textField(
                    _dob,
                    'Date of Birth (YYYY-MM-DD)',
                    required: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date of Birth is required';
                      }

                      try {
                        final selectedBs = NepaliDateTime.parse(value);
                        final todayBs = NepaliDateTime.now();
                        final diff = todayBs.year - selectedBs.year;

                        if (diff < 18 ||
                            (diff == 18 &&
                                (todayBs.month < selectedBs.month ||
                                    (todayBs.month == selectedBs.month &&
                                        todayBs.day < selectedBs.day)))) {
                          return 'You must be at least 18 years old';
                        }
                      } catch (e) {
                        return 'Invalid date format';
                      }

                      return null;
                    },
                  ),
                ),
              ),

              _textField(
                _mobile,
                'Mobile No.',
                type: TextInputType.number,
                required: true,
                validator:
                    (v) =>
                        RegExp(r'^(97|98)\d{8}$').hasMatch(v ?? '')
                            ? null
                            : 'Enter valid 10-digit number starting with 97/98',
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),

              _textField(
                _email,
                'Email',
                validator:
                    (v) =>
                        RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v ?? '')
                            ? null
                            : 'Invalid email',
              ),

              // Course dropdown
              DropdownButtonFormField<String>(
                value: _selectedCourse,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'BIT', child: Text('BIT')),
                  DropdownMenuItem(value: 'BSc.CSIT', child: Text('BSc.CSIT')),
                ],
                onChanged: (v) => setState(() => _selectedCourse = v),
                validator: (v) => v == null ? 'Please select a course' : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _selectedExamType,
                decoration: const InputDecoration(
                  labelText: 'Exam Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Regular', child: Text('Regular')),
                  DropdownMenuItem(value: 'Partial', child: Text('Partial')),
                ],
                onChanged: (v) => setState(() => _selectedExamType = v),
                validator:
                    (v) => v == null ? 'Please select a exam type' : null,
              ),
              const SizedBox(height: 12),

              _textField(
                _year,
                'Year',
                required: true,
                type: TextInputType.number,
                validator:
                    (v) =>
                        RegExp(r'^(20)\d{2}$').hasMatch(v ?? '')
                            ? null
                            : 'Enter valid 4-digit number starting with 20',

                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              _textField(
                _registrationNumber,
                'Registration Number',
                required: true,
                type: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]')),
                ],
                validator:
                    (v) =>
                        RegExp(r'^[0-9\-]+$').hasMatch(v ?? '')
                            ? null
                            : 'Only numbers and "-" allowed',
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Subjects',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _addSubject,
                    child: const Text('Add Subject'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._subjects.asMap().entries.map((e) {
                final i = e.key;
                final subj = e.value;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text('${i + 1}.'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: subj.code,
                          decoration: const InputDecoration(labelText: 'Code'),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Code required';
                            }
                            final regex = RegExp(r'^[A-Z]{3}[0-9]{3}$');
                            if (!regex.hasMatch(v)) {
                              return 'Must be 3 capital letters followed by 3 digits (e.g., CSC213)';
                            }
                            return null;
                          },
                          onChanged: (v) => subj.code = v,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z0-9]'),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: subj.name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Name required'
                                      : null,
                          onChanged: (v) => subj.name = v,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeSubject(i),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed:
                        () => _pickImage(
                          (b) => setState(() => _studentImage = b),
                        ),
                    child: const Text('Pick Student Photo'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed:
                        () => _pickImage(
                          (b) => setState(() => _signatureImage = b),
                        ),
                    child: const Text('Pick Signature'),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _showPreview = true);
                  } else {
                    setState(() => _showPreview = false);
                  }
                },
                child: const Text('Generate Admit Card Preview'),
              ),

              const SizedBox(height: 20),
              if (_showPreview) _buildAdmitCardPreview(),

              if (_showPreview)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text("Download PDF"),
                    onPressed: downloadAsPdf,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController ctr,
    String label, {
    bool required = false,
    String? Function(String?)? validator,
    TextInputType? type,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctr,
        keyboardType: type,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator:
            validator ??
            (required
                ? (v) => v == null || v.isEmpty ? '$label is required' : null
                : null),
      ),
    );
  }

  Widget _buildAdmitCardPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header with logo and college details
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/collage/logo.png", width: 60, height: 60),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      children: const [
                        Text(
                          "TRIBHUVAN UNIVERSITY",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Institute of Science & Technology",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "CENTRAL CAMPUS OF TECHNOLOGY",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Dharan-14, Sunsari",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "www.cctdharan.edu.np",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Exam Admit Card",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                8,
              ), // Border radius on all sides
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns image and text top aligned
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Left align text
                    children: [
                      Text("Full Name: ${_fullName.text}"),
                      const SizedBox(height: 5),
                      Text("Father's Name: ${_fatherName.text}"),
                      const SizedBox(height: 5),
                      Text("Address: ${_address.text}"),
                      const SizedBox(height: 5),
                      Text("Mobile No. : ${_mobile.text}"),
                      const SizedBox(height: 5),
                      Text("Email: ${_email.text}"),
                      const SizedBox(height: 5),
                      Text("Symbol No. : ${_symbol.text}"),
                      const SizedBox(height: 5),
                      Text("Course: $_selectedCourse"),
                      const SizedBox(height: 5),
                      Text("Year: ${_year.text}"),
                      const SizedBox(height: 5),
                      Text("Date of Birth: ${_dob.text}"),
                      const SizedBox(height: 5),
                      Text("Regd No: ${_registrationNumber.text}"),
                    ],
                  ),
                ),
                const SizedBox(width: 20), // Gap between text and image
                if (_studentImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _studentImage!,
                      width: 200,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Text(
            "Subjects:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Table(
            border: TableBorder.all(),
            children: [
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Text("S.N.", textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Text("Course Code", textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Text("Course Name", textAlign: TextAlign.center),
                  ),
                ],
              ),
              ..._subjects.asMap().entries.map((e) {
                final i = e.key + 1;
                final subj = e.value;
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text('$i', textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(subj.code, textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(subj.name, textAlign: TextAlign.center),
                    ),
                  ],
                );
              }),
            ],
          ),

          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end, // Align bottom
            children: [
              if (_signatureImage != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.memory(_signatureImage!, width: 60, height: 120),
                    const SizedBox(height: 4),
                    const Text("Student Signature"),
                  ],
                ),
              const SizedBox(width: 130), // Spacing between image and text
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Left-align both text lines
                  children: [
                    Text("Exam Type: $_selectedExamType"),
                    const SizedBox(height: 5),
                    const Text("Approved by: Admin. Amit M."),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> downloadAsPdf() async {
    final pdf = pw.Document();

    // Load logo from assets
    final logoImage = await rootBundle.load('assets/collage/logo.png');
    final logoBytes = logoImage.buffer.asUint8List();

    pdf.addPage(
      pw.MultiPage(
        build:
            (pw.Context context) => [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.black,
                    width: 1,
                  ), // Black border, width 1, no radius
                ),
                padding: const pw.EdgeInsets.all(
                  16,
                ), // Padding inside the border
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Header with logo and college info
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Image(
                          pw.MemoryImage(logoBytes),
                          width: 60,
                          height: 60,
                        ),
                        pw.SizedBox(width: 50),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "TRIBHUVAN UNIVERSITY",
                                style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.Text(
                                "Institute of Science & Technology",
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                "CENTRAL CAMPUS OF TECHNOLOGY",
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                "Dharan-14, Sunsari",
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                              pw.Text(
                                "www.cctdharan.edu.np",
                                style: const pw.TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Center(
                      child: pw.Text(
                        "Exam Admit Card",
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 20),

                    // Student details and photo
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey),
                      ),
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Full Name: ${_fullName.text}"),
                                pw.SizedBox(height: 5),
                                pw.Text("Father's Name: ${_fatherName.text}"),
                                pw.SizedBox(height: 5),
                                pw.Text("Address: ${_address.text}"),
                                pw.SizedBox(height: 5),
                                pw.Text("Mobile No.: ${_mobile.text}"),
                                pw.SizedBox(height: 5),
                                pw.Text("Email: ${_email.text}"),
                                pw.SizedBox(height: 5),
                                pw.Text("Symbol No.: ${_symbol.text}"),
                                pw.SizedBox(height: 5),
                                pw.Text("Course: $_selectedCourse"),
                                pw.SizedBox(height: 5),
                                pw.Text("Year: ${_year.text}"),
                                pw.SizedBox(height: 5),
                                pw.Text("Date of Birth: ${_dob.text}"),
                                pw.SizedBox(height: 5),
                                pw.Text(
                                  "Regd No.: ${_registrationNumber.text}",
                                ),
                              ],
                            ),
                          ),
                          pw.SizedBox(width: 12),
                          if (_studentImage != null)
                            pw.Image(
                              pw.MemoryImage(_studentImage!),
                              width: 120,
                              height: 160,
                              fit: pw.BoxFit.cover,
                            ),
                        ],
                      ),
                    ),

                    pw.SizedBox(height: 16),

                    // Subjects table
                    pw.Text(
                      "Subjects:",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Table.fromTextArray(
                      border: pw.TableBorder.all(),
                      headers: ['S.N.', 'Course Code', 'Course Name'],
                      cellAlignment: pw.Alignment.centerLeft,
                      data:
                          _subjects.asMap().entries.map((e) {
                            final i = e.key + 1;
                            final subj = e.value;
                            return [i.toString(), subj.code, subj.name];
                          }).toList(),
                    ),

                    pw.SizedBox(height: 20),

                    // Signature and approval section
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        if (_signatureImage != null)
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Image(
                                pw.MemoryImage(_signatureImage!),
                                width: 60,
                                height: 100,
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text("Student Signature"),
                            ],
                          ),
                        pw.SizedBox(width: 100),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Exam Type: $_selectedExamType"),
                              pw.SizedBox(height: 5),
                              pw.Text("Approved by: Admin. Amit M."),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
      ),
    );

    // Your permission and file saving code remains unchanged below...
    try {
      Directory? dir;

      if (Platform.isAndroid) {
        var status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Storage permission denied")),
          );
          return;
        }

        dir = Directory('/storage/emulated/0/Download/AdmitCards');
        if (!dir.existsSync()) dir.createSync(recursive: true);
      } else if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      }

      final filePath = '${dir!.path}/admit_card_${_symbol.text}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      if (!context.mounted) return;
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text("PDF Downloaded"),
              content: Text("Saved to:\n$filePath"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Ignore"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    OpenFile.open(filePath);
                  },
                  child: const Text("Open"),
                ),
              ],
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save PDF: $e")));
    }
  }
}
