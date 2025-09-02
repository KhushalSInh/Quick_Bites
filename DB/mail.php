<?php

            use PHPMailer\PHPMailer\PHPMailer;
            use PHPMailer\PHPMailer\SMTP;
            use PHPMailer\PHPMailer\Exception;

          if(isset($_POST['send']))
          {
            $name=$_POST['name'];
            $em=$_POST['em'];
            $sub=$_POST['sub'];
            $msg=$_POST['msg'];
        
                          //Import PHPMailer classes into the global namespace
                //These must be at the top of your script, not inside a function
               

                //Load Composer's autoloader
                require 'PHPMailer/Exception.php';
                require 'PHPMailer/PHPMailer.php';
                require 'PHPMailer/SMTP.php';

                //Create an instance; passing `true` enables exceptions
                $mail = new PHPMailer(true);

                try {
                    //Server settings
                  
                    $mail->isSMTP();                                            //Send using SMTP
                    $mail->Host       = 'smtp.gmail.com';                     //Set the SMTP server to send through
                    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
                    $mail->Username   = 'unique.gift.store09@gmail.com';                    //SMTP username
                    $mail->Password   = 'gfmwtgrcusxizssw';                           //SMTP password
                    $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
                    $mail->Port       = 465;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

                    //Recipients
                    $mail->setFrom("$em", ' ');
                    $mail->addAddress("unique.gift.store09@gmail.com", ' ');     //Add a recipient
                  

                    //Content
                    $mail->isHTML(true);                                  //Set email format to HTML
                    $mail->Subject = 'contect form';
                    $mail->Body    = "sender name - $name <br> sender $em <br> $msg";

                    $mail->send();
                    echo "<script> alert('send'); </script>";
                    echo "<script> window.location.href = 'index.php';</script>";
                } catch (Exception $e) {
                    echo "<script> alert(' not send'); </script>: {$mail->ErrorInfo}";
                }
          }

          // welcome


          if(isset($_POST['singup']))
          {
            require 'PHPMailer/Exception.php';
            require 'PHPMailer/PHPMailer.php';
            require 'PHPMailer/SMTP.php';

            //Create an instance; passing `true` enables exceptions
            $mail = new PHPMailer(true);

            try {
                //Server settings
              
                $mail->isSMTP();                                            //Send using SMTP
                $mail->Host       = 'smtp.gmail.com';                     //Set the SMTP server to send through
                $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
                $mail->Username   = 'unique.gift.store09@gmail.com';                    //SMTP username
                $mail->Password   = 'gfmwtgrcusxizssw';                           //SMTP password
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
                $mail->Port       = 465;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

                //Recipients
                $mail->setFrom("unique.gift.store09@gmail.com", '');
                $mail->addAddress("$em", ' ');     //Add a recipient
              

                //Content
                $mail->isHTML(true);                                  //Set email format to HTML
                $mail->Subject = 'The Foodies';
                $mail->Body    = " <body>
                hello $name,
            <h1>Welcome to Thefoodies!🍔🎉</h1> <br>
            Join our community of food enthusiasts 
            and sign up today to unlock exclusive deals, faster checkout, 
            and personalized recommendations. Enter your details below to 
            savor the convenience of online ordering and enjoy a delightful fast food experience with us!

            <ul>
            our features  include :
            <li>table reserve</li>
            <li>online order</li>
            <li>online payment</li>
            <li>cash on delivery</li>

            </ul>

            <h3>thenks to join our community </h3>
            </body>  

         ";

                $mail->send();
            } catch (Exception $e) {
            }
          }


          if(isset($_POST['reset']))
          {
            require 'PHPMailer/Exception.php';
            require 'PHPMailer/PHPMailer.php';
            require 'PHPMailer/SMTP.php';

            //Create an instance; passing `true` enables exceptions
            $mail = new PHPMailer(true);
             

            try {
                //Server settings
              
                $mail->isSMTP();                                            //Send using SMTP
                $mail->Host       = 'smtp.gmail.com';                     //Set the SMTP server to send through
                $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
                $mail->Username   = 'unique.gift.store09@gmail.com';                    //SMTP username
                $mail->Password   = 'gfmwtgrcusxizssw';                           //SMTP password
                $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;            //Enable implicit TLS encryption
                $mail->Port       = 465;                                    //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS`

                //Recipients
                $mail->setFrom("unique.gift.store09@gmail.com", '');
                $mail->addAddress("$em", ' ');     //Add a recipient
              

                //Content
                $mail->isHTML(true);                                  //Set email format to HTML
                $mail->Subject = 'Your verification code :'.$otp;
                $mail->Body    = " <body>
                Please use the following code to verify that for
                Reset Password:<br>
                <br>OTP Valid for 1 minute only<br><br>

              your password reset code is :<br>
              <h2>$otp</h2>
              ";

                $mail->send();
            } catch (Exception $e) {
            }
          }


 ?>