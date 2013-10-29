<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Api extends Controller
{
    private function do_login()
    {
        $json = json_decode($this->request->body(), true);
        if (!$json)
        {
            $this->response->status(403);
            $this->response->body('Invalid data provided.');
            return false;
        }

        if ( ! Auth::instance()->login($json["username"], $json["password"]))
        {
            $this->response->status(403);
            $this->response->body('Bad username/password');
            return false;
        }

        return $json;
    }

    public function action_list_users()
    {
        if (!$this->do_login()) return;

        $owner = Auth::instance()->get_user();

        $output = array();

        $output["default"] = "Description";

        foreach ($owner->participants->find_all() as $participant)
        {
            $output[$participant->username] = "Description";
        }

        $this->response->body(json_encode($output));
    }

    public function action_uploadlogs()
    {
        if ( ! ($json = $this->do_login())) return;

        $owner = Auth::instance()->get_user();

        foreach($json["log_data"] as $username => $logs)
        {
            $user = $owner->participants->where('username', '=', $username)->find();
            if (!$user->loaded())
            {
                $user->username = $username;
                $user->user = $owner;
                $user->save();
            }

            foreach($logs as $log_timestamp => $log_content)
            {
                $existing_log = $user->logs->where('log_timestamp', '=', $log_timestamp)->find();
                if ($existing_log->loaded()) continue;

                $log = new Model_Log();
                $log->participant = $user;
                $log->log_timestamp = $log_timestamp;
                $log->upload_timestamp = time();
                $log->data = $log_content;
                $log->save();
            }
        }

        $this->response->body('Logs saved');
    }

    public function action_load_user()
    {
        if (!$this->do_login()) return;

        if ($username = $this->request->param('username'))
        {
            $participant = Auth::instance()->get_user()->participants
                ->where('username', '=', $username)
                ->find();

            if ($username == 'default') $participant = Auth::instance()->get_user()->default_participant;

            if ( ! $participant->loaded())
            {
                $this->response->body('User not found');
                return;
            }

            $this->response->headers('Content-Type', 'application/json');

            $configurations = array();

            foreach ($participant->configurations->order_by('position', 'ASC')->find_all() as $configuration)
            {
                $configurations[] = $configuration->serialize_configuration();
            }

            $this->response->body(json_encode($configurations));
        }
        else
        {
            $this->response->body('No user selected');
            return;
        }
    }

    public function action_load_users()
    {
        if (!$this->do_login()) return;

        $participants = Auth::instance()->get_user()->participants->find_all();

        $default_participant = Auth::instance()->get_user()->default_participant;

        $this->response->headers('Content-Type', 'application/json');

        $data = array();

        foreach ($participants as $participant)
        {
            $configurations = array();

            foreach ($participant->configurations->order_by('position', 'ASC')->find_all() as $configuration)
            {
                $configurations[] = $configuration->serialize_configuration();
            }

            $data[$participant->username] = $configurations;
        }

        $configurations = array();

        foreach ($default_participant->configurations->order_by('position', 'ASC')->find_all() as $configuration)
        {
            $configurations[] = $configuration->serialize_configuration();
        }

        $data["default"] = $configurations;

        $this->response->body(json_encode($data));
    }

    public function action_save_user()
    {
        if (!$this->do_login()) return;

        if ($username = $this->request->param('username'))
        {
            $participant = Auth::instance()->get_user()->participants
                ->where('username', '=', $username)
                ->find();

            if ($username == 'default') $participant = Auth::instance()->get_user()->default_participant;

            if ( ! $participant->loaded())
            {
                $participant = new Model_Participant();
                $participant->user = Auth::instance()->get_user();
                $participant->username = $username;
                $participant->save();
            }

            foreach ($participant->configurations->find_all() as $configuration)
            {
                $configuration->delete();
            }

            $json = json_decode($this->request->body(), true);
            $i = 0;
            foreach ($json["configurations"] as $configuration_data)
            {
                $configuration = new Model_Configuration();
                $configuration->load_from($configuration_data);
                $configuration->participant = $participant;
                $configuration->position = $i++;
                $configuration->save();
            }
        }
        else
        {
            $this->response->body('No user selected');
            return;
        }
    }

    public function action_save_users()
    {
        if (!$this->do_login()) return;

        $json = json_decode($this->request->body(), true);

        foreach ($json["users"] as $username => $configurations_data)
        {
            $participant = Auth::instance()->get_user()->participants
                ->where('username', '=', $username)
                ->find();

            if ($username == 'default') $participant = Auth::instance()->get_user()->default_participant;

            if ( ! $participant->loaded())
            {
                $participant = new Model_Participant();
                $participant->user = Auth::instance()->get_user();
                $participant->username = $username;
                $participant->save();
            }

            foreach ($participant->configurations->find_all() as $configuration)
            {
                $configuration->delete();
            }

            $i = 0;
            foreach ($configurations_data as $configuration_data)
            {
                $configuration = new Model_Configuration();
                $configuration->load_from($configuration_data);
                $configuration->participant = $participant;
                $configuration->position = $i++;
                $configuration->save();
            }
        }
    }

    public function action_upload_logs()
    {
        if (!$this->do_login()) return;
	$json = json_decode($this->request->body(), true);
	foreach ($json["log_data"] as $username => $log_data)
	{
		$participant = Auth::instance()->get_user()->participants
                ->where('username', '=', $username)
                ->find();

            if ($username == 'default') $participant = Auth::instance()->get_user()->default_participant;

                if (!$participant->loaded())
            {
                $participant->username = $username;
                $participant->user = Auth::instance()->get_user();
                $participant->save();
            }

		foreach($log_data as $one_log_id => $one_log_data)
		{
			$new_log = new Model_Log();
			$new_log->where('participant_id', '=', $participant->id)->where('log_timestamp', '=', $one_log_id)->find();
			if ($new_log->loaded()) continue;
			
			$new_log->participant = $participant;
			$new_log->data = $one_log_data;
			$new_log->log_timestamp = $one_log_id;
			$new_log->upload_timestamp = time();
			$new_log->save();
		}
	}
    }

    public function action_sync()
    {
        if (!$this->do_login()) return;

        $owner = Auth::instance()->get_user();
        $participants = $owner->participants->find_all();

        $output = '{';

        foreach($participants as $participant)
        {
            if ($participant->configuration)
                $output .= '"'.$participant->username.'": '.$participant->configuration.',';
        }

        $output .= '}';

        $this->response->headers('Content-Type', 'application/json');
        $this->response->body($output);
    }

    public function action_imageset()
    {
        $imageset_id = (int)$this->request->param('id');
        $imageset = ORM::factory('ImageSet')->where('id', '=', $imageset_id)->find();
        if ($imageset->loaded())
        {
            $this->response->headers('Content-Type', 'application/zip');
            $this->response->headers('Content-Length', @filesize($imageset->path."combined"));
            $this->response->body(file_get_contents($imageset->path."combined"));
        }
        else
        {
            $this->response->body('Image set not found');
            return;
        }
    }
}
