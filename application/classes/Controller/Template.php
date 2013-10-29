<?php defined('SYSPATH') OR die('No direct script access.');

class Controller_Template extends Kohana_Controller_Template
{
    public $template = 'template';

    // Controls access for the whole controller, if not set to FALSE we will only allow user roles specified
    // Can be set to a string or an array, for example 'login' or array('login', 'admin')
    // Note that in second(array) example, user must have both 'login' AND 'admin' roles set in database
    public $auth_required = FALSE;

    // Controls access for separate actions
    // 'adminpanel' => 'admin' will only allow users with the role admin to access action_adminpanel
    // 'moderatorpanel' => array('login', 'moderator') will only allow users with the roles login and moderator to access action_moderatorpanel
    public $secure_actions = FALSE;

    public function before()
    {
        parent::before();

        $this->session= Session::instance();

        $action_name = Request::$current->action();
        if (($this->auth_required !== FALSE && Auth::instance()->logged_in() === FALSE)
            || (is_array($this->secure_actions) && array_key_exists($action_name, $this->secure_actions) &&
                Auth::instance()->logged_in($this->secure_actions[$action_name]) === FALSE))
        {
            $this->request->action('accessdenied');
        }

        if ($this->auto_render === TRUE)
        {
            // Initialize empty values
            $this->template->title   = '';
            $this->template->content = '';

            $this->template->breadcrumbs = array();

            $this->template->styles = array();
            $this->template->scripts = array();
        }
    }

    public function breadcrumb($text = null, $url = null)
    {
        if ($text == null) { $text = 'Home'; $url = '/'; }
        $this->template->breadcrumbs[] = array($text, $url);
    }

    public function action_accessdenied()
    {
        $this->template->title = 'Access Denied';
        $this->template->content = View::factory('security/accessdenied');
    }

    public function after()
    {
        if ($this->auto_render === TRUE)
        {
            $styles = array(
                'media/css/main.css' => 'all'
            );

            $scripts = array(
                'media/js/vendor/jquery-1.9.0.min.js',
                'media/js/vendor/bootstrap.min.js',
                'media/js/vendor/modernizr-2.6.2.min.js',
                'media/js/vendor/jqBootstrapValidation.js',
                'media/js/vendor/spectrum.js',
                'media/js/main.js'
            );

            $this->template->styles = array_merge( $this->template->styles, $styles );
            $this->template->scripts = array_merge( $this->template->scripts, $scripts );
        }

        parent::after();
    }
}
