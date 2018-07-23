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
	private $output = 'No writable apps directory was found.';

	/**
	 * SimpleConfigReader constructor.
	 * @param string $config
	 */
	public function __construct($config = '')
	{
		$this->config = $config;
	}

	/**
	 * Find the first app directory path that is set as
	 * being writable and is physically writable in the filesystem
	 *
	 * @return string
	 * @throws \Exception
	 */
	function findPath()
	{
		if (!array_key_exists('apps_paths', $this->config)) {
			throw new \Exception('Configuration is missing the apps_path key');
		}

		foreach ($this->config['apps_paths'] as $path) {
			if ($path['writable'] == true && is_writable($path['path'])) {
				$this->output = $path['path'];
				break;
			}
		}

		return $this->output;
	}
}

/*
 * As per the PHP manual: The first argument $argv[0] is always the name that
 * was used to run the script. So we need at least two to access the new app's
 * name, as well as the running script's name.
 * @see https://secure.php.net/manual/en/reserved.variables.argv.php
 */
if (count($argv) != 2) {
    echo "Need to provide the path to the ownCloud directory.";
    exit(1);
}

$ownCloudConfigFile = sprintf("%s/config/config.php", (string) $argv[1]);

if (file_exists($ownCloudConfigFile)) {
    require_once($ownCloudConfigFile);
    print (new SimpleConfigReader($CONFIG))->findPath();
}
