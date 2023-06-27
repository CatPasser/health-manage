<?php
require "../connect/connection.php";

$uID = $_POST['uID'];
$bmi = $_POST['bmi'];
$state = $_POST['state'];

$sql = "UPDATE bmi SET users_bmi = '$bmi', bmi_state = '$state' WHERE uID = '$uID' ";
$result = $connectNow->query($sql);

?>