<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Security extends Controller_Template
{
    public function action_login()
    {
        if ($this->request->method() == HTTP_Request::POST)
        {
            // Attempt to login user
            $remember = array_key_exists('remember', $this->request->post()) ? (bool) $this->request->post('remember') : FALSE;
            $user = Auth::instance()->login($this->request->post('username'), $this->request->post('password'), $remember);

            // If successful, redirect user
            if ($user)
            {
                HTTP::redirect($this->request->referrer() ? $this->request->referrer() : '/');
            }
            else
            {
                $this->template->title = 'Login failed';
                $this->template->content = '<p>Invalid username/password combination, please try again.</p>';
            }
        }
    }

    public function action_logout()
    {
        Auth::instance()->logout();
        HTTP::redirect('/');
    }

    //TODO create a form for this
    /* public function action_adduser()
     {
         // Create the user using form values

         $user = new Model_User;
         $user->create_user(array(
             'username' => '',
             'email' => '',
             'password' => '',
             'password_confirm' => '',
         ), array(
             'username',
             'password',
             'email'
         ));


        // Grant user login role
        $user->add('roles', ORM::factory('Role', array('name' => 'login')));

        #$user = ORM::factory('User')->where('username', '=', 'allison')->find();

        $default = Model_Participant::default_participant();
        $user->default_participant = $default;
        $user->save();
    }*/

}
