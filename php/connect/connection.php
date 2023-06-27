<?php

$serverhost = "localhost";
$user = "root";
$password = "1234";
$database = "health_manage";

$connectNow = new mysqli($serverhost, $user, $password, $database);
mysqli_query($connectNow,"SET NAMES 'UTF8'");  

