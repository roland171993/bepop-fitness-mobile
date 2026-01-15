import '../utils/shared_import.dart';
import '../components/adMob_component.dart';

class ViewAllDiet extends StatefulWidget {
  final bool? isFeatured;
  final bool? isCategory;
  final int? mCategoryId;
  final String? mTitle;
  final bool? isAssign;
  final bool? isFav;

  ViewAllDiet(
      {this.isFeatured = false,
      this.isCategory,
      this.mCategoryId,
      this.mTitle,
      this.isFav = false,
      this.isAssign = false});

  @override
  _ViewAllDietState createState() => _ViewAllDietState();
}

class _ViewAllDietState extends State<ViewAllDiet> {
  ScrollController scrollController = ScrollController();

  List<DietModel> mDietList = [];

  CategoryDietModel? mCategoryDietModel;

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          init();
        }
      }
    });
  }

  void init() async {
    getDietData();
  }

  Future<void> getDietData() async {
    appStore.setLoading(true);
    await getDietApi(
            page: page,
            widget.isFeatured == true ? "yes" : "no",
            widget.isCategory,
            isAssign: widget.isAssign,
            categoryId: widget.mCategoryId,
            isFav: widget.isFav)
        .then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mDietList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mDietList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("dfgdfgdfgdfgdfg");
    return Scaffold(
      appBar: widget.isAssign == true || widget.isFav == true
          ? PreferredSize(preferredSize: Size.fromHeight(0), child: SizedBox())
          : appBarWidget(widget.mTitle.validate(), context: context),
      body: Stack(
        children: [
          mDietList.isNotEmpty
              ? AnimatedListView(
                  controller: scrollController,
                  itemCount: mDietList.length,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: widget.isFav == true || widget.isAssign == true
                          ? 16
                          : 8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return FeaturedDietComponent(
                      isList: true,
                      mDietModel: mDietList[index],
                      onCall: () {
                        if (widget.isFav == true) {
                          mDietList.clear();
                          getDietData();
                        }
                      },
                    );
                  },
                )
              : NoDataScreen(mTitle: languages.lblResultNoFound)
                  .visible(!appStore.isLoading),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
      bottomNavigationBar: userStore.adsBannerDetailShowBannerAdsOnDiet == 1 &&
              userStore.isSubscribe == 0
          ? showBannerAds(context)
          : SizedBox(),
    );
  }
}
