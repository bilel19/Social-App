
class PostsModel{
  String? uId;
  String? name;
  String? image;
  String? dateTime;
  String? postImage;
  String? postText;
  String? postID;

  PostsModel({this.name,this.uId,this.image,this.dateTime,this.postImage,this.postText,this.postID});

  PostsModel.Fromjson(Map<String,dynamic> json){
    uId=json['uId'];
    name=json['name'];
    image=json['image'];
    dateTime=json['dateTime'];
    postImage=json['postImage'];
    postText=json['postText'];
    postID=json['postID'];
  }

  Map<String,dynamic> ToMap(){
    return {
      'uId':uId,
      'name':name,
      'image':image,
      'dateTime':dateTime,
      'postImage':postImage,
      'postText':postText,
      'postID':postID,
    };
  }
}