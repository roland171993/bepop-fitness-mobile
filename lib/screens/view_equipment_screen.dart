import '../utils/shared_import.dart';
import '../components/adMob_component.dart';

class ViewEquipmentScreen extends StatefulWidget {
  @override
  _ViewEquipmentScreenState createState() => _ViewEquipmentScreenState();
}

class _ViewEquipmentScreenState extends State<ViewEquipmentScreen> {
  ScrollController scrollController = ScrollController();

  List<EquipmentModel> mEquipmentList = [];

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((val) {
      getEquipmentData();
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !appStore.isLoading) {
          if (page < numPage!) {
            page++;
            getEquipmentDataPagination();
          }
        }
      });
    });
  }

  Future<void> getEquipmentData() async {
    appStore.setLoading(true);
    await getEquipmentListApi(page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mEquipmentList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mEquipmentList.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> getEquipmentDataPagination() async {
    appStore.setLoading(true);
    await getEquipmentListApi(page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mEquipmentList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mEquipmentList.add(e)).toList();
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
        appBar: appBarWidget(languages.lblEquipmentsExercise,
            elevation: 0, context: context),
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(16),
              child: AnimatedWrap(
                runSpacing: 16,
                spacing: 16,
                children: List.generate(mEquipmentList.length, (index) {
                  return EquipmentComponent(
                      isGrid: true, mEquipmentModel: mEquipmentList[index]);
                }),
              ),
            ),
            Observer(builder: (context) {
              return Loader().center().visible(appStore.isLoading);
            })
          ],
        ),
        bottomNavigationBar:
            userStore.adsBannerDetailShowBannerOnEquipment == 1 &&
                    userStore.isSubscribe == 0
                ? showBannerAds(context)
                : SizedBox());
  }
}
