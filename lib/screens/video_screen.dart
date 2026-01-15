import '../utils/shared_import.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ScrollController scrollController = ScrollController();

  List<BlogModel> mVideoList = [];

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

  init() async {
    //
    getVideoData();
  }

  Future<void> getVideoData() async {
    appStore.setLoading(true);
    getVideoApi(page: page).then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mVideoList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mVideoList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///TODO
      appBar: appBarWidget("Videos", context: context),
      body: Stack(
        children: [
          AnimatedListView(
            shrinkWrap: true,
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            itemCount: 5,
            itemBuilder: (context, index) {
              return VideoComponent();
            },
          ),
          mVideoList.isEmpty
              ? NoDataScreen().visible(!appStore.isLoading)
              : SizedBox(),
          Loader().center().visible(appStore.isLoading)
        ],
      ),
    );
  }
}
