import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as nepali;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class IDCardGenerator extends StatefulWidget {
  const IDCardGenerator({super.key});

  @override
  State<IDCardGenerator> createState() => _IDCardGeneratorState();
}

class _IDCardGeneratorState extends State<IDCardGenerator> {
  final picker = ImagePicker();
  File? _image;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final dobController = TextEditingController();
  final batchController = TextEditingController();
  String? selectedCourse;

  bool showCard = false;
  bool isGeneratingPDF = false;

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future pickNepaliDate() async {
    final picked = await nepali.showAdaptiveDatePicker(
      context: context,
      initialDate: nepali.NepaliDateTime(2050),
      firstDate: nepali.NepaliDateTime(2000),
      lastDate: nepali.NepaliDateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  String calculateValidity(String batch) {
    try {
      int startYear = int.parse(batch);
      return "${startYear + 4}-12-30";
    } catch (_) {
      return "Invalid";
    }
  }

  Future<void> downloadPDF() async {
    setState(() {
      isGeneratingPDF = true;
    });

    try {
      if (Platform.isAndroid) {
        if (await Permission.photos.request().isGranted ||
            await Permission.storage.request().isGranted ||
            await Permission.manageExternalStorage.request().isGranted) {
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Storage permission is required to download PDF'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      final pdf = pw.Document();
      final profileImage =
          _image != null ? pw.MemoryImage(_image!.readAsBytesSync()) : null;

      Uint8List? logoBytes;
      try {
        logoBytes = await rootBundle
            .load('assets/collage/logo.png')
            .then((value) => value.buffer.asUint8List());
      } catch (_) {
        logoBytes = null;
      }

      final logoImage = logoBytes != null ? pw.MemoryImage(logoBytes) : null;

      String name = nameController.text.trim();
      String roll = rollController.text.trim();
      String dob = dobController.text.trim();
      String batch = batchController.text.trim();
      String course = selectedCourse ?? '';
      String validity = calculateValidity(batch);
      String barcodeData = '$batch$course$roll';
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            320 * PdfPageFormat.mm,
            500 * PdfPageFormat.mm, // width: card width + margins
            marginAll: 10 * PdfPageFormat.mm,
          ),
          build:
              (context) => pw.Center(
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Container(
                      margin: const pw.EdgeInsets.only(
                        top: 20,
                      ), // optional: adds space from top
                      padding: const pw.EdgeInsets.all(10),
                      width: 280,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                        borderRadius: pw.BorderRadius.circular(10),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (logoImage != null)
                                pw.Container(
                                  width: 50,
                                  height: 50,
                                  child: pw.Image(logoImage),
                                ),
                              pw.SizedBox(width: 10),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    "TRIBHUVAN UNIVERSITY",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Text(
                                    "Institute of Science & Technology",
                                    style: pw.TextStyle(fontSize: 8),
                                  ),
                                  pw.Text(
                                    "CENTRAL CAMPUS OF TECHNOLOGY",
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                  pw.Text(
                                    "Dharan-14, Sunsari\nwww.cctdharan.edu.np",
                                    style: pw.TextStyle(fontSize: 8),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          pw.Container(
                            margin: const pw.EdgeInsets.symmetric(vertical: 5),
                            color: PdfColors.blue,
                            width: double.infinity,
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Center(
                              child: pw.Text(
                                "STUDENT ID CARD",
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (profileImage != null)
                            pw.Center(
                              child: pw.Container(
                                width: 70,
                                height: 70,
                                decoration: pw.BoxDecoration(
                                  shape: pw.BoxShape.circle,
                                  border: pw.Border.all(
                                    color: PdfColors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: pw.ClipOval(
                                  child: pw.Image(
                                    profileImage,
                                    fit: pw.BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          pw.Container(
                            color: PdfColors.blue,
                            width: double.infinity,
                            margin: const pw.EdgeInsets.symmetric(vertical: 8),
                            padding: const pw.EdgeInsets.symmetric(vertical: 6),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Text(
                                  name,
                                  style: pw.TextStyle(
                                    fontSize: 14,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white,
                                  ),
                                ),
                                pw.Text(
                                  "$course / $batch",
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    fontSize: 13,
                                    color: PdfColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.Center(
                            child: pw.Text(
                              "Roll No.: $roll",
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ),
                          pw.Center(
                            child: pw.Text(
                              "DOB: $dob",
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ),
                          pw.Center(
                            child: pw.Text(
                              "Valid Till: $validity",
                              style: pw.TextStyle(fontSize: 12),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Center(
                            child: pw.BarcodeWidget(
                              barcode: pw.Barcode.code128(),
                              data: barcodeData,
                              width: 200,
                              height: 50,
                              drawText: false,
                            ),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Divider(),
                          pw.Center(
                            child: pw.Text(
                              "Phone: 025-570228/576530",
                              style: pw.TextStyle(fontSize: 8),
                            ),
                          ),
                          pw.Center(
                            child: pw.Text(
                              "Email: info@cctdharan.edu.np",
                              style: pw.TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        ),
      );
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadsDir = Directory('${directory.path}/Downloads');
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          directory = downloadsDir;
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      directory ??= await getApplicationDocumentsDirectory();

      final fileName = 'ID_Card_${name.replaceAll(' ', '_')}_$roll.pdf';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      if (await file.exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('PDF saved successfully!\nLocation: $filePath'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () => OpenFile.open(filePath),
              ),
            ),
          );
        }
      } else {
        throw Exception('File was not created');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading PDF: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isGeneratingPDF = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student ID Card Generator"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.photo),
                label: const Text("Pick Student Photo"),
              ),
              const SizedBox(height: 10),
              buildNameField(),
              buildRollField(),
              buildDobField(),
              buildBatchField(),
              buildCourseDropdown(),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      showCard = true;
                    });
                  }
                },
                child: const Text("Generate ID Card"),
              ),
              const SizedBox(height: 10),
              if (showCard)
                ElevatedButton.icon(
                  onPressed: isGeneratingPDF ? null : downloadPDF,
                  icon:
                      isGeneratingPDF
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.download),
                  label: Text(
                    isGeneratingPDF ? "Generating..." : "Download PDF",
                  ),
                ),
              const SizedBox(height: 20),
              if (showCard) buildGeneratedCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGeneratedCard() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/collage/logo.png', width: 50, height: 50),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "TRIBHUVAN UNIVERSITY",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "Institute of Science & Technology",

                      style: TextStyle(fontSize: 8, color: Colors.black),
                    ),
                    Text(
                      "CENTRAL CAMPUS OF TECHNOLOGY",
                      style: TextStyle(fontSize: 9, color: Colors.black),
                    ),
                    Text(
                      "Dharan-14, Sunsari\nwww.cctdharan.edu.np",
                      style: TextStyle(fontSize: 8, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: Colors.blue,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            child: const Center(
              child: Text(
                "STUDENT ID CARD",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child:
                _image != null
                    ? ClipOval(
                      child: Image.file(
                        _image!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    )
                    : const Icon(Icons.person, size: 35),
          ),
          Container(
            color: Colors.blue,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Text(
                  nameController.text.trim(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${selectedCourse ?? ''} / ${batchController.text}",
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ],
            ),
          ),
          Text(
            "Roll No.: ${rollController.text}",
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          Text(
            "DOB: ${dobController.text}",
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          Text(
            "Valid Till: ${calculateValidity(batchController.text)}",
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
          const SizedBox(height: 10),
          BarcodeWidget(
            barcode: Barcode.code128(),
            data:
                '${batchController.text}${selectedCourse ?? ''}${rollController.text}',
            width: 200,
            height: 50,
            drawText: false,
          ),
          const SizedBox(height: 5),
          const Divider(color: Colors.black),
          const Text(
            "Phone: 025-570228/576530",
            style: TextStyle(fontSize: 8, color: Colors.black),
          ),
          const Text(
            "Email: info@cctdharan.edu.np",
            style: TextStyle(fontSize: 8, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildNameField() => buildTextField(
    "Full Name",
    nameController,
    validator: (value) {
      if (value == null || value.trim().isEmpty) return 'Name is required';
      if (!value.trim().contains(' ')) return 'Enter full name';
      return null;
    },
  );

  Widget buildRollField() => buildTextField(
    "Roll No.",
    rollController,
    keyboardType: TextInputType.number,
    validator: (value) {
      if (value == null || value.isEmpty) return 'Roll number required';
      if (!RegExp(r'^\d{5,8}$').hasMatch(value)) {
        return 'Roll must be 5–8 digit number';
      }
      return null;
    },
  );

  Widget buildDobField() => GestureDetector(
    onTap: pickNepaliDate,
    child: AbsorbPointer(
      child: buildTextField(
        "DOB",
        dobController,
        validator:
            (value) =>
                value == null || value.isEmpty ? 'DOB is required' : null,
      ),
    ),
  );

  Widget buildBatchField() => buildTextField(
    "Batch Year",
    batchController,
    keyboardType: TextInputType.number,
    validator: (value) {
      if (value == null || value.isEmpty) return 'Batch year required';
      int? year = int.tryParse(value);
      if (year == null || year < 2070 || year > DateTime.now().year + 57) {
        return 'Batch must be between 2070 and current year';
      }
      return null;
    },
  );

  Widget buildCourseDropdown() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: DropdownButtonFormField<String>(
      value: selectedCourse,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Course',
      ),
      items:
          ['BIT', 'BSc.CSIT']
              .map(
                (course) =>
                    DropdownMenuItem(value: course, child: Text(course)),
              )
              .toList(),
      onChanged: (value) => setState(() => selectedCourse = value),
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Please select a course' : null,
    ),
  );

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
    ),
  );
}
