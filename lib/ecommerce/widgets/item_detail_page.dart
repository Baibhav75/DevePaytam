import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/product_detail_controller.dart';
import '../../controller/category_product_controller.dart';
import '../../models/product_detail_model.dart';
import 'cart_page.dart';
import 'OderSummary.dart';

class ItemDetailPage extends StatefulWidget {
  final String productId;

  const ItemDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> with SingleTickerProviderStateMixin {
  final ProductDetailController detailController = Get.put(ProductDetailController());
  final CategoryProductController productController = Get.put(CategoryProductController());
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    detailController.fetchProductDetails(widget.productId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final product = detailController.productDetail.value;
          return Text(
            product?.productName ?? "Product Details",
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (detailController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = detailController.productDetail.value;
        if (product == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text("Product not found", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }

        final images = product.imageList;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= IMAGE SLIDER =================
                  _buildImageSlider(images),

                  const SizedBox(height: 24),

                  // ================= PRODUCT INFO HEADER =================
                  _buildProductHeader(product, theme),

                  const SizedBox(height: 24),

                  // ================= DESCRIPTION =================
                  if (product.description.isNotEmpty) _buildDescriptionSection(product),

                  const SizedBox(height: 24),

                  // ================= SPECIFICATIONS =================
                  _buildSpecificationsSection(product),

                  const SizedBox(height: 24),

                  // ================= VARIANTS (IF ANY) =================
                  if (product.sizeList.isNotEmpty || product.colorList.isNotEmpty)
                    _buildVariantsSection(product, theme),
                ],
              ),
            ),

            // ================= BOTTOM ACTIONS =================
            _buildBottomBar(product, theme),
          ],
        );
      }),
    );
  }

  Widget _buildImageSlider(List<String> images) {
    return Stack(
      children: [
        Container(
          height: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  images[index],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.image_not_supported_outlined, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(images.length, (index) {
                      num selectedness = (index - (_pageController.hasClients ? _pageController.page ?? 0 : 0)).abs();
                      double zoom = 1.0 + (1.0 - selectedness).clamp(0.0, 1.0) * 0.5;
                      return Container(
                        width: 8 * zoom,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: selectedness < 0.5 ? Colors.black : Colors.grey[300],
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductHeader(ProductDetail product, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.brandName.toUpperCase(),
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              if (product.isInStock)
                const Icon(Icons.check_circle, color: Colors.green, size: 16)
              else
                const Icon(Icons.error, color: Colors.red, size: 16),
              const SizedBox(width: 4),
              Text(
                product.stockStatus,
                style: TextStyle(
                  color: product.isInStock ? Colors.green : Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            product.productName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "₹${product.afterDiscount.toInt()}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 12),
              if (product.discount > 0) ...[
                Text(
                  "₹${product.mrp.toInt()}",
                  style: const TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D4D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${product.discountPercentage}% OFF",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ProductDetail product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About Product",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 12),
          Text(
            product.cleanDescription,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection(ProductDetail product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Specifications",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 16),
          _buildSpecRow("Product ID", product.productId),
          _buildSpecRow("SKU", product.sku),
          _buildSpecRow("Category", product.categoryName),
          _buildSpecRow("Sub-Category", product.subCategoryName),
          _buildSpecRow("Type", product.productType),
          _buildSpecRow("Unit", product.unit, isLast: true),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          if (!isLast) ...[
            const SizedBox(height: 12),
            Divider(color: Colors.grey[100], height: 1),
          ],
        ],
      ),
    );
  }

  Widget _buildVariantsSection(ProductDetail product, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.sizeList.isNotEmpty) ...[
            const Text("Select Size", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 45,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: product.sizeList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: index == 0 ? theme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: index == 0 ? theme.primaryColor : Colors.grey[300]!),
                  ),
                  child: Text(
                    product.sizeList[index],
                    style: TextStyle(
                      color: index == 0 ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (product.colorList.isNotEmpty) ...[
            const Text("Available Colors", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: product.colorList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!),
                    color: index == 0 ? theme.primaryColor : Colors.grey[100],
                  ),
                  child: index == 0 ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar(ProductDetail product, ThemeData theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  productController.addToCart(product.toCategoryProduct());

                  Get.snackbar(
                    'Success',
                    '${product.productName} added to cart',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.white,
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("ADD TO CART", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () => Get.to(() => OrderSummary(buyNowProduct: product.toCategoryProduct())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("BUY NOW", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

