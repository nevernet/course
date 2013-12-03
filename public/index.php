<?php

try {

	//Register an autoloader
	$loader = new \Phalcon\Loader();
	
	$loader->registerNamespaces(array(
		'Controllers\Admin' => '../apps/web/controllers/admin/'
	));

	$loader->registerDirs(array(
		'../apps/web/controllers/',
		'../apps/web/models/'
	))->register();

	//Create a DI
	$di = new Phalcon\DI\FactoryDefault();

	//Setup the view component
	$di->set('view', function() {
		$view = new \Phalcon\Mvc\View();
		$view->setViewsDir('../apps/web/views/');
		return $view;
	});

	//Setup a base URI so that all generated URIs include the "tutorial" folder
	$di->set('url', function() {
		$url = new \Phalcon\Mvc\Url();
		$url->setBaseUri('/');
		return $url;
	});

	$di->set('router', function() {
		$router = new \Phalcon\Mvc\Router();
		$router->add('/admin/:controller/:action/:params', array(
			'namespace' => 'Controllers\Admin',
			'controller' => 1,
			'action' => 2,
			'params' => 3,
		));

		$router->add('/admin/:controller', array(
			'namespace' => 'Controllers\Admin',
			'controller' => 1
		));

		$router->add('/admin', array(
			'namespace' => 'Controllers\Admin',
			'controller' => 'index'
		));
		
		return $router;
	});

	//Handle the request
	$application = new \Phalcon\Mvc\Application($di);

	echo $application->handle()->getContent();
} catch (\Phalcon\Exception $e) {
	echo "PhalconException: ", $e->getMessage();
}

