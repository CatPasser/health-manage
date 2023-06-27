<?php
require "../connect/connection.php";

$uID = $_POST['uID'];

$sql = "SELECT height, weight, tdee, created_at FROM record WHERE uID = '$uID' ";
$result = $connectNow->query($sql);
if(mysqli_num_rows($result) == 0){
    echo "no data";
}
else{
    while($row = $result->fetch_assoc()){
        $db_data[] = $row;
    }
    echo json_encode($db_data);
}

?>