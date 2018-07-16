#!/usr/bin/php
<?php
/**
 * @author Matthew Setter <matthew@matthewsetter.com>
 *
 * @copyright Copyright (c) 2018, ownCloud GmbH
 * @license AGPL-3.0
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License, version 3,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License, version 3,
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 *
 */
if (count($argv) != 2) {
    echo "Need to provide the path to the ownCloud directory.";
    exit(1);
}

$ownCloudConfigFile = sprintf("%s/config/config.php", (string) $argv[1]);

if (file_exists($ownCloudConfigFile)) {
    require_once($ownCloudConfigFile);
    $output = "No writable apps directory was found.";

    if (array_key_exists('apps_paths', $CONFIG)) {
        // Returns the first available app directory, if one is available.
        foreach ($CONFIG['apps_paths'] as $path) {
            if ($path['writable'] == true) {
                $output = $path['path'];
                break;
            }
        }
    }

    echo $output;
} else {
    print "Could not find the specified config file: $ownCloudConfigFile.";
}
