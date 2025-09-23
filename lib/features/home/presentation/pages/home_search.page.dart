import 'dart:async';
import 'package:tour_guide_app/common/widgets/app_bar/custom_search_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';

class HomeSearchPage extends StatefulWidget {
  const HomeSearchPage({super.key});

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<String> _results = [];
  bool _isLoading = false;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _doFakeSearch(value.trim());
    });
  }

  void _doFakeSearch(String query) async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
      if (query.isEmpty) {
        _results = [];
      } else {
        _results = List.generate(
          6,
          (i) => "Kết quả ${i + 1} cho '$query'",
        );
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchAppBar(
        hintText: "Tìm kiếm...",
        controller: _controller,
        onBack: () => Navigator.of(context).pop(),
        onSearchChanged: _onSearchChanged,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? Center(
                  child: Text(
                    "Không có kết quả",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _results[index],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  },
                ),
    );
  }
}
