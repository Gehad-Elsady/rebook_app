import 'package:googleapis_auth/auth_io.dart';

class get_server_key {
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "app-app-4fb0a",
          "private_key_id": "22300fa6aabe53ee1c2aa318b272a3067e4ab202",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQD4k75oSUujwfiR\ncKMsXAOAnSf8fF7mifrOEZfkU0G0WD/rH8eAY5i2/FpQpEdd4kR8lcydR/8iVm7q\ndwKue+Ql4jMeK36K3btuGiWCXPuOxfGn+pTPkAipVBCxesEAog8OCcA6Gh1dv/7h\ng4djlyK5b3BHqXO5Sy4xmp4+tmQ1A/dKr1P/GfEc5SGOQOCQH7LieEGOavvht03C\noRi1Fg4NxQbMVo73Wxsgge9X6A7yQ4hQ2DfXXzDUOM4O8IIOiR72b9jcQ3dYfiXJ\nNyRi8FzdaVoJLUTr4z4sc/OOvLCoB2sGhBDrt3yDv0IMhAjdWDnNawVEluUI8XrX\nNgCqvO+jAgMBAAECggEADMN84PdLY6czMxu3D9vRqHEwe1FTFiPI7pfVjzlSvM3j\nPBiTMog//oORxBALYEqAbqRYr7823krxbNHw5t0gyvr2oPqewI2/4q3ZBBlFRB0J\n2mmOW+PSinnxAJoujJtT33ThKbcHyMPjrWZ4pzZ1dcT4MrlZ1A6EaOuh+WF9e0ij\nKkp1nG7DYLJlK7Qp1d24zsCOcWc2CdaCIvVM3mxXFmnt/uRNFGJ6niW8LBBic1nc\n86D9Hc4eE/Qw247JZoWTfZ+4XUxmpr/SgxNZC3k59/p9eKGxie5IHUDXtLQS5im/\nTr+OacBQJkoRJglW2raGU2LlDMRWlA6Nx/VobarlMQKBgQD7+ZhUeBcHhVM+MXhu\nRDGJ8kUUY9sQY0mr2XY5rWIHWp3S+j+bw1+swdw/UcuVSdijCTk1j57ANO37Oqo9\nEqQyycB7yple3R2AITBTC38Q2IGAhLJNziPHKavhQVB7rA3XdGAK5YertuutlOVn\nQLYNM5q2152t1tRl1aYfEQMMTwKBgQD8jED7YqLWBdPysC2CQM5tgTaEb37NpLpz\n9+sIREj74/u9tQGrDIZEcnep1bgaGCOZWFhfKpSUPJgsDwOsZZSr01CgQiz7Wc0M\n9xZg6IFDrXglbCHgk3DVf01iB41WkwtEHHJPICHXooMvs94YKojn7/1X3ibTY7Ii\nHp3d0P2ubQKBgGLNkj+8/zrBusxuVYzXTJ2M1C2Uojeg1yh9kvA23nOHws8RtZN8\nXq29LoHdrviRBlOXsEkiUduIZbDXZh2gi6YmmkVwQgeCqKivWuWVYnPWkaE1Zz0/\nEaRs4KrpE4gLBTpwtaBQNIzOo0djVTjRlRFEJOyBS6D41jxANG2GHC3dAoGBAPCb\nFxXpZUYOi1096D2eTI0be7s1FlQJyvHNkwhvNjF1hVO57XrvFcSEYelWim2h7dic\nyKTyRlfsWvYu38sRhFEnpDrqkTxu0+K0TYfKO80kqcDNgoEZN3jQLgNlOozuzt73\nUxh7foKYe++op8HSVFjU1kMujUL8SqwjCzhXcjkJAoGBAMAHa/t8i05BNdCZi/R2\n/G0zqDf2R/UcvXYoIxUepZA7BVs/ddIHHVzUE9w6Tl5x7gkXT9HDVqEtVBRbh9f1\nXtRd2//3+ZUqJNL6PJEbqO6SP0roLFsik3XDzkIO3uj/Tr3Q0WFBwyXzQ/KWefCI\nxTz7cazzFRWkFNQczIrCiZCn\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-uo8ak@app-app-4fb0a.iam.gserviceaccount.com",
          "client_id": "105663383201750266413",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-uo8ak%40app-app-4fb0a.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}
