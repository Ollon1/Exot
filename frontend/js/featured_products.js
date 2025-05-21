$(document).ready(function () {
  const productIds = [1, 2, 3]; // Produkt-IDs für die "Featured Products"

  const fetchPromises = productIds.map((productId) => {
    return $.ajax({
      url: "../backend/public/api/products.php",
      type: "GET",
      data: { product_id: productId },
      dataType: "json",
    });
  });

  Promise.all(fetchPromises)
    .then((results) => {
      results.forEach((data) => {
        const html = `
          <div class="col-md-4 mb-4">
            <div class="card">
              <img src="../${
                data.product_imagepath
              }" class="card-img-top" alt="${data.product_name}" />
              <div class="card-body">
                <h5 class="card-title">${data.product_name}</h5>
                <p class="card-text">${data.product_description}</p>
                <p><strong>Rating:</strong> ${
                  data.latest_rating ?? "No ratings yet"
                } ⭐</p>
                <a href="index.html?page=shop" id="shop-nav" class="btn btn-primary">Shop Now</a>
              </div>
            </div>
          </div>
        `;
        $("#product-container").append(html);
      });
    })
    .catch((error) => {
      console.error("Error fetching featured products:", error);
    });
});
