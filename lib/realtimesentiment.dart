import 'package:flutter/material.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

class RealtimeAnalysisScreen extends StatefulWidget {
  const RealtimeAnalysisScreen({super.key});

  @override
  _RealtimeAnalysisScreenState createState() => _RealtimeAnalysisScreenState();
}

class _RealtimeAnalysisScreenState extends State<RealtimeAnalysisScreen> {
  final TextEditingController _controller = TextEditingController();
  SentimentResult? _analysisResult;

  void _analyzeSentiment(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _analysisResult = Sentiment.analysis(text);
      });
    } else {
      setState(() {
        _analysisResult = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Analysis',style: TextStyle(color:Colors.teal.shade50 ),),
       backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  
                  child: TextField(// input for user 
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter text for sentiment analysis',
                      border: InputBorder.none,
                    ),
                    onChanged: _analyzeSentiment,
                    maxLines: 5,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_analysisResult != null)
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