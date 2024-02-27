import 'package:education_app/core/enums/notification_enum.dart';
import 'package:education_app/core/extensions/string_extension.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/features/videos/data/models/video_model.dart';
import 'package:education_app/src/course/features/videos/presentation/cubit/video_cubit.dart';
import 'package:education_app/src/course/features/videos/presentation/utils/video_utils.dart';
import 'package:education_app/src/notifications/presentation/widgets/notification_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

class AddVideoView extends StatefulWidget {
  const AddVideoView({super.key});

  static const routeName = '/add-video';

  @override
  State<AddVideoView> createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {
  final urlController = TextEditingController();
  final authorController = TextEditingController(text: 'kim-jia');
  final titleController = TextEditingController();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);

  final formKey = GlobalKey<FormState>();

  VideoModel? video;
  PreviewData? previewData;

  final authorFocusNode = FocusNode();
  final titleFocusNode = FocusNode();
  final urlFocusNode = FocusNode();

  bool getMoreDetails = false;

  bool get isYoutube => urlController.text.trim().isYoutubeVideo;

  bool thumbNailIsFile = false;
  bool loading = false;
  bool showingDialog = false;

  void reset() {
    setState(() {
      urlController.clear();
      authorController.text = 'kim-jia';
      titleController.clear();
      getMoreDetails = false;
      loading = false;
      video = null;
      previewData = null;
    });
  }

  @override
  void initState() {
    super.initState();
    urlController.addListener(() {
      if (urlController.text.trim().isEmpty) {
        return reset();
      }
    });
    authorController.addListener(() {
      video = video?.copyWith(tutor: authorController.text.trim());
    });
    titleController.addListener(() {
      video = video?.copyWith(title: titleController.text.trim());
    });
  }

  Future<void> fetchVideo() async {
    if (urlController.text.trim().isEmpty) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      getMoreDetails = false;
      loading = false;
      thumbNailIsFile = false;
      video = null;
      previewData = null;
    });
    setState(() {
      loading = true;
    });
    if (isYoutube) {
      video = await VideoUtils.getVideoFromYT(
        context,
        url: urlController.text.trim(),
      ) as VideoModel?;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    urlController.dispose();
    authorController.dispose();
    titleController.dispose();
    courseController.dispose();
    courseNotifier.dispose();
    urlFocusNode.dispose();
    titleFocusNode.dispose();
    authorFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.of(context).pop();
      },
      child: BlocListener<VideoCubit, VideoState>(
        listener: (context, state) {
          if (showingDialog == true) {
            Navigator.pop(context);
            showingDialog = false;
          }
          if (state is AddingVideo) {
            CoreUtils.showLoadingDialog(context);
            showingDialog = true;
          } else if (state is VideoError) {
            CoreUtils.showSnackBar(context, 'Video added successfully');
            CoreUtils.sendNotification(
              context,
              title: 'New ${courseNotifier.value!.title} video',
              body:
                  'A new video has been added for ${courseNotifier.value!.title}',
              category: NotificationCategory.NONE,
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Add Video'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              Form(child: Container()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
