import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fundo_flutter/features/support_chat/application/support_chat_providers.dart';
import 'package:fundo_flutter/features/support_chat/application/support_chat_service.dart';
import 'package:fundo_flutter/features/support_chat/domain/support_chat_message.dart';
import 'package:fundo_flutter/features/support_chat/presentation/support_chat_screen.dart';

class _FakeSupportChatService implements SupportChatService {
  _FakeSupportChatService(this._messagesStream);

  final Stream<List<SupportChatMessage>> _messagesStream;
  final List<String> sentMessages = [];
  bool throwOnSend = false;

  @override
  Stream<List<SupportChatMessage>> watchConversation({int limit = 50}) {
    return _messagesStream;
  }

  @override
  Future<void> sendUserMessage(String text) async {
    if (throwOnSend) {
      throw StateError('boom');
    }
    sentMessages.add(text);
  }
}

void main() {
  final sampleMessages = <SupportChatMessage>[
    SupportChatMessage(
      id: '1',
      text: 'Hello, how can we help?',
      sentAt: DateTime(2024, 7, 20, 10, 0),
      fromSupport: true,
    ),
    SupportChatMessage(
      id: '2',
      text: 'I need help with my report',
      sentAt: DateTime(2024, 7, 20, 10, 2),
      fromSupport: false,
    ),
  ];

  Widget buildTestApp(_FakeSupportChatService service) {
    return ProviderScope(
      overrides: [
        supportChatServiceProvider.overrideWithValue(service),
        supportChatMessagesProvider.overrideWith(
          (ref) => service.watchConversation(),
        ),
      ],
      child: const MaterialApp(home: SupportChatScreen()),
    );
  }

  testWidgets('renders chat history and sends new message', (tester) async {
    final service = _FakeSupportChatService(Stream.value(sampleMessages));
    await tester.pumpWidget(buildTestApp(service));
    await tester.pumpAndSettle();

    expect(find.text('Hello, how can we help?'), findsOneWidget);
    expect(find.text('I need help with my report'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'This is urgent');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    expect(service.sentMessages, ['This is urgent']);
  });

  testWidgets('shows error snackbar when sending fails', (tester) async {
    final service = _FakeSupportChatService(Stream.value(sampleMessages))
      ..throwOnSend = true;

    await tester.pumpWidget(buildTestApp(service));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Will this work?');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
  });
}
