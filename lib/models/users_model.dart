
class UsersModel{
   String? email;
   String? uId;
   String? name;
   String? phone;
   String? image;
   String? cover;
   String? bio;
   bool? isEmailVerified;

   UsersModel({this.email,this.name,this.uId,this.phone,this.image,this.cover,this.bio,this.isEmailVerified=false});

   UsersModel.Fromjson(Map<String,dynamic> json){
     email=json['email'];
     uId=json['uId'];
     name=json['name'];
     phone=json['phone'];
     image=json['image'];
     cover=json['cover'];
     bio=json['bio'];
     isEmailVerified=json['isEmailVerified'];
   }

   Map<String,dynamic> ToMap(){
     return {
       'email':email,
       'uId':uId,
       'name':name,
       'phone':phone,
       'image':image,
       'cover':cover,
       'bio':bio,
       'isEmailVerified':isEmailVerified,
   };
}
}