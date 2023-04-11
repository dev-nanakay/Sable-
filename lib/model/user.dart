import 'package:sac_wallet/util/database_creator.dart';

class User {
  String id;
  String? dbid;
  String userAccessToken;
  String name;
  String? description;
  String email;
  String phoneNumber;
  String? photo;
  String? country;
  String? walletAddress;
  String? facebook_link;
  String? twitter_link;
  String? instagram_link;
  String? linkedin_link;
  String enabledChat;
  String? privateKey;
  String? publicKey;
  String? username;
  String? pin;
  String? mnemonic;
  String? incorrectAttemptsTime;
  String? incorrectAttempts;
  String referralCode;
  String phoneNumberVerified;
  String emailVerified;

  User(
      this.id,
      this.dbid,
      this.userAccessToken,
      this.name,
      this.description,
      this.email,
      this.phoneNumber,
      this.photo,
      this.country,
      this.walletAddress,
      this.facebook_link,
      this.twitter_link,
      this.instagram_link,
      this.linkedin_link,
      this.enabledChat,
      this.privateKey,
      this.publicKey,
      this.username,
      this.pin,
      this.mnemonic,
      this.incorrectAttemptsTime,
      this.incorrectAttempts,
      this.referralCode,
      this.phoneNumberVerified,
      this.emailVerified);

  factory User.fromJson(Map<String, dynamic> json) {
    print(json);
    return User(
      json[DatabaseCreator.id] as String,
      json[DatabaseCreator.dbid] as String?,
      json[DatabaseCreator.userAccessToken] as String,
      json[DatabaseCreator.name] as String,
      json[DatabaseCreator.description] as String?,
      json[DatabaseCreator.email] as String,
      json[DatabaseCreator.phoneNumber] as String,
      json[DatabaseCreator.photo] as String?,
      json[DatabaseCreator.country] as String?,
      json[DatabaseCreator.walletAddress] as String?,
      json[DatabaseCreator.facebook_link] as String?,
      json[DatabaseCreator.twitter_link] as String?,
      json[DatabaseCreator.instagram_link] as String?,
      json[DatabaseCreator.linkedin_link] as String?,
      json[DatabaseCreator.enabledChat].toString(),
      json[DatabaseCreator.privateKey] as String?,
      json[DatabaseCreator.publicKey] as String?,
      json[DatabaseCreator.username] as String,
      json[DatabaseCreator.pin] as String?,
      json[DatabaseCreator.mnemonic] as String?,
      json[DatabaseCreator.incorrectAttemptsTime] as String?,
      json[DatabaseCreator.incorrectAttempts] as String?,
      json[DatabaseCreator.referralCode] as String,
      json[DatabaseCreator.phoneNumberVerified].toString(),
      json[DatabaseCreator.emailVerified].toString(),
    );
  }
// db to class mapping
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'dbid': dbid,
      'userAccessToken': userAccessToken,
      'name': name,
      'description': description,
      'email': email,
      'phoneNumber': phoneNumber,
      'photo': photo,
      'country': country,
      'walletAddress': walletAddress,
      'facebook_link': facebook_link,
      'twitter_link': twitter_link,
      'instagram_link': instagram_link,
      'linkedin_link': linkedin_link,
      'enabledChat': enabledChat,
      'privateKey': privateKey,
      'publicKey': publicKey,
      'username': username,
      'pin': pin,
      'mnemonic': mnemonic,
      'incorrectAttemptsTime': incorrectAttemptsTime,
      'incorrectAttempts': incorrectAttempts,
      'referralCode': referralCode,
      'phoneNumberVerified': phoneNumberVerified,
      'emailVerified': emailVerified
    };
  }

  @override
  String toString() {
    return 'User{id: $id, dbid: $dbid, name: $name, description: $description, email: $email, photo: $photo, country: $country, walletAddress: $walletAddress, facebook_link: $facebook_link, twitter_link: $twitter_link, instagram_link: $instagram_link, linkedin_link: $linkedin_link, enabledChat: $enabledChat, privateKey: $privateKey, publicKey: $publicKey, username: $username, pin: $pin, mnemonic: $mnemonic, referralCode: $referralCode, phoneNumberVerified: $phoneNumberVerified, emailVerified: $emailVerified, phone: $phoneNumber, accessToken: $userAccessToken}';
  }
}
