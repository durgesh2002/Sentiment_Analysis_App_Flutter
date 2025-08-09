// import 'package:flutter/material.dart';
// import 'package:sentiment_dart/sentiment_dart.dart';
//
// class RealtimeAnalysisScreen extends StatefulWidget {
//   const RealtimeAnalysisScreen({super.key});
//
//   @override
//   _RealtimeAnalysisScreenState createState() => _RealtimeAnalysisScreenState();
// }
//
// class _RealtimeAnalysisScreenState extends State<RealtimeAnalysisScreen> {
//   final TextEditingController _controller = TextEditingController();
//   SentimentResult? _analysisResult;
//
//   void _analyzeSentiment(String text) {
//     if (text.isNotEmpty) {
//       setState(() {
//         _analysisResult = Sentiment.analysis(text);
//       });
//     } else {
//       setState(() {
//         _analysisResult = null;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Row(
//
//           children: [
//             IconButton(onPressed: (){
//               Navigator.of(context).pop();
//             }, icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)),
//             const SizedBox(
//               width: 20,
//             ),
//             Text('Real-time Analysis',style: TextStyle(color:Colors.teal.shade50 ),),
//           ],
//         ),
//        backgroundColor: Colors.teal,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.deepPurple.shade50, Colors.white],
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 8),
//
//                   child: TextField(// input for user
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: 'Enter text for sentiment analysis',
//                       border: InputBorder.none,
//                     ),
//                     onChanged: _analyzeSentiment,
//                     maxLines: 5,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               if (_analysisResult != null)
//                 Expanded(
//                   child: Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: EdgeInsets.all(16),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Analysis Result:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                             SizedBox(height: 10),
//                             _buildResultItem('Sentiment', _getSentimentText(_analysisResult!.score)),
//                             _buildResultItem('Score', _analysisResult!.score.toStringAsFixed(2)),
//                             _buildResultItem('Comparative', _analysisResult!.comparative.toStringAsFixed(2)),
//                             _buildResultItem('Word count', _analysisResult!.words.all.length.toString()),
//                             _buildResultItem('Positive words', _analysisResult!.words.good.keys.join(', ')),
//                             _buildResultItem('Negative words', _analysisResult!.words.bad.keys.join(', ')),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildResultItem(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value)),
//         ],
//       ),
//     );
//   }
//
//   String _getSentimentText(double score) {
//     if (score > 0) return 'Positive';
//     if (score < 0) return 'Negative';
//     return 'Neutral';
//   }
// }

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              tooltip: 'Go back',
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Real-time Sentiment',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type here to analyze sentiment in real-time...',
                      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      prefixIcon: Icon(Icons.text_fields, color: Colors.teal.shade400),
                    ),
                    onChanged: _analyzeSentiment,
                    maxLines: 7,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              if (_analysisResult != null && _controller.text.isNotEmpty)
                Expanded(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Analysis Report',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade800),
                            ),
                            const Divider(height: 25, thickness: 1),

                            _buildResultItem(
                              'Overall Sentiment',
                              _getSentimentText(_analysisResult!.score),
                              valueStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _getSentimentColor(_analysisResult!.score),
                              ),
                            ),
                            _buildResultItem('Sentiment Score', _analysisResult!.score.toStringAsFixed(2)),
                            _buildResultItem('Comparative Score', _analysisResult!.comparative.toStringAsFixed(2)),
                            _buildResultItem('Total Word Count', _analysisResult!.words.all.length.toString()),
                            const SizedBox(height: 20),

                            ExpansionTile(
                              title: const Text('Positive Words', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              leading: Icon(Icons.sentiment_very_satisfied, color: Colors.green.shade600),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    // CORRECTED: Access .keys from the Map
                                    _analysisResult!.words.good.keys.isEmpty
                                        ? 'No positive words found.'
                                        : _analysisResult!.words.good.keys.join(', '),
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: const Text('Negative Words', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              leading: Icon(Icons.sentiment_very_dissatisfied, color: Colors.red.shade600),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    _analysisResult!.words.bad.keys.isEmpty
                                        ? 'No negative words found.'
                                        : _analysisResult!.words.bad.keys.join(', '),
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: const Text('All Words Analyzed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              leading: Icon(Icons.sort_by_alpha, color: Colors.blueGrey.shade400),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    _analysisResult!.words.all.isEmpty
                                        ? 'No words found.'
                                        : _analysisResult!.words.all.join(', '),
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else if (_controller.text.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lightbulb_outline, size: 60, color: Colors.teal.shade300),
                        const SizedBox(height: 15),
                        Text(
                          'Start typing to see real-time sentiment analysis!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Expanded(child: Text(value, style: valueStyle ?? const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  String _getSentimentText(double score) {
    if (score > 0) return 'Positive';
    if (score < 0) return 'Negative';
    return 'Neutral';
  }

  Color _getSentimentColor(double score) {
    if (score > 0) return Colors.green.shade600;
    if (score < 0) return Colors.red.shade600;
    return Colors.blueGrey.shade600;
  }
}