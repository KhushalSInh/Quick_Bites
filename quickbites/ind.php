<?php
include './class.php';
$obj = new Database();

// $obj->insert('admin',['name'=>'loki','email'=>'loki@gmail.com','pass'=>'loki']);
// $obj->update('admin',['name'=>'kittu2','email'=>'k@gmail.com'],'id = "12"');
// $obj->delete('admin','id="12"');
// $obj->selectall('admin');

$obj->selectall('admin');
// echo "Result: ";
// print_r($obj->getResult());
// $result = array();
$result = $obj->getresult();

// print_r($result);

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<tabl>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>NAME</th>
            <th>EMAIL</th>
            <Th>PASSWORD</Th>
        </tr>
    <?php
    foreach ($result as $key) {
        ?>
        <tr>
            <?php
            foreach ($key as $val) {
                ?>
                <td><?php echo $val; ?></td>
                <?php
            }
            ?>
        </tr>
        <?php
    }
    ?>
    </table>
    </body>

</html>

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
<?php 

//privacy change password
 if(isset($_POST['Change_pass']))
 {
        $opas = $_POST['opass'];
        $pas = $_POST['pass'];
        $rpas = $_POST['repass'];

      //   $sql = "SELECT * FROM `login` WHERE id='$id' and pass='$opas' ;";
        $sql = "SELECT * FROM `login` WHERE id='$id' ;";
        $qry=mysqli_query($con,$sql);
        $row=mysqli_fetch_array($qry);
        $num=mysqli_num_rows($qry);

        $iv=hex2bin($row['iv']);
        $password=str_openssl_dec($row['pass'],$iv);


         if($password == $opas){

            $pas = $_POST['pass'];
            $rpas = $_POST['repass'];
    
            if($pas == $rpas)
            {
               $iv2=openssl_random_pseudo_bytes(16);
	            $Passw=str_openssl_enc($pas,$iv2);
               $iv2=bin2hex($iv2);

                $sql = "UPDATE `login` SET `pass` = '$Passw',`iv`='$iv2' WHERE `login`.`id` = '$id';";
                $qry=mysqli_query($con,$sql);
                ?> <script>
                Swal.fire({
                    position: "center",
                        icon: "success",
                        title: "Password Change successfully",
                        showConfirmButton: true,
                        timer: 3000
                    });
                    </script> <?php
                   
            }
            else{
                    ?> <script>
                    Swal.fire({
                        position: "center",
                        icon: "error",
                        title: "Password Does not Match",
                        showConfirmButton: true,
                        timer: 3000
                        });</script>
                        <?php
        
            }

         }
        else{ 
                        ?> <script>
                Swal.fire({
                    position: "center",
                    icon: "error",
                    title: "Wrong old Password",
                    showConfirmButton: true,
                    timer: 3000
                    });</script>
                    <?php
        }  

 }