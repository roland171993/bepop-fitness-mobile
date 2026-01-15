import '../utils/shared_import.dart';

class ExerciseListScreen extends StatefulWidget {
  final bool? isBodyPart;
  final bool? isLevel;
  final bool? isEquipment;

  final String? mTitle;

  final int? id;

  ExerciseListScreen(
      {this.mTitle,
      this.isBodyPart = false,
      this.isLevel = false,
      this.isEquipment = false,
      this.id});

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late ScrollController scrollController;
  late TextEditingController searchCont;
  List<ExerciseModel> mExerciseList = [];

  int page = 1;
  int? numPage;

  bool isLastPage = false;
  bool isSearch = false;

  String? mSearchValue = "";

  late VoidCallback _scrollListener;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    searchCont = TextEditingController();

    _scrollListener = () {
      if (!mounted) return;
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!appStore.isLoading && !isLastPage && page < (numPage ?? 1)) {
          page++;
          getExerciseData();
        }
      }
    };
    scrollController.addListener(_scrollListener);
    getExerciseData();
  }

  void init() async {
    getExerciseData();
  }

  Future<void> getExerciseData() async {
    appStore.setLoading(true);
    await getExerciseApi(
            page: page,
            mSearchValue: mSearchValue,
            id: widget.id.validate(),
            isBodyPart: widget.isBodyPart,
            isEquipment: widget.isEquipment,
            isLevel: widget.isLevel)
        .then((value) {
      if (!mounted) return;
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mExerciseList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mExerciseList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      if (!mounted) return;
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
          isSearch ? "" : widget.mTitle.validate().capitalizeFirstLetter(),
          context: context,
          actions: [
            AnimatedContainer(
              margin: EdgeInsets.only(left: 8, top: 4),
              duration: Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isSearch)
                    TextField(
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      cursorColor: primaryColor,
                      controller: searchCont,
                      onChanged: (v) {
                        mSearchValue = v;
                        mExerciseList.clear();
                        getExerciseData();
                      },
                      onSubmitted: (v) {
                        setState(() {
                          mSearchValue = v;
                          mExerciseList.clear();
                          getExerciseData();
                        });
                      },
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: languages.lblSearch,
                        hintStyle: primaryTextStyle(),
                      ),
                    ).paddingBottom(10).expand(),
                  IconButton(
                    icon: isSearch
                        ? Icon(Icons.close)
                        : Image.asset(ic_search,
                            height: 20, width: 20, color: primaryColor),
                    onPressed: () async {
                      isSearch = !isSearch;
                      mSearchValue = "";
                      if (!searchCont.text.isEmptyOrNull) {
                        page = 1;
                        getExerciseData();
                      }
                      searchCont.clear();
                      setState(() {});
                    },
                    color: primaryColor,
                  )
                ],
              ),
              width: isSearch ? context.width() - 80 : 50,
            ),
          ]),
      body: Stack(
        children: [
          mExerciseList.isNotEmpty
              ? AnimatedListView(
                  controller: scrollController,
                  itemCount: mExerciseList.length,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ExerciseComponent(
                        mExerciseModel: mExerciseList[index]);
                  },
                )
              : NoDataScreen(mTitle: languages.lblExerciseNoFound)
                  .visible(!appStore.isLoading),
          Observer(builder: (context) {
            return Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: double.infinity,
                    child: Loader().center())
                .visible(appStore.isLoading);
          })
        ],
      ),
    );
  }
}
