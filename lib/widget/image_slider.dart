import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:sac_wallet/model/user.dart';
import 'package:sac_wallet/repository/user_repository.dart';

class ImageSlider extends StatelessWidget {
  final List<String> images;

  ImageSlider(this.images);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: FutureBuilder(
        future: UserRepository().getUser(),
        builder: (context, AsyncSnapshot<User?> user) {
          if (user.hasData) {
            User currentUser = user.data!;
            List<Widget> imagesList = getImageList(images, currentUser);
            if (imagesList.length > 0) {
              return Carousel(
                images: imagesList,
              );
            } else {
              return Center(child: Image.asset("assets/images/app_icon.png"));
            }
          }
          return Center(child: Text("Loading"));
        },
      ),
    );
  }

  List<Widget> getImageList(List<String> images, User user) {
    List<Widget> imgWidgets = [];

    for (String image in images) {
      imgWidgets.add(Image.network(image,
          headers: {"Authorization": 'Bearer ${user.userAccessToken}'},
          fit: BoxFit.fill));
    }
    return imgWidgets;
  }


}

