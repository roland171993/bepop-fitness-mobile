import '../utils/shared_import.dart';

String? selectMainGoal = '';
String? selectExperienced = '';
String? selectEquipments = '';
String? selectWeekWorkout = '';

class MainGoalScreen extends StatefulWidget {
  @override
  _MainGoalScreenState createState() => _MainGoalScreenState();
}

class _MainGoalScreenState extends State<MainGoalScreen> {
  int _selectedGoalIndex = 0;
  int _selectedExperienceIndex = 0;
  int _selectedEquipmentIndex = 0;
  int selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BackgroundColorImageColor,
        title: Text(
          '${appName} Ai',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
        ),
        leading: GestureDetector(
          onTap: () {
            setState(() {
              selectedScreen == 0
                  ? finish(context)
                  : selectedScreen == 1
                      ? selectedScreen = 0
                      : selectedScreen == 2
                          ? selectedScreen = 1
                          : selectedScreen == 3
                              ? selectedScreen = 2
                              : selectedScreen = 3;
            });
          },
          child: Icon(
            Octicons.chevron_left,
            color: primaryColor,
            size: 28,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
        ),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  userStore.gender == "male"
                      ? ic_male_selected
                      : ic_female_selected,
                  width: 100,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    selectedScreen == 0
                        ? languages.lblMainGoal
                        : selectedScreen == 1
                            ? languages.lblHowExperienced
                            : selectedScreen == 2
                                ? '${languages.lblHoweEquipment}'
                                : '${languages.lblHoweOftenWorkout}',
                    style: TextStyle(
                      color: appStore.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (selectedScreen == 0) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGoalIndex = index;
                            selectMainGoal =
                                firstDescriptions[_selectedGoalIndex];
                          });
                        },
                        child: GoalCard(
                          title: firstTitles[index],
                          description: firstDescriptions[index],
                          icon: firstIcons[index],
                          isSelected: _selectedGoalIndex == index,
                          width: 45,
                          height: 42,
                        ),
                      );
                    },
                  ),
                ] else if (selectedScreen == 1) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedExperienceIndex = index;
                            selectExperienced =
                                secondDescriptions[_selectedExperienceIndex];
                          });
                        },
                        child: GoalCard(
                          title: secondTitles[index],
                          description: secondDescriptions[index],
                          icon: secondIcons[index],
                          isSelected: _selectedExperienceIndex == index,
                          width: 30,
                          height: 28,
                        ),
                      );
                    },
                  ),
                ] else if (selectedScreen == 2) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedEquipmentIndex = index;
                            selectEquipments =
                                thirdDescriptions[_selectedEquipmentIndex];
                          });
                        },
                        child: GoalCard(
                          title: thirdTitles[index],
                          description: thirdDescriptions[index],
                          icon: thirdIcons[index],
                          isSelected: _selectedEquipmentIndex == index,
                          width: 45,
                          height: 42,
                        ),
                      );
                    },
                  ),
                ] else ...[
                  SeekBar(),
                ],
                16.height,
                ElevatedButton(
                  onPressed: () {
                    if (selectedScreen == 0) {
                      selectedScreen = 1;
                    } else if (selectedScreen == 1) {
                      selectedScreen = 2;
                    } else if (selectedScreen == 2) {
                      selectedScreen = 3;
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChattingImageScreen()),
                      );
                    }
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 85, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(selectedScreen == 3
                      ? '${languages.lblFinish}'
                      : '${languages.lblContinue}'),
                ),
                20.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalCard extends StatelessWidget {
  final String title;
  final String description;
  final String icon;
  final bool isSelected;
  final double width;
  final double height;

  GoalCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: isSelected ? primaryColor : primaryOpacity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  icon,
                  width: width,
                  height: height,
                  color: isSelected ? Colors.white : primaryColor,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SeekBar extends StatefulWidget {
  const SeekBar({Key? key}) : super(key: key);

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _currentSliderValue = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          HabitTracker(currentSliderValue: _currentSliderValue),
          SizedBox(height: 50),
          Slider(
            value: _currentSliderValue,
            min: 1,
            max: 7,
            divisions: 6,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
                selectWeekWorkout =
                    '${languages.lblRecommend} ${_currentSliderValue.round()} ${languages.lblTimesWeek}';
              });
            },
          ),
          Text(
            '${_currentSliderValue.round()} ${languages.lblOnlyTimesWeek}',
            // '${_currentSliderValue.round()} ${'times/week'}',
            style: TextStyle(
                color: appStore.isDarkMode ? Colors.white : Colors.black),
          ),
          const SizedBox(height: 16),
          Text(
            '${languages.lblRecommend} ${_currentSliderValue.round()} ${languages.lblTimesWeek}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: appStore.isDarkMode ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}

class HabitTracker extends StatefulWidget {
  final double currentSliderValue;

  HabitTracker({this.currentSliderValue = 0.7});

  @override
  State<HabitTracker> createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: primaryOpacity,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: scaffoldColorDark),
              SizedBox(width: 8.0),
              Text(languages.lblEasyHabit,
                  style: TextStyle(color: scaffoldColorDark)),
            ],
          ),
          SizedBox(height: 8.0),
          LinearProgressIndicator(
            value: 0.9 / widget.currentSliderValue,
            backgroundColor: primaryColor.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Icon(Icons.speed, color: scaffoldColorDark),
              SizedBox(width: 8.0),
              Text(languages.lblProgression,
                  style: TextStyle(color: scaffoldColorDark)),
            ],
          ),
          SizedBox(height: 8.0),
          LinearProgressIndicator(
            value: widget.currentSliderValue / 10,
            backgroundColor: primaryColor.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ],
      ),
    );
  }
}
