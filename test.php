<?php

$db = new SQLite3('/build/address.db');
$db->loadExtension('mod_spatialite.so');
$result = $db->query("SELECT * FROM knn WHERE f_table_name = 'address' AND ref_geometry = ST_GeomFromText('POINT(174 -41)', 4326)");
$row = $result->fetchArray();
var_dump($row);
