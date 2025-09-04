import 'lib/models/task.dart';

void main() {
  // Test the URL pattern matching
  final task = Task(
    id: 'test',
    name: 'Test Task',
    url: 'https://www.baidu.com/',
    domainList: ['www.baidu.com'],
    urlPatterns: ['https://www.baidu.com/*.html'],
    captureUrlPatterns: ['https://www.baidu.com/thread-*.html'],
    createdAt: DateTime.now(),
  );

  
  // Test URLs
  final testUrls = [
  ];

  for (final url in testUrls) {
    final matches = task.isUrlValid(url);
    print('$url -> ${matches ? "MATCHES url" : "NO MATCH url"}');
    final matches2 = task.isUrlNeedCapture(url);
    print('$url -> ${matches2 ? "MATCHES captureUrl" : "NO MATCH captureUrl"}');
  }
}
