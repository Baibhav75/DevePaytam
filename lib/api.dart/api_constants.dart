class ApiConstants {
  static const String baseUrl = "https://dewa.co.in";

  static const String registerUser = "/api/userregistration/add";
  static const String loginUser = "/api/userlogin";
  static const String sendOtp = "/api/sendotp/send";
  static const String verifyOtp = "/api/verifyotp/verify";

  // New endpoint for getting user profile
  static const String getUserProfile = "/api/getuserprofile/getbymobile";

  static const String getUserProfileByMobile =
      "/api/getuserprofile/getbymobile";

  static const String changePassword =
      "/api/changepassword/change?con";

  // ✅ CATEGORY API
  static const String getCategories =
      "/api/categories/get";

  // ✅ SUB CATEGORY (NEW – REQUIRED)
  static const String getSubCategoriesByCategory =
      "/api/subcategories/getbycategory";


  static const String getProductsByCategory =
      "/api/products/get"; // 👈 only endpoint (no baseUrl here)

  static const String productDetails =
      "/api/product/details";

  static const String addToCart = "/api/cart/add";

  static const String bannerList = "/api/banner/list";




  // ================= COMMON HEADERS =================
  static const Map<String, String> jsonHeaders = {
    "Content-Type": "application/json",
  };


}
