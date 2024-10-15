import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedListApp());
}

class AnimatedListApp extends StatelessWidget {
  const AnimatedListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedListView(),
    );
  }
}

class AnimatedListView extends StatelessWidget {
  const AnimatedListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animated List"),
        centerTitle: true,
      ),
      body: const CustomAnimatedList(),
    );
  }
}

class CustomAnimatedList extends StatefulWidget {
  const CustomAnimatedList({super.key});

  @override
  State<CustomAnimatedList> createState() => _CustomAnimatedListState();
}

class _CustomAnimatedListState extends State<CustomAnimatedList> {
  final List<String> items = [];

  final GlobalKey<AnimatedListState> key = GlobalKey();
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedList(
            controller: scrollController,
            key: key,
            initialItemCount: items.length,
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: AnimatedListTile(
                  // index: index,
                  onPressed: () {
                    deleteItem(index);
                  },
                  text: items[index],
                ),
              );
            },
          ),
        ),
        TextButton(
            onPressed: () {
              insertItem();
            },
            child: const Text("Add"))
      ],
    );
  }

  void insertItem() {
    var index = items.length;
    items.add("item ${index + 1}");
    key.currentState?.insertItem(
      index,
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(microseconds: 300), curve: Curves.easeIn);
    });
    // });
  }

  void deleteItem(int index) {
    var removedItem = items.removeAt(index);
    key.currentState?.removeItem(index, (context, animation) {
      return SlideTransition(
          position: animation.drive(Tween<Offset>(
              begin: const Offset(1, 0), end: const Offset(0, 0))),
          child: AnimatedListTile(text: removedItem, onPressed: () {}));
    });
  }
}

class AnimatedListTile extends StatelessWidget {
  const AnimatedListTile(
      {super.key,
      //  required this.index,
      required this.text,
      required this.onPressed});
  // final int index;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.amber,
          ),
          title: Text(text),
          subtitle: Text(text),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onPressed,
          )

          // onTap: () {
          //   // Handle tap event
          // },
          ),
    );
  }
}
