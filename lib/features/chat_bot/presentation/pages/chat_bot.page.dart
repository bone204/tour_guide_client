import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_result_item.dart';
import 'package:tour_guide_app/features/chat_bot/presentation/bloc/chat_cubit.dart';
import 'package:tour_guide_app/features/chat_bot/presentation/bloc/chat_state.dart';
import 'package:tour_guide_app/features/destination/presentation/pages/destination_detail.page.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  static Widget withProvider() {
    return BlocProvider(create: (_) => ChatCubit(), child: const ChatBotPage());
  }

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage>
    with TickerProviderStateMixin {
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

    if (text.isEmpty && cubit.state.selectedImages.isEmpty) return;

    final lang = Localizations.localeOf(context).languageCode;

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
    return GestureDetector(
      onTap: () => _focusNode.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.travelAssistant,
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

                    final itemCount =
                        messages.length + (state.isTyping ? 1 : 0);

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SelectedImagesList(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: isBusy
                    ? null
                    : () => context.read<ChatCubit>().pickImages(),
                icon: Icon(
                  Icons.image_outlined,
                  color: AppColors.primaryBlue,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 8.w),
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
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(
                        context,
                      )!.searchDestinationHint,
                      hintStyle: Theme.of(context).textTheme.displayLarge
                          ?.copyWith(color: AppColors.textSubtitle),
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
        ],
      ),
    );
  }
}

class _SelectedImagesList extends StatelessWidget {
  const _SelectedImagesList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state.selectedImages.isEmpty) return const SizedBox.shrink();

        return Container(
          height: 80.h,
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: state.selectedImages.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final path = state.selectedImages[index];
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(
                      File(path),
                      width: 80.w,
                      height: 80.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4.w,
                    right: 4.w,
                    child: GestureDetector(
                      onTap: () => context.read<ChatCubit>().removeImage(path),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  const _ChatMessageBubble({required this.message});

  final ChatUiMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isUser ? 0 : 0, vertical: 4.h),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[const _BotAvatar(), SizedBox(width: 8.w)],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (message.images.isNotEmpty) _buildImages(context, isUser),
                if (message.content.trim().isNotEmpty &&
                    (isUser || !message.hasSuggestions))
                  _buildMessageContent(context, isUser),
                if (message.hasSuggestions) ...[
                  if (message.images.isNotEmpty ||
                      (isUser && message.content.trim().isNotEmpty))
                    SizedBox(height: 12.h),
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
          ),
          if (isUser) ...[SizedBox(width: 8.w), const _UserAvatar()],
        ],
      ),
    );
  }

  Widget _buildImages(BuildContext context, bool isUser) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        alignment: isUser ? WrapAlignment.end : WrapAlignment.start,
        children: message.images.map((path) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: path.startsWith('http')
                ? Image.network(
                    path,
                    width: 150.w,
                    height: 150.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 150.w,
                      height: 150.h,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  )
                : Image.file(
                    File(path),
                    width: 150.w,
                    height: 150.h,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 150.w,
                      height: 150.h,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context, bool isUser) {
    final backgroundColor = message.isError
        ? AppColors.primaryRed.withOpacity(0.12)
        : isUser
        ? Colors
              .transparent // Gradient will be used instead
        : AppColors.primaryWhite;

    final textColor = message.isError
        ? AppColors.primaryRed
        : isUser
        ? AppColors.primaryWhite
        : AppColors.textPrimary;

    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isUser ? 20.r : 4.r),
      topRight: Radius.circular(isUser ? 4.r : 20.r),
      bottomLeft: Radius.circular(20.r),
      bottomRight: Radius.circular(20.r),
    );

    return Container(
      constraints: BoxConstraints(maxWidth: 0.76.sw),
      decoration: BoxDecoration(
        color: !isUser || message.isError ? backgroundColor : null,
        gradient: isUser && !message.isError
            ? const LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryLightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: isUser && !message.isError
                ? AppColors.primaryBlue.withOpacity(0.25)
                : AppColors.primaryBlack.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: !isUser && !message.isError
            ? Border.all(
                color: AppColors.secondaryGrey.withOpacity(0.1),
                width: 1,
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      child: _FormattedMessageText(
        content: message.content,
        textColor: textColor,
        context: context,
        isUser: isUser,
      ),
    );
  }
}

class _BotAvatar extends StatelessWidget {
  const _BotAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.primaryLightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.smart_toy_rounded,
        color: AppColors.primaryWhite,
        size: 18.sp,
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: AppColors.secondaryGrey.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_rounded,
        color: AppColors.textSubtitle,
        size: 18.sp,
      ),
    );
  }
}

class _ChatSuggestionCard extends StatelessWidget {
  const _ChatSuggestionCard({required this.item});

