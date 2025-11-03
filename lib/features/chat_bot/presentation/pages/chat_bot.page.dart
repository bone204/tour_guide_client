import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
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

class _ChatBotPageState extends State<ChatBotPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final cubit = context.read<ChatCubit>();
    if (cubit.state.isTyping) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    // Mặc định dùng tiếng Việt
    const lang = 'vi';

    cubit.sendMessage(text, lang: lang);
    _controller.clear();
    _focusNode.unfocus();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Trợ lý du lịch Traveline',
        showBackButton: true,
        onBackPressed: () => Navigator.of(context).pop(),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 24.h,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 24.h,
                    ),
                    itemCount: itemCount,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index >= messages.length) {
                        return const _ChatTypingIndicator();
                      }

                      final message = messages[index];
                      return _buildMessageWithAnimation(message, index);
                    },
                  );
                },
              ),
            ),
            _ChatComposer(
              controller: _controller,
              focusNode: _focusNode,
              onSend: _handleSend,
              isBusy: context.watch<ChatCubit>().state.isTyping,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildMessageWithAnimation(ChatUiMessage message, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _ChatMessageBubble(message: message),
            ),
          ),
        );
      },
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.isBusy,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: AppColors.secondaryGrey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
                decoration: InputDecoration(
                  hintText: 'Hỏi về điểm đến, nhà hàng...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isBusy
                    ? [AppColors.secondaryGrey, AppColors.secondaryGrey]
                    : [AppColors.primaryBlue, AppColors.primaryLightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: isBusy
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isBusy ? null : onSend,
                borderRadius: BorderRadius.circular(24.r),
                child: Icon(
                  Icons.send_rounded,
                  color: AppColors.primaryWhite,
                  size: 20.sp,
                ),
              ),
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
    
    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (message.content.trim().isNotEmpty)
            _buildMessageContent(context, isUser),
          if (message.hasSuggestions) ...[
            if (message.content.trim().isNotEmpty) SizedBox(height: 12.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: message.suggestions
                  .map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
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

  Widget _buildMessageContent(BuildContext context, bool isUser) {
    final backgroundColor = message.isError
        ? AppColors.primaryRed.withOpacity(0.1)
        : isUser
            ? AppColors.primaryBlue
            : AppColors.primaryWhite;
    final textColor = message.isError
        ? AppColors.primaryRed
        : isUser
            ? AppColors.primaryWhite
            : AppColors.textPrimary;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(20.r),
      topRight: Radius.circular(20.r),
      bottomLeft: Radius.circular(isUser ? 20.r : 4.r),
      bottomRight: Radius.circular(isUser ? 4.r : 20.r),
    );

    return Container(
      constraints: BoxConstraints(maxWidth: 280.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: message.isError || isUser
            ? []
            : [
                BoxShadow(
                  color: AppColors.primaryBlack.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: _FormattedMessageText(
        content: message.content,
        textColor: textColor,
        context: context,
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
        return AppColors.primaryOrange.withOpacity(0.12);
      case 'hotel':
        return AppColors.primaryPurple.withOpacity(0.12);
      default:
        return AppColors.primaryBlue.withOpacity(0.12);
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

  IconData _getIconByType() {
    switch (item.type) {
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'hotel':
        return Icons.hotel_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.secondaryGrey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _chipColor(),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconByType(),
                      size: 14.sp,
                      color: _chipTextColor(),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      item.type.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _chipTextColor(),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            item.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if ((item.address ?? '').isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.sp,
                  color: AppColors.textSubtitle,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    item.address!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if ((item.description ?? '').isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              item.description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary.withOpacity(0.7),
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
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
        margin: EdgeInsets.only(top: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TypingDot(),
            SizedBox(width: 6.w),
            _TypingDot(delay: Duration(milliseconds: 150)),
            SizedBox(width: 6.w),
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
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _ChatWelcomeSection extends StatelessWidget {
  const _ChatWelcomeSection({required this.onQuickSend});

  final ValueChanged<String> onQuickSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryBlue,
                AppColors.primaryLightBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.smart_toy_rounded,
            color: AppColors.primaryWhite,
            size: 32.sp,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Xin chào! 👋',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Tôi là trợ lý du lịch AI của Traveline',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Bạn có thể hỏi tôi về điểm đến, nhà hàng, khách sạn và nhiều hơn nữa. Hãy thử các câu hỏi gợi ý bên dưới!',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSubtitle,
            height: 1.5,
          ),
        ),
        SizedBox(height: 28.h),
        Text(
          'Câu hỏi gợi ý',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        _buildQuickSuggestions(context),
      ],
    );
  }

  Widget _buildQuickSuggestions(BuildContext context) {
    final suggestions = [
      {
        'icon': Icons.place_rounded,
        'text': 'Gợi ý điểm du lịch nổi bật tại Đà Nẵng',
        'color': AppColors.primaryBlue,
      },
      {
        'icon': Icons.restaurant_rounded,
        'text': 'Tìm nhà hàng hải sản ngon ở Nha Trang',
        'color': AppColors.primaryOrange,
      },
      {
        'icon': Icons.hotel_rounded,
        'text': 'Khách sạn 4 sao tại Hà Nội',
        'color': AppColors.primaryPurple,
      },
    ];

    return Column(
      children: suggestions.map((suggestion) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _QuickSuggestionChip(
            icon: suggestion['icon'] as IconData,
            label: suggestion['text'] as String,
            color: suggestion['color'] as Color,
            onTap: () => onQuickSend(suggestion['text'] as String),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickSuggestionChip extends StatelessWidget {
  const _QuickSuggestionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 14.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget để format và hiển thị message text đẹp hơn
class _FormattedMessageText extends StatelessWidget {
  const _FormattedMessageText({
    required this.content,
    required this.textColor,
    required this.context,
  });

  final String content;
  final Color textColor;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    // Parse và format text
    final lines = _parseContent(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.asMap().entries.map((entry) {
        final index = entry.key;
        final line = entry.value;
        final isLast = index == lines.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
          child: _buildLine(line),
        );
      }).toList(),
    );
  }

  List<_MessageLine> _parseContent(String text) {
    final lines = <_MessageLine>[];
    final rawLines = text.split('\n');

    for (var rawLine in rawLines) {
      final trimmed = rawLine.trim();
      if (trimmed.isEmpty) continue;

      // Kiểm tra bullet point (*, -, •)
      if (trimmed.startsWith('*') || 
          trimmed.startsWith('-') || 
          trimmed.startsWith('•')) {
        final content = trimmed.substring(1).trim();
        if (content.isNotEmpty) {
          lines.add(_MessageLine(content: content, type: _LineType.bullet));
        }
      }
      // Normal text (có thể chứa inline bold **text**)
      else {
        lines.add(_MessageLine(content: trimmed, type: _LineType.normal));
      }
    }

    return lines;
  }

  Widget _buildLine(_MessageLine line) {
    if (line.type == _LineType.bullet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h, right: 8.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: _buildRichText(line.content),
          ),
        ],
      );
    }

    // Normal line
    return _buildRichText(line.content);
  }

  /// Build RichText với inline bold formatting
  Widget _buildRichText(String text) {
    final spans = _parseInlineFormatting(text);
    final baseStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: textColor,
      height: 1.5,
    );
    
    return RichText(
      text: TextSpan(
        children: spans,
        style: baseStyle,
      ),
    );
  }

  /// Parse inline bold (**text**) trong text
  List<TextSpan> _parseInlineFormatting(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastMatchEnd = 0;
    
    final normalStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: textColor,
    );
    
    final boldStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w700,
    );

    for (final match in regex.allMatches(text)) {
      // Add text trước bold
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: normalStyle,
          ),
        );
      }

      // Add bold text
      spans.add(
        TextSpan(
          text: match.group(1), // Text bên trong ** **
          style: boldStyle,
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add phần text còn lại sau match cuối cùng
    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: normalStyle,
        ),
      );
    }

    // Nếu không có bold nào, return toàn bộ text
    if (spans.isEmpty) {
      spans.add(
        TextSpan(
          text: text,
          style: normalStyle,
        ),
      );
    }

    return spans;
  }
}

enum _LineType { normal, bullet }

class _MessageLine {
  final String content;
  final _LineType type;

  const _MessageLine({
    required this.content,
    required this.type,
  });
}
