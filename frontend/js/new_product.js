$(document).ready(function () {
	fetchCategories();

	$('#new-product-form').on('submit', function (event) {
		event.preventDefault();

		var formData = new FormData();
		formData.append('product_name', $('#product_name').val());
		formData.append('product_description', $('#product_description').val());
		formData.append('product_price', $('#product_price').val());
		formData.append('product_weight', $('#product_weight').val());
		formData.append('product_quantity', $('#product_quantity').val());
		formData.append('product_category', $('#product_category').val());
		formData.append('product_imagepath', $('#product_imagepath')[0].files[0]);

		console.log('Form data: ', formData);

		$.ajax({
			url: '../backend/public/api/add_product.php',
			type: 'POST',
			data: formData,
			processData: false,
			contentType: false,
		/**
		 * Success callback for adding a new product.
		 * @param {object} response - The response from the server.
		 * @prop {string} status - The status of the request. Either "success" or "error".
		 * @prop {string} [error] - The error message if status is "error".
		 */
			success: function (response) {
				console.log('Response: ', response);
				if (response.status === 'success') {
					alert('Product added successfully!');
					$('#new-product-form')[0].reset();
				} else {
					alert('Failed to add product: ' + response.error);
				}
			},
			/**
			 * Error callback for adding a new product.
			 * @param {object} xhr - The XMLHttpRequest object.
			 * @param {string} status - The status of the request. Either "error" or "timeout".
			 * @param {string} error - The error type.
			 */
			error: function (xhr, status, error) {
				console.error('Error: ', xhr.responseText);
				alert('An error occurred: ' + xhr.responseText);
			},
		});
	});

/**
 * Fetches product categories from the server and populates the product category dropdown.
 * Utilizes an AJAX GET request to retrieve category data in JSON format.
 * On success, clears the existing options in the category dropdown and appends
 * new options for each category fetched.
 * Logs any errors encountered during the request to the console.
 */
	function fetchCategories() {
		$.ajax({
			url: '../backend/public/api/categories.php',
			type: 'GET',
			dataType: 'json',
			success: function (categories) {
				var categorySelect = $('#product_category');
				categorySelect.empty();
				categories.forEach(function (category) {
					var option = $('<option>')
						.val(category.category_name)
						.text(category.category_name);
					categorySelect.append(option);
				});
			},
			error: function (error) {
				console.error('Error fetching categories:', error);
			},
		});
	}
});
