<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");

ini_set('display_errors', 1);
error_reporting(E_ALL);

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    try {
        include './class.php';
        $obj = new Database();

        $data = json_decode(file_get_contents("php://input"), true);

        $userId        = $data['id'] ?? '';
     //    $oldPassword   = $data['old_password'] ?? '';
        $newPassword   = $data['new_password'] ?? '';

        if (empty($userId) || empty($oldPassword) || empty($newPassword)) {
            echo json_encode(['message' => 'All fields are required']);
            exit();
        }

        // Check old password
        $obj->select("user", "*", "id = '$userId'");
        $result = $obj->getresult();

        if (!empty($result)) {
            // Update password
            $updateData = ["password" => $newPassword];
            $obj->update("user", $updateData, "id = '$userId'");
            $updateResult = $obj->getresult();

            if ($updateResult) {
                echo json_encode(['message' => 'Password updated successfully']);
            } else {
                echo json_encode(['message' => 'Password update failed']);
            }
        } else {
            echo json_encode(['message' => 'Old password is incorrect']);
        }
    } catch (Exception $e) {
        http_response_code(503);
        echo json_encode(['message' => 'Connection error']);
    }
}

?>
<!-- {
  "id": "1",
  "old_password": "12345",
  "new_password": "67890"
} -->
