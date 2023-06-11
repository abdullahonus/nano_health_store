// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:nano_health_store/screens/login/login_screen.dart';
import '../../services/product_services/product_services.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int id;

  const ProductDetailsScreen({super.key, required this.id});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _productService = ProductService();
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Detail",
            style: TextStyle(color: Color(0xff2AB3C6), fontWeight: FontWeight.bold, fontSize: 30),
          ),
          /*  toolbarHeight: MediaQuery.of(context).size.height / 15,
        leadingWidth: MediaQuery.of(context).size.width / 7, */
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xff2AB3C6),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 6,
                    ),
                  ],
                ),
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
                          value: 0,
                          child: Text("My Account"),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Text("Settings"),
                        ),
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
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _productService.getProduct(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final product = snapshot.data;
              return Column(
                children: <Widget>[
                  buildExpandedImageStack(context, product!),
                  buildBottomContainer(context, product),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return const Center(child: CircularProgressIndicator.adaptive());
          },
        ));
  }

  Widget buildExpandedImageStack(BuildContext context, Map<String, dynamic> product) {
    return Expanded(
      flex: 3,
      child: Stack(
        children: [
          buildImage(product),
          buildPriceBox(context, product),
        ],
      ),
    );
  }

  Widget buildImage(Map<String, dynamic> product) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Image.network(
        product['image'],
      ),
    );
  }

  Widget buildPriceBox(BuildContext context, Map<String, dynamic> product) {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 6,
            ),
          ],
        ),
        child: FittedBox(
          child: Text(
            "\$${product['price'].toString()}",
            style: const TextStyle(color: Color(0xff08293b), fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
      ),
    );
  }

  Widget buildBottomContainer(BuildContext context, Map<String, dynamic> product) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: buildAnimatedContainer(context, product),
      ),
    );
  }

  Widget buildAnimatedContainer(BuildContext context, Map<String, dynamic> product) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded ? MediaQuery.of(context).size.height / 2.2 : MediaQuery.of(context).size.height / 3,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        color: Color(0xff08293b),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: buildContainerContent(context, product),
      ),
    );
  }

  Widget buildContainerContent(BuildContext context, Map<String, dynamic> product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildExpandIcon(),
        buildButtonRow(context, product),
        buildSpacer(height: 20),
        buildDescriptionSection(context, product),
        buildSpacer(height: 20),
        buildExpandableReviewSection(context, product),
      ],
    );
  }

  Widget buildExpandIcon() {
    return Center(
      child: Icon(
        _isExpanded ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget buildButtonRow(BuildContext context, Map<String, dynamic> product) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildShareButton(context, product),
          buildOrderButton(context),
        ],
      ),
    );
  }

  Widget buildSpacer({required double height}) {
    return SizedBox(
      height: height,
    );
  }

  Widget buildDescriptionSection(BuildContext context, Map<String, dynamic> product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w200,
            fontSize: MediaQuery.of(context).size.height / 50,
          ),
        ),
        Text(
          product['description'],
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
            fontSize: MediaQuery.of(context).size.height / 70,
          ),
        )
      ],
    );
  }

  Widget buildExpandableReviewSection(BuildContext context, Map<String, dynamic> product) {
    return _isExpanded ? buildReviewSection(context, product) : Container();
  }

  Widget buildShareButton(BuildContext context, Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.height / 140,
        ),
        child: IconButton(
          style: IconButton.styleFrom(
            minimumSize: Size(
              MediaQuery.of(context).size.width / 1.35,
              MediaQuery.of(context).size.height / 20,
            ),
          ),
          icon: const Icon(
            Icons.ios_share_rounded,
            color: Color(0xff08293b),
            size: 30,
          ),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget buildOrderButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 6,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: Colors.white,
          minimumSize: Size(
            MediaQuery.of(context).size.width / 1.35,
            MediaQuery.of(context).size.height / 15,
          ),
        ),
        onPressed: () {
          const snackBar = SnackBar(
            content: Text('Your product has been added to the cart !!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Text(
          "Order Now",
          style: TextStyle(
            color: Color(0xff08293b),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget buildReviewSection(BuildContext context, Map<String, dynamic> product) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 204, 204, 204),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 20),
                child: Text(
                  "Reviews (${product['rating']['count']})",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      child: Text(
                        product['rating']['rate'].toStringAsFixed(2),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 35),
                      ),
                    ),
                    buildStarRating(product),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStarRating(Map<String, dynamic> product) {
    return Row(
      children: [
        Icon(Icons.star, color: product['rating']['rate'] >= 1 ? Colors.yellow : Colors.grey),
        Icon(Icons.star, color: product['rating']['rate'] >= 2 ? Colors.yellow : Colors.grey),
        Icon(Icons.star, color: product['rating']['rate'] >= 3 ? Colors.yellow : Colors.grey),
        Icon(Icons.star, color: product['rating']['rate'] >= 4 ? Colors.yellow : Colors.grey),
        Icon(Icons.star, color: product['rating']['rate'] >= 5 ? Colors.yellow : Colors.grey),
      ],
    );
  }

// Her bir widgeti oluşturan metodların detayları burada olmalıdır.
// Örneğin: buildShareButton, buildOrderButton, buildReviewSection, vb.
}
