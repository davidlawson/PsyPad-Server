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

    /*public function rules()
    {
        return array(
            'username' => array(
                array('not_empty'),
                array('max_length', array(':value', 32)),
                array(array($this, 'unique'), array('username', ':value')),
            ),
            'password' => array(
                array('not_empty'),
            ),
            'email' => array(
                array('not_empty'),
                array('email'),
                array(array($this, 'unique'), array('email', ':value')),
            ),
        );
    }*/

    public static function get_password_validation($values)
    {
        return Validation::factory($values)
            //->rule('password', 'min_length', array(':value', 8))
            ->rule('password_confirm', 'matches', array(':validation', ':field', 'password'));
    }

} // End User Model