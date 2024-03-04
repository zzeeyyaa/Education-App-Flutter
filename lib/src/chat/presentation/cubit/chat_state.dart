part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {
  const ChatInitial();
}

//*send-message
class SendingMessage extends ChatState {
  const SendingMessage();
}

class MessageSent extends ChatState {
  const MessageSent();
}

//*get-groups
class LoadingGroups extends ChatState {
  const LoadingGroups();
}

class GroupsLoaded extends ChatState {
  const GroupsLoaded(this.groups);

  final List<Group> groups;

  @override
  List<Object> get props => [groups];
}

//*get-messages
class LoadingMessages extends ChatState {
  const LoadingMessages();
}

class MessagesLoaded extends ChatState {
  const MessagesLoaded(this.messages);

  final List<Message> messages;

  @override
  List<Object> get props => [messages];
}

//*join-group
class JoiningGroup extends ChatState {
  const JoiningGroup();
}

class JoinedGroup extends ChatState {
  const JoinedGroup();
}

//*leave-group
class LeavingGroup extends ChatState {
  const LeavingGroup();
}

class LeftGroup extends ChatState {
  const LeftGroup();
}

//*get-user-by-id
class GettingUser extends ChatState {
  const GettingUser();
}

class UserFound extends ChatState {
  const UserFound(this.user);

  final LocalUser user;

  @override
  List<Object> get props => [user];
}

//*error
class ChatError extends ChatState {
  const ChatError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
