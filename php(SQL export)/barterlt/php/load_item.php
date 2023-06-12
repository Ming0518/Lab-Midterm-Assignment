<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlloadcatches = "SELECT * FROM `info_items` WHERE user_id = '$userid'";
}if (isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloadcatches = "SELECT * FROM `info_items` WHERE name LIKE '%$search%'";
}else{
	$sqlloadcatches = "SELECT * FROM `info_items`";
}



$result = $conn->query($sqlloadcatches);
if ($result->num_rows > 0) {
    $items["items"] = array();
	while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['id'];
        $itemlist['item_name'] = $row['name'];
        //$itemlist['catch_type'] = $row['catch_type'];
        $itemlist['item_desc'] = $row['descrip'];
        $itemlist['item_value'] = $row['value'];
        //$itemlist['catch_qty'] = $row['catch_qty'];
        $itemlist['item_lat'] = $row['lat'];
        $itemlist['item_long'] = $row['longt'];
        $itemlist['item_state'] = $row['state'];
        $itemlist['item_locality'] = $row['locality'];
		$itemlist['item_date'] = $row['date'];
        array_push($items["items"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $items);
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
