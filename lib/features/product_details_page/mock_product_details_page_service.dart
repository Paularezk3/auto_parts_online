import 'dart:math';

import 'package:auto_parts_online/features/product_details_page/product_details_page_model.dart';

import '../../core/models/guarantee_level.dart';
import '../../core/models/stock_level.dart';

abstract class IMockProductDetailsPageService {
  IMockProductDetailsPageService();

  Future<ProductDetailsPageData> fetchProductDetailsPageData(int productId);
}

class MockProductDetailsPageService implements IMockProductDetailsPageService {
  @override
  Future<ProductDetailsPageData> fetchProductDetailsPageData(
      int productId) async {
    // Simulate a delay to mimic a network request
    await Future.delayed(Duration(seconds: getRandomNumber()));

// Generate fake carousel data
    final List<CarouselData> carouselData1 = [
      CarouselData("https://via.placeholder.com/600x300"),
      CarouselData("https://via.placeholder.com/800x400"),
      CarouselData("https://via.placeholder.com/300x600"),
    ];

    final List<CarouselData> carouselData2 = [
      CarouselData("https://via.placeholder.com/700x350"),
      CarouselData("https://via.placeholder.com/900x450"),
      CarouselData("https://via.placeholder.com/400x700"),
    ];

    final List<CarouselData> carouselData3 = [
      CarouselData("https://via.placeholder.com/650x325"),
      CarouselData("https://via.placeholder.com/850x425"),
      CarouselData("https://via.placeholder.com/350x650"),
    ];

    final products = [
      ProductDetailsPageData(
          productId: 1,
          stockLevel: StockLevel.limited,
          title: "Vacuum Cell",
          productName: "Turbo Vacuum Cell for m254",
          description: """
      <p>This Turbo Vacuum Cell is compatible with a wide range of models and comes with excellent durability and performance.</p>
      <ul>
        <li><strong>High Efficiency:</strong> Ensures optimal performance and fuel efficiency.</li>
        <li><em>Durable Construction:</em> Built to last with high-quality materials.</li>
        <li><span style="color: green;">Eco-Friendly:</span> Designed to reduce emissions and environmental impact.</li>
      </ul>
      <p>Upgrade your vehicle with this top-of-the-line Turbo Vacuum Cell and experience the difference in performance and reliability.</p>
      """,
          originalPrice: 999.99,
          discountedPrice: 899.99,
          carousel: carouselData1,
          guaranteeLevel: GuaranteeLevel.basic,
          compatibility: ["Mercedes-Benz E-Class (W213) 2016-2021"]),
      ProductDetailsPageData(
          productId: 0,
          stockLevel: StockLevel.inStock,
          title: "Camshaft Column",
          productName: "Premium Camshaft Column",
          description: """
      <p>Engineered for high performance, this camshaft column ensures smooth operation and longevity of your vehicle.</p>
      <ul>
        <li><strong>Precision Engineering:</strong> Crafted with exact specifications for optimal performance.</li>
        <li><em>Long-Lasting:</em> Made from high-quality materials to ensure durability.</li>
        <li><span style="color: blue;">Enhanced Performance:</span> Improves engine efficiency and power output.</li>
      </ul>
      <p>Choose this Premium Camshaft Column for a reliable and efficient upgrade to your vehicle's engine system.</p>
      """,
          originalPrice: 7999.99,
          discountedPrice: 6999.99,
          carousel: carouselData2,
          guaranteeLevel: GuaranteeLevel.none,
          compatibility: [
            "Mercedes-Benz C-Class (W205) 2014-2019",
          ]),
      ProductDetailsPageData(
          stockLevel: StockLevel.outOfStock,
          productId: 2,
          title: "Balance Bar",
          productName: "Balance Bar Link for Mercedes w204",
          description: """
      <p>This Mercedes Balance Bar Link is a high-quality replacement part designed to restore the stability and handling of your vehicle. It is compatible with a wide range of Mercedes models and ensures excellent durability and performance.</p>
      <ul>
        <li>High-quality construction for long-lasting durability</li>
        <li>Designed to meet or exceed OEM specifications</li>
        <li>Improves vehicle stability and handling</li>
        <li>Easy to install with direct fitment</li>
        <li>Compatible with various Mercedes models</li>
      </ul>
      <p>Upgrade your vehicle's suspension system with this reliable and efficient balance bar link, ensuring a smooth and safe driving experience.</p>
      """,
          originalPrice: 1999.99,
          carousel: carouselData3,
          guaranteeLevel: GuaranteeLevel.high,
          compatibility: [
            "Mercedes-Benz C-Class (W204) 2007-2014",
          ]),
      ProductDetailsPageData(
        stockLevel: StockLevel.outOfStock,
        productId: 4,
        title: "Engine Mount",
        productName: "Engine Mount for Mercedes",
        description: """
<p>This Mercedes Engine Mount is a high-quality replacement part designed to reduce vibrations and ensure smooth engine operation. It is built to meet OEM standards for reliability and performance.</p>
<ul>
  <li>Durable construction for long-term use</li>
  <li>Reduces engine vibration and noise</li>
  <li>Ensures proper engine alignment</li>
  <li>Direct fit for easy installation</li>
  <li>Compatible with various Mercedes models</li>
</ul>
<p>Enhance your vehicle's performance and comfort with this premium engine mount, a reliable choice for your Mercedes.</p>
""",
        originalPrice: 4999.99,
        carousel: carouselData3,
        guaranteeLevel: GuaranteeLevel.high,
        compatibility: [
          "Mercedes-Benz C-Class (W204) 2007-2014",
          "Mercedes-Benz E-Class (W212) 2010-2016",
        ],
      ),
      ProductDetailsPageData(
        stockLevel: StockLevel.inStock,
        productId: 3,
        title: "Ignition Coil",
        productName: "Ignition Coil for Mercedes",
        description: """
<p>This Mercedes Ignition Coil ensures optimal engine performance by delivering a reliable spark for efficient combustion. It is manufactured to high standards for durability and consistency.</p>
<ul>
  <li>Ensures reliable ignition and performance</li>
  <li>Manufactured to meet or exceed OEM specifications</li>
  <li>Improves fuel efficiency and reduces emissions</li>
  <li>Easy to install and compatible with multiple Mercedes models</li>
</ul>
<p>Upgrade your vehicle's ignition system with this top-quality ignition coil, designed to keep your engine running smoothly.</p>
""",
        originalPrice: 2399.99,
        carousel: carouselData3,
        guaranteeLevel: GuaranteeLevel.basic,
        compatibility: [
          "Mercedes-Benz C-Class (W204) 2007-2014",
          "Mercedes-Benz E-Class (W212) 2010-2016",
          "Mercedes-Benz S-Class (W221) 2006-2013",
        ],
      ),
    ];
    // Return fake product details
    return products.firstWhere((product) => product.productId == productId);
  }

  int getRandomNumber({int? number}) {
    final random = Random();
    return random.nextInt(
        number ?? 4); // Generates a random number from 0 to 3 (inclusive)
  }

  double getRandomDouble(num? number) {
    final random = Random().nextDouble() * (number ?? 4);
    return random; // Generates a random number from 0 to 3 (inclusive)
  }
}
