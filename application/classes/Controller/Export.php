<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Export extends Controller_Template
{
    public $auth_required = TRUE;
    public $auto_render = FALSE;

    public function action_logs()
    {
        $data = "";

        $users = Auth::instance()->get_user()->participants->find_all();
        foreach ($users as $user)
        {
            $logs = $user->logs
                ->order_by('log_timestamp', 'asc')
                ->group_by(array('log_id','log_timestamp'))
                ->find_all();
            foreach ($logs as $log)
            {
                $logdata = preg_replace('/^/m', $user->username."|" ,$log->data);
                $data .= $logdata;
            }
        }

        $this->response->headers('Content-Type', 'text/plain');
        $this->response->body($data);
    }

}
