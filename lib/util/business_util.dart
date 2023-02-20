import 'package:sac_wallet/model/business.dart';
import 'package:sac_wallet/util/api_config.dart';

List<String> getImageUrls(Business business) {
  List<String> imageUrls = [];
  business.images.forEach((element) {
    try {
      imageUrls.add('${ApiConfig.getConfig().FILES_BASE}/${element.imageId}');
    } catch (e, s) {
      print(s);
    }
  });
  return imageUrls;
}
