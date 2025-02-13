import 'package:bookbeauty_desktop/models/service.dart';
import 'package:bookbeauty_desktop/providers/base_provider.dart';

class ServiceProvider extends BaseProvider<Service> {
  ServiceProvider() : super("Service");

  @override
  Service fromJson(data) {
    return Service.fromJson(data);
  }
}
