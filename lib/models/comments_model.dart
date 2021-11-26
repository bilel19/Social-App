class CommentsModel{
  String? uId;
  String? name;
  String? image;
  String? dateTime;
  String? commentText;
  String? postID;

  CommentsModel({this.name,this.uId,this.image,this.dateTime,this.commentText,this.postID});

  CommentsModel.Fromjson(Map<String,dynamic> json){
    uId=json['uId'];
    name=json['name'];
    image=json['image'];
    dateTime=json['dateTime'];
    commentText=json['commentText'];
    postID=json['postID'];
  }

  Map<String,dynamic> ToMap(){
    return {
      'uId':uId,
      'name':name,
      'image':image,
      'dateTime':dateTime,
      'commentText':commentText,
      'postID':postID,
    };
  }
}