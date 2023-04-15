import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;

  CreatePostCubit({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
    required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  Future<File> compressImage(File imageFile, {int quality = 45}) async {
    final filePath = imageFile.absolute.path;
    final lastIndex = filePath.lastIndexOf(Platform.pathSeparator);
    final newPath = filePath.substring(0, lastIndex);
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '$newPath/compressed.jpg',
      quality: quality,
    );
    return compressedImage!;
  }

  Future<File> createThumbnail(File thumbnailFile, {int quality = 10}) async {
    final filePath = thumbnailFile.absolute.path;
    final lastIndex = filePath.lastIndexOf(Platform.pathSeparator);
    final newPath = filePath.substring(0, lastIndex);
    final thumbnailImageBytes = await FlutterImageCompress.compressAndGetFile(
      thumbnailFile.absolute.path,
      '$newPath/thumbnailcompressed.jpg',
      quality: quality,
      
    );
    return thumbnailImageBytes!;
  }

  void postImageChanged(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user!.uid);

      // Compress and upload the original image
      final compressedImage = await compressImage(state.postImage!);
      final postImageUrl =
          await _storageRepository.uploadPostImage(image: compressedImage);

      // Compress and create the thumbnail image
      final thumbnailImage = await createThumbnail(state.postImage!);

      // Read the thumbnail image as bytes
      final thumbnailImageBytes = await thumbnailImage.readAsBytes();

      // Create and upload the thumbnail
      final thumbnailImageUrl = await _storageRepository.uploadThumbnailImage(
          thumbnailImageBytes: thumbnailImageBytes);

      final post = Post(
        author: author,
        imageUrl: postImageUrl,
        thumbnailUrl: thumbnailImageUrl,
        caption: state.caption,
        likes: 0,
        date: DateTime.now(),
      );

      await _postRepository.createPost(post: post);

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          failure:
              const Failure(message: 'We were unable to create your post.'),
        ),
      );
    }
  }

  void reset() {
    emit(CreatePostState.initial());
  }
}
