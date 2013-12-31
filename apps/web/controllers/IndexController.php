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

		$word = $this->request->get('word');

		$sql = "SELECT *  FROM course.courses WHERE ts_search @@ course.plainto_or_tsquery2('".$word."') ORDER BY ts_rank(ts_search, course.plainto_or_tsquery2('".$word."')) DESC LIMIT 20";
		$result = $this->db->query($sql);
		$result->setFetchMode(Phalcon\Db::FETCH_OBJ);
		$result = $result->fetchAll();

		$scws = new \Phalcon\Utils\Scws('utf8');
		$scws->set_dict("/var/www/dict.utf8.xdb");
		$scws->set_rule("/var/www/rule.utf8.ini");
		$scws->send_text($word);
		$tops = $scws->get_tops(5);
		$tmp = '';
		foreach($tops as $top) {
			$tmp = $tmp ? $tmp.'|'.$top['word'] : $top['word'];
		}
		var_dump($tmp);
		$tmp = '';
		while ($tops = $scws->get_result())
		{
			foreach($tops as $top) {
				$tmp = $tmp ? $tmp.'|'.$top['word'] : $top['word'];
			}
		}
		var_dump($tmp);exit;
	}

}
