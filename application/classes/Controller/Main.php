<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Main extends Controller_Template
{

    public function action_index()
    {
        $this->template->title = 'Home';
        $this->template->content = View::factory('index');
    }

}
