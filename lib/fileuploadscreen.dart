import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sentiment_analysis_app/realtimesentiment.dart';
import 'package:sentiment_dart/sentiment_dart.dart';
// Stateful class is used to show dynamic data 
class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  String _fileContent = '';
  SentimentResult? _analysisResult;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _uploadFile() async {
  setState(() {
    _isLoading = true;
    _errorMessage = '';
    _analysisResult = null;
  });

  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      if (file.path != null) {
        // Read file content using the file path
        final File fileObj = File(file.path!);
        _fileContent = await fileObj.readAsString();
      } else if (file.bytes != null) {
        // If path is not available, try to use bytes
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
   // SetState Used for to reload the widget or screen to show the changes in screen.
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
        actions: [Padding(
          padding: const EdgeInsets.all(8.0),

          child: IconButton(onPressed: (){
            // Navigate to real time analysis screen.
            Navigator.push(context, MaterialPageRoute(builder: (context)=> RealtimeAnalysisScreen()));
          }, icon: Icon(Icons.sentiment_neutral_rounded,color: Colors.white,)),
        )],
        title: Text('File Analysis',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                
                onPressed: _isLoading ? null : _uploadFile,
                icon: Icon(Icons.upload_file),
                label: Text('Select Text File',style:TextStyle( color: Colors.white) ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              if (_isLoading)
                Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: TextStyle(color: Colors.red))
              else if (_analysisResult != null)
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Analysis Result:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            _buildResultItem('Sentiment', _getSentimentText(_analysisResult!.score)),
                            _buildResultItem('Score', _analysisResult!.score.toStringAsFixed(2)),
                            _buildResultItem('Comparative', _analysisResult!.comparative.toStringAsFixed(2)),
                            _buildResultItem('Word count', _analysisResult!.words.all.length.toString()),
                            _buildResultItem('Positive words', _analysisResult!.words.good.keys.join(', ')),
                            _buildResultItem('Negative words', _analysisResult!.words.bad.keys.join(', ')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getSentimentText(double score) {
    if (score > 0) return 'Positive';
    if (score < 0) return 'Negative';
    return 'Neutral';
  }
}