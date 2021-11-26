import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/compoments/compoments.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var PostTextController = TextEditingController();
        var postImage = SocialCubit.get(context).PostImage;
        var usermodel=SocialCubit.get(context).userModel;
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Post'),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(IconBroken.Arrow___Left_2),
            ),
            titleSpacing: 5,
            actions: [
              defaultTextButton(
                function: () {
                  if (SocialCubit.get(context).PostImage != null) {
                    SocialCubit.get(context).UploadPostImage(
                      postText: PostTextController.text,
                      dateTime: DateTime.now().toString(),
                    );
                  } else {
                    SocialCubit.get(context).CreatePost(
                      postText: PostTextController.text,
                      dateTime: DateTime.now().toString(),
                    );
                  }
                  Navigator.pop(context);
                },
                text: 'Post',
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (state is SocialAddPostLoadingState)
                LinearProgressIndicator(),
                if (state is SocialAddPostLoadingState)
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${usermodel!.image}'),
                      radius: 25,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${usermodel.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, height: 1.4),
                          ),
                          Text(
                            DateTime.now().toString(),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: PostTextController,
                    decoration: InputDecoration(
                      hintText: 'What\'s on your mind ...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (SocialCubit.get(context).PostImage != null)
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(postImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      child: IconButton(
                        onPressed: () {
                          SocialCubit.get(context).RemovePostImage();
                        },
                        icon: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          SocialCubit.get(context).getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(IconBroken.Image),
                            Text('Add Photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('# Tags'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
