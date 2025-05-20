let selectedItemKey = null;
let currentCart = {};

function initCartView() {
  const tableBody = $("table tbody");
  tableBody.empty();

  const cartData = sessionStorage.getItem("shoppingCart");
  let cart = {};

  try {
    cart = cartData ? JSON.parse(cartData) : {};
  } catch (e) {
    console.warn("Warenkorb konnte nicht gelesen werden:", e);
    cart = {};
  }

  if (cart && Object.keys(cart).length > 0) {
    Object.keys(cart).forEach((key, index) => {
      const item = cart[key];
      const row = `
        <tr data-key="${key}">
          <td>${index + 1}</td>
          <td>${item.product_name}</td>
          <td>${item.qty}</td>
          <td>${(item.qty * item.product_price).toFixed(2)} €</td>
          <td>
            <button class="btn btn-sm btn-danger remove-item">Remove</button>
            <button class="btn btn-sm btn-success buy-now">Buy Now</button>
          </td>
        </tr>`;
      tableBody.append(row);
    });
  } else {
    tableBody.append(
      '<tr><td colspan="5" class="text-danger">Ihr Warenkorb ist leer oder wurde schon bestellt</td></tr>'
    );
  }

  currentCart = cart;
}

$(document).on("click", ".remove-item", function () {
  const row = $(this).closest("tr");
  const key = row.data("key");

  let cart = JSON.parse(sessionStorage.getItem("shoppingCart")) || {};
  delete cart[key];
  sessionStorage.setItem("shoppingCart", JSON.stringify(cart));
  row.remove();

  if (Object.keys(cart).length === 0) {
    $("table tbody").html(
      '<tr><td colspan="5" class="text-danger">Ihr Warenkorb ist leer oder wurde schon bestellt</td></tr>'
    );
  }
});

$(document).on("click", ".buy-now", function () {
  const row = $(this).closest("tr");
  const key = row.data("key");
  const cart = JSON.parse(sessionStorage.getItem("shoppingCart")) || {};
  const item = cart[key];

  if (!item) return;
  let paymentMethod = "";

  $.ajax({
    type: "GET",
    url: "../backend/public/api/check_session.php",
    dataType: "json",
    success: function (response) {
      if (!response.logged_in) {
        alert("Bitte zuerst einloggen, um den Artikel zu kaufen.");
        return;
      }

      selectedItemKey = key;
      currentCart = cart;

      fetchUserPaymentMethods().then(() => {
        const modal = new bootstrap.Modal(
          document.getElementById("paymentModal")
        );
        modal.show();
      });
    },
    error: function (xhr) {
      console.error("Fehler beim Login-Check:", xhr.responseText);
    },
  });
});

function fetchUserPaymentMethods() {
  return $.ajax({
    url: "../backend/public/api/user_payment_methods.php",
    type: "GET",
    dataType: "json",
    success: function (methods) {
      const $select = $("#payment-method-select");
      $select.empty().append('<option value="">Bitte auswählen</option>');
      methods.forEach((method) => {
        $select.append(`<option value="${method}">${method}</option>`);
      });
    },
    error: function (xhr) {
      console.error(
        "Zahlungsarten konnten nicht geladen werden:",
        xhr.responseText
      );
      alert("Zahlungsarten konnten nicht geladen werden.");
    },
  });
}

$("#confirm-payment-btn").on("click", function () {
  const paymentMethod = $("#payment-method-select").val();
  if (!paymentMethod) {
    alert("Bitte wähle eine Zahlungsart.");
    return;
  }

  const item = currentCart[selectedItemKey];
  if (!item) return;

  const orderData = {
    payment_method: paymentMethod,
    voucher_code: "",
    items: [
      {
        product_name: item.product_name,
        quantity: item.qty,
        subtotal: item.qty * item.product_price,
      },
    ],
  };

  $.ajax({
    type: "POST",
    url: "../backend/public/api/place_order.php",
    contentType: "application/json",
    data: JSON.stringify(orderData),
    success: function (response) {
      alert(
        `✅ Bestellung erfolgreich! Rechnungsnummer: ${response.invoice_number}`
      );
      delete currentCart[selectedItemKey];
      sessionStorage.setItem("shoppingCart", JSON.stringify(currentCart));
      $(`tr[data-key="${selectedItemKey}"]`).remove();

      if (Object.keys(currentCart).length === 0) {
        $("table tbody").html(
          '<tr><td colspan="5" class="text-danger">Ihr Warenkorb ist leer oder wurde schon bestellt</td></tr>'
        );
      }

      const modalEl = document.getElementById("paymentModal");
      const modalInstance = bootstrap.Modal.getInstance(modalEl);
      if (modalInstance) {
        modalInstance.hide();
        $(".modal-backdrop").remove();
        $("body").removeClass("modal-open").css("padding-right", "0");
      }
    },
    error: function (xhr) {
      console.error("Fehler beim Kauf:", xhr.responseText);
      alert("❌ Bestellung fehlgeschlagen.");
    },
  });
});
