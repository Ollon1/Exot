<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once '../../logic/datahandler.php';

header('Content-Type: application/json');

if (!isset($_SESSION['user_id'])) {
    error_log('Unauthorized access attempt');
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

//Abfrage nach order id, prüfung ob order id zurückgeliefert
$order_id = $_GET['order_id'] ?? null;

if (!$order_id) {
    error_log('Order ID is required');
    http_response_code(400);
    echo json_encode(['error' => 'Order ID is required']);
    exit;
}

$dataHandler = new DataHandler();
$order = $dataHandler->getOrderById($order_id);

//wenn keine order id zurückgeliefert wurde
if (!$order) {
    error_log("Order not found for ID: $order_id");
    http_response_code(404);
    echo json_encode(['error' => 'Order not found']);
    exit;
}

$orderItems = $dataHandler->getOrderItemsWithProductName($order_id);

echo json_encode([
    'status' => 'success',
    'order' => $order,
    'order_items' => $orderItems
]);
