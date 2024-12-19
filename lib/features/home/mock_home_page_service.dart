import 'home_page_model.dart';

abstract class IMockHomePageService {
  IMockHomePageService();

  Future<HomePageData> fetchHomePageData();
}

class MockHomePageService implements IMockHomePageService {
  @override
  Future<HomePageData> fetchHomePageData() async {
    await Future.delayed(const Duration(seconds: 3));
    return HomePageData(
      title: "Elite Spare Parts",
      description: "Find the best spare parts for your needs",
      items: [
        HomePageItem(title: "Engine Oil", subtitle: "Best quality oils"),
        HomePageItem(title: "Brake Pads", subtitle: "Reliable brake pads"),
      ],
      noOfItemsInCart: 3,
    );
  }
}
