<?php defined('SYSPATH') OR die('No direct access allowed.');

class Model_Participant extends ORM
{
    protected $_has_many = array(
        'user_tokens' => array('model' => 'User_Token'),
        'roles'       => array('model' => 'Role', 'through' => 'roles_users'),
        'logs'        => array(),
        'configurations' => array()
    );

    protected $_belongs_to = array(
        'user' => array()
    );

    public function get_link()
    {
        return '/participants/'.$this->username;
    }

    public static function default_participant()
    {
        $participant = new Model_Participant();
        $participant->username = 'default';
        $participant->save();
        return $participant;
    }
}