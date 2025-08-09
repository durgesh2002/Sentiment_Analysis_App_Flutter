// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:sentiment_analysis_app/api.dart';
// import 'package:sentiment_dart/sentiment_dart.dart';
//
// class TweetSentimentScreen extends StatefulWidget {
//   const TweetSentimentScreen({super.key});
//
//   @override
//   State<TweetSentimentScreen> createState() => _TweetSentimentScreenState();
// }
//
// class _TweetSentimentScreenState extends State<TweetSentimentScreen> {
//   final _controller = TextEditingController();
//   final Api _api = Api();
//   bool _isLoading = false;
//   String _errorMessage = '';
//   List<Map<String, dynamic>> _tweets = [];
//
//   int positiveCount = 0;
//   int negativeCount = 0;
//   int neutralCount = 0;
//
//   Future<void> _fetchTweets(String query) async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//       _tweets = [];
//       positiveCount = 0;
//       negativeCount = 0;
//       neutralCount = 0;
//     });
//
//     try {
//       final tweetTexts = await _api.fetchTweets(query); //  Use API class
//       _tweets = tweetTexts.map((text) {
//         final sentiment = Sentiment.analysis(text);
//         final score = sentiment.score;
//
//         if (score > 0) {
//           positiveCount++;
//         } else if (score < 0) {
//           negativeCount++;
//         } else {
//           neutralCount++;
//         }
//
//         return {
//           'text': text,
//           'username': 'Anonymous', // Placeholder (update if backend sends it)
//           'score': score,
//           'sentiment': score > 0 ? 'Positive' : score < 0 ? 'Negative' : 'Neutral',
//         };
//       }).toList();
//     } catch (e) {
//       _errorMessage = 'Error: $e';
//       print(_errorMessage);
//     }
//
//     setState(() => _isLoading = false);
//   }
//
//   Widget _buildTweetCard(Map<String, dynamic> tweet) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       elevation: 3,
//       child: ListTile(
//         title: Text(tweet['text']),
//         subtitle: Text('@${tweet['username']} • ${tweet['sentiment']}'),
//         trailing: Text(tweet['score'].toString()),
//       ),
//     );
//   }
//
//   Widget _buildPieChart() {
//     final total = positiveCount + negativeCount + neutralCount;
//     if (total == 0) return const SizedBox.shrink();
//
//     double percent(int count) => (count / total) * 100;
//
//     return SizedBox(
//       height: 250,
//       child: PieChart(
//         PieChartData(
//           centerSpaceRadius: 0,
//           sections: [
//             PieChartSectionData(
//               value: positiveCount.toDouble(),
//               color: Colors.green,
//               title: '${percent(positiveCount).toStringAsFixed(1)}%',
//               radius: 80,
//               titleStyle: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             PieChartSectionData(
//               value: negativeCount.toDouble(),
//               color: Colors.red,
//               title: '${percent(negativeCount).toStringAsFixed(1)}%',
//               radius: 80,
//               titleStyle: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             PieChartSectionData(
//               value: neutralCount.toDouble(),
//               color: Colors.blueGrey,
//               title: '${percent(neutralCount).toStringAsFixed(1)}%',
//               radius: 80,
//               titleStyle: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Twitter Sentiment Analysis'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: 'Enter search keyword',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: _isLoading ? null : () => _fetchTweets(_controller.text.trim()),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (_isLoading)
//               const CircularProgressIndicator()
//             else if (_errorMessage.isNotEmpty)
//               Text(_errorMessage, style: const TextStyle(color: Colors.red))
//             else if (_tweets.isNotEmpty) ...[
//                 const Text('Sentiment Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 _buildPieChart(),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _tweets.length,
//                     itemBuilder: (context, index) => _buildTweetCard(_tweets[index]),
//                   ),
//                 )
//               ]
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sentiment_analysis_app/api.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

class TweetSentimentScreen extends StatefulWidget {
  const TweetSentimentScreen({super.key});

  @override
  State<TweetSentimentScreen> createState() => _TweetSentimentScreenState();
}

class _TweetSentimentScreenState extends State<TweetSentimentScreen> {
  final _controller = TextEditingController();
  final Api _api = Api();
  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _tweets = [];

  int positiveCount = 0;
  int negativeCount = 0;
  int neutralCount = 0;

