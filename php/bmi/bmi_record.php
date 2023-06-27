<?php
require "../connect/connection.php";

$uID = $_POST['uID'];

$sql = "SELECT users_bmi, bmi_state FROM bmi WHERE uID = '$uID' ";
$result = $connectNow->query($sql);
if (mysqli_num_rows($result) != 0){
    $row = mysqli_fetch_assoc($result);
    if (!isset($row['users_bmi'])){
        echo "無紀錄";
    }
    else {
        echo json_encode($row);
    }
}
else {
    $sql = "INSERT INTO bmi SET uID = '$uID' ";
    $result = $connectNow->query($sql);
    echo "無紀錄";
}

?>