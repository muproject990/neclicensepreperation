import 'package:neclicensepreperation/features/auth/domain/entities/user.dart';


// TODO yo kina banako vanesi data lai structure ma garna kam lagxa 
//TODO kina  vanesi yesle domain layer ko structure ma depend gardaina ra yesle afnai data layer ko kam milauxa tesaile hamle user model banako ho jsle User lai extend garxa ani its  just like previous interface and its implementations..

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
    );
  }
}
