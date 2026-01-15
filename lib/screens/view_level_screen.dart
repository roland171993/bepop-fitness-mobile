import '../utils/shared_import.dart';
import '../components/adMob_component.dart';

class ViewLevelScreen extends StatefulWidget {
  @override
  _ViewLevelScreenState createState() => _ViewLevelScreenState();
}

class _ViewLevelScreenState extends State<ViewLevelScreen> {
  ScrollController scrollController = ScrollController();

  List<LevelModel> mLevelList = [];

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((val) {
      getLevelData();
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !appStore.isLoading) {
          if (page < numPage!) {
            page++;
            getLevelDataPagination();
          }
        }
      });
    });
  }

  Future<void> getLevelData() async {
    appStore.setLoading(true);
    await getLevelListApi(page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mLevelList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mLevelList.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> getLevelDataPagination() async {
    appStore.setLoading(true);
    await getLevelListApi(page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mLevelList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mLevelList.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblLevels, elevation: 0, context: context),
      body: Stack(
        children: [
          AnimatedListView(
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: mLevelList.length,
            itemBuilder: (context, index) {
              return LevelComponent(mLevelModel: mLevelList[index]);
            },
          ),
          Observer(builder: (context) {
            return Loader().center().visible(appStore.isLoading);
          })
        ],
      ),
      bottomNavigationBar: userStore.adsBannerDetailShowBannerOnLevel == 1 &&
              userStore.isSubscribe == 0
          ? showBannerAds(context)
          : SizedBox(),
    );
  }
}
