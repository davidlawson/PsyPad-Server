<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Users extends Controller_Template
{
    public $auth_required = TRUE;

    public function action_user()
    {
        Kohana_Auth_ORM::instance()->force_login('david');
        $this->template->title = 'User Control Panel';
        $this->template->content = View::factory('users/user');
        $this->template->content->user = Auth::instance()->get_user();

        if ($this->request->method() == HTTP_Request::POST)
        {
            $data = $this->request->post();
            if (Auth::instance()->check_password($data['old']) === FALSE)
            {
                $this->template->content->message = "Existing password entered was incorrect";
            }
            else if ($data['password'] != $data['password_confirm'])
            {
                $this->template->content->message = "Passwords do not match";
            }
            else if (strlen($data['password']) < 6)
            {
                $this->template->content->message = "Passwords must be greater than 6 characters long";
            }
            else
            {
                Auth::instance()->get_user()->password = Auth::instance()->hash($data['password']);
                Auth::instance()->get_user()->save();
                $this->template->content->message = "Password updated successfully";
            }
        }
    }

    public $secure_actions = array('users' => 'admin');

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
