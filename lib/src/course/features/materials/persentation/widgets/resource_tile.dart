import 'package:education_app/core/res/my_colors.dart';
import 'package:education_app/src/course/features/materials/persentation/providers/resource_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourceTile extends StatelessWidget {
  const ResourceTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResourceController>(
      builder: (_, controller, __) {
        final resource = controller.resource!;
        final authorIsNull =
            resource.author == null || resource.author!.isEmpty;
        final descriptionIsNull =
            resource.description == null || resource.description!.isEmpty;

        final downloadButton = controller.downloading
            ? CircularProgressIndicator(
                value: controller.percentage,
                color: MyColors.primaryColour,
              )
            : IconButton.filled(
                onPressed: controller.fileExists
                    ? controller.openFile
                    : controller.downloadAndSaveFile,
                icon: Icon(
                  controller.fileExists
                      ? Icons.download_done_rounded
                      : Icons.download_rounded,
                ),
              );
        return ExpansionTile(
          tilePadding: EdgeInsets.zero,
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
          title: Text(
            resource.title!,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (authorIsNull && descriptionIsNull) downloadButton,
                if (!authorIsNull)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Author',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(resource.author!),
                    ],
                  ),
                if (!descriptionIsNull)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!authorIsNull) const SizedBox(height: 10),
                            const Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(resource.description!),
                          ],
                        ),
                      ),
                      if (authorIsNull) downloadButton,
                    ],
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
