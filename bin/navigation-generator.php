#!/usr/bin/env php

<?php

// Build a list of the available content
$input = stream_get_contents(fopen("php://stdin", "r"));
$files = explode("\n", $input);
$treeFiles = [];
foreach ($files as $file) {
    if (empty($file)) {
        continue;
    }
    $parts = explode('/', $file);
    $filename = array_pop($parts);
    $parts = array_reverse($parts);
    $tree = [$filename => $filename];
    foreach ($parts as $part) {
        if ($part === '.') {
            continue;
        }
        $tree = [$part => $tree];
    }
    $treeFiles = array_merge_recursive($treeFiles, $tree);
}

// Echo the aggregated content in a formatted way
$format = function($tree, $format, $nesting = 0) {
    ksort($tree, SORT_STRING);
    $files = [];
    $return = '';
    foreach ($tree as $name => $value) {
        if ($name === $value) {
            $files[] = $value;
            continue;
        }
        $return .= str_repeat('*', $nesting) . ' ' . $name . "\n";
        $return .= $format($tree[$name], $format, $nesting + 1);
    }
    foreach ($files as $file) {
        $return .= str_repeat('*', $nesting) . ' ' . $file . "\n";
    }
    return $return;
};

echo $format($treeFiles, $format);
