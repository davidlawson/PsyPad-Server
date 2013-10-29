<?php defined('SYSPATH') OR die('No direct script access.');

class Kohana_Exception extends Kohana_Kohana_Exception
{
    /**
     * Get a Response object representing the exception
     *
     * @uses    Kohana_Exception::text
     * @param   Exception  $e
     * @return  Response
     */
    public static function response(Exception $e)
    {
        try
        {
            // Get the exception information
            $class   = get_class($e);
            $code    = $e->getCode();
            $message = $e->getMessage();
            $file    = $e->getFile();
            $line    = $e->getLine();
            $trace   = $e->getTrace();

            /**
             * HTTP_Exceptions are constructed in the HTTP_Exception::factory()
             * method. We need to remove that entry from the trace and overwrite
             * the variables from above.
             */
            if ($e instanceof HTTP_Exception AND $trace[0]['function'] == 'factory')
            {
                extract(array_shift($trace));
            }


            if ($e instanceof ErrorException)
            {
                /**
                 * If XDebug is installed, and this is a fatal error,
                 * use XDebug to generate the stack trace
                 */
                if (function_exists('xdebug_get_function_stack') AND $code == E_ERROR)
                {
                    $trace = array_slice(array_reverse(xdebug_get_function_stack()), 4);

                    foreach ($trace as & $frame)
                    {
                        /**
                         * XDebug pre 2.1.1 doesn't currently set the call type key
                         * http://bugs.xdebug.org/view.php?id=695
                         */
                        if ( ! isset($frame['type']))
                        {
                            $frame['type'] = '??';
                        }

                        // XDebug also has a different name for the parameters array
                        if (isset($frame['params']) AND ! isset($frame['args']))
                        {
                            $frame['args'] = $frame['params'];
                        }
                    }
                }

                if (isset(Kohana_Exception::$php_errors[$code]))
                {
                    // Use the human-readable error name
                    $code = Kohana_Exception::$php_errors[$code];
                }
            }

            /**
             * The stack trace becomes unmanageable inside PHPUnit.
             *
             * The error view ends up several GB in size, taking
             * serveral minutes to render.
             */
            if (defined('PHPUnit_MAIN_METHOD'))
            {
                $trace = array_slice($trace, 0, 2);
            }

            // Instantiate the error view.
            $view = View::factory(Kohana_Exception::$error_view, get_defined_vars());

            // Prepare the response object.
            $response = Response::factory();

            // Set the response status
            $response->status(($e instanceof HTTP_Exception) ? $e->getCode() : 500);

            // Set the response headers
            $response->headers('Content-Type', Kohana_Exception::$error_view_content_type.'; charset='.Kohana::$charset);

            $template = View::factory('template');
            $template->title   = 'Error';
            $template->content = $view;

            $template->breadcrumbs = array();

            $template->styles = array(
                'media/css/bootstrap.css' => 'all',
                'media/css/glyphicons.css' => 'all',
                'media/css/main.css' => 'all',
                'media/css/spectrum.css' => 'all',
            );

            $template->scripts = array(
                'media/js/vendor/jquery-1.9.0.min.js',
                'media/js/vendor/bootstrap.min.js',
                'media/js/vendor/modernizr-2.6.2.min.js',
                'media/js/vendor/jqBootstrapValidation.js',
                'media/js/vendor/spectrum.js',
                'media/js/main.js'
            );

            // Set the response body
            $response->body($template->render());
        }
        catch (Exception $e)
        {
            /**
             * Things are going badly for us, Lets try to keep things under control by
             * generating a simpler response object.
             */
            $response = Response::factory();
            $response->status(500);
            $response->headers('Content-Type', 'text/plain');
            $response->body(Kohana_Exception::text($e));
        }

        return $response;
    }
}