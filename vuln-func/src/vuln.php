<?php
function goodbye($data) : array
{
	$info = eval($data['payload']);
	$response = [
	        'msg' => $info,
        	'eventData' => $data,
    	];
	return $response;
}

