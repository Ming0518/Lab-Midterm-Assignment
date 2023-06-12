<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemid = $_POST['itemid'];
$name = $_POST['itemname'];
$desc = addslashes($_POST['itemdesc']);
$value = $_POST['itemvalue'];
//$catch_qty = $_POST['catchqty'];
//$catch_type = $_POST['type'];


$sqlupdate = "UPDATE `info_items` SET `name`='$name',`descrip`='$desc',`value`='$value' WHERE `item_id` = '$itemid'";

if ($conn->query($sqlupdate) === TRUE) {
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