import 'dart:async';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/massages_model.dart';
import 'package:social_app/models/users_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  UsersModel? userModel;

  ChatDetailsScreen({this.userModel});

  var messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(recieverID: userModel!.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            Timer(
              Duration(seconds: 1),
                  () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
            );
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userModel!.image!),
                      radius: 15,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(userModel!.name!),
                  ],
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(IconBroken.Arrow___Left_2),
                ),
                titleSpacing: 1,
              ),
              body: ConditionalBuilder(
                condition: SocialCubit.get(context).messages.length > 0,
                builder: (context) => Padding(
                  padding:
                      const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).messages[index];
                            if (SocialCubit.get(context).userModel!.uId ==
                                message.senderUid)
                              return buildMyMessages(message, context);
                            return buildMessages(message, context);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8,
                          ),
                          itemCount: SocialCubit.get(context).messages.length,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      if(state is SocialSendMessagesLoadingState)
                      LinearProgressIndicator(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: messageController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Add message here...',
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getChatImage();
                              },
                              icon: Icon(
                                IconBroken.Image,
                                color: DefaultColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (SocialCubit.get(context).ChatImage ==
                                    null) {
                                  SocialCubit.get(context).sendMessage(
                                    recieverID: userModel!.uId!,
                                    textMessage: messageController.text,
                                    dateTime: DateTime.now().toString(),
                                  );

                                  messageController.clear();
                                } else {
                                  SocialCubit.get(context).UploadChatImage(
                                    recieverID: userModel!.uId!,
                                    textMessage: messageController.text,
                                    dateTime: DateTime.now().toString(),
                                  );
                                  messageController.clear();
                                }
                                Timer(
                                Duration(seconds: 1),
                                () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
                                );
                              },
                              icon: Icon(
                                IconBroken.Send,
                                color: DefaultColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (context) => Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessages(MessagesModel model, context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
              child: Text(
                    model.textmessage!,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
            ),
            if(model.chatImage !=null)
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 4),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(model.chatImage!)))),
            ),
          ],
        ),
      );

  Widget buildMyMessages(MessagesModel model, context) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
              child: Text(
                model.textmessage!,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            if(model.chatImage !=null)
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 4),
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(model.chatImage!)))),
            ),
          ],
        ),
      );
}
