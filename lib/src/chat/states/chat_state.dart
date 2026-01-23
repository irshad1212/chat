import 'package:chat/src/chat/models/chat_message.dart';
import 'package:chat/utils/helpers/loader_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<ChatMessage> messages,
    @Default(LoaderState.initial()) LoaderState<void> sendStatus,
  }) = _ChatState;

  factory ChatState.initial() => const ChatState();
}
