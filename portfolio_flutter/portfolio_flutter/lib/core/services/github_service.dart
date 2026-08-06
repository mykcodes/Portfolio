import 'dart:convert';
import 'package:http/http.dart' as http;

class GithubCommitData {
  final String repoName;
  final String language;
  final int stars;
  final int forks;
  final String hash;
  final String message;
  final String date;
  final bool isMajor;

  GithubCommitData({
    required this.repoName,
    required this.language,
    required this.stars,
    required this.forks,
    required this.hash,
    required this.message,
    required this.date,
    required this.isMajor,
  });
}

class GithubService {
  static final GithubService instance = GithubService._();
  GithubService._();

  static const String _username = 'mykcodes'; 

  
  List<GithubCommitData>? _cachedData;
  DateTime? _lastFetchTime;
  static const Duration _cacheDuration = Duration(minutes: 15);

  Future<List<GithubCommitData>> fetchLatestActivity() async {
    
    if (_cachedData != null && _lastFetchTime != null) {
      if (DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        return _cachedData!;
      }
    }

    try {
      
      final repoResponse = await http
          .get(
            Uri.parse(
              'https://api.github.com/users/$_username/repos?sort=updated&per_page=3',
            ),
            headers: {'Accept': 'application/vnd.github.v3+json'},
          )
          .timeout(const Duration(seconds: 10));

      if (repoResponse.statusCode != 200) {
        throw Exception('Failed to load repositories');
      }

      final List<dynamic> repos = json.decode(repoResponse.body);
      List<GithubCommitData> timelineData = [];

      
      for (var repo in repos) {
        final repoName = repo['name'] as String;
        final language = repo['language'] as String? ?? 'Unknown';
        final stars = repo['stargazers_count'] as int? ?? 0;
        final forks = repo['forks_count'] as int? ?? 0;

        final commitResponse = await http
            .get(
              Uri.parse(
                'https://api.github.com/repos/$_username/$repoName/commits?per_page=1',
              ),
              headers: {'Accept': 'application/vnd.github.v3+json'},
            )
            .timeout(const Duration(seconds: 5));

        if (commitResponse.statusCode == 200) {
          final List<dynamic> commits = json.decode(commitResponse.body);
          if (commits.isNotEmpty) {
            final latestCommit = commits.first;
            final sha = (latestCommit['sha'] as String).substring(0, 7);
            final message = latestCommit['commit']['message'] as String;
            final dateStr = latestCommit['commit']['author']['date'] as String;

            
            final dateObj = DateTime.parse(dateStr);
            final formattedDate =
                "${dateObj.year}-${dateObj.month.toString().padLeft(2, '0')}-${dateObj.day.toString().padLeft(2, '0')}";

            timelineData.add(
              GithubCommitData(
                repoName: repoName,
                language: language,
                stars: stars,
                forks: forks,
                hash: sha,
                message: message.split('\n').first, 
                date: formattedDate,
                isMajor:
                    stars > 5 ||
                    forks > 2, 
              ),
            );
          }
        }
      }

      if (timelineData.isEmpty) {
        throw Exception('No commit activity found');
      }

      _cachedData = timelineData;
      _lastFetchTime = DateTime.now();
      return timelineData;
    } catch (e) {
      
      return [];
    }
  }
}
