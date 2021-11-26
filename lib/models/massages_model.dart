class MessagesModel{
  String? senderUid;
  String? recieverUid;
  String? textmessage;
  String? dateTime;
  String? chatImage;

  MessagesModel({this.senderUid,this.recieverUid,this.textmessage,this.dateTime,this.chatImage});

  MessagesModel.Fromjson(Map<String,dynamic> json){
    senderUid=json['senderUid'];
    recieverUid=json['recieverUid'];
    textmessage=json['textmessage'];
    dateTime=json['dateTime'];
    chatImage=json['chatImage'];
  }

  Map<String,dynamic> ToMap(){
    return {
      'senderUid':senderUid,
      'recieverUid':recieverUid,
      'textmessage':textmessage,
      'dateTime':dateTime,
      'chatImage':chatImage,
    };
  }
}