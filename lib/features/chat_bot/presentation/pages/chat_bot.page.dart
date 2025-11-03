import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_result_item.dart';
import 'package:tour_guide_app/features/chat_bot/presentation/bloc/chat_cubit.dart';
import 'package:tour_guide_app/features/chat_bot/presentation/bloc/chat_state.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  static Widget withProvider() {
    return BlocProvider(create: (_) => ChatCubit(), child: const ChatBotPage());
  }

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final cubit = context.read<ChatCubit>();
    if (cubit.state.isTyping) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode == 'en' ? 'en' : 'vi';

    cubit.sendMessage(text, lang: lang);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ lý du lịch'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.primaryWhite,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  _scrollToBottom();
                },
                builder: (context, state) {
                  final messages = state.messages;
                  if (messages.isEmpty) {
                    return ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      children: [
                        _ChatWelcomeSection(
                          onQuickSend: (value) {
                            _controller.text = value;
                            _handleSend();
                          },
                        ),
                      ],
                    );
                  }

                  final itemCount = messages.length + (state.isTyping ? 1 : 0);

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    itemCount: itemCount,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index >= messages.length) {
                        return const _ChatTypingIndicator();
                      }

                      final message = messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ChatMessageBubble(message: message),
                      );
                    },
                  );
                },
              ),
            ),
            _ChatComposer(
              controller: _controller,
              onSend: _handleSend,
              isBusy: context.watch<ChatCubit>().state.isTyping,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({
    required this.controller,
    required this.onSend,
    required this.isBusy,
    required this.theme,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isBusy;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: AppColors.secondaryGrey.withOpacity(0.4)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Hỏi tôi về điểm du lịch, nhà hàng, khách sạn...',
                filled: true,
                fillColor: AppColors.primaryWhite,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: AppColors.secondaryGrey.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: isBusy
                ? AppColors.secondaryGrey
                : AppColors.primaryBlue,
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: AppColors.primaryWhite,
              ),
              onPressed: isBusy ? null : onSend,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  const _ChatMessageBubble({required this.message});

  final ChatUiMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final backgroundColor = message.isError
        ? AppColors.primaryRed.withOpacity(0.1)
        : isUser
        ? AppColors.primaryBlue
        : AppColors.primaryWhite;
    final textColor = message.isError
        ? AppColors.primaryRed
        : isUser
        ? AppColors.primaryWhite
        : AppColors.primaryBlack;
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isUser ? 20 : 4),
      bottomRight: Radius.circular(isUser ? 4 : 20),
    );

    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (message.content.trim().isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
                boxShadow: isUser
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                message.content,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: textColor, height: 1.4),
              ),
            ),
          if (message.hasSuggestions) ...[
            if (message.content.trim().isNotEmpty) const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: message.suggestions
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ChatSuggestionCard(item: item),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChatSuggestionCard extends StatelessWidget {
  const _ChatSuggestionCard({required this.item});

  final ChatResultItem item;

  Color _chipColor() {
    switch (item.type) {
      case 'restaurant':
        return AppColors.primaryOrange.withOpacity(0.14);
      case 'hotel':
        return AppColors.primaryPurple.withOpacity(0.14);
      default:
        return AppColors.primaryBlue.withOpacity(0.14);
    }
  }

  Color _chipTextColor() {
    switch (item.type) {
      case 'restaurant':
        return AppColors.primaryOrange;
      case 'hotel':
        return AppColors.primaryPurple;
      default:
        return AppColors.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _chipColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.type.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _chipTextColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if ((item.address ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppColors.primaryGrey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.address!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primaryGrey,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if ((item.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              item.description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primaryBlack.withOpacity(0.7),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChatTypingIndicator extends StatelessWidget {
  const _ChatTypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _TypingDot(),
            SizedBox(width: 4),
            _TypingDot(delay: Duration(milliseconds: 150)),
            SizedBox(width: 4),
            _TypingDot(delay: Duration(milliseconds: 300)),
          ],
        ),
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  const _TypingDot({this.delay = Duration.zero});

  final Duration delay;

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.delay.inMilliseconds / 800,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
      child: const CircleAvatar(
        radius: 4,
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }
}

class _ChatWelcomeSection extends StatelessWidget {
  const _ChatWelcomeSection({required this.onQuickSend});

  final ValueChanged<String> onQuickSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xin chào! Tôi là trợ lý du lịch Traveline.',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Bạn có thể hỏi tôi về điểm đến, nhà hàng, khách sạn và nhiều hơn nữa.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.primaryBlack.withOpacity(0.7),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _QuickSuggestionChip(
              label: 'Gợi ý điểm du lịch nổi bật tại Đà Nẵng',
              onTap: () =>
                  onQuickSend('Gợi ý điểm du lịch nổi bật tại Đà Nẵng'),
            ),
            _QuickSuggestionChip(
              label: 'Tìm nhà hàng hải sản ngon ở Nha Trang',
              onTap: () => onQuickSend('Tìm nhà hàng hải sản ngon ở Nha Trang'),
            ),
            _QuickSuggestionChip(
              label: 'Khách sạn 4 sao tại Hà Nội',
              onTap: () => onQuickSend('Khách sạn 4 sao tại Hà Nội'),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickSuggestionChip extends StatelessWidget {
  const _QuickSuggestionChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.primaryBlue),
        ),
      ),
    );
  }
}