  final ChatResultItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.8.sw,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.secondaryGrey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: item.id != null
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DestinationDetailPage.withProvider(
                      destinationId: item.id!,
                    ),
                  ),
                )
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.images?.isNotEmpty == true)
                _buildCardImage()
              else
                _buildPlaceholderImage(),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTagsRow(context),
                    SizedBox(height: 10.h),
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.rating != null) ...[
                      SizedBox(height: 6.h),
                      _buildRatingRow(context),
                    ],
                    if (item.address != null && item.address!.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      _buildAddressRow(context),
                    ],
                    if (item.description != null &&
                        item.description!.isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      Text(
                        item.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary.withOpacity(0.65),
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardImage() {
    return SizedBox(
      height: 140.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            item.images!.first,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.2), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 120.h,
      width: double.infinity,
      color: AppColors.secondaryGrey.withOpacity(0.1),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textSubtitle,
        size: 32.sp,
      ),
    );
  }

  Widget _buildTagsRow(BuildContext context) {
    final List<String> tags = [];
    if (item.type != 'destination') {
      tags.add(item.type.toUpperCase());
    }
    if (item.categories != null) {
      tags.addAll(item.categories!.take(2));
    }

    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: tags.map((tag) => _buildTagChip(context, tag)).toList(),
    );
  }

  Widget _buildTagChip(BuildContext context, String label) {
    final isPrimary = label == item.type.toUpperCase();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primaryBlue.withOpacity(0.1)
            : AppColors.secondaryGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isPrimary ? AppColors.primaryBlue : AppColors.textSubtitle,
          fontWeight: FontWeight.w900,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildRatingRow(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
        SizedBox(width: 4.w),
        Text(
          item.rating!.toStringAsFixed(1),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on_rounded,
          size: 14.sp,
          color: AppColors.primaryBlue,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            item.address!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSubtitle,
              fontSize: 12.sp,
              height: 1.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ChatTypingIndicator extends StatelessWidget {
  const _ChatTypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const _BotAvatar(),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
                bottomRight: Radius.circular(18.r),
                bottomLeft: Radius.circular(4.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlack.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(),
                SizedBox(width: 4.w),
                _TypingDot(delay: Duration(milliseconds: 150)),
                SizedBox(width: 4.w),
                _TypingDot(delay: Duration(milliseconds: 300)),
              ],
            ),
          ),
        ],
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
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

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
        width: 6.w,
        height: 6.w,
        decoration: BoxDecoration(
          color: AppColors.textSubtitle,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40.h),
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryBlue, AppColors.primaryLightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.smart_toy_rounded,
            color: AppColors.primaryWhite,
            size: 40.sp,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Xin chào! 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Tôi là trợ lý du lịch AI của Traveline',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textSubtitle,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 40.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Gợi ý cho bạn',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 16.h),
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.secondaryGrey.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlack.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textSubtitle.withOpacity(0.5),
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
    required this.isUser,
  });

  final String content;
  final Color textColor;
  final BuildContext context;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return Text(
        content,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          color: textColor,
          height: 1.55,
          fontSize: 15.5.sp,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    final lines = _parseContent(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.asMap().entries.map((entry) {
        final index = entry.key;
        final line = entry.value;
        final isLast = index == lines.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 6.h),
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
      if (trimmed.isEmpty) {
        // Add empty line for spacing
        if (lines.isNotEmpty && lines.last.type != _LineType.empty) {
          lines.add(const _MessageLine(content: '', type: _LineType.empty));
        }
        continue;
      }

      // Check for bullet points
      if (trimmed.startsWith('* ') ||
          trimmed.startsWith('- ') ||
          trimmed.startsWith('• ')) {
        final content = trimmed.substring(1).trim();
        if (content.isNotEmpty) {
          lines.add(_MessageLine(content: content, type: _LineType.bullet));
        }
      }
      // Check for numbered list (simple check for 1. 2. etc)
      else if (RegExp(r'^\d+\.\s').hasMatch(trimmed)) {
        lines.add(_MessageLine(content: trimmed, type: _LineType.numbered));
      }
      // Normal text
      else {
        lines.add(_MessageLine(content: trimmed, type: _LineType.normal));
      }
    }
    return lines;
  }

  Widget _buildLine(_MessageLine line) {
    if (line.type == _LineType.empty) {
      return SizedBox(height: 8.h);
    }

    if (line.type == _LineType.bullet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h, right: 10.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(child: _buildRichText(line.content)),
        ],
      );
    }

    if (line.type == _LineType.numbered) {
      // Split number and content
      final match = RegExp(r'^(\d+\.)\s+(.*)').firstMatch(line.content);
      if (match != null) {
        final number = match.group(1) ?? '';
        final content = match.group(2) ?? '';
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.primaryBlue,
                height: 1.6,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(child: _buildRichText(content)),
          ],
        );
      }
    }

    return _buildRichText(line.content);
  }

  Widget _buildRichText(String text) {
    final spans = _parseInlineFormatting(text);
    // Base style for bot text
    final baseStyle = Theme.of(context).textTheme.displayLarge?.copyWith(
      color: AppColors.textPrimary,
      height: 1.6,
      fontSize: 15.5.sp,
      letterSpacing: 0.1,
    );

    return RichText(
      text: TextSpan(children: spans, style: baseStyle),
    );
  }

  List<TextSpan> _parseInlineFormatting(String text) {
    final spans = <TextSpan>[];
    // Pattern to match **bold** text
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastMatchEnd = 0;

    final normalStyle = Theme.of(context).textTheme.displayLarge?.copyWith(
      color: AppColors.textPrimary,
      height: 1.6,
      fontSize: 15.sp,
    );

    final boldStyle = Theme.of(context).textTheme.displayLarge?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w700,
      height: 1.6,
      fontSize: 15.sp,
    );

    for (final match in regex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: normalStyle,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(1),
          style: boldStyle, // Apply bold style
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(text: text.substring(lastMatchEnd), style: normalStyle),
      );
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: text, style: normalStyle));
    }

    return spans;
  }
}

enum _LineType { normal, bullet, numbered, empty }

class _MessageLine {
  final String content;
  final _LineType type;

  const _MessageLine({required this.content, required this.type});
}
