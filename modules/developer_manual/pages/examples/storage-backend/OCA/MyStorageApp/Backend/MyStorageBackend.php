<?php

namespace OCA\MyStorageApp\Backend;

use \OCP\IL10N;
use \OCP\Files\External\Backend\Backend;
use \OCP\Files\External\DefinitionParameter;
use \OCP\Files\External\Auth\AuthMechanism;

class MyStorageBackend extends Backend {
	public function __construct(IL10N $l) {
		$this
			->setIdentifier('mystorage')
			// specify the storage class as defined above
			->setStorageClass('\OCA\MyStorageApp\Storage\MyStorage')
			// label as displayed in the web UI
			->setText($l->t('My Storage'))
			// configuration parameters
			->addParameters([
				(new DefinitionParameter('host', $l->t('Host'))),
				(new DefinitionParameter('root', $l->t('Root')))
					->setFlag(DefinitionParameter::FLAG_OPTIONAL),
				(new DefinitionParameter('secure', $l->t('Use SSL')))
					->setType(DefinitionParameter::VALUE_BOOLEAN),
			])
			// support for password scheme, will expect two parameters "user" and "password"
			->addAuthScheme(AuthMechanism::SCHEME_PASSWORD);
	}
}

