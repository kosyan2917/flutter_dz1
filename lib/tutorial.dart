import 'api_service.dart';
void main() async {
  final apiService = APIService();
  print(await apiService.getStories());
}

