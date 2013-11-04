<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Api extends Controller
{
    private function post_data()
    {
        return json_decode($this->request->body(), true);
    }

    private function do_login()
    {
        $json = $this->post_data();
        if (!$json)
        {
            $this->response->status(403);
            $this->response->body(json_encode(array('error' => 'Invalid data provided.')));
            return false;
        }

        if ( ! Auth::instance()->login($json["username"], $json["password"]))
        {
            $this->response->status(403);
            $this->response->body(json_encode(array('error' => 'Bad username/password')));
            return false;
        }

        return true;
    }

    public function action_list_participants()
    {
        if (!$this->do_login()) return;

        $owner = Auth::instance()->get_user();

        $output = array();

        $output["default"] = $owner->default_participant->configurations->count_all() . " configurations";

        foreach ($owner->participants->find_all() as $participant)
        {
            $output[$participant->username] = $participant->configurations->count_all() . " configurations";
        }

        $this->response->headers('Content-Type', 'application/json');
        $this->response->body(json_encode($output));
        $this->response->headers('Content-Length', (string) $this->response->content_length());
    }

    public function action_load_participant()
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
                $this->response->status(404);
                $this->response->body(json_encode(array('error' => 'Participant not found')));
                return;
            }

            $this->response->headers('Content-Type', 'application/json');

            $configurations = array();

            foreach ($participant->configurations->order_by('position', 'ASC')->find_all() as $configuration)
            {
                $configurations[] = $configuration->serialize_configuration();
            }

            $this->response->body(json_encode($configurations));
            $this->response->headers('Content-Length', (string) $this->response->content_length());
        }
        else
        {
            $this->response->status(404);
            $this->response->body(json_encode(array('error' => 'No participant selected')));
            return;
        }
    }

    /**
     * Creates a new participant if they don't exist
     * Deletes all existing configurations, replaces them with provided ones
     */
    public function action_save_participant()
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

            $this->response->body(json_encode(array('success' => true)));
        }
        else
        {
            $this->response->status(404);
            $this->response->body(json_encode(array('error' => 'No participant selected')));
            return;
        }
    }

    /**
     * Creates new participants on server if they don't exist
     */
    public function action_upload_logs()
    {
        if (!$this->do_login()) return;

        $json = $this->post_data();

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

            $this->response->body(json_encode(array('success' => true)));
        }
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
            $this->response->status(404);
            $this->response->body(json_encode(array('error' => 'Image set not found')));
            return;
        }
    }
}
