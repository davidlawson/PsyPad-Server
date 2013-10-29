<?php defined('SYSPATH') OR die('No direct access allowed.');

class Model_ImageSet extends ORM
{
    protected $_belongs_to = array(
        'user' => array(),
    );

    public function extract()
    {
        $zip = zip_open($this->path);

        $cur_pos = 0;
        $positions = array();

        $combined = fopen($this->path."combined", "w");

        while ($zip_entry = zip_read($zip))
        {
            if (strtolower(substr(zip_entry_name($zip_entry), -3)) == "png" && zip_entry_open($zip, $zip_entry, "r"))
            {
                $buf = zip_entry_read($zip_entry, zip_entry_filesize($zip_entry));

                $name = zip_entry_name($zip_entry);
                $components = explode('/', $name);
		//$positions["debug"] = print_r($components, TRUE);
                if (count($components) == 2)
                {
                    $folder = $components[0];
                    $imgname = $components[1];
                    $positions[$folder][$imgname] = array($cur_pos, zip_entry_filesize($zip_entry));
                }
                else if (count($components) == 3)
                {
                    $folder = $components[0];
                    $anim_imgname = $components[1];
                    $anim_image = $components[2];
                    $positions[$folder][$anim_imgname][$anim_image] = array($cur_pos, zip_entry_filesize($zip_entry));
                }

                fwrite($combined, $buf);
                $cur_pos += zip_entry_filesize($zip_entry);

                zip_entry_close($zip_entry);
            }
        }

        fclose($combined);

        zip_close($zip);

        $this->data = json_encode($positions);
	$this->save();

        return $positions;
    }

    public function get_url()
    {
        return "/api/imageset/".$this->id;
    }
}
