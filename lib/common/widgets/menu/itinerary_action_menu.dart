import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItineraryActionMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItineraryActionMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      type: ExpandableFabType.up,
      distance: 70.h,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.small,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
      ),
      children: [
        FloatingActionButton.small(
          heroTag: 'edit_fab',
          onPressed: onEdit,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.edit_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        FloatingActionButton.small(
          heroTag: 'delete_fab',
          onPressed: onDelete,
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          child: Icon(
            Icons.delete_rounded,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
