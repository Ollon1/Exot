<?php
require_once '../../config/dbaccess.php';

$db = new DatabaseAccess();
$conn = $db->getConnection();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    $product_id = $data['product_id'];
    $rating = $data['rating'];
    $review_text = $data['review_text'];

    $stmt = $conn->prepare("INSERT INTO product_reviews (fk_product_id, rating, review_text) VALUES (:product_id, :rating, :review_text)");
    $stmt->bindParam(':product_id', $product_id);
    $stmt->bindParam(':rating', $rating);
    $stmt->bindParam(':review_text', $review_text);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success"]);
    } else {
        // NEU: Gib detaillierten Fehler aus
        echo json_encode([
            "status" => "error",
            "message" => "Fehler beim Insert.",
            "errorInfo" => $stmt->errorInfo()
        ]);
    }
}
