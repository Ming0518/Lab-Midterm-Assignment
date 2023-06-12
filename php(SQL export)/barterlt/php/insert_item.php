<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$name = $_POST['itemname'];
$desc = $_POST['itemdesc'];
$value = $_POST['itemvalue'];
//$catch_qty = $_POST['catchqty'];
//$catch_type = $_POST['type'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$imageList= $_POST["image"];
$image = json_decode($imageList);
$imagelength = count($image);

$sqlinsert = "INSERT INTO `info_items`(`id`,`name`, `descrip`, `value`, `lat`, `longt`, `state`, `locality`) VALUES ('$userid','$name','$desc','$value','$latitude','$longitude','$state','$locality')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);

foreach ($image as $key => $value) {
                $imageB64 = base64_decode($value);
                $index = $key + 1;
                file_put_contents('../assets/items/'.$filename.'_'.$index.'.png', $imageB64);
            }
	
	$response = array('status' => 'success', 'data' => null);
	
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>