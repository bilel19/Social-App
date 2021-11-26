import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:readmore/readmore.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/posts_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedScreen extends StatelessWidget {
  var CommentController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                margin: EdgeInsets.all(6),
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Image(
                      height: 180,
                      image: NetworkImage(
                          'https://image.freepik.com/free-photo/cheerful-male-gives-nice-offer-advertises-new-product-sale-stands-torn-paper-hole-has-positive-expression_273609-38452.jpg'),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        'Communicate with Friends !',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              ConditionalBuilder(
                condition: SocialCubit.get(context).posts.length > 0 && SocialCubit.get(context).userModel != null,
                builder: (context)=>ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index)=>BuildPosts(SocialCubit.get(context).posts[index],context,index),
                  separatorBuilder: (context,index)=>SizedBox(height: 8,),
                  itemCount: SocialCubit.get(context).posts.length,
                ),
                fallback: (context)=>Center(child: CircularProgressIndicator()),
              ),
              SizedBox(
                height: 8,),
            ],
          ),
        );
      },
    );
  }

  Widget BuildComments(context,index)=>BlocConsumer<SocialCubit,SocialStates>(
    listener: (context,state){},
    builder: (context,state){
      return ConditionalBuilder(
        condition: SocialCubit.get(context).comments.length > 0,//state is !SocialGetCommentPostLoadingState,
        builder: (context)=> Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height *0.7,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: DefaultColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  width: MediaQuery.of(context).size.width *0.4,
                  height: 5,

                ),
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index)=>BuildCommentItems(SocialCubit.get(context).comments[index],context,index),
                    separatorBuilder: (context,index)=>SizedBox(
                      height: 15,),
                    itemCount: SocialCubit.get(context).comments.length,
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: CommentController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Add comment...',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          SocialCubit.get(context).CommentPost(
                            postId: SocialCubit.get(context).postsId[index],
                            commentText: CommentController.text,
                            dateTime: DateTime.now().toString(),
                          );
                          CommentController.clear();
                        },
                        icon: Icon(IconBroken.Send,color:DefaultColor,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        fallback: (context)=>Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height *0.7,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: DefaultColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                width: MediaQuery.of(context).size.width *0.4,
                height: 5,

              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: CircularProgressIndicator(),),
                    Center(
                      child: Text('Be the first to comment !',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: CommentController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Add comment...',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        SocialCubit.get(context).CommentPost(
                          postId: SocialCubit.get(context).postsId[index],
                          commentText: CommentController.text,
                          dateTime: DateTime.now().toString(),
                        );
                        CommentController.clear();
                      },
                      icon: Icon(IconBroken.Send,color:DefaultColor,),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
        /*Container(
          height: MediaQuery.of(context).size.height *0.7,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: DefaultColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                width: MediaQuery.of(context).size.width *0.4,
                height: 5,

              ),
              Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          ),
        ),*/
      );
    },
  );

  Widget BuildCommentItems(CommentsModel model,context,index)=>Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        backgroundImage: NetworkImage(
            '${model.image}'),
        radius: 17,
      ),
      SizedBox(
        width: 12,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('${model.name}',
                    style: Theme.of(context).textTheme.caption,
                ),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.check_circle,
                  color: DefaultColor,
                  size: 16,
                ),
              ],
            ),
            Text(
              '${model.commentText}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              '${model.dateTime}',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    ],
  );

  Widget BuildPosts(PostsModel model,context,index)=>Card(
    margin: EdgeInsets.symmetric(horizontal: 6),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 10,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    '${model.image}'),
                radius: 25,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${model.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                height: 1.4)),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: DefaultColor,
                          size: 16,
                        ),
                      ],
                    ),
                    Text(
                      '${model.dateTime}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                  size: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade300,
            height: 1,
          ),
          SizedBox(
            height: 5,
          ),
          ReadMoreText(
            '${model.postText}',
            trimLines: 3,
            colorClickableText: DefaultColor,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'Show more',
            trimExpandedText: 'Show less',
            moreStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),
            lessStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: DefaultColor),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: 4,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: double.infinity,
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 5),
                    child: Container(
                      height: 21,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 1,
                        padding: EdgeInsets.zero,
                        child: Text(
                          '#Flutter_app',
                          style: TextStyle(
                              color: DefaultColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(model.postImage !='')
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                  image: NetworkImage(
                    '${model.postImage}'
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 21,
                        ),
                        Text('${SocialCubit.get(context).likes[index]}',
                          style: Theme.of(context).textTheme.caption,),
                      ],
                    ),
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          IconBroken.Chat,
                          color: Colors.amber,
                          size: 21,
                        ),
                        Text('${SocialCubit.get(context).commentNumber[index]} Comments',
                          style: Theme.of(context).textTheme.caption,),
                      ],
                    ),
                    onTap: (){},
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade300,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            '${SocialCubit.get(context).userModel!.image}'
                          ),
                          radius: 15,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Write a Comment ...',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    onTap: (){
                      showMaterialModalBottomSheet(
                      context: context,
                      builder: (context)=>BuildComments(context,index),
                      );
                      SocialCubit.get(context).getComments(model:model);
                      },
                  ),
                ),
                InkWell(
                  child: Row(
                    children: [
                      Icon(
                        IconBroken.Heart,
                        color: Colors.red,
                        size: 21,
                      ),
                      SizedBox(
                        width: 3,),
                      Text('Like',
                        style: Theme.of(context).textTheme.caption,),
                    ],
                  ),
                  onTap: (){
                      SocialCubit.get(context).LikePosts(SocialCubit.get(context).postsId[index]);
                     },
                ),
                SizedBox(
                  width: 10,),
                InkWell(
                  child: Row(
                    children: [
                      Icon(
                        IconBroken.Arrow___Up_Square,
                        color: DefaultColor,
                        size: 21,
                      ),
                      SizedBox(
                        width: 3,),
                      Text('Share',
                        style: Theme.of(context).textTheme.caption,),
                    ],
                  ),
                  onTap: (){},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
