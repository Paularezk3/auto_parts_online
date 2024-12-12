class HomePageModel {
  final String title;
  final String description;
  final List<HomePageItem> items;

  HomePageModel({
    required this.title,
    required this.description,
    required this.items,
  });
}

class HomePageItem {
  final String title;
  final String subtitle;

  HomePageItem({
    required this.title,
    required this.subtitle,
  });
}
