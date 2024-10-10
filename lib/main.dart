import 'package:brain_bets/api/tournaments.dart';
import 'package:brain_bets/services/tournaments.dart';
import 'package:flutter/material.dart';

import 'package:dynamic_tabbar/dynamic_tabbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tournaments',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Current Tournaments'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isScrollable = false;
  bool showNextIcon = true;
  bool showBackIcon = true;

  @override
  void initState() {
    super.initState();
    getTournaments();
  }

  // Leading icon
  Widget? leading;

  // Trailing icon
  Widget? trailing;

  // Sample data for tabs
  List<TabData> tabs = [
    TabData(
      index: 1,
      title: const Tab(
        child: Text('Tab 1'),
      ),
      content: const Center(
        child: Tab(
          child: Text('Tab 1'),
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: addDefaultsTab,
                  child: const Text('Add Tab'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => removeTab(tabs.length - 1),
                  child: const Text('Remove Last Tab'),
                ),
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('isScrollable'),
                    Switch.adaptive(
                      value: isScrollable,
                      onChanged: (bool val) {
                        setState(() {
                          isScrollable = !isScrollable;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('showBackIcon'),
                    Switch.adaptive(
                      value: showBackIcon,
                      onChanged: (bool val) {
                        setState(() {
                          showBackIcon = !showBackIcon;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('showNextIcon'),
                    Switch.adaptive(
                      value: showNextIcon,
                      onChanged: (bool val) {
                        setState(() {
                          showNextIcon = !showNextIcon;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 22),
                ElevatedButton(
                  onPressed: addLeadingWidget,
                  child: const Text('Add Leading Widget'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: removeLeadingWidget,
                  child: const Text('remove Leading Widget'),
                ),
                const SizedBox(width: 22, height: 44),
                ElevatedButton(
                  onPressed: addTrailingWidget,
                  child: const Text('Add Trailing Widget'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: removeTrailingWidget,
                  child: const Text('remove Trailing Widget'),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
          Expanded(
            child: DynamicTabBarWidget(
              dynamicTabs: tabs,
              // optional properties :-----------------------------
              isScrollable: isScrollable,
              onTabControllerUpdated: (controller) {
                debugPrint("onTabControllerUpdated");
              },
              onTabChanged: (index) {
                debugPrint("Tab changed: $index");
              },
              onAddTabMoveTo: MoveToTab.last,
              // onAddTabMoveToIndex: tabs.length - 1, // Random().nextInt(tabs.length);
              // backIcon: Icon(Icons.keyboard_double_arrow_left),
              // nextIcon: Icon(Icons.keyboard_double_arrow_right),
              showBackIcon: showBackIcon,
              showNextIcon: showNextIcon,
              leading: leading,
              trailing: trailing,
            ),
          ),
        ],
      ),
    );
  }

  void getTournaments() async {
    final tournamentsService = TournamentsService();
    final List? tournaments = await tournamentsService.getTournaments();

    for (var tournament in tournaments!) {
      addTab(tabName: tournament["tournament_name"], content:  tournament["event_type_type"]);
    }
  }

  void addTab({required String tabName, required String content}) {
    setState(() {
      var tabNumber = tabs.length + 1;
      tabs.add(
        TabData(
          index: tabNumber,
          title: Tab(
            child: Text(tabName),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(content),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => removeTab(tabNumber - 1),
                child: const Text('Remove this Tab'),
              ),
            ],
          ),
        ),
      );
    });
  }

  void addDefaultsTab() {
    setState(() {
      var tabNumber = tabs.length + 1;
      tabs.add(
        TabData(
          index: tabNumber,
          title: Tab(
            child: Text('Tab $tabNumber'),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Dynamical tab $tabNumber"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => removeTab(tabNumber - 1),
                child: const Text('Remove this Tab'),
              ),
            ],
          ),
        ),
      );
    });
  }

  void removeTab(int id) {
    setState(() {
      tabs.removeAt(id);
    });
  }

  void addLeadingWidget() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          'Adding Icon button Widget \nYou can add any customized widget)'),
    ));

    setState(() {
      leading = Tooltip(
        message: 'Add your desired Leading widget here',
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      );
    });
  }

  void removeLeadingWidget() {
    setState(() {
      leading = null;
    });
  }

  void addTrailingWidget() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
          'Adding Icon button Widget \nYou can add any customized widget)'),
    ));

    setState(() {
      trailing = Tooltip(
        message: 'Add your desired Trailing widget here',
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      );
    });
  }

  void removeTrailingWidget() {
    setState(() {
      trailing = null;
    });
  }
}
