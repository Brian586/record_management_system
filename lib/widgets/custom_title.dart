import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  const CustomTitle({super.key, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (actions != null) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                )
              ] else ...[
                const SizedBox()
              ]
            ],
          ),
          const SizedBox(height: 10.0),
          Container(
            height: 1.0,
            width: size.width,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}

class SecondaryTitle extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final Widget? secondaryWidget;
  final bool? showDivider;

  const SecondaryTitle({
    super.key,
    required this.title,
    this.iconData,
    this.secondaryWidget = const SizedBox(),
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  iconData,
                  color: Colors.grey,
                  size: 24.0,
                ),
                const SizedBox(width: 10.0),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  // style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            secondaryWidget!
          ],
        ),
        if (showDivider!) ...[
          const SizedBox(height: 10.0),
          Container(
            height: 1.0,
            width: size.width,
            color: Colors.grey,
          )
        ]
      ],
    );
  }
}

class SimpleTitle extends StatelessWidget {
  final String title;
  const SimpleTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
