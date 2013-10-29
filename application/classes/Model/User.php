<?php defined('SYSPATH') OR die('No direct access allowed.');

class Model_User extends Model_Auth_User {

    /**
     * A user has many tokens and roles
     *
     * @var array Relationhips
     */
    protected $_has_many = array(
        'user_tokens' => array('model' => 'User_Token'),
        'roles'       => array('model' => 'Role', 'through' => 'roles_users'),
        'participants' => array(),
        'imagesets' => array('model' => 'ImageSet')
    );

    protected $_belongs_to = array(
        'default_participant' => array(
            'model' => 'Participant',
            'foreign_key' => 'default_participant_id'
        )
    );

} // End User Model