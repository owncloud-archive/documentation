#!/usr/bin/php
<?php
/**
 * @author Matthew Setter <matthew@matthewsetter.com> & Martin Mattel <github@diemattels.at>
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

/**
 * Class SimpleConfigReader
 * @package ConfigReader
 */
class SimpleConfigReader
{
	/**
	 * @var array
	 */
	private $config = [];

	/**
	 * String returned to the user.
	 * @var string
	 */
	private $output = '';

	/**
	 * SimpleConfigReader constructor.
	 * @param string $config
	 */
	public function __construct($config = '')
	{
		$this->config = $config;
	}

	/**
	 * Find a writable app directory path that is either defined by key 'apps_paths'
	 * or use the default owncloud_root/apps path if the key is not set 
	 *
	 * @return string
	 * @throws \Exception
	 */
	function findPath($ocAppsPath)	{

		// default path = /apps
		if (!array_key_exists('apps_paths', $this->config)) {
			$this->output = $ocAppsPath;
			return $this->output;
		}

		foreach ($this->config['apps_paths'] as $path) {
			if ($path['writable'] == true && is_writable($path['path'])) {
				$this->output = $path['path'];
				return $this->output;
			}
		}
		return "Key 'apps_paths' found, but no writable path defined or path found not writeable";
	}
}

/*
 * As per the PHP manual: The first argument $argv[0] is always the name that
 * was used to run the script. So we need at least two to access the new app's
 * name, as well as the running script's name.
 * @see https://secure.php.net/manual/en/reserved.variables.argv.php
 */
if (count($argv) != 2) {
	echo "Command usage: read-config.php <full path to ownCloud root dir> \n";
	echo "Please provide the path to the ownCloud directory. \n";
	exit(1);
}

// create a realpath and remove trailing "/" from argument if present
$ocRoot = rtrim( (string) $argv[1], "/");
$ownCloudConfigFile = sprintf("%s/config/config.php", $ocRoot);

if (!realpath($ownCloudConfigFile)) {
	// if path/file does not exist, return an error message
	echo 'File not found: ' . $ownCloudConfigFile . PHP_EOL;
} else {
	// return the path, identified by a leading "/" and no new line character at the end
    require_once($ownCloudConfigFile);
    $result = (new SimpleConfigReader($CONFIG))->findPath($ocRoot . '/apps');
	if (!strpos($result, '/')) {
		// return an error string which does not start with a leading "/"
		echo $result  . PHP_EOL;
	} else {
		// return the path, identified by a leading "/" and no new line character at the end
		echo $result;
	}
}
