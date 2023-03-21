import 'dart:io';

import 'package:app_6/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../helpers/helpers.dart';
import '../../widgets/widgets.dart';
import 'cubit/create_post_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  static const String routeName = '/createPost';

  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late File _image;

  final imageHelper = ImageHelperPost();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: mobileBackgroundColor,
          iconTheme: const IconThemeData(
            color: black,
          ),
          elevation: 3,
          title: const Text(
            'Create Post',
            style: TextStyle(color: black),
          ),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.success) {
              _formKey.currentState!.reset();
              context.read<CreatePostCubit>().reset();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                  content: Text('Post Created'),
                ),
              );
            } else if (state.status == CreatePostStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final file = await imageHelper.pickImage();
                      if (file != null) {
                        final croppedFile = await imageHelper.crop(
                          file: file,
                          cropStyle: CropStyle.rectangle,
                        );
                        if (croppedFile != null) {
                          setState(() {
                            _image = File(croppedFile.path);
                            context
                                .read<CreatePostCubit>()
                                .postImageChanged(_image);
                          });
                        }
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.3,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: state.postImage != null
                          ? Image.file(state.postImage!, fit: BoxFit.cover)
                          : const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 120.0,
                            ),
                    ),
                  ),
                  if (state.status == CreatePostStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(hintText: 'Caption'),
                            onChanged: (value) => context
                                .read<CreatePostCubit>()
                                .captionChanged(value),
                            validator: (value) => value!.trim().isEmpty
                                ? 'La description ne peut pas être vide'
                                : null,
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              textStyle: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () => _submitForm(
                              context,
                              state.postImage!,
                              state.status == CreatePostStatus.submitting,
                            ),
                            child: const Text('Post'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: grey,
                              textStyle: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () => _submitReset(
                              context,
                            ),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // void _selectPostImage(BuildContext context) async {
  //   final pickedFile = await ImageHelper.pickImageFromGallery(
  //     context: context,
  //     cropStyle: CropStyle.rectangle,
  //     title: 'Create Post',
  //   );
  //   if (pickedFile != null) {
  //     context.read<CreatePostCubit>().postImageChanged(pickedFile);
  //   }
  // }

  void _submitForm(BuildContext context, File? postImage, bool isSubmitting) {
    if (_formKey.currentState!.validate() &&
        postImage != null &&
        !isSubmitting) {
      context.read<CreatePostCubit>().submit();
    }
  }

  void _submitReset(BuildContext context) {
    _formKey.currentState!.reset();
    context.read<CreatePostCubit>().reset();
  }
}
