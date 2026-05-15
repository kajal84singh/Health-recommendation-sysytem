import 'dart:io';

void main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Listening on localhost:8080');

  await for (HttpRequest request in server) {
    String path = request.uri.path == '/' ? '/index.html' : request.uri.path;
    File file = File('.$path');

    if (await file.exists()) {
      if (path.endsWith('.html')) {
        request.response.headers.contentType = ContentType.html;
      } else if (path.endsWith('.css')) {
        request.response.headers.contentType = ContentType.parse('text/css');
      } else if (path.endsWith('.js')) {
        request.response.headers.contentType = ContentType.parse('application/javascript');
      }
      await file.openRead().pipe(request.response);
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not found');
      await request.response.close();
    }
  }
}
