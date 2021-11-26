
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/users_model.dart';
import 'package:social_app/modules/chat_details/chatdetails_screen.dart';
import 'package:social_app/shared/compoments/compoments.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
          condition: SocialCubit.get(context).allUsers.length > 0,
          builder: (context)=>ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index)=> buildUserItem(SocialCubit.get(context).allUsers[index],context),
            separatorBuilder:(context,index)=> SizedBox(height: 5,),
            itemCount: SocialCubit.get(context).allUsers.length,
          ),
          fallback: (context)=>Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
  Widget buildUserItem(UsersModel model,context)=>InkWell(
    onTap: (){
      NavigatTo(context,ChatDetailsScreen(userModel: model,));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                '${model.image}'),
            radius: 25,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${model.name}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        height: 1.1)),
                SizedBox(
                  width: 4,
                ),
                Text(
                  'message',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
