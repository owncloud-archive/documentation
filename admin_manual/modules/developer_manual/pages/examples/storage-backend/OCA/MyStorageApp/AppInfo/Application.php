<?php

namespace OCA\MyStorageApp\AppInfo;

use OCP\AppFramework\App;
use OCP\AppFramework\IAppContainer;
use OCP\IContainer;
use OCP\Files\External\Config\IBackendProvider;

/**
 * @package OCA\MyStorageApp\AppInfo
 */
class Application extends App implements IBackendProvider {
	public function __construct(array $urlParams = array()) {
		parent::__construct('mystorageapp', $urlParams);
		$container = $this->getContainer();

		// retrieve the backend service
		$backendService = $container->getServer()->getStoragesBackendService();

		// register this class as backend provider
		$backendService->registerBackendProvider($this);
	}

	/**
	 * Return a list of backends to register
	 */
	public function getBackends() {
		$container = $this->getContainer();
		$backends = [
			$container->query('OCA\MyStorageApp\Backend\MyStorageBackend'),
		];
		return $backends;
	}
}
