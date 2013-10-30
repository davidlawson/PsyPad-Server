<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Images extends Controller_Template
{
    public $auth_required = TRUE;

    public function action_index()
    {
        $this->template->title = 'Images';
        $this->template->content = View::factory('images/index');

        if ($this->request->method() == HTTP_Request::POST)
        {
            $filename = '';
            if (isset($_FILES['file']))
            {
                $filename = $this->_save_file($_FILES['file']);
            }

            if (!$filename)
            {
                $this->template->content->message = 'Error uploading file.';
            }
            else
            {
                $data = $this->request->post();

                $imageset = new Model_ImageSet();
                $imageset->user = Auth::instance()->get_user();
                $imageset->path = $filename;
                $imageset->name = $data['name'];
                $imageset->save();

                $this->template->content->message = '<pre>'.print_r($imageset->extract(), true).'</pre>';

                // TODO validate upload here
                //$this->template->content->message = 'Upload successful!';
            }
        }

        $this->template->content->imagesets = Auth::instance()->get_user()->imagesets->find_all();
    }

    public function action_delete()
    {
        $imageset = ORM::factory('ImageSet')->where('id', '=', $this->request->param('id'))->find();
        if ($imageset->loaded())
        {
            @unlink($imageset->path);
            @unlink($imageset->path."compressed"); 
            $imageset->delete();
        }
        $this->redirect('/images');
    }

    protected function _save_file($upload)
    {
        if (
            ! Upload::valid($upload) OR
            ! Upload::not_empty($upload) OR
            ! Upload::type($upload, array('zip')))
        {
            return FALSE;
        }

        $directory = DOCROOT.'uploads/imagesets/';

        if ($file = Upload::save($upload, strtolower(Text::random('alnum', 20)).'.zip', $directory))
        {
            return $file;
        }

        return FALSE;
    }
}
