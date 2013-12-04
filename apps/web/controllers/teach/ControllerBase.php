<?php

/**
 * Description of ControllerBase
 *
 * @author Dreamszhu dreamsxin@qq.com
 * @date Dec 4, 2013
 */

namespace Controllers\Teach;

class ControllerBase extends \Phalcon\Mvc\Controller {

	public function afterExecuteRoute() {
		$this->view->setViewsDir($this->view->getVIewsDir() . 'teach/');

		$this->assets
				->addCss('css/bootstrap.css')
				->addCss('css/bootstrap-chosen.css')
				->addCss('css/bootstrap-theme.css')
				->addCss('css/admin.css');

		$this->assets
				->addJs('js/jquery.js')
				->addJs('js/jquery.sortable.js')
				->addJs('js/bootstrap.js')
				->addJs('js/bootbox.js')
				->addJs('js/holder.js')
				->addJs('js/chosen.jquery.js');
	}

}
