<?php

namespace OCA\MyStorageApp\Storage;

use \OCP\Files\Storage\StorageAdapter;
use Icewind\Streams\IteratorDirectory;
use Icewind\Streams\CallbackWrapper;

// for this storage we use a fake library
use \SomeVendor\FakeStorageLib;

class MyStorage extends StorageAdapter {
	/**
	 * Storage parameters
	 */
	private $params;

	/**
	 * Connection
	 *
	 * @var \SomeVendor\FakeStorageLib\Connection
	 */
	private $connection;

	public function __construct($params) {
		// validate and store parameters here, don't initialize the storage yet
		$this->params = $params;
	}

	public function getConnection() {
		if ($this->connection === null) {
			// do the connection to the storage lazily
			$this->connection = new \SomeVendor\FakeStorageLib\Connection($params);
		}
		return $this->connection;
	}

	public function getId() {
		// id specific to this storage type and also unique for the specified user and path
		return 'mystorage::' . $this->params['user'] . '@' . $this->params['host'] . '/' . $this->params['root'];
	}

	public function filemtime($path) {
		return $this->connection->getModifiedTime($path);
	}

	public function filesize($path) {
		// let's say the library doesn't support getting the size directly,
		// so we use stat instead
		$data = $this->stat($path);
		return $data['size'];
	}

	public function filetype($path) {
		if ($this->connection->isDirectory($path)) {
			return 'dir';
		}
		return 'file';
	}

	public function mkdir($path) {
		return $this->connection->createDirectory($path);
	}

	public function rmdir($path) {
		return $this->connection->delete($path);
	}

	public function unlink($path) {
		return $this->connection->delete($path);
	}

	public function file_get_contents($path) {
		return $this->connection->getContents($path);
	}

	public function file_put_contents($path) {
		return $this->connection->setContents($path);
	}

	public function touch($path, $time = null) {
		if ($time === null) {
			$time = time();
		}

		// many libraries might not support touch, so need to adapt
		if (!$this->file_exists($path)) {
			// create empty file
			$this->file_put_contents($path, '');
		}
		// set mtime to existing file
		return $this->connection->setModifiedTime($path, $time);
	}

	public function file_exists($path) {
		return $this->connection->pathExists($path);
	}

	public function rename($source, $target) {
		return $this->connection->move($source, $target);
	}

	public function copy($source, $target) {
		return $this->connection->copy($source, $target);
	}

	public function opendir($path) {
		// let's say the library returns an array of entries
		$allEntries = $this->connection->listFolder($path);
		// extract the names
		$names = array_map(function ($object) {
			return $object['name'];
		}, $allEntries);

		// wrap them in an iterator
		return IteratorDirectory::wrap($names);
	}

	public function stat($path) {
		$data = $this->connection->getMetadata($path);
		// convert to format expected by ownCloud
		return [
			'mtime' => $data['mtime'],
			'size' => $data['size'],
		];
	}

	public function fopen($path, $mode) {
		switch ($mode) {
			case 'r':
			case 'rb':
				// this works if the library returns a PHP stream directly
				return $this->connection->getStream($path);
			case 'w':
			case 'w+':
			case 'wb':
			case 'wb+':
			case 'a':
			case 'ab':
			case 'r+':
			case 'a+':
			case 'x':
			case 'x+':
			case 'c':
			case 'c+':
				// most storages do not support on the fly stream upload for all modes,
				// so we use a temporary file first
				$ext = pathinfo($filename, PATHINFO_EXTENSION);
				$tmpFile = \OC::$server->getTempManager()->getTemporaryFile($ext);

				// this wrapper will call the callback whenever fclose() was called on the file,
				// after which we send the file to the library
				$result = CallbackWrapper::wrap(
					$source,
					null,
					null,
					function () use ($tmpFile, $path) {
						$this->connection->putFile($tmpFile, $path);
						unlink($tmpFile);
					}
				);
		}
		return false;
	}

	public function isReadable($path) {
		return $this->connection->canRead($path);
	}

	public function isUpdatable($path) {
		return $this->connection->canUpdate($path);
	}

	public function isCreatable($path) {
		return $this->connection->canUpdate($path);
	}

	public function isDeletable($path) {
		return $this->connection->canUpdate($path);
	}

	public function isSharable($path) {
		return $this->connection->canRead($path);
	}
}