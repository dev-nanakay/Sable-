import '../util/text_util.dart';

class Company {
  String id;
  String companyName;
 // String description;
  String userName;
  String userWalletAddress;
  String industry;
  String location;
  String year;
  String phone;
  String email;
  String website;
  String facebookLink;
  String twitterLink;
  String instagramLink;

  Company({required this.id, required this.companyName, required this.userName, required this.userWalletAddress, required this.industry, required this.location, required this.year, required this.phone, required this.email, required this.website, required this.facebookLink, required this.twitterLink, required this.instagramLink});

  
  factory Company.fromServer(Map<String, dynamic> snapshot) => Company(
    id: snapshot[TextUtil.ID],
    companyName: snapshot[TextUtil.COMPANY_NAME],
    userName: snapshot[TextUtil.USER_NAME],
    userWalletAddress: snapshot[TextUtil.USER_WALLET_ADDRESS],
    industry: snapshot[TextUtil.INDUSTRY],
    location: snapshot[TextUtil.LOCATION],
    year: snapshot[TextUtil.YEAR],
    phone: snapshot[TextUtil.PHONE],
    email: snapshot[TextUtil.EMAIL],
    website: snapshot[TextUtil.WEBSITE],
    facebookLink: snapshot[TextUtil.FACEBOOK_LINK],
    twitterLink: snapshot[TextUtil.TWITTER_LINK],
    instagramLink: snapshot[TextUtil.INSTAGRAM_LINK]
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map[TextUtil.ID] = id;
    map[TextUtil.COMPANY_NAME] = companyName;
    map[TextUtil.USER_NAME] = userName;
    map[TextUtil.USER_WALLET_ADDRESS] = userWalletAddress;
    map[TextUtil.INDUSTRY] = industry;
    map[TextUtil.LOCATION] = location;
    map[TextUtil.YEAR] = year;
    map[TextUtil.PHONE] = phone;
    map[TextUtil.EMAIL] = email;
    map[TextUtil.WEBSITE] = website;
    map[TextUtil.FACEBOOK_LINK] = facebookLink;
    map[TextUtil.TWITTER_LINK] = twitterLink;
    map[TextUtil.INSTAGRAM_LINK] = instagramLink;
    return map;
  }
}