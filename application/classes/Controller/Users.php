<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Users extends Controller_Template
{
    public function action_user()
    {
        $this->template->title = 'User Control Panel';
        $this->template->content = View::factory('users/user');
        $this->template->content->user = Auth::instance()->get_user();

        if ($this->request->method() == HTTP_Request::POST)
        {
            $data = $this->request->post();
            if (Auth::instance()->check_password($data['old']) === FALSE)
            {
                $this->template->content->message = "Existing password entered was incorrect";
                return;
            }
            else
            {
                unset($data['old']);

                try
                {
                    Auth::instance()->get_user()->update_user($data);
                    $this->template->content->message = "Password updated successfully";
                }
                catch (ORM_Validation_Exception $exception)
                {
                    $this->template->content->message = "<ul style=\"margin: 0;\">";
                    foreach($exception->errors(true)['_external'] as $field => $error)
                    {
                        $this->template->content->message .= "<li>".$error."</li>";
                    }
                    $this->template->content->message .= "</ul>";
                }
            }
        }
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
