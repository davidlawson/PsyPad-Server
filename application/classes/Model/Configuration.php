<?php defined('SYSPATH') OR die('No direct access allowed.');

class Model_Configuration extends ORM
{
    protected $_belongs_to = array(
        'participant' => array(),
        'imageset' => array('model' => 'ImageSet')
    );

    public function edit_link()
    {
        return '/participants/'.$this->participant->username.'/configurations/'.$this->id;
    }

    public function serialize_configuration()
    {
        $data = array();

        $data["name"] = $this->name;
        $data["enabled"] = $this->enabled;
        $data["practice_configuration"] = $this->practice_configuration;
        $data["day_of_week_mon"] = $this->day_of_week_mon;
        $data["day_of_week_tue"] = $this->day_of_week_tue;
        $data["day_of_week_wed"] = $this->day_of_week_wed;
        $data["day_of_week_thu"] = $this->day_of_week_thu;
        $data["day_of_week_fri"] = $this->day_of_week_fri;
        $data["day_of_week_sat"] = $this->day_of_week_sat;
        $data["day_of_week_sun"] = $this->day_of_week_sun;

        if ($this->imageset->loaded())
        {
            $data["imageset_url"] = $this->imageset->get_url();
            if (!$this->imageset->data)
                $this->imageset->extract();

            $data["imageset_data"] = $this->imageset->data;
        }
        
        $data["loop_animated_images"] = $this->loop_animated_images;
        $data["animation_frame_rate"] = $this->animation_frame_rate;
        $data["use_staircase_method"] = $this->use_staircase_method;
        $data["number_of_staircases"] = $this->number_of_staircases;
        $data["staircase_start_level"] = $this->staircase_start_level;
        $data["number_of_reversals"] = $this->number_of_reversals;
        $data["hits_to_finish"] = $this->hits_to_finish;
        $data["staircase_min_level"] = $this->staircase_min_level;
        $data["staircase_max_level"] = $this->staircase_max_level;
        $data["delta_values"] = $this->delta_values;
        $data["questions_per_folder"] = $this->questions_per_folder;
        $data["num_wrong_to_get_easier"] = $this->num_wrong_to_get_easier;
        $data["num_correct_to_get_harder"] = $this->num_correct_to_get_harder;
        $data["background_colour"] = $this->background_colour;
        $data["show_exit_button"] = $this->show_exit_button;
        $data["exit_button_x"] = $this->exit_button_x;
        $data["exit_button_y"] = $this->exit_button_y;
        $data["exit_button_w"] = $this->exit_button_w;
        $data["exit_button_h"] = $this->exit_button_h;
        $data["exit_button_fg"] = $this->exit_button_fg;
        $data["exit_button_bg"] = $this->exit_button_bg;
        $data["num_buttons"] = $this->num_buttons;
        $data["button1_text"] = $this->button1_text;
        $data["button2_text"] = $this->button2_text;
        $data["button3_text"] = $this->button3_text;
        $data["button4_text"] = $this->button4_text;
        $data["button1_bg"] = $this->button1_bg;
        $data["button2_bg"] = $this->button2_bg;
        $data["button3_bg"] = $this->button3_bg;
        $data["button4_bg"] = $this->button4_bg;
        $data["button1_fg"] = $this->button1_fg;
        $data["button2_fg"] = $this->button2_fg;
        $data["button3_fg"] = $this->button3_fg;
        $data["button4_fg"] = $this->button4_fg;
        $data["button1_x"] = $this->button1_x;
        $data["button1_y"] = $this->button1_y;
        $data["button1_w"] = $this->button1_w;
        $data["button1_h"] = $this->button1_h;
        $data["button2_x"] = $this->button2_x;
        $data["button2_y"] = $this->button2_y;
        $data["button2_w"] = $this->button2_w;
        $data["button2_h"] = $this->button2_h;
        $data["button3_x"] = $this->button3_x;
        $data["button3_y"] = $this->button3_y;
        $data["button3_w"] = $this->button3_w;
        $data["button3_h"] = $this->button3_h;
        $data["button4_x"] = $this->button4_x;
        $data["button4_y"] = $this->button4_y;
        $data["button4_w"] = $this->button4_w;
        $data["button4_h"] = $this->button4_h;
        $data["require_next"] = $this->require_next;
        $data["time_between_each_question_mean"] = $this->time_between_each_question_mean;
        $data["time_between_each_question_plusminus"] = $this->time_between_each_question_plusminus;
        $data["infinite_presentation_time"] = $this->infinite_presentation_time;
        $data["presentation_time"] = $this->presentation_time;
        $data["use_specified_seed"] = $this->use_specified_seed;
        $data["specified_seed"] = $this->specified_seed;
        $data["attempt_facial_recognition"] = $this->attempt_facial_recognition;

        return $data;
    }

    public function copy_from($configuration)
    {
        $from_data = $configuration->as_array();
        unset($from_data["id"]);
        unset($from_data["participant_id"]);
        $this->values($from_data);
    }

    public function load_from($data)
    {
        $this->values($data);

        if (isset($data["imageset_url"]))
        {
            preg_match('/([0-9]*)$/', $data["imageset_url"], $matches);
            $imageset_id = $matches[1];
            $this->imageset = ORM::factory('ImageSet')->where('id', '=', $imageset_id)->find();
        }
    }
}
