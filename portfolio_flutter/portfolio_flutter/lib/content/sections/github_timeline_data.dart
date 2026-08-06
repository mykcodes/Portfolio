class GithubCommit {
  final String hash;
  final String message;
  final String date;
  final bool isMajor;

  const GithubCommit({
    required this.hash,
    required this.message,
    required this.date,
    this.isMajor = false,
  });
}

class GithubTimelineData {
  static const List<GithubCommit> recentCommits = [
    GithubCommit(
      hash: 'a9f23b1',
      message: 'feat(engine): deploy webgl canvas renderer optimization',
      date: '2 hours ago',
      isMajor: true,
    ),
    GithubCommit(
      hash: '3d8c11e',
      message: 'refactor(timeline): decouple scroll physics from framerate',
      date: '5 hours ago',
    ),
    GithubCommit(
      hash: 'f0192a7',
      message: 'fix(core): resolve state tearing in cinematic sequence',
      date: '1 day ago',
    ),
    GithubCommit(
      hash: 'b6e399c',
      message: 'feat(ai): integrate local LLM inference bindings',
      date: '2 days ago',
      isMajor: true,
    ),
    GithubCommit(
      hash: 'e4c220f',
      message: 'chore(deps): bump flutter SDK to latest stable',
      date: '4 days ago',
    ),
  ];
}
