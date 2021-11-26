import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/compoments/compoments.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/state.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfilScreen extends StatelessWidget {

  var UsernameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var usermodel = SocialCubit.get(context).userModel;
        var profilImage = SocialCubit.get(context).ProfilImage;
        var coverImage = SocialCubit.get(context).coverImage;
        UsernameController.text = usermodel!.name!;
        bioController.text = usermodel.bio!;
        phoneController.text = usermodel.phone!;
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit Profil'),
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
                  if (profilImage == null && coverImage == null) {
                    SocialCubit.get(context).UpdateUserData(
                      name: UsernameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  } else if (profilImage != null) {
                    SocialCubit.get(context).UploadProfilImage(
                      name: UsernameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  } else if (coverImage != null) {
                    SocialCubit.get(context).UploadCoverImage(
                      name: UsernameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  }
                },
                text: 'Update',
              ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is SocialUpdateUserLoadingState)
                    LinearProgressIndicator(),
                  if (state is SocialUpdateUserLoadingState)
                    SizedBox(
                      height: 10,
                    ),
                  Container(
                    height: 170,
                    child: Stack(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                image: DecorationImage(
                                  image: coverImage == null
                                      ? NetworkImage('${usermodel.cover}')
                                      : FileImage(coverImage) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              child: IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getcoverImage();
                                },
                                icon: Icon(IconBroken.Camera),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                child: CircleAvatar(
                                  radius: 49,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    backgroundImage: profilImage != null
                                        ? FileImage(profilImage)
                                            as ImageProvider
                                        : NetworkImage('${usermodel.image}'),
                                    radius: 45,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.withOpacity(0.7),
                                child: IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getImage();
                                  },
                                  icon: Icon(
                                    IconBroken.Camera,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*if (SocialCubit.get(context).ProfilImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).ProfilImage != null)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                SocialCubit.get(context).UploadProfilImage(
                                  name: UsernameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                              child: Text(
                                'Upload Profil',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        SizedBox(
                          width: 6,
                        ),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                SocialCubit.get(context).UploadCoverImage(
                                  name: UsernameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                              child: Text(
                                'Upload Cover',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                      ],
                    ),*/
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: UsernameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'name must be not empty';
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 0.8),
                      ),
                      labelText: 'User Name',
                      prefixIcon: Icon(IconBroken.User),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: bioController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'bio must be not empty';
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 0.8),
                      ),
                      labelText: 'Bio ...',
                      prefixIcon: Icon(IconBroken.Info_Square),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'phone must be not empty';
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 0.8),
                      ),
                      labelText: 'Phone Number',
                      prefixIcon: Icon(IconBroken.Call),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
