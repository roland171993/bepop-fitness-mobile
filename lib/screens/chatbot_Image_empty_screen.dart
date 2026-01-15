import '../utils/shared_import.dart';

class ChatbotImageEmptyScreen extends StatefulWidget {
  final Function(String value) onTap;
  final bool isScroll;

  ChatbotImageEmptyScreen(
      {Key? key, required this.onTap, this.isScroll = false})
      : super(key: key);

  @override
  State<ChatbotImageEmptyScreen> createState() =>
      _ChatbotImageEmptyScreenState();
}

class _ChatbotImageEmptyScreenState extends State<ChatbotImageEmptyScreen> {
  ScrollController controller = ScrollController();

  List<String> questionImageList = [
    'https://www.shoulder-pain-explained.com/images/shoulder-muscles-anatomy.jpg',
    'https://as1.ftcdn.net/v2/jpg/02/91/36/96/1000_F_291369692_6Wi20oLl9clU8w6a3BmckCWnsWIgSDjO.jpg',
    'https://www.shutterstock.com/image-illustration/leg-muscles-quadriceps-hamstrings-calves-600w-2448678081.jpg',
    'https://i.pinimg.com/736x/7a/1e/3c/7a1e3cb52d0a5369714a538920aaac94.jpg',
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isScroll) {
      controller.animToBottom(milliseconds: 100);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(
          left: 16, right: 16, top: 16, bottom: widget.isScroll ? 185 : 90),
      controller: controller,
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 5 / 4,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        // Padding around the grid
        children: List.generate(questionImageList.length, (index) {
          return GestureDetector(
              onTap: () {
                widget.onTap.call(questionImageList[index]);
                selectedImageIndex = index;
              },
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selectedImageIndex == index
                          ? primaryColor
                          : Colors.transparent, // Highlight if selected
                      width: 2.0,
                    ),
                  ),
                  child: cachedImage(questionImageList[index],
                          height: 100, fit: BoxFit.cover, width: 100)
                      .cornerRadiusWithClipRRect(16)));
        }),
      ),
    );
  }
}
