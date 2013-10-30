<?php defined('SYSPATH') or die('No direct script access.');

//TODO don't allow restricted user names (admin, default) on app as well!

// -- Environment setup --------------------------------------------------------

// Load the core Kohana class
require SYSPATH.'classes/Kohana/Core'.EXT;

if (is_file(APPPATH.'classes/Kohana'.EXT))
{
	// Application extends the core
	require APPPATH.'classes/Kohana'.EXT;
}
else
{
	// Load empty core extension
	require SYSPATH.'classes/Kohana'.EXT;
}

/**
 * Set the default time zone.
 *
 * @link http://kohanaframework.org/guide/using.configuration
 * @link http://www.php.net/manual/timezones
 */
date_default_timezone_set('Australia/Melbourne');

/**
 * Set the default locale.
 *
 * @link http://kohanaframework.org/guide/using.configuration
 * @link http://www.php.net/manual/function.setlocale
 */
setlocale(LC_ALL, 'en_US.utf-8');

/**
 * Enable the Kohana auto-loader.
 *
 * @link http://kohanaframework.org/guide/using.autoloading
 * @link http://www.php.net/manual/function.spl-autoload-register
 */
spl_autoload_register(array('Kohana', 'auto_load'));

/**
 * Optionally, you can enable a compatibility auto-loader for use with
 * older modules that have not been updated for PSR-0.
 *
 * It is recommended to not enable this unless absolutely necessary.
 */
//spl_autoload_register(array('Kohana', 'auto_load_lowercase'));

/**
 * Enable the Kohana auto-loader for unserialization.
 *
 * @link http://www.php.net/manual/function.spl-autoload-call
 * @link http://www.php.net/manual/var.configuration#unserialize-callback-func
 */
ini_set('unserialize_callback_func', 'spl_autoload_call');

// -- Configuration and initialization -----------------------------------------

/**
 * Set the default language
 */
I18n::lang('en-us');

/**
 * Set Kohana::$environment if a 'KOHANA_ENV' environment variable has been supplied.
 *
 * Note: If you supply an invalid environment name, a PHP warning will be thrown
 * saying "Couldn't find constant Kohana::<INVALID_ENV_NAME>"
 */
if (isset($_SERVER['KOHANA_ENV']))
{
	Kohana::$environment = constant('Kohana::'.strtoupper($_SERVER['KOHANA_ENV']));
}

/**
 * Initialize Kohana, setting the default options.
 *
 * The following options are available:
 *
 * - string   base_url    path, and optionally domain, of your application   NULL
 * - string   index_file  name of your index file, usually "index.php"       index.php
 * - string   charset     internal character set used for input and output   utf-8
 * - string   cache_dir   set the internal cache directory                   APPPATH/cache
 * - integer  cache_life  lifetime, in seconds, of items cached              60
 * - boolean  errors      enable or disable error handling                   TRUE
 * - boolean  profile     enable or disable internal profiling               TRUE
 * - boolean  caching     enable or disable internal caching                 FALSE
 * - boolean  expose      set the X-Powered-By header                        FALSE
 */
Kohana::init(array(
	'base_url'   => '/',
    'index_file' => '',
));

Cookie::$salt = 'your_cookie_salt_here';

/**
 * Attach the file write to logging. Multiple writers are supported.
 */
Kohana::$log->attach(new Log_File(APPPATH.'logs'));

/**
 * Attach a file reader to config. Multiple readers are supported.
 */
Kohana::$config->attach(new Config_File);

/**
 * Enable modules. Modules are referenced by a relative or absolute path.
 */
Kohana::modules(array(
	'auth'       => MODPATH.'auth',       // Basic authentication
	// 'cache'      => MODPATH.'cache',      // Caching with multiple backends
	// 'codebench'  => MODPATH.'codebench',  // Benchmarking tool
	'database'   => MODPATH.'database',   // Database access
	// 'image'      => MODPATH.'image',      // Image manipulation
	// 'minion'     => MODPATH.'minion',     // CLI Tasks
	'orm'        => MODPATH.'orm',        // Object Relationship Mapping
	// 'unittest'   => MODPATH.'unittest',   // Unit testing
	'userguide'  => MODPATH.'userguide',  // User guide and API documentation
));

/**
 * Set the routes. Each route must have a minimum of a name, a URI and a set of
 * defaults for the URI.
 */

/* API routes */

Route::set('load_user', 'api/load_participant/<username>')
    ->defaults(array(
        'controller' => 'api',
        'action' => 'load_participant'
    ));

Route::set('load_users', 'api/load_participants')
    ->defaults(array(
        'controller' => 'api',
        'action' => 'load_participants'
    ));

Route::set('save_user', 'api/save_participant/<username>')
    ->defaults(array(
        'controller' => 'api',
        'action' => 'save_participant'
    ));

Route::set('save_users', 'api/save_participants')
    ->defaults(array(
        'controller' => 'api',
        'action' => 'save_participants'
    ));

Route::set('upload', 'api/upload_logs')
    ->defaults(array(
    'controller' => 'api',
    'action' => 'upload_logs'
));

Route::set('list_users', 'api/list_participants')
    ->defaults(array(
        'controller' => 'api',
        'action' => 'list_participants'
    ));

Route::set('images_download', 'api/imageset/<id>')
    ->defaults(array(
        'controller' => 'api',
        'action' => 'imageset'
    ));

/* Website routes */

Route::set('export', 'export/<action>')
    ->defaults(array(
        'controller' => 'export'
    ));

Route::set('imageset_delete', 'images/<id>/delete')
    ->defaults(array(
        'controller' => 'images',
        'action' => 'delete'
    ));

Route::set('images', 'images')
    ->defaults(array(
        'controller' => 'images',
        'action' => 'index'
    ));

Route::set('configurations', 'participants/<username>/configurations(/<configid>)')
    ->defaults(array(
        'controller' => 'participants',
        'action' => 'configurations'
    ));

Route::set('add_participant', 'participants/add')
    ->defaults(array(
        'controller' => 'participants',
        'action' => 'add'
    ));

Route::set('participants', 'participants(/<username>)')
    ->defaults(array(
    'controller' => 'participants',
    'action' => 'index'
));

Route::set('security', 'security/<action>')
    ->defaults(array(
    'controller' => 'security'
));

Route::set('default', '(<action>)')
	->defaults(array(
		'controller' => 'main',
		'action'     => 'index',
	));
