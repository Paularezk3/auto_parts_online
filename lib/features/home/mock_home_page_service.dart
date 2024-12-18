import 'bloc/home_page_state.dart';
import 'home_page_model.dart';

abstract class IMockHomePageService {
  IMockHomePageService();

  Future<HomePageData> fetchHomePageData();
  Future<SearchBarTapped> fetchSearchTappedDetails();
  Future<SearchData> searchHomePageData(String query);
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

  @override
  Future<SearchBarTapped> fetchSearchTappedDetails() async {
    await Future.delayed(const Duration(seconds: 1));
    return SearchBarTapped(
      recentSearches: List.generate(
          4,
          (index) => index % 3 == 0
              ? "This long Recent Search $index"
              : "Recent Search $index"),
      searchTappedDetails: SearchTappedDetails(
        popularSearches: List.generate(
            6,
            (i) => i % 3 == 0
                ? "This is long Popular Searches $i"
                : "Popular adsdasddsa$i"),
        noOfItemsInCart: 0,
      ),
      sparePartsCategorySuggestions:
          List.generate(7, (i) => SparePartsCategory("Part Suggestion $i")),
    );
  }

  @override
  Future<SearchData> searchHomePageData(String query) async {
    await Future.delayed(const Duration(seconds: 2));
    return SearchData(
      data: [HomePageItem(title: "title", subtitle: "subtitle")],
      noOfItemsInCart: 3,
    );
  }
}
