<?php
        $h = "172.17.0.1";
        $u = "sisuser";
        $p = "sispass";
	$b = "sisdb";

        $con = mysql_connect($h, $u, $p);
        mysql_select_db($b, $con);
?>
