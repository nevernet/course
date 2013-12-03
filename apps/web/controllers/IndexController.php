<?php

/**
 * Description of IndexController
 *
 * @author dreamszhu dreamsxin@qq.com
 * @date 2013-11-29
 */
class IndexController extends \Phalcon\Mvc\Controller {

	public function indexAction() {
		$this->assets
				->addCss('css/bootstrap.css')
				->addCss('css/bootstrap-theme.css')
				->addCss('css/web.css');

		$this->assets
				->addJs('js/jquery.js')
				->addJs('js/jquery.sortable.js')
				->addJs('js/bootstrap.js');
	}

}
