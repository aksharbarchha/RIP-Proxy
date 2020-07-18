import 'package:http/http.dart' as http;

Future getImageData(url) async {
  http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    print("Success !!!!\n");
  } else {
    print('A network error occurred');
  }
  return response.body;
}
