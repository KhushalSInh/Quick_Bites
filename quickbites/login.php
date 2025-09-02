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

        $email = $data['email'] ?? '';
        $password = $data['password'] ?? '';


        $obj->select("user", "*", "email = '$email' AND password = '$password'");
        $result = $obj->getresult();



        if (!empty($result) && $result[0]["password"] == $password) {
            echo json_encode(['message' => 'successful', "id" => $result[0]["id"]]);
        } else {
            echo json_encode(['message' => 'Invalid credentials']);
        }



    } catch (Exception $e) {
        http_response_code(503); // Service Unavailable
        echo json_encode(['message' => 'Connection error ']);
    }
}

?>