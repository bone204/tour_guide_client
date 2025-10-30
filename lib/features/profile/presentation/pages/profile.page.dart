import 'package:tour_guide_app/common_libs.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 16.h),
              _buildStatsSection(context),
              SizedBox(height: 24.h),
              _buildMenuSection(context),
              SizedBox(height: 24.h),
              _buildLogoutButton(context),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar with gradient border
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange,
                  AppColors.primaryBlue,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.all(4.w),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(4.w),
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: 50.sp,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // User name
          Text(
            'Nguyễn Văn A',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 8.h),

          // Email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                size: 16.sp,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
              SizedBox(width: 8.w),
              Text(
                'nguyenvana@email.com',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary.withOpacity(0.8),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Edit profile button
          TextButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              size: 16.sp,
              color: AppColors.textSecondary,
            ),
            label: Text(
              'Chỉnh sửa hồ sơ',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.flight_takeoff,
              label: 'Chuyến đi',
              value: '12',
              color: AppColors.primaryBlue,
            ),
            Container(
              width: 1,
              height: 40.h,
              color: AppColors.primaryGrey.withOpacity(0.2),
            ),
            _buildStatItem(
              icon: Icons.favorite,
              label: 'Yêu thích',
              value: '28',
              color: AppColors.primaryRed,
            ),
            Container(
              width: 1,
              height: 40.h,
              color: AppColors.primaryGrey.withOpacity(0.2),
            ),
            _buildStatItem(
              icon: Icons.star,
              label: 'Điểm',
              value: '850',
              color: AppColors.primaryOrange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSubtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildMenuItem(
              icon: Icons.history,
              title: 'Lịch sử đặt chỗ',
              subtitle: 'Xem các chuyến đi của bạn',
              color: AppColors.primaryBlue,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.favorite_border,
              title: 'Yêu thích',
              subtitle: 'Địa điểm và tour yêu thích',
              color: AppColors.primaryRed,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.payment,
              title: 'Phương thức thanh toán',
              subtitle: 'Quản lý thẻ và ví',
              color: AppColors.primaryGreen,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Thông báo',
              subtitle: 'Cài đặt thông báo',
              color: AppColors.primaryOrange,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.language,
              title: 'Ngôn ngữ',
              subtitle: 'Tiếng Việt',
              color: AppColors.primaryPurple,
              onTap: () {
                Navigator.pushNamed(context, AppRouteConstant.language);
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Hỗ trợ',
              subtitle: 'Trợ giúp và liên hệ',
              color: AppColors.primaryBlue,
              onTap: () {},
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'Về chúng tôi',
              subtitle: 'Thông tin ứng dụng',
              color: AppColors.primaryGrey,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSubtitle,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Divider(
        height: 1,
        color: AppColors.primaryGrey.withOpacity(0.1),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: InkWell(
        onTap: () {
          _showLogoutDialog(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primaryRed.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: AppColors.primaryRed,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Đăng xuất',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn đăng xuất?',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSubtitle,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: TextStyle(
                color: AppColors.textSubtitle,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
              Navigator.pushReplacementNamed(context, AppRouteConstant.signIn);
            },
            child: Text(
              'Đăng xuất',
              style: TextStyle(
                color: AppColors.primaryRed,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

