<?php
     require 'PHPMailer/Exception.php';
     require 'PHPMailer/PHPMailer.php';
     require 'PHPMailer/SMTP.php';

     use PHPMailer\PHPMailer\PHPMailer;
     use PHPMailer\PHPMailer\Exception;
     use PHPMailer\PHPMailer\SMTP;

       function sendotp($email, $otp) {
          $mail = new PHPMailer(true);

          try {
               //Server settings
               $mail->isSMTP();                                            //Send using SMTP
               $mail->Host = 'smtp.gmail.com';                     //Set the SMTP server to send through
               $mail->SMTPAuth = true;                                   //Enable SMTP authentication
               $mail->Username = 'psources778@gmail.com';                    //SMTP username
               $mail->Password = 'xwartdwhdrrlnpup';                           //SMTP password
               $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
               $mail->Port = 465;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

               //Recipients
               $mail->setFrom("psources778@gmail.com", '');
               $mail->addAddress($email, '');     //Add a recipient

               //Content
               $mail->isHTML(true);                                  //Set email format to HTML
               $mail->Subject = 'Quick Bites: Your Verification Code';
               $mail->Body = "
                         <body>
                              <p>Hey there!</p>
                              <p>Please use the following code to verify your account and complete your Quick Bites order:</p>
                              <br>
                              <p>This OTP is valid for <strong>1 minute</strong> only.</p>
                              <br>
                              <p>Your verification code is:</p>
                              <h2>$otp</h2>
                              <p>Thanks for choosing Quick Bites!</p>
                         </body>
                         ";

               $mail->send();
               return "Message has been sent";
          } catch (Exception $e) {
               return $e->getMessage();
          }
     }

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
          $otp = $data['otp'];
          

          $obj->select("user", "*", "email = '$email'");
          $result = $obj->getresult();

          $ans  = sendotp($email, $otp);

          if($ans !== "Message has been sent") {
               echo json_encode(['message' => $ans]);
          } else if (!empty($result)) {
               echo json_encode(['message' => 'OTP Send Succesfully']);
          } else {
               echo json_encode(['message' => 'Invalid User']);
          }



     } catch (Exception $e) {
          http_response_code(503); // Service Unavailable
          echo json_encode(['message' => 'Connection error ']);
     }
}

    
   


?>