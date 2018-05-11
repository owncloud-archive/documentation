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
    $tree = [$filename => $file];
    foreach ($parts as $part) {
        if ($part === '.') {
            continue;
        }
        $tree = [$part => $tree];
    }
    $treeFiles = array_merge_recursive($treeFiles, $tree);
}

$format = function($tree, $format, $nesting = 0) {
    ksort($tree, SORT_STRING);
    $files = [];
    $return = '';

    foreach ($tree as $name => $value) {
        if (is_string($value)) {
            $files[$name] = $value;
            continue;
        }
        $return .= sprintf(
            "%s %s\n",
            str_repeat('*', $nesting + 1),
            ucfirst($name)
        );
        $return .= $format($tree[$name], $format, $nesting + 1);
    }

    foreach ($files as $name => $file) {
        $return .= sprintf(
            "%s xref:%s[%s]\n",
            str_repeat('*', $nesting + 1),
            str_replace('./', '', $file),
            ucwords(str_replace('_', ' ', pathinfo($file, PATHINFO_FILENAME)))
        );
    }

    return $return;
};
$list = $format($treeFiles, $format);

print $list;
