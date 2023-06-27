<?php
require "../connect/connection.php";

$account = $_POST['account'];
$password = $_POST['password'];

$sql = "SELECT * FROM users WHERE account = '$account' ";
$result = $connectNow->query($sql);
if (mysqli_num_rows($result) == 0) {
    echo "無此帳號";
}
else {
    $row = mysqli_fetch_assoc($result);
    $uID = $row['uID'];
    $dbaccount = $row['account'];
    $dbpassword = $row['password'];
    if ($dbaccount == $account && password_verify($password, $dbpassword)) {
        echo $uID;
    }
    else {
        echo "密碼錯誤";
    }
   
}
?>