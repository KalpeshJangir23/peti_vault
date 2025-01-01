import 'package:flutter/material.dart';

class StackingContainers extends StatefulWidget {
  const StackingContainers({super.key});

  @override
  _StackingContainersState createState() => _StackingContainersState();
}

class _StackingContainersState extends State<StackingContainers> {
  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
  ];
  
  int currentIndex = 0;
  List<_ContainerInfo> stackedContainers = [];
  final double containerHeight = 200.0;
  final double stackOffset = 50.0;

  @override
  void initState() {
    super.initState();
    // Add initial container
    stackedContainers.add(
      _ContainerInfo(
        index: 0,
        isEntering: true,
        isExiting: false,
        offsetY: 0,
      ),
    );
  }

  Widget _buildAnimatedContainer(_ContainerInfo info) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(
        begin: info.isEntering ? 1 : (info.isExiting ? 0 : info.offsetY),
        end: info.isExiting ? 1 : info.offsetY,
      ),
      onEnd: () {
        if (info.isExiting) {
          setState(() {
            stackedContainers.removeLast();
          });
        }
      },
      builder: (context, double animValue, child) {
        double xOffset = 0.0;
        double yOffset = 0.0;

        if (info.isEntering) {
          xOffset = MediaQuery.of(context).size.width * animValue;
        } else if (info.isExiting) {
          xOffset = MediaQuery.of(context).size.width * animValue;
        }

        if (!info.isEntering && !info.isExiting) {
          yOffset = stackOffset * info.offsetY;
        }

        return Transform.translate(
          offset: Offset(xOffset, yOffset),
          child: Container(
            height: containerHeight,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors[info.index % colors.length],
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Container ${info.index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onNext() {
    if (currentIndex < colors.length - 1) {
      setState(() {
        currentIndex++;
        // Update positions of existing containers
        for (var container in stackedContainers) {
          container.offsetY = (currentIndex - container.index).toDouble();
          container.isEntering = false;
          container.isExiting = false;
        }
        // Add new container
        stackedContainers.add(
          _ContainerInfo(
            index: currentIndex,
            isEntering: true,
            isExiting: false,
            offsetY: 0,
          ),
        );
      });
    }
  }

  void _onPrevious() {
    if (currentIndex > 0) {
      setState(() {
        // Mark current container as exiting
        stackedContainers.last.isExiting = true;
        // Update positions of remaining containers
        for (var container
            in stackedContainers.take(stackedContainers.length - 1)) {
          container.offsetY = ((currentIndex - 1) - container.index).toDouble();
        }
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stacking Containers'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: stackedContainers
                  .map((info) => _buildAnimatedContainer(info))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? _onPrevious : null,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: currentIndex < colors.length - 1 ? _onNext : null,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContainerInfo {
  final int index;
  bool isEntering;
  bool isExiting;
  double offsetY;

  _ContainerInfo({
    required this.index,
    required this.isEntering,
    required this.isExiting,
    required this.offsetY,
  });
}
