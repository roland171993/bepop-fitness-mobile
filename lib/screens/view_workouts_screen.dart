import '../utils/shared_import.dart';
import '../components/adMob_component.dart';

class ViewWorkoutsScreen extends StatefulWidget {
  final bool? isFav;
  final bool? isAssign;

  ViewWorkoutsScreen({this.isFav = false, this.isAssign = false});

  @override
  _ViewWorkoutsScreenState createState() => _ViewWorkoutsScreenState();
}

class _ViewWorkoutsScreenState extends State<ViewWorkoutsScreen> {
  ScrollController scrollController = ScrollController();

  List<WorkoutDetailModel> mWorkoutList = [];

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
    getWorkoutData();
  }

  Future<void> getWorkoutData() async {
    appStore.setLoading(true);

    await getWorkoutListApi(widget.isFav, widget.isAssign, page: page)
        .then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mWorkoutList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mWorkoutList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.isFav == true || widget.isAssign == true
            ? PreferredSize(
                preferredSize: Size.fromHeight(0), child: SizedBox())
            : appBarWidget(languages.lblWorkouts,
                elevation: 0, context: context),
        body: Stack(
          children: [
            mWorkoutList.isNotEmpty
                ? AnimatedListView(
                    shrinkWrap: true,
                    controller: scrollController,
                    itemCount: mWorkoutList.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical:
                            widget.isFav == true || widget.isAssign == true
                                ? 16
                                : 4),
                    itemBuilder: (context, int i) {
                      return WorkoutComponent(
                        mWorkoutModel: mWorkoutList[i],
                        isView: true,
                        onCall: () {
                          if (widget.isFav == true) {
                            mWorkoutList.clear();
                            getWorkoutData();
                          }
                        },
                      );
                    },
                  )
                : NoDataScreen(mTitle: languages.lblWorkoutNoFound)
                    .visible(!appStore.isLoading),
            Loader().center().visible(appStore.isLoading)
          ],
        ),
        bottomNavigationBar:
            userStore.adsBannerDetailShowBannerOnWorkouts == 1 &&
                    userStore.isSubscribe == 0
                ? showBannerAds(context)
                : SizedBox());
  }
}
