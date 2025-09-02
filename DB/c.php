<?php
function str_openssl_enc($str,$iv){
    $key='1234567890kittu';
    $chiper="AES-128-CTR";
    $options=0;
    $str=openssl_encrypt($str,$chiper,$key,$options,$iv);
    return $str;
  }

  function str_openssl_dec($str,$iv){
    $key='1234567890kittu';
    $chiper="AES-128-CTR";
    $options=0;
    $str=openssl_decrypt($str,$chiper,$key,$options,$iv);
    return $str;
  }
  
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <script>
      if ( window.history.replaceState ) {
            window.history.replaceState( null, null, window.location.href );
            }
    </script>
    <?php include 'component/jsfile.php'; ?>
    
<!-- </body>
</html> -->

<?php

    // login 

    session_start();
    error_reporting(0);

    if($_SESSION['role_user']=="user"){
       header("location:index.php"); 
    }
    
    
    $con = mysqli_connect("localhost","root","","fast-food");

    if(isset($_POST['user_login']))
    {

        $em = $_POST['email'];
        $pass = $_POST['pass'];

        if(empty($em)){
            header("location:login.php?error=Username is require");
        }
        elseif(empty($pass)){
            header("location:login.php?error=Password is require");
        }
        else
        {

        //    $sql = "SELECT * FROM `login` WHERE email='$em' AND  pass='$pass';";
           $sql = "SELECT * FROM `login` WHERE email='$em';";
           $qry=mysqli_query($con,$sql);
           $num=mysqli_num_rows($qry);
           $row=mysqli_fetch_array($qry);

           $iv=hex2bin($row['iv']);
		   $password=str_openssl_dec($row['pass'],$iv);



                    if($num == 1)
                    {
                         if($row['email']=="$em")
                            {
                                if($password ==$pass)
                                {
                                    $_SESSION['role_user'] = "user";
                                    $_SESSION["bk"] = "book";
                                    $_SESSION['id'] = $row['id'];
                                    setcookie('role_user',$_SESSION['role_user'],time() + (86400 * 10), "/");
                                    setcookie('id',$_SESSION['id'],time() + (86400 * 10), "/");

                                    include 'a.php';

                                } else{
                                    header("location:login.php?error=incorrect password");
                                }
                               
                            }
                            else{
                                header("location:login.php?error=incorrect Email");
                            }
                     } else
                    {
                        header("location:login.php?error=Invalid Email and password");
                    }

        }
       

   } 


  
    

// singup

   if(isset($_POST['singup']))
   {

    $name = $_POST['name'];
    $mobile = $_POST['mobile'];
    $em = $_POST['email'];
    $pass = $_POST['pass'];
    $iv=openssl_random_pseudo_bytes(16);
	$Password=str_openssl_enc($pass,$iv);

    $iv=bin2hex($iv);



    $sql = "SELECT * FROM `login` WHERE email='$em';";
    $qry=mysqli_query($con,$sql);

    $num=mysqli_num_rows($qry);
    $row=mysqli_fetch_array($qry);

     if($num>=1)
     {
        header("location:singup.php?error=an email is allredy exisst");

     }
     else{

        
                   $sql="INSERT INTO `login` (`email`, `pass`,`name`, `mobile`,`iv`) VALUES ('$em', '$Password','$name','$mobile','$iv');";
                 

               
                               if(mysqli_query($con,$sql))
                               { 
                               $_SESSION['role_user'] = "user";
                               setcookie('role_user',$_SESSION['role_user'],time() + (86400 * 10), "/");

                               $sql1 = "SELECT * FROM `login` WHERE email='$em' AND  pass='$pass';";
                               $qry1=mysqli_query($con,$sql1);
                               $ro=mysqli_fetch_array($qry1);

                               $_SESSION['id'] = $ro['id'];
                               setcookie('id',$ro['id'],time() + (86400 * 10), "/");

                               $id=$ro['id'];

                               $s="INSERT INTO `address`(`user_id`, `name`) VALUES ('$id','$name');";
                               $qr=mysqli_query($con,$s);

                               include 'a.php';
                               include 'mail.php';
                                    ?>
                                    <script>
                                        Swal.fire({
                                    position: "center",
                                    icon: "success",
                                    title: "Account Created Successfully",
                                    showConfirmButton: true,
                                    timer: 3000
                                    })  .then(function(){
                                        window.location = "index.php";
            
                                    });
                                    </script>
                                    <?php 

                               }
            }

                               
     }  

    // reset Password  
 if(isset($_POST['reset']))
{


        $em = $_POST['email'];
      
        $sql = "SELECT * FROM `login` WHERE email='$em';";
        $qry=mysqli_query($con,$sql);

        $num=mysqli_num_rows($qry);
        $row=mysqli_fetch_array($qry);

        if($num ==1)
        {
            $_SESSION['id']= $row['id'];
            $_SESSION['password']= "reset";
            $otp = rand(000000,999999);
            setcookie('otp',$otp,time() + (60), "/");
            include 'mail.php';
            include 'a.php';


        }
        else{
            header("location:Forget_password.php?error=invalid Emial");
            
        }
}

// varify otp

if(isset($_POST['varify']))
{


 $Fill_otp = $_POST['otp'];
 $otp = $_COOKIE['otp'];

 if($Fill_otp == $otp)
 {
    header("location:changepass.php");
     
 }
 else{
        
    header("location:fotp.php?error=invalid OTP");

 }

 
}
// update password
if(isset($_POST['change']))
{


        $pas = $_POST['pass'];
        $rpas = $_POST['repass'];
        $id = $_SESSION['id'];

       

        if($pas == $rpas)
        {
             unset($_SESSION['password']);

             $iv=openssl_random_pseudo_bytes(16);
             $Password=str_openssl_enc($pas,$iv);
         
             $iv=bin2hex($iv);
    
             
            $sql = "UPDATE `login` SET `pass` = '$Password',`iv`='$iv' WHERE `login`.`id` = '$id';";
            $qry=mysqli_query($con,$sql);
            include 'a.php';
            unset($_SESSION['id']);
        
            
        }
        else{
                
            header("location:changepass.php?error=Password Does not Match");

        }

 
}

if (isset($_POST['order_product'])) {

    if(isset($_SESSION['role_user'])){

    
     $_SESSION['qty'] = $_POST['qty'];
     header("location:order.php");  

    //  $_SESSION['order'] = "order";
    //  unset($_SESSION['order']);
    }
    else{
    header("location:login.php");
  
    }

  }


?>   
</body>
</html>
    
   