<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json");

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

        $name = $data['name'] ?? '';
        $email = $data['email'] ?? '';
        $password = $data['password'] ?? '';

        // Check if email already exists
        $obj->select("user", "*", "email = '$email'");
        $existing = $obj->getresult();

        if (!empty($existing)) {
            echo json_encode(['message' => 'Email already registered']);
            exit();
        } else {
            // Insert new user
            $insertData = [
                "username" => $name,
                "email" => $email,
                "password" => $password, // Consider hashing
            ];

            $insert = $obj->insert("user", $insertData);

            if ($insert) {
                echo json_encode(['message' => 'Signup successful']);
            } else {
                echo json_encode(['message' => 'Signup failed']);
            }
        }
    } catch (Exception $e) {
        http_response_code(503); // Service Unavailable
        echo json_encode(['message' => 'Connection error ']);
    }
}
