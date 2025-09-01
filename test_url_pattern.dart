import 'lib/models/task.dart';

void main() {
  // Test the URL pattern matching
  final task = Task(
    id: 'test',
    name: 'Test Task',
    url: 'https://www.315lz.com/',
    domainList: ['www.315lz.com'],
    urlPattern: 'https://www.315lz.com/*.html',
    captureUrlPattern: 'https://www.315lz.com/thread-*.html',
    createdAt: DateTime.now(),
  );

  
  // Test URLs
  final testUrls = [
    'https://www.315lz.com/forum.php?mobile=yes',
    'https://www.315lz.com/page.html',
    'https://www.315lz.com/page/ddd.html',
    'https://www.315lz.com/thread-1095-1-1.html',
    'https://www.315lz.com/article.html?param=value',
    'https://www.315lz.com/other.php',
  ];

  for (final url in testUrls) {
    final matches = task.isUrlValid(url);
    print('$url -> ${matches ? "MATCHES url" : "NO MATCH url"}');
    final matches2 = task.isUrlNeedCapture(url);
    print('$url -> ${matches2 ? "MATCHES captureUrl" : "NO MATCH captureUrl"}');
  }
}
