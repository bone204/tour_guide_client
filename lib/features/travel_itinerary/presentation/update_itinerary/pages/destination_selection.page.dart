// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tour_guide_app/common_libs.dart';
// import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
// import 'package:tour_guide_app/features/destination/data/models/destination.dart';
// import 'package:tour_guide_app/features/destination/data/models/destination_query.dart';
// import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_cubit.dart';
// import 'package:tour_guide_app/features/home/presentation/bloc/get_destination_state.dart';

// class DestinationSelectionPage extends StatefulWidget {
//   final String province;

//   const DestinationSelectionPage({super.key, required this.province});

//   @override
//   State<DestinationSelectionPage> createState() =>
//       _DestinationSelectionPageState();
// }

// class _DestinationSelectionPageState extends State<DestinationSelectionPage> {
//   final List<Destination> _selectedDestinations = [];
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     context.read<GetDestinationCubit>().getDestinations(
//       query: DestinationQuery(offset: 0, limit: 200),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: CustomAppBar(
//         title: widget.province,
//         showBackButton: true,
//         onBackPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//       body: Column(
//         children: [
//           _buildHeader(),
//           _buildSearchBar(),
//           Expanded(child: _buildDestinationList()),
//         ],
//       ),
//       bottomNavigationBar:
//           _selectedDestinations.isNotEmpty ? _buildBottomBar() : null,
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: AppColors.primaryBlue,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryBlack.withOpacity(0.08),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             AppLocalizations.of(context)!.createItinerary,
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               color: AppColors.primaryWhite,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             AppLocalizations.of(context)!.selectPlace,
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//               color: AppColors.primaryWhite.withOpacity(0.9),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       color: AppColors.primaryWhite,
//       child: TextField(
//         onChanged: (value) => setState(() => _searchQuery = value),
//         style: Theme.of(
//           context,
//         ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
//         decoration: InputDecoration(
//           hintText: AppLocalizations.of(context)!.searchDestinationHint,
//           hintStyle: Theme.of(
//             context,
//           ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
//           prefixIcon: Icon(
//             Icons.search_rounded,
//             color: AppColors.textSubtitle,
//             size: 22.sp,
//           ),
//           filled: true,
//           fillColor: AppColors.backgroundColor,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 16.w,
//             vertical: 12.h,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(
//               color: AppColors.secondaryGrey.withOpacity(0.3),
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: BorderSide(
//               color: AppColors.secondaryGrey.withOpacity(0.3),
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12.r),
//             borderSide: const BorderSide(
//               color: AppColors.primaryBlue,
//               width: 2,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDestinationList() {
//     return BlocBuilder<GetDestinationCubit, GetDestinationState>(
//       builder: (context, state) {
//         if (state is GetDestinationLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (state is GetDestinationError) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.error_outline,
//                   size: 64.sp,
//                   color: AppColors.primaryRed,
//                 ),
//                 SizedBox(height: 16.h),
//                 Text(
//                   AppLocalizations.of(context)!.somethingWentWrong,
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
//                 ),
//               ],
//             ),
//           );
//         }

//         if (state is GetDestinationLoaded) {
//           // Filter by province and search query
//           final destinations =
//               state.destinations.where((d) {
//                 final matchesProvince =
//                     d.province?.contains(widget.province) ?? false;
//                 final matchesSearch =
//                     _searchQuery.isEmpty ||
//                     d.name.toLowerCase().contains(_searchQuery.toLowerCase());
//                 return matchesProvince && matchesSearch;
//               }).toList();

//           if (destinations.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.location_off_rounded,
//                     size: 64.sp,
//                     color: AppColors.textSubtitle,
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     AppLocalizations.of(context)!.searchDestinationHint,
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       color: AppColors.textSubtitle,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.separated(
//             padding: EdgeInsets.all(16.w),
//             itemCount: destinations.length,
//             separatorBuilder: (_, __) => SizedBox(height: 12.h),
//             itemBuilder: (context, index) {
//               final destination = destinations[index];
//               final isSelected = _selectedDestinations.any(
//                 (d) => d.id == destination.id,
//               );

//               return _DestinationCard(
//                 destination: destination,
//                 isSelected: isSelected,
//                 onTap: () {
//                   setState(() {
//                     if (isSelected) {
//                       _selectedDestinations.removeWhere(
//                         (d) => d.id == destination.id,
//                       );
//                     } else {
//                       _selectedDestinations.add(destination);
//                     }
//                   });
//                 },
//               );
//             },
//           );
//         }

//         return const SizedBox();
//       },
//     );
//   }

//   Widget _buildBottomBar() {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: AppColors.primaryWhite,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryBlack.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${_selectedDestinations.length} địa điểm',
//                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                       color: AppColors.textPrimary,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   Text(
//                     'đã chọn',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: AppColors.textSubtitle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 16.w),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed(
//                   AppRouteConstant.create ,
//                   arguments: {
//                     'province': widget.province,
//                     'destinations': _selectedDestinations,
//                   },
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryBlue,
//                 padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.r),
//                 ),
//               ),
//               child: Text(
//                 AppLocalizations.of(context)!.createItinerary,
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   color: AppColors.primaryWhite,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _DestinationCard extends StatelessWidget {
//   const _DestinationCard({
//     required this.destination,
//     required this.isSelected,
//     required this.onTap,
//   });

//   final Destination destination;
//   final bool isSelected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16.r),
//         child: Container(
//           decoration: BoxDecoration(
//             color: AppColors.primaryWhite,
//             borderRadius: BorderRadius.circular(16.r),
//             border: Border.all(
//               color:
//                   isSelected
//                       ? AppColors.primaryBlue
//                       : AppColors.secondaryGrey.withOpacity(0.3),
//               width: isSelected ? 2 : 1,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: AppColors.primaryBlack.withOpacity(0.06),
//                 blurRadius: 8,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               // Image
//               ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(16.r),
//                   bottomLeft: Radius.circular(16.r),
//                 ),
//                 child:
//                     destination.photos != null && destination.photos!.isNotEmpty
//                         ? Image.network(
//                           destination.photos!.first,
//                           width: 100.w,
//                           height: 100.h,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => _buildPlaceholder(),
//                         )
//                         : _buildPlaceholder(),
//               ),
//               // Content
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.all(12.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         destination.name,
//                         style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                           color: AppColors.textPrimary,
//                           fontWeight: FontWeight.w700,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       if (destination.specificAddress != null) ...[
//                         SizedBox(height: 4.h),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.location_on_outlined,
//                               size: 14.sp,
//                               color: AppColors.textSubtitle,
//                             ),
//                             SizedBox(width: 4.w),
//                             Expanded(
//                               child: Text(
//                                 destination.specificAddress!,
//                                 style: Theme.of(context).textTheme.bodySmall
//                                     ?.copyWith(color: AppColors.textSubtitle),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                       if (destination.rating != null) ...[
//                         SizedBox(height: 4.h),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.star_rounded,
//                               size: 16.sp,
//                               color: AppColors.primaryYellow,
//                             ),
//                             SizedBox(width: 4.w),
//                             Text(
//                               destination.rating!.toStringAsFixed(1),
//                               style: Theme.of(
//                                 context,
//                               ).textTheme.bodySmall?.copyWith(
//                                 color: AppColors.textPrimary,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//               // Checkbox
//               Padding(
//                 padding: EdgeInsets.only(right: 12.w),
//                 child: Container(
//                   width: 24.w,
//                   height: 24.w,
//                   decoration: BoxDecoration(
//                     color:
//                         isSelected ? AppColors.primaryBlue : Colors.transparent,
//                     border: Border.all(
//                       color:
//                           isSelected
//                               ? AppColors.primaryBlue
//                               : AppColors.secondaryGrey,
//                       width: 2,
//                     ),
//                     borderRadius: BorderRadius.circular(6.r),
//                   ),
//                   child:
//                       isSelected
//                           ? Icon(
//                             Icons.check,
//                             size: 16.sp,
//                             color: AppColors.primaryWhite,
//                           )
//                           : null,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPlaceholder() {
//     return Container(
//       width: 100.w,
//       height: 100.h,
//       color: AppColors.secondaryGrey.withOpacity(0.3),
//       child: Icon(
//         Icons.image_not_supported_outlined,
//         size: 32.sp,
//         color: AppColors.textSubtitle,
//       ),
//     );
//   }
// }
