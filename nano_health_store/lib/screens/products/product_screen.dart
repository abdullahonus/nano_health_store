import 'package:flutter/material.dart';
import 'package:nano_health_store/screens/login/login_screen.dart';
import 'package:nano_health_store/screens/products_detail/product_detil_screen.dart';
import 'package:nano_health_store/services/product_services/product_services.dart';

class ProductsScreen extends StatelessWidget {
  final _productService = ProductService();

  ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: PopupMenuButton(
                  color: Colors.white,
                  icon: const Icon(
                    Icons.menu,
                    color: Color(0xff2AB3C6),
                  ),
                  // add icon, by default "3 dot" icon
                  // icon: Icon(Icons.book)
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem<int>(
                        value: 2,
                        child: Text("Logout"),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                    } else if (value == 1) {
                    } else if (value == 2) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<void>(builder: (BuildContext context) => const LoginScreen()),
                        ModalRoute.withName('/'),
                      );
                    }
                  }),
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          title: const Text(
            "All Products",
            style: TextStyle(color: Color(0xff2AB3C6), fontWeight: FontWeight.bold, fontSize: 30),
          ),
          /*  toolbarHeight: MediaQuery.of(context).size.height / 15,
        leadingWidth: MediaQuery.of(context).size.width / 7, */
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _productService.getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return RefreshIndicator(
                onRefresh: () {
                  return _productService.getAllProducts();
                },
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
                    return buildCard(context, product);
                  },
                ),
              );
            }
          },
        ));
  }

  Widget buildCard(BuildContext context, Map<String, dynamic> product) {
    return Card(
      margin: const EdgeInsets.all(25),
      elevation: 25,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => ProductDetailsScreen(
                id: product['id'], // assuming the product id is in 'id' key
              ),
            ),
          );
        },
        child: buildCardContent(context, product),
      ),
    );
  }

  Widget buildCardContent(BuildContext context, Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          buildImageContainer(context, product['image']),
          buildPriceAndRatingRow(product),
          const SizedBox(height: 20),
          buildTitle(product['title']),
          const SizedBox(height: 20),
          buildDescription(product['description']),
        ],
      ),
    );
  }

  Widget buildImageContainer(BuildContext context, String imageUrl) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(imageUrl),
        ],
      ),
    );
  }

  Widget buildPriceAndRatingRow(Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "\$${product['price'].toString()}",
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xff08293b),
            ),
          ),
          buildRatingStars(product),
        ],
      ),
    );
  }

  Widget buildRatingStars(Map<String, dynamic> product) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          color: product['rating']['rate'] > index ? Colors.yellow : Colors.grey,
        );
      }),
    );
  }

  Widget buildTitle(String title) {
    return Text(title, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15, fontWeight: FontWeight.w200));
  }

  Widget buildDescription(String description) {
    return Text(description, style: const TextStyle(color: Color(0xff08293b), fontStyle: FontStyle.normal, fontSize: 15, fontWeight: FontWeight.w400));
  }
}
