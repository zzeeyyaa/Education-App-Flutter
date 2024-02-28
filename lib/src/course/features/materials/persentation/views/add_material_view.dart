import 'package:education_app/core/common/widgets/course_picker.dart';
import 'package:education_app/core/common/widgets/info_field.dart';
import 'package:education_app/core/enums/notification_enum.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/extensions/int_extension.dart';
import 'package:education_app/core/res/my_colors.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/features/materials/data/models/resource_model.dart';
import 'package:education_app/src/course/features/materials/domain/entities/picked_resource.dart';
import 'package:education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:education_app/src/course/features/materials/persentation/cubit/material_cubit.dart';
import 'package:education_app/src/course/features/materials/persentation/widgets/edit_resource_dialog.dart';
import 'package:education_app/src/course/features/materials/persentation/widgets/picked_resource_tile.dart';
import 'package:education_app/src/notifications/presentation/widgets/notification_wrapper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';

class AddMaterialView extends StatefulWidget {
  const AddMaterialView({super.key});

  static const routeName = '/add-materials';

  @override
  State<AddMaterialView> createState() => _AddMaterialViewState();
}

class _AddMaterialViewState extends State<AddMaterialView> {
  List<PickedResource> resources = <PickedResource>[];

  final formKey = GlobalKey<FormState>();
  final courseController = TextEditingController();
  final courseNotifier = ValueNotifier<Course?>(null);
  final authorController = TextEditingController();

  bool authorSet = false;

  Future<void> pickResources() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        resources.addAll(
          result.paths.map(
            (path) => PickedResource(
              path: path!,
              title: path.split('/').last,
              author: authorController.text.trim(),
            ),
          ),
        );
      });
    }
  }

  Future<void> editResource(int resourceIndex) async {
    final resource = resources[resourceIndex];
    final newResource = await showDialog<PickedResource>(
      context: context,
      builder: (_) => EditResourceDialog(resource),
    );
    if (newResource != null) {
      setState(() {
        resources[resourceIndex] = newResource;
      });
    }
  }

  void uploadMaterials() {
    if (formKey.currentState!.validate()) {
      if (this.resources.isEmpty) {
        return CoreUtils.showSnackBar(
          context,
          'No resources picked yet.',
        );
      }
      if (!authorSet && authorController.text.trim().isNotEmpty) {
        return CoreUtils.showSnackBar(
          context,
          'Please tap on the check icon in '
          'the author field to confirm the author',
        );
      }

      final resources = <Resource>[];
      for (final resource in this.resources) {
        resources.add(
          ResourceModel.empty().copyWith(
            courseId: courseNotifier.value!.id,
            fileURL: resource.path,
            title: resource.title,
            description: resource.description,
            author: resource.author,
            fileExtension: resource.path.split('.').last,
          ),
        );
      }
      context.read<MaterialCubit>().addMaterial(resources);
    }
  }

  bool showingLoader = false;
  void setAuthor() {
    if (authorSet) {
      return;
    }
    final text = authorController.text.trim();
    FocusManager.instance.primaryFocus?.unfocus();

    final newResources = <PickedResource>[];
    for (final resource in resources) {
      if (resource.authorManuallySet) {
        newResources.add(resource);
        continue;
      }
      newResources.add(resource.copyWith(author: text));
    }
    setState(() {
      resources = newResources;
      authorSet = true;
    });
  }

  @override
  void dispose() {
    courseController.dispose();
    courseNotifier.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationWrapper(
      onNotificationSent: () {
        Navigator.pop(context);
      },
      child: BlocListener<MaterialCubit, MaterialState>(
        listener: (context, state) {
          if (showingLoader) {
            Navigator.pop(context);
            showingLoader = false;
          }
          if (state is MaterialError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is MaterialAdded) {
            CoreUtils.showSnackBar(
              context,
              'Material(s) uploaded successfully',
            );
            CoreUtils.sendNotification(
              context,
              title: 'New ${courseNotifier.value!.title}'
                  ' Material${resources.length.pluralize}',
              body: 'A new material has been uploaded'
                  ' for ${courseNotifier.value!.title}',
              category: NotificationCategory.MATERIAL,
            );
          } else if (state is AddingMaterial) {
            CoreUtils.showLoadingDialog(context);
            showingLoader = true;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Add Materials'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: CoursePicker(
                        controller: courseController,
                        notifier: courseNotifier,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InfoField(
                      controller: authorController,
                      border: true,
                      hintText: 'General Author',
                      onChanged: (_) {
                        if (authorSet) {
                          setState(() {
                            authorSet = false;
                          });
                        }
                      },
                      suffixIcon: IconButton(
                        onPressed: setAuthor,
                        icon: Icon(
                          authorSet
                              ? Icons.check_circle
                              : Icons.check_circle_outline,
                          color: authorSet ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You can upload multiple materials at once.',
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: MyColors.neutralTextColour,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (resources.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: resources.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, index) {
                            final resource = resources[index];
                            return PickedResourceTile(
                              resource,
                              onEdit: () => editResource(index),
                              onDelete: () {
                                setState(() {
                                  resources.removeAt(index);
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: pickResources,
                          child: const Text('Add Materials'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: uploadMaterials,
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
