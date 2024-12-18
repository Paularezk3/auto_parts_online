class SearchPageModel {}

class SearchData extends SearchPageModel {
  final List<SearchPageItems> data;
  SearchData({required this.data});
}

class SearchTappedDetails extends SearchPageModel {
  final List<String> popularSearches;
  SearchTappedDetails({required this.popularSearches});
}

class SearchPageItems {
  final String partName;
  final String partDescription;
  final String carBrandName;
  SearchPageItems(
      {required this.carBrandName,
      required this.partDescription,
      required this.partName});
}

class SparePartsCategory {
  final String partName;
  SparePartsCategory(this.partName);
}
