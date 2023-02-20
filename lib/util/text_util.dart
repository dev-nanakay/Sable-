class TextUtil {

  static String USER_REF_TITLE = "Users";
  static String COMPANY_REF_TITLE = "Companies";
  static String PROFIT_REF_TITLE = "Non-Profits";

  static String ID = "id";
  static String TOKEN = "token";
  static String NAME = "name";
  static String DESCRIPTION = "description";
  static String COMPANY_NAME = "company_name";
  static String PROFIT_NAME = "profit_name";
  static String USER_NAME = "user_name";
  static String USER_WALLET_ADDRESS = "user_wallet_address";
  static String EMAIL = "email";
  static String PHOTO = "photo";
  static String COUNTRY = "country";
  static String walletAddress = "walletAddress";
  static String FACEBOOK_LINK = "facebook_link";
  static String TWITTER_LINK = "twitter_link";
  static String INSTAGRAM_LINK = "instagram_link";
  static String LINKEDIN_LINK = "linkedin_link";
  static String ENABLED_CHAT = "enabled_chat";
  static String INDUSTRY = "industry";
  static String LOCATION = "location";
  static String YEAR = "year_in_operation";
  static String PHONE = "phone";
  static String WEBSITE = "website";
  static String ORGANIZATION = "organization";
  static String STATUS = "status";

  static String ADDRESS = "address";
  static String MY_ADDRESS = "myAddress";
  static String TO_ADDRESS = "toAddress";
  static String BALANCE = "balance";
  static String AMOUNT = "amount";
  static String MESSAGE = "message";
  static String PRIVATE_RESPONSE_KEY = "private_key";
  static String PRIVATE_BODY_KEY = "privateKey";
  static String EMAIL_ALREADY_IN_USE = "email_already_in_use";

 static String REGISTRATION_SUCCESSFUL_MSG = "Registration successful";
  static String LOGIN_SUCCESSFUL_MSG = "Login successful";

  static String PRIVATE_KEY = "privatekey";
  
  static String INSTRUCTION1 = " The above secret words are the keys to your wallets and assets on this app. Back them up in safe place and do not ever share this with anyone.";
  static String INSTRUCTION2 = "Treate these words as your bank card pin number";
  static String INSTRUCTION3 = "On the next few screens you will need to re-enter these words to confirm you have safely backed up these key words.";
  static String INSTRUCTION4 = " Take these secrete words and save them somewhere safe and/or write them down.";

  String formatAddressText(final String address){
    if(address != null && address.length > 11){
     // final formattedAddress = "${address.substring(0, 10)}...${address.substring(address.length - 5, address.length-1)}";
      final formattedAddress = "${address.substring(0, 12)}..";
      return formattedAddress;
    }
    return address;
  }


  String formatText(final String text, final int len){
    if(text != null && text.length > len){
      return "${text.substring(0, len)}...";
    }
    return text;
  }

}