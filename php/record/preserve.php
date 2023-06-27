<?php
require "../connect/connection.php";

$uID = $_POST['uID'];
$height = $_POST['height'];
$weight = $_POST['weight'];
$tdee = $_POST['tdee'];

$sql = "INSERT INTO record (uID, height, weight, tdee, created_at) VALUES ('$uID', '$height', '$weight', '$tdee', NOW())";
$result = $connectNow->query($sql);

?>