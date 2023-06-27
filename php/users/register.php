<?php
require "../connect/connection.php";

$account = $_POST['account'];
$password = $_POST['password'];
$password_Hash = password_hash($password, PASSWORD_DEFAULT);

$sql = "SELECT * FROM users WHERE account = '$account' ";
$result = $connectNow->query($sql);
if (mysqli_num_rows($result) > 0) {
    echo "帳號重複";
}
else {
    $sql = "INSERT INTO users SET account = '$account', password = '$password_Hash', created_at = NOW() ";
    $result = $connectNow->query($sql);
    echo "註冊成功";
}

?>