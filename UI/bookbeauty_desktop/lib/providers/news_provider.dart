import 'package:bookbeauty_desktop/models/news.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';

class NewsProvider extends BaseProvider<News> {
  NewsProvider() : super("News");

  @override
  News fromJson(data) {
    return News.fromJson(data);
  }
}
