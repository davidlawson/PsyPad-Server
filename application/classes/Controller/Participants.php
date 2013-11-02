<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Participants extends Controller_Template
{
    public $auth_required = TRUE;

    # /participants
    public function action_index()
    {
        $this->template->title = 'Participants';
        $this->template->content = View::factory('participants/index');
        $participant = null;

        $this->breadcrumb();
        $this->breadcrumb('Participants', '/participants');

        # /participants/<username>
        if ($username = $this->request->param('username'))
        {
            $participant = Auth::instance()->get_user()->participants
                ->where('username', '=', $username)
                ->find();

            if ($username == 'default') $participant = Auth::instance()->get_user()->default_participant;

            if ( ! $participant->loaded())
            {
                throw new HTTP_Exception_404('Participant does not exist');
            }

            if ($this->request->method() == HTTP_Request::POST)
            {
                $data = $this->request->post();
                if ($data['action'] == 'delete' && $participant->username != 'default')
                {
                    $participant->delete();
                    $this->redirect('/participants');
                }
            }

            $this->breadcrumb($participant->username, '/participants/'.$participant->username);

            $this->template->content->participant = $participant;
            $this->template->content->configurations = $participant->configurations->where('practice_configuration', '=', '0')->order_by('position', 'ASC')->find_all();
            $this->template->content->practice_configurations = $participant->configurations->where('practice_configuration', '=', '1')->order_by('position', 'ASC')->find_all();
            $this->template->content->logs = $participant->logs
                ->group_by('log_timestamp')
                ->order_by('log_timestamp', 'asc')
                ->find_all();
        }

        $this->template->sidebar = View::factory('participants/sidebar');
        $this->template->sidebar->username = $participant ? $participant->username : '';
        $this->template->sidebar->participants = Auth::instance()->get_user()->participants->find_all();
        $this->template->sidebar->default_participant = Auth::instance()->get_user()->default_participant;
    }

    # /participants/add
    public function action_add()
    {
        $this->template->title = 'Add Participant';
        $this->template->content = View::factory('participants/add');

        if ($this->request->method() == HTTP_Request::POST)
        {
            $data = $this->request->post();

            $existing = Auth::instance()->get_user()->participants->where('username', '=', $data['username'])->find();
            if ($existing->loaded())
            {
                $this->template->content->error = 'User already exists';
            }
            else if ($data['username'] == 'admin' || $data['username'] == 'default')
            {
                $this->template->content->error = 'Reserved username, please choose something else';
            }
            else
            {
                $user = new Model_Participant();
                $user->username = $data['username'];
                $user->user = Auth::instance()->get_user();
                $user->save();

                $default_user = Auth::instance()->get_user()->default_participant;
                foreach($default_user->configurations->find_all() as $configuration)
                {
                    $new_conf = new Model_Configuration();
                    $new_conf->copy_from($configuration);
                    $new_conf->participant = $user;
                    $new_conf->save();
                }

                $this->redirect('/participants/'.$user->username);
                return;
            }
        }

        $this->template->sidebar = View::factory('participants/sidebar');
        $this->template->sidebar->participants = Auth::instance()->get_user()->participants->find_all();
        $this->template->sidebar->default_participant = Auth::instance()->get_user()->default_participant;
    }

    # /participants/<username>/configurations
    public function action_configurations()
    {
        if ($username = $this->request->param('username'))
        {
            $participant = Auth::instance()->get_user()->participants
                ->where('username', '=', $username)
                ->find();

            if ($username == 'default') $participant = Auth::instance()->get_user()->default_participant;

            if ( ! $participant->loaded())
            {
                throw new HTTP_Exception_404('Participant does not exist');
            }

            $this->breadcrumb();
            $this->breadcrumb('Participants', '/participants');
            $this->breadcrumb($participant->username, '/participants/'.$participant->username);
            $this->breadcrumb('Configurations', '/participants/'.$participant->username.'/configurations');

            $configuration = $this->request->param('configid');

            # /participants/<username>/configurations
            if (!$configuration)
            {
                $this->template->title = 'Configurations';
                $this->template->content = View::factory('participants/configurations/index');
                $this->template->content->configurations = $participant->configurations->where('practice_configuration', '=', '0')->order_by('position', 'ASC')->find_all();
                $this->template->content->practice_configurations = $participant->configurations->where('practice_configuration', '=', '1')->order_by('position', 'ASC')->find_all();
                $this->template->content->participant = $participant;
            }
            # /participants/<username>/configurations/add
            elseif ($configuration == "add")
            {
                if ($this->request->method() == HTTP_Request::POST)
                {
                    if ($_POST['action'] == 'save')
                    {
                        $new_configuration = new Model_Configuration();
                        $new_configuration->participant = $participant;

                        $data = $this->request->post();
                        $data["imageset_id"] = $data["imageset_id"] ? $data["imageset_id"] : NULL;
                        $data["day_of_week_mon"] = isset($data["day_of_week_mon"]) ? $data["day_of_week_mon"] : 0;
                        $data["day_of_week_tue"] = isset($data["day_of_week_tue"]) ? $data["day_of_week_tue"] : 0;
                        $data["day_of_week_wed"] = isset($data["day_of_week_wed"]) ? $data["day_of_week_wed"] : 0;
                        $data["day_of_week_thu"] = isset($data["day_of_week_thu"]) ? $data["day_of_week_thu"] : 0;
                        $data["day_of_week_fri"] = isset($data["day_of_week_fri"]) ? $data["day_of_week_fri"] : 0;
                        $data["day_of_week_sat"] = isset($data["day_of_week_sat"]) ? $data["day_of_week_sat"] : 0;
                        $data["day_of_week_sun"] = isset($data["day_of_week_sun"]) ? $data["day_of_week_sun"] : 0;
                        $new_configuration->values($data);
                        $new_configuration->save();

                        $this->redirect('/participants/'.$participant->username.'/configurations/'.$new_configuration->id);
                        return;
                    }
                }

                $this->breadcrumb('Add Configuration', '/participants/'.$participant->username.'/configurations/add');

                $this->template->title = 'Add Configuration';
                $this->template->content = View::factory('participants/configurations/add');
                $this->template->content->image_sequences = Auth::instance()->get_user()->imagesets->find_all();
            }
            # /participants/<username>/configurations/<configid>
            else
            {
                $configuration = $participant->configurations
                    ->where('id', '=', $configuration)
                    ->find();
                if ( ! $configuration->loaded())
                {
                    throw new HTTP_Exception_404('Configuration does not exist');
                }

                $this->breadcrumb($configuration->name, '/participants/'.$participant->username.'/configurations/'.$configuration->id);

                $this->template->title = 'Add Configuration';
                $this->template->content = View::factory('participants/configurations/edit');

                if ($this->request->method() == HTTP_Request::POST)
                {
                    if ($_POST['action'] == 'save')
                    {
                        $data = $this->request->post();
                        $data["imageset_id"] = $data["imageset_id"] ? $data["imageset_id"] : NULL;
                        $data["day_of_week_mon"] = isset($data["day_of_week_mon"]) ? $data["day_of_week_mon"] : 0;
                        $data["day_of_week_tue"] = isset($data["day_of_week_tue"]) ? $data["day_of_week_tue"] : 0;
                        $data["day_of_week_wed"] = isset($data["day_of_week_wed"]) ? $data["day_of_week_wed"] : 0;
                        $data["day_of_week_thu"] = isset($data["day_of_week_thu"]) ? $data["day_of_week_thu"] : 0;
                        $data["day_of_week_fri"] = isset($data["day_of_week_fri"]) ? $data["day_of_week_fri"] : 0;
                        $data["day_of_week_sat"] = isset($data["day_of_week_sat"]) ? $data["day_of_week_sat"] : 0;
                        $data["day_of_week_sun"] = isset($data["day_of_week_sun"]) ? $data["day_of_week_sun"] : 0;
                        $configuration->values($data);
                        $configuration->save();

                        $this->template->content->message = "Configuration saved";
                    }
                    else if ($_POST['action'] == 'copy')
                    {
                        $to = $_POST['configuration_copy'];
                        if (substr($to, 0, 4) == 'new:')
                        {
                            $to = substr($to, 4);
                            $to_participant = Auth::instance()->get_user()->participants->where('username', '=', $to)->find();
                            if ($to == 'default') $to_participant = Auth::instance()->get_user()->default_participant;
                            if ($to_participant->loaded())
                            {
                                $new_configuration = new Model_Configuration();
                                $new_configuration->copy_from($configuration);
                                $new_configuration->participant = $to_participant;
                                $new_configuration->save();

                                $this->template->content->message = "Configuration copied to ".$to_participant->username.", <a href=\"/participants/".$to_participant->username."/configurations/".$new_configuration->id."\">go there now</a>";
                            }
                        }
                        else
                        {
                            $to_configuration = ORM::factory('Configuration')->where('id', '=', $to)->find();

                            if($to_configuration->loaded())
                            {
                                $to_configuration->copy_from($configuration);
                                $to_configuration->save();

                                $this->template->content->message = "Configuration copied to ".$to_configuration->participant->username.", <a href=\"/participants/".$to_configuration->participant->username."/configurations/".$to_configuration->id."\">go there now</a>";
                            }
                        }
                    }
                    else if ($_POST['action'] == 'load')
                    {
                        $from = $_POST['configuration_load'];
                        $from = ORM::factory('Configuration')->where('id', '=', $from)->find();
                        if ($from->loaded())
                        {
                            $configuration->copy_from($from);
                            $configuration->save();

                            $this->template->content->message = "Configuration loaded";
                        }
                    }
                    else if ($_POST['action'] == 'delete')
                    {
                        $configuration->delete();
                        $this->redirect('/participants/'.$participant->username);
                        return;
                    }
                }

                $this->template->content->configuration = $configuration;
                $this->template->content->participant = $participant;
                $this->template->content->image_sequences = Auth::instance()->get_user()->imagesets->find_all();
                $this->template->content->participants = Auth::instance()->get_user()->participants->find_all();
                $this->template->content->default_participant = Auth::instance()->get_user()->default_participant;
            }

            $this->template->sidebar = View::factory('participants/sidebar');
            $this->template->sidebar->username = $participant->username;
            $this->template->sidebar->participants = Auth::instance()->get_user()->participants->find_all();
            $this->template->sidebar->default_participant = Auth::instance()->get_user()->default_participant;
        }
        else
        {
            throw new HTTP_Exception_404();
        }
    }
}
