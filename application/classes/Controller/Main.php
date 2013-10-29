<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Main extends Controller_Template
{

    public function action_index()
    {
        $this->template->title = 'Home';
        $this->template->content = View::factory('index');
    }

    public function action_manual()
    {
        $users = ORM::factory('User')->find_all();
        foreach($users as $user)
        {
            $default = new Model_Participant();
            $default->username = 'Default Participant';
            $default->save();
            $user->default_participant = $default;
            $user->save();
        }
        $this->template->content = 'Done';
    }

}
