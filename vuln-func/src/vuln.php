<?php
function goodbye($data) : array
{
	$response = [
		$msg => eval($data['payload'])
	];
	return ($response);
}

