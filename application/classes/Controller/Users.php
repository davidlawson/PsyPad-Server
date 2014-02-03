<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Users extends Controller_Template
{
    public function action_user()
    {
        $this->template->title = 'User Control Panel';
        $this->template->content = View::factory('users/user');
        $this->template->content->user = Auth::instance()->get_user();
    }

    public function action_users()
    {
        if ($username = $this->request->param('username'))
        {

        }
        else
        {
            $this->template->title = 'Users';
            $this->template->content = View::factory('users/users');
            $this->template->content->users = ORM::factory('User')->find_all();
        }
    }

}