  Future<void> _fetchTweets(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _tweets = [];
      positiveCount = 0;
      negativeCount = 0;
      neutralCount = 0;
    });

    try {
      final tweetTexts = await _api.fetchTweets(query);
      _tweets = tweetTexts.map((text) {
        final sentiment = Sentiment.analysis(text);
        final score = sentiment.score;

        if (score > 0) {
          positiveCount++;
        } else if (score < 0) {
          negativeCount++;
        } else {
          neutralCount++;
        }

        return {
          'text': text,
          'username': 'Anonymous',
          'score': score,
          'sentiment': score > 0 ? 'Positive' : score < 0 ? 'Negative' : 'Neutral',
        };
      }).toList();
    } catch (e) {
      _errorMessage = 'Error: $e. Please ensure your backend server is running and accessible.';
      print(_errorMessage);
    }

    setState(() => _isLoading = false);
  }

  // Widget to build individual tweet cards with an enhanced look
  Widget _buildTweetCard(Map<String, dynamic> tweet) {
    Color sentimentColor;
    IconData sentimentIcon;

    switch (tweet['sentiment']) {
      case 'Positive':
        sentimentColor = Colors.green.shade600;
        sentimentIcon = Icons.sentiment_very_satisfied;
        break;
      case 'Negative':
        sentimentColor = Colors.red.shade600;
        sentimentIcon = Icons.sentiment_very_dissatisfied;
        break;
      default: // Neutral
        sentimentColor = Colors.blueGrey.shade600;
        sentimentIcon = Icons.sentiment_neutral;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tweet['text'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '@${tweet['username']}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: sentimentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(sentimentIcon, size: 16, color: sentimentColor),
                      const SizedBox(width: 6),
                      Text(
                        tweet['sentiment'],
                        style: TextStyle(color: sentimentColor, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Score: ${tweet['score'].toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the pie chart for sentiment summary
  Widget _buildPieChart() {
    final total = positiveCount + negativeCount + neutralCount;
    if (total == 0) return const SizedBox.shrink();

    double percent(int count) => (count / total) * 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Sentiment Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200, // Adjusted height for better fit
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 50, // Slightly larger center space
                sectionsSpace: 4, // Space between sections
                sections: [
                  PieChartSectionData(
                    value: positiveCount.toDouble(),
                    color: Colors.green.shade400,
                    title: '${percent(positiveCount).toStringAsFixed(1)}%',
                    radius: 60, // Adjusted radius
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                    badgeWidget: _buildBadge(Icons.sentiment_very_satisfied, Colors.green.shade400),
                    badgePositionPercentageOffset: 1.1,
                  ),
                  PieChartSectionData(
                    value: negativeCount.toDouble(),
                    color: Colors.red.shade400,
                    title: '${percent(negativeCount).toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                    badgeWidget: _buildBadge(Icons.sentiment_very_dissatisfied, Colors.red.shade400),
                    badgePositionPercentageOffset: 1.1,
                  ),
                  PieChartSectionData(
                    value: neutralCount.toDouble(),
                    color: Colors.blueGrey.shade400,
                    title: '${percent(neutralCount).toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                    badgeWidget: _buildBadge(Icons.sentiment_neutral, Colors.blueGrey.shade400),
                    badgePositionPercentageOffset: 1.1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildLegend(),
        ],
      ),
    );
  }

  // Helper to build custom badges for pie chart sections
  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  // Widget to build the legend for the pie chart
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.green.shade400, 'Positive'),
        _buildLegendItem(Colors.red.shade400, 'Negative'),
        _buildLegendItem(Colors.blueGrey.shade400, 'Neutral'),
      ],
    );
  }

  // Helper to build individual legend items
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitter Sentiment Analysis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal.shade700,
        elevation: 0, // Remove shadow for a flatter look
        automaticallyImplyLeading: false, // Disable default back button
        leading: IconButton( // Add a custom back button
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search input field
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter keyword to search tweets', // Changed from labelText to hintText
                    hintStyle: TextStyle(color: Colors.grey[700]), // Applied style to hintText
                    prefixIcon: Icon(Icons.search, color: Colors.teal.shade600),
                    suffixIcon: _isLoading
                        ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : IconButton(
                      icon: Icon(Icons.send, color: Colors.teal.shade600),
                      onPressed: () => _fetchTweets(_controller.text.trim()),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  onSubmitted: _isLoading ? null : _fetchTweets,
                ),
              ),
              const SizedBox(height: 20),

              // Loading, error, or results display
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)),
                        SizedBox(height: 10),
                        Text('Fetching tweets...', style: TextStyle(color: Colors.teal, fontSize: 16)),
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
                      Icon(Icons.error_outline, color: Colors.red.shade700),
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
              else if (_tweets.isNotEmpty)
                  Expanded(
                    child: Column(
                      children: [
                        _buildPieChart(),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Recent Tweets & Sentiment',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _tweets.length,
                            itemBuilder: (context, index) => _buildTweetCard(_tweets[index]),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.insights, size: 80, color: Colors.teal.shade200),
                          const SizedBox(height: 15),
                          Text(
                            'Enter a keyword to analyze tweet sentiments!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, color: Colors.grey[500]),
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
}