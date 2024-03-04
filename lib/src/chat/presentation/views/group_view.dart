import 'package:education_app/core/common/views/loading_view.dart';
import 'package:education_app/core/common/widgets/not_found_text.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';
import 'package:education_app/src/chat/presentation/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsView extends StatefulWidget {
  const GroupsView({super.key});

  @override
  State<GroupsView> createState() => _GroupsViewState();
}

class _GroupsViewState extends State<GroupsView> {
  List<Group> yourGroups = [];
  List<Group> otherGroups = [];

  bool showingDialog = false;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (_, state) {
          if (showingDialog) {
            Navigator.of(context).pop();
            showingDialog = false;
          }
          if (state is ChatError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is JoiningGroup) {
            showingDialog = true;
            CoreUtils.showLoadingDialog(context);
          } else if (state is JoinedGroup) {
            CoreUtils.showSnackBar(context, 'Joined group successfully');
          } else if (state is GroupsLoaded) {
            yourGroups = state.groups
                .where(
                  (group) => group.members.contains(context.currentUser!.uid),
                )
                .toList();
            otherGroups = state.groups
                .where(
                  (group) => !group.members.contains(context.currentUser!.uid),
                )
                .toList();
          }
        },
        builder: (context, state) {
          if (state is LoadingGroups) {
            return const LoadingView();
          } else if (state is GroupsLoaded && state.groups.isEmpty) {
            return const NotFoundText(
              'No groups found\nPlease contect admin or if you are admin'
              ' add courses',
            );
          }
          return Container();
        },
      ),
    );
  }
}
