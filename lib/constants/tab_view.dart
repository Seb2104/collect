part of '../collect.dart';

/// Example [TabViewContent] so that theres a fallback option
const TabViewContent demoContent = TabViewContent([
  TabViewItem('First', view: First()),
  TabViewItem('Second', view: Second()),
  TabViewItem('Third', view: Third()),
  TabViewItem('Fourth', view: Fourth()),
  TabViewItem('Fifth', view: Fifth()),
]);

class First extends StatelessWidget {
  const First({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('First'));
  }
}

class Second extends StatelessWidget {
  const Second({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Second'));
  }
}

class Third extends StatelessWidget {
  const Third({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Third'));
  }
}

class Fourth extends StatelessWidget {
  const Fourth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Fourth'));
  }
}

class Fifth extends StatelessWidget {
  const Fifth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: const Word('Fifth'));
  }
}
