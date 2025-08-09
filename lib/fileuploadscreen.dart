import 'dart:io';
import 'dart:ui' as ui;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sentiment_analysis_app/TweetSentimentScreen.dart';
import 'package:sentiment_analysis_app/realtimesentiment.dart';
import 'package:sentiment_dart/sentiment_dart.dart';
import 'dart:typed_data';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  final GlobalKey _pieChartKey = GlobalKey();

  String _fileContent = '';
  SentimentResult? _analysisResult;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _uploadFile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _analysisResult = null;
      _fileContent = ''; // Clear previous file content
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'], // Only .txt files are allowed
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        if (file.path != null) {
          final File fileObj = File(file.path!);
          _fileContent = await fileObj.readAsString();
        } else if (file.bytes != null) {
          _fileContent = String.fromCharCodes(file.bytes!);
        } else {
          throw Exception('Unable to read file content');
        }

        if (_fileContent.isNotEmpty) {
          _analyzeSentiment(_fileContent);
        } else {
          _errorMessage = 'The selected file is empty.';
        }
      } else {
        _errorMessage = 'No file selected.';
      }
    } catch (e) {
      _errorMessage = 'Error reading file: $e';
    }
    setState(() => _isLoading = false);
  }

  void _analyzeSentiment(String text) {
    try {
      _analysisResult = Sentiment.analysis(text);
    } catch (e) {
      _errorMessage = 'Error analyzing sentiment: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'File Sentiment Analyzer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          Tooltip(
            message: 'Real-time Analysis',
            child: IconButton(
              onPressed: () {
                // Navigate to real time analysis screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RealtimeAnalysisScreen()),
                );
              },
              icon: const Icon(Icons.mic, color: Colors.white), // Changed icon for real-time
            ),
          ),
          Tooltip(
            message: 'Tweet Analysis',
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TweetSentimentScreen()),
                );
              },
              icon: const Icon(Icons.cloud, color: Colors.white), // Changed icon for Twitter
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0), // Increased padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section for File Upload
              Card(
                elevation: 8, // More prominent card
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Analyze Text from File',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Upload a .txt file to get its sentiment analysis. Only text content will be processed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _uploadFile,
                        icon: const Icon(Icons.file_upload, color: Colors.white),
                        label: Text(
                          _isLoading ? 'Uploading...' : 'Choose Text File',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 5,
                        ),
                      ),
                      if (_fileContent.isNotEmpty && _analysisResult == null && !_isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'File selected: ${_fileContent.substring(0, _fileContent.length > 50 ? 50 : _fileContent.length)}...',
                            style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)),
                        SizedBox(height: 15),
                        Text('Analyzing sentiment...', style: TextStyle(color: Colors.teal, fontSize: 16)),
                      ],
                    ),
                  ),
                )
              else if (_errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red.shade700, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                )
              else if (_analysisResult != null)
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20), // Increased padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sentiment Analysis Report',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade800),
                          ),
                          const Divider(height: 25, thickness: 1), // Separator
                          _buildResultItem('Overall Sentiment', _getSentimentText(_analysisResult!.score)),
                          _buildResultItem('Sentiment Score', _analysisResult!.score.toStringAsFixed(2)),
                          _buildResultItem('Comparative Score', _analysisResult!.comparative.toStringAsFixed(2)),
                          _buildResultItem('Total Word Count', _analysisResult!.words.all.length.toString()),

                          const SizedBox(height: 20),
                          Center(child: _buildSentimentPieChart(_analysisResult!)),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute evenly
                            children: [
                              _labelRow(Colors.green.shade600, 'Positive'),
                              _labelRow(Colors.red.shade600, 'Negative'),
                              _labelRow(const Color(0xFF7BAFD4), 'Neutral'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ExpansionTile( // Use ExpansionTile for word lists
                            title: const Text('Positive Words', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            leading: Icon(Icons.thumb_up_alt, color: Colors.green.shade600),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  _analysisResult!.words.good.keys.join(', ').isEmpty
                                      ? 'No positive words found.'
                                      : _analysisResult!.words.good.keys.join(', '),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: const Text('Negative Words', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            leading: Icon(Icons.thumb_down_alt, color: Colors.red.shade600),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  _analysisResult!.words.bad.keys.join(', ').isEmpty
                                      ? 'No negative words found.'
                                      : _analysisResult!.words.bad.keys.join(', '),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                              onPressed: _exportToPDF,
                              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                              label: const Text("Export Report as PDF", style: TextStyle(color: Colors.white, fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                elevation: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 50), // Increased bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelRow(Color? color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  String _getSentimentText(double score) {
    if (score > 0) return 'Positive';
    if (score < 0) return 'Negative';
    return 'Neutral';
  }

  Future<Uint8List?> _capturePieChart() async {
    try {
      RenderRepaintBoundary boundary =
      _pieChartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing pie chart image: $e');
      return null;
    }
  }


  Widget _buildSentimentPieChart(SentimentResult result) {
    final positive = result.words.good.length.toDouble();
    final negative = result.words.bad.length.toDouble();
    final totalWords = result.words.all.length.toDouble();
    final neutral = (totalWords - (positive + negative)).clamp(0, totalWords).toDouble();

    if (totalWords == 0) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text("No words to analyze.", style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    String getPercent(double value) => '${((value / totalWords) * 100).toStringAsFixed(1)}%';

    return SizedBox(
      height: 250,
      child: RepaintBoundary(
        key: _pieChartKey,
        child: PieChart(
          PieChartData(
            sectionsSpace: 4,
            startDegreeOffset: -90,
            centerSpaceRadius: 60,
            pieTouchData: PieTouchData(enabled: false),
            sections: [
              PieChartSectionData(
                value: positive,
                color: Colors.green.shade600,
                showTitle: true,
                title: getPercent(positive),
                titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                radius: 80,
                titlePositionPercentageOffset: 0.6,
              ),
              PieChartSectionData(
                value: negative,
                color: Colors.red.shade600,
                showTitle: true,
                title: getPercent(negative),
                titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                radius: 80,
                titlePositionPercentageOffset: 0.6,
              ),
              PieChartSectionData(
                value: neutral,
                color: const Color(0xFF7BAFD4),
                showTitle: true,
                title: getPercent(neutral),
                titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                radius: 80,
                titlePositionPercentageOffset: 0.6,
              ),
            ],
          ),
          swapAnimationDuration: const Duration(milliseconds: 800),
          swapAnimationCurve: Curves.easeOutCubic,
        ),
      ),
    );
  }


  Future<void> _exportToPDF() async {
    final result = _analysisResult;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No analysis result to export.')),
      );
      return;
    }

    final pdf = pw.Document();

    try {
      final pieChartImageBytes = await _capturePieChart();
      pw.MemoryImage? pdfPieChartImage;
      if (pieChartImageBytes != null) {
        pdfPieChartImage = pw.MemoryImage(pieChartImageBytes);
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.copyWith(
            marginLeft: 40,
            marginRight: 40,
            marginTop: 40,
            marginBottom: 40,
          ),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text('Sentiment Analysis Report',
                      style: pw.TextStyle(
                          fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.teal800)),
                ),
                pw.SizedBox(height: 30),
                if (pdfPieChartImage != null)
                  pw.Center(
                    child: pw.Container(
                      height: 200,
                      width: 200,
                      child: pw.Image(pdfPieChartImage),
                    ),
                  ),
                pw.SizedBox(height: 25),
                _buildPdfResultRow(
                    'Overall Sentiment:', _getSentimentText(result.score),
                    isBoldValue: true,
                    valueColor: _getSentimentText(result.score) == 'Positive'
                        ? PdfColors.green600
                        : _getSentimentText(result.score) == 'Negative'
                        ? PdfColors.red600
                        : PdfColors.blueGrey600),
                _buildPdfResultRow('Sentiment Score:', result.score.toStringAsFixed(2)),
                _buildPdfResultRow('Comparative Score:', result.comparative.toStringAsFixed(2)),
                _buildPdfResultRow('Total Word Count:', result.words.all.length.toString()),
                pw.SizedBox(height: 20),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 10),
                pw.Text('Detailed Analysis:',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800)),
                pw.SizedBox(height: 10),
                pw.Text('Positive Words:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                pw.Text(
                    result.words.good.keys.join(', ').isEmpty
                        ? 'No positive words found.'
                        : result.words.good.keys.join(', '),
                    style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 10),
                pw.Text('Negative Words:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
                pw.Text(
                    result.words.bad.keys.join(', ').isEmpty
                        ? 'No negative words found.'
                        : result.words.bad.keys.join(', '),
                    style: const pw.TextStyle(fontSize: 10)),
                pw.Spacer(), // Pushes content to the top
                pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text('Generated by Sentiment Analyzer App',
                        style: pw.TextStyle(fontSize: 8, color: PdfColors.grey))),
              ],
            );
          },
        ),
      );

      // Save PDF to a temporary file and open it
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: $e')),
      );
      print('Error generating PDF: $e');
    }
  }

  pw.Widget _buildPdfResultRow(String label, String value,
      {bool isBoldValue = false, PdfColor? valueColor}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                  fontWeight: isBoldValue ? pw.FontWeight.bold : pw.FontWeight.normal,
                  color: valueColor ?? PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }
}