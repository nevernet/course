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
				->addCss('css/jquery.contextMenu.css')
				->addCss('css/etch.css')
				->addCss('css/core.css')
				->addCss('css/teach.css')
				->addCss('css/slide-editor.css');

		$this->assets
				->addJs('js/jquery.js')
				->addJs('js/jquery.form.js')
				->addJs('js/jquery.ui.position.js')
				->addJs('js/jquery.contextMenu.js')
				->addJs('js/underscore.js')
				->addJs('js/backbone.js')
				->addJs('js/rangy-core.js')
				->addJs('js/etch.js')
				->addJs('js/jquery.sortable.js')
				->addJs('js/jquery.event.drag-2.2.js')
				->addJs('js/jquery.event.drag.live-2.2.js')
				->addJs('js/jquery.event.drop-2.2.js')
				->addJs('js/jquery.event.drop.live-2.2.js')
				->addJs('js/bootstrap.js')
				->addJs('js/bootbox.js')
				->addJs('js/holder.js')
				->addJs('js/chosen.jquery.js')
				->addJs('js/jquery.nicescroll.js')
				->addJs('js/slide-editor.js');
	}

}
