import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItineraryActionMenu extends StatefulWidget {
  final VoidCallback onEdit;
  final VoidCallback? onEditInfo;
  final VoidCallback onDelete;
  final VoidCallback? onPublicize;
  final bool canPublicize;
  final bool canEdit;

  const ItineraryActionMenu({
    super.key,
    required this.onEdit,
    this.onEditInfo,
    required this.onDelete,
    this.onPublicize,
    this.canPublicize = false,
    this.canEdit = true,
  });

  @override
  State<ItineraryActionMenu> createState() => _ItineraryActionMenuState();
}

class _ItineraryActionMenuState extends State<ItineraryActionMenu>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _isOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      parent: _controller,
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(curve: Curves.easeInOut, parent: _controller));
  }

  void _toggleMenu() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isOpen) ...[
          if (widget.canEdit) ...[
            _buildMenuItem(
              onPressed: () {
                _toggleMenu();
                widget.onEditInfo?.call();
              },
              icon: Icons.edit_note_rounded,
              color: Theme.of(context).colorScheme.secondaryContainer,
              iconColor: Theme.of(context).colorScheme.secondary,
              heroTag: 'edit_info_fab',
            ),
            SizedBox(height: 12.h),
            _buildMenuItem(
              onPressed: () {
                _toggleMenu();
                widget.onEdit();
              },
              icon: Icons.edit_rounded,
              color: Theme.of(context).colorScheme.primaryContainer,
              iconColor: Theme.of(context).colorScheme.primary,
              heroTag: 'edit_fab',
            ),
            SizedBox(height: 12.h),
          ],
          _buildMenuItem(
            onPressed: () {
              _toggleMenu();
              widget.onDelete();
            },
            icon: Icons.delete_rounded,
            color: Theme.of(context).colorScheme.errorContainer,
            iconColor: Theme.of(context).colorScheme.error,
            heroTag: 'delete_fab',
          ),
          SizedBox(height: 12.h),
          if (widget.canPublicize && widget.onPublicize != null) ...[
            _buildMenuItem(
              onPressed: () {
                _toggleMenu();
                widget.onPublicize!();
              },
              icon: Icons.public,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              iconColor: Theme.of(context).colorScheme.tertiary,
              heroTag: 'publicize_fab',
            ),
            SizedBox(height: 12.h),
          ],
        ],
        FloatingActionButton(
          onPressed: _toggleMenu,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: RotationTransition(
            turns: _rotateAnimation,
            child: Icon(Icons.add, size: 28.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String heroTag,
  }) {
    return ScaleTransition(
      scale: _expandAnimation,
      child: FloatingActionButton.small(
        heroTag: heroTag,
        onPressed: onPressed,
        backgroundColor: color,
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}
