<script>
    $(function () {
        $("input,select,textarea").not("[type=submit]").jqBootstrapValidation();

        $("input[type=color]").spectrum({
            showInput: true,
            clickoutFiresChange: true,
            preferredFormat: "hex6"
        });
    });

    function multipleValues($el, value, callback) {
        var useStaircaseMethod = $('#use_staircase_method-0:checked').length == 1;
        if (useStaircaseMethod)
        {
            var numStaircases = parseInt($('#number_of_staircases').val());
            var splitValue = value.split('/');

            if (splitValue.length != numStaircases)
            {
                callback({
                    value: value,
                    valid: false,
                    message: "You specified "+numStaircases+" staircases but provided "+splitValue.length+" here."
                });

                return;
            }

            callback({
                value: value,
                valid: value.match(/^(([0-9]+)\/)*([0-9])+]*$/),
                message: "Invalid format"
            });
        }
        else
        {
            callback({
                value: value,
                valid: true
            });
        }
    }

    function deltaValues($el, value, callback) {
        var useStaircaseMethod = $('#use_staircase_method-0:checked').length == 1;
        if (useStaircaseMethod)
        {
            var numStaircases = parseInt($('#number_of_staircases').val());
            var splitValue = value.split('/');

            if (splitValue.length != numStaircases)
            {
                callback({
                    value: value,
                    valid: false,
                    message: "You specified "+numStaircases+" staircases but provided "+splitValue.length+" here."
                });

                return;
            }

            var numReversals = $('#number_of_reversals').val().split('/');

            var valid = true;
            var message = "";

            for (var i = 0; i < splitValue.length; i++)
            {
                if (splitValue[i].split(',').length != numReversals[i])
                {
                    valid = false;
                    message = "Invalid number of values";
                    break;
                }
                else if (splitValue[i].match(/^(([0-9]+),)*([0-9])+]*$/) == null)
                {
                    valid = false;
                    message = "Invalid format";
                    break;
                }
            }

            callback({
                value: value,
                valid: valid,
                message: message
            });
        }
        else
        {
            callback({
                value: value,
                valid: true
            });
        }
    }
</script>

<form action="" method="POST" class="form-horizontal">
<fieldset>
    <legend>General Settings</legend>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="name">Configuration Name</label>
        <div class="col-lg-10">
            <input id="name" name="name" type="text" class="form-control">
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="enabled">Enabled</label>
        <div class="col-lg-10">
            <label class="radio-inline" for="enabled-0">
                <input type="radio" name="enabled" id="enabled-0" value="1">
                Yes
            </label>
            <label class="radio-inline" for="enabled-1">
                <input type="radio" name="enabled" id="enabled-1" value="0">
                No
            </label>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="practice_configuration">Is practice configuration</label>
        <div class="col-lg-10">
            <label class="radio-inline" for="practice_configuration-0">
                <input type="radio" name="practice_configuration" id="practice_configuration-0" value="1">
                Yes
            </label>
            <label class="radio-inline" for="practice_configuration-1">
                <input type="radio" name="practice_configuration" id="practice_configuration-1" value="0">
                No
            </label>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="position">Order</label>
        <div class="col-lg-10">
            <input id="position" name="position" type="number" class="form-control">
            <p class="help-block"></p>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="day_of_week">Day of week this configuration applies</label>
        <div class="col-lg-10">
            <label class="checkbox-inline" for="day_of_week_mon">
                <input type="checkbox" name="day_of_week_mon" id="day_of_week_mon" value="1">
                Mon
            </label>
            <label class="checkbox-inline" for="day_of_week_tue">
                <input type="checkbox" name="day_of_week_tue" id="day_of_week_tue" value="1">
                Tue
            </label>
            <label class="checkbox-inline" for="day_of_week_wed">
                <input type="checkbox" name="day_of_week_wed" id="day_of_week_wed" value="1">
                Wed
            </label>
            <label class="checkbox-inline" for="day_of_week_thu">
                <input type="checkbox" name="day_of_week_thu" id="day_of_week_thu" value="1">
                Thu
            </label>
            <label class="checkbox-inline" for="day_of_week_fri">
                <input type="checkbox" name="day_of_week_fri" id="day_of_week_fri" value="1">
                Fri
            </label>
            <label class="checkbox-inline" for="day_of_week_sat">
                <input type="checkbox" name="day_of_week_sat" id="day_of_week_sat" value="1">
                Sat
            </label>
            <label class="checkbox-inline" for="day_of_week_sun">
                <input type="checkbox" name="day_of_week_sun" id="day_of_week_sun" value="1">
                Sun
            </label>
        </div>
    </div>
</fieldset>

<fieldset>
    <legend>Image Sequences</legend>
    <div class="form-group">
        <label class="col-lg-2 control-label" for="imageset_id">Image sequence</label>
        <div class="col-lg-10">
            <select id="imageset_id" name="imageset_id" class="form-control">
                <option></option>
                <?php foreach($image_sequences as $image_sequence): ?>
                    <option value="<?php echo $image_sequence->id ?>"><?php echo $image_sequence->name ?></option>
                <?php endforeach ?>
            </select>

            <a href="<?php echo URL::site('images') ?>" class="btn btn-default" style="margin-top: 10px" target="_blank">Manage image sequences</a>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="loop_animated_images">Loop animated images</label>
        <div class="col-lg-10">
            <label class="radio-inline" for="loop_animated_images-0">
                <input type="radio" name="loop_animated_images" id="loop_animated_images-0" value="1">
                Yes
            </label>
            <label class="radio-inline" for="loop_animated_images-1">
                <input type="radio" name="loop_animated_images" id="loop_animated_images-1" value="0">
                No
            </label>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="animation_frame_rate">Animation frame rate</label>
        <div class="col-lg-10">
            <input id="animation_frame_rate" name="animation_frame_rate" type="number" class="form-control">
            <p class="help-block"></p>
        </div>
    </div>

</fieldset>

<fieldset>
    <legend>Staircase Method Parameters</legend>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="use_staircase_method">Use staircase method</label>
        <div class="col-lg-2">
            <label class="radio-inline" for="use_staircase_method-0">
                <input type="radio" name="use_staircase_method" id="use_staircase_method-0" value="1">
                Yes
            </label>
            <label class="radio-inline" for="use_staircase_method-1">
                <input type="radio" name="use_staircase_method" id="use_staircase_method-1" value="0">
                No
            </label>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="number_of_staircases">Number of staircases</label>
        <div class="col-lg-10">
            <input id="number_of_staircases" name="number_of_staircases" type="number" class="form-control" placeholder="Number of staircases">
            <p class="help-block"></p>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="staircase_start_level">Start level</label>
        <div class="col-lg-10">
            <input id="staircase_start_level" name="staircase_start_level" type="text" data-validation-callback-callback="multipleValues" placeholder="Staircase separator: '/', e.g. 50/60/20" class="form-control">
            <small>Staircase separator: '/', e.g. 50/60/20</small>
            <p class="help-block"></p>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="number_of_reversals">Number of reversals</label>
        <div class="col-lg-10">
            <input id="number_of_reversals" name="number_of_reversals" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 6/6/6">
            <small>Staircase separator: '/', e.g. 6/6/6</small>
            <p class="help-block"></p>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="hits_to_finish">Floor/ceiling hits to finish</label>
        <div class="col-lg-10">
            <input id="hits_to_finish" name="hits_to_finish" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 2/2/2">
            <small>Staircase separator: '/', e.g. 2/2/2</small>
            <p class="help-block"></p>

        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="staircase_min_level">Minimum level</label>
        <div class="col-lg-10">
            <input id="staircase_min_level" name="staircase_min_level" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 0/0/0">
            <small>Staircase separator: '/', e.g. 0/0/0</small>
            <p class="help-block"></p>

        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="staircase_max_level">Maximum level</label>
        <div class="col-lg-10">
            <input id="staircase_max_level" name="staircase_max_level" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 100/100/100">
            <small>Staircase separator: '/', e.g. 100/100/100</small>
            <p class="help-block"></p>

        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="delta_values">∆ values</label>
        <div class="col-lg-10">
            <input id="delta_values" name="delta_values" type="text" data-validation-callback-callback="deltaValues" class="form-control" placeholder="E.g. 8,4,2,2,2,2/16,8,4,2,2,2/2,2,2,2,2,2">
            <small>E.g. 8,4,2,2,2,2/16,8,4,2,2,2/2,2,2,2,2,2</small>
            <p class="help-block"></p>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="num_wrong_to_get_easier"># wrong to get easier</label>
        <div class="col-lg-10">
            <input id="num_wrong_to_get_easier" name="num_wrong_to_get_easier" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 1/1">
            <small>Staircase separator: '/', e.g. 1/1/1</small>
            <p class="help-block"></p>

        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="num_correct_to_get_harder"># correct to get harder</label>
        <div class="col-lg-10">
            <input id="num_correct_to_get_harder" name="num_correct_to_get_harder" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 2/2/2">
            <small>Staircase separator: '/', e.g. 2/2/2</small>
            <p class="help-block"></p>

        </div>
    </div>
</fieldset>

<fieldset>
    <legend>Method of Constant Stimuli (MOCS) Parameters</legend>
    <div class="form-group">
        <label class="col-lg-2 control-label" for="questions_per_folder"># questions per folder</label>
        <div class="col-lg-10">
            <input id="questions_per_folder" name="questions_per_folder" type="text" pattern="([0-9A-z]+:[0-9]+,)*([0-9A-z]+:[0-9]+)" placeholder="&lt;level&gt;:&lt;count&gt;,&lt;level&gt;:&lt;count&gt;..." class="form-control">
            <small>&lt;level&gt;:&lt;count&gt;,&lt;level&gt;:&lt;count&gt;...</small>
            <p class="help-block"></p>
        </div>
    </div>

</fieldset>

<fieldset>
    <legend>Display Configuration</legend>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="background_colour">Background colour</label>
        <div class="col-lg-10">
            <input id="background_colour" name="background_colour" type="color" class="form-control">
            <small>#XXXXXX (hexadecimal RGB)</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="show_exit_button">Show exit button</label>
        <div class="col-lg-10">
            <label class="radio-inline" for="show_exit_button-0">
                <input type="radio" name="show_exit_button" id="show_exit_button-0" value="1">
                Yes
            </label>
            <label class="radio-inline" for="show_exit_button-1">
                <input type="radio" name="show_exit_button" id="show_exit_button-1" value="0">
                No
            </label>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="exit_button_position">Exit button position</label>
        <div class="col-lg-2">
            <input id="exit_button_x" name="exit_button_x" type="number" class="form-control" placeholder="X position">
            <small>X position</small>
        </div>
        <div class="col-lg-2">
            <input id="exit_button_y" name="exit_button_y" type="number" class="form-control" placeholder="Y position">
            <small>Y position</small>
        </div>
        <div class="col-lg-2">
            <input id="exit_button_w" name="exit_button_w" type="number" class="form-control" placeholder="Width">
            <small>Width</small>
        </div>
        <div class="col-lg-2">
            <input id="exit_button_h" name="exit_button_h" type="number" class="form-control" placeholder="Height">
            <small>Height</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="exit_button_colour">Exit button colour</label>
        <div class="col-lg-4">
            <input id="exit_button_bg" name="exit_button_bg" type="color" class="form-control">
            <small>#XXXXXX (background)</small>
        </div>
        <div class="col-lg-4">
            <input id="exit_button_fg" name="exit_button_fg" type="color" class="form-control">
            <small>#XXXXXX (exit cross)</small>
        </div>
    </div>
</fieldset>

<fieldset>
    <legend>Button Configuration</legend>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="num_buttons">Number of buttons</label>
        <div class="col-lg-10">
            <label class="radio-inline" for="num_buttons-0">
                <input type="radio" name="num_buttons" id="num_buttons-0" value="1">
                1
            </label>
            <label class="radio-inline" for="num_buttons-1">
                <input type="radio" name="num_buttons" id="num_buttons-1" value="2">
                2
            </label>
            <label class="radio-inline" for="num_buttons-2">
                <input type="radio" name="num_buttons" id="num_buttons-2" value="3">
                3
            </label>
            <label class="radio-inline" for="num_buttons-3">
                <input type="radio" name="num_buttons" id="num_buttons-3" value="4">
                4
            </label>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="button_text">Button text</label>
        <div class="col-lg-2">
            <input id="button1_text" name="button1_text" type="text" class="form-control" placeholder="Button 1">
            <small>Button 1</small>
        </div>
        <div class="col-lg-2">
            <input id="button2_text" name="button2_text" type="text" class="form-control" placeholder="Button 2">
            <small>Button 2</small>
        </div>
        <div class="col-lg-2">
            <input id="button3_text" name="button3_text" type="text" class="form-control" placeholder="Button 3">
            <small>Button 3</small>
        </div>
        <div class="col-lg-2">
            <input id="button4_text" name="button4_text" type="text" class="form-control" placeholder="Button 4">
            <small>Button 4</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="button_bg">Background colours</label>
        <div class="col-lg-2">
            <input id="button1_bg" name="button1_bg" type="color" class="form-control">
            <small>B1 #XXXXXX</small>
        </div>
        <div class="col-lg-2">
            <input id="button2_bg" name="button2_bg" type="color" class="form-control">
            <small>B2 #XXXXXX</small>
        </div>
        <div class="col-lg-2">
            <input id="button3_bg" name="button3_bg" type="color" class="form-control">
            <small>B3 #XXXXXX</small>
        </div>
        <div class="col-lg-2">
            <input id="button4_bg" name="button4_bg" type="color" class="form-control">
            <small>B4 #XXXXXX</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="button_text">Text colours</label>
        <div class="col-lg-2">
            <input id="button1_fg" name="button1_fg" type="color" class="form-control">
            <small>B1 #XXXXXX</small>
        </div>
        <div class="col-lg-2">
            <input id="button2_fg" name="button2_fg" type="color" class="form-control">
            <small>B2 #XXXXXX</small>
        </div>
        <div class="col-lg-2">
            <input id="button3_fg" name="button3_fg" type="color" class="form-control">
            <small>B3 #XXXXXX</small>
        </div>
        <div class="col-lg-2">
            <input id="button4_fg" name="button4_fg" type="color" class="form-control">
            <small>B4 #XXXXXX</small>
        </div>
    </div>

    <!-- Text input-->
    <div class="form-group">
        <label class="col-lg-2 control-label" for="button_pos">Button positions</label>

        <label class="col-lg-1 control-label small-label">Button 1</label>
        <div class="col-lg-2">
            <input id="button1_x" name="button1_x" type="number" class="form-control" placeholder="X position">
            <small>X position</small>
        </div>
        <div class="col-lg-2">
            <input id="button1_y" name="button1_y" type="number" class="form-control" placeholder="Y position">
            <small>Y position</small>
        </div>
        <div class="col-lg-2">
            <input id="button1_w" name="button1_w" type="number" class="form-control" placeholder="Width">
            <small>Width</small>
        </div>
        <div class="col-lg-2">
            <input id="button1_h" name="button1_h" type="number" class="form-control" placeholder="Height">
            <small>Height</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-3 control-label small-label">Button 2</label>
        <div class="col-lg-2">
            <input id="button2_x" name="button2_x" type="number" class="form-control" placeholder="X position">
            <small>X position</small>
        </div>
        <div class="col-lg-2">
            <input id="button2_y" name="button2_y" type="number" class="form-control" placeholder="Y position">
            <small>Y position</small>
        </div>
        <div class="col-lg-2">
            <input id="button2_w" name="button2_w" type="number" class="form-control" placeholder="Width">
            <small>Width</small>
        </div>
        <div class="col-lg-2">
            <input id="button2_h" name="button2_h" type="number" class="form-control" placeholder="Height">
            <small>Height</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-3 control-label small-label">Button 3</label>
        <div class="col-lg-2">
            <input id="button3_x" name="button3_x" type="number" class="form-control" placeholder="X position">
            <small>X position</small>
        </div>
        <div class="col-lg-2">
            <input id="button3_y" name="button3_y" type="number" class="form-control" placeholder="Y position">
            <small>Y position</small>
        </div>
        <div class="col-lg-2">
            <input id="button3_w" name="button3_w" type="number" class="form-control" placeholder="Width">
            <small>Width</small>
        </div>
        <div class="col-lg-2">
            <input id="button3_h" name="button3_h" type="number" class="form-control" placeholder="Height">
            <small>Height</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-3 control-label small-label">Button 4</label>
        <div class="col-lg-2">
            <input id="button1_x" name="button4_x" type="number" class="form-control" placeholder="X position">
            <small>X position</small>
        </div>
        <div class="col-lg-2">
            <input id="button1_y" name="button4_y" type="number" class="form-control" placeholder="Y position">
            <small>Y position</small>
        </div>
        <div class="col-lg-2">
            <input id="button1_w" name="button4_w" type="number" class="form-control" placeholder="Width">
            <small>Width</small>
        </div>
        <div class="col-lg-2">
            <input id="button1_h" name="button4_h" type="number" class="form-control" placeholder="Height">
            <small>Height</small>
        </div>
    </div>
</fieldset>
<fieldset>
    <legend>General Test Parameters</legend>
    <div class="form-group">
        <label class="col-lg-2 control-label" for="require_next">[next] button after each response</label>
        <div class="col-lg-10">
            <label class="radio-inline" for="require_next-0">
                <input type="radio" name="require_next" id="require_next-0" value="1">
                Yes
            </label>
            <label class="radio-inline" for="require_next-1">
                <input type="radio" name="require_next" id="require_next-1" value="0">
                No
            </label>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="time_between_each_question">Time between each question (s)</label>
        <div class="col-lg-4">
            <input id="time_between_each_question" name="time_between_each_question_mean" type="text" pattern="(?:[1-9]\d*|0)?(?:\.\d+)?" class="form-control" placeholder="d.dd (Mean)">
            <small>d.dd (Mean)</small>
        </div>
        <div class="col-lg-4">
            <input id="time_between_each_question" name="time_between_each_question_plusminus" type="text" pattern="(?:[1-9]\d*|0)?(?:\.\d+)?" class="form-control" placeholder="d.dd (± variation)">
            <small>d.dd (± variation)</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="infinite_presentation_time">Infinite presentation time</label>
        <div class="col-lg-2">
            <label class="radio-inline" for="infinite_presentation_time-0">
                <input type="radio" name="infinite_presentation_time" id="infinite_presentation_time-0" value="1">
                Yes
            </label>
            <label class="radio-inline" for="infinite_presentation_time-1">
                <input type="radio" name="infinite_presentation_time" id="infinite_presentation_time-1" value="0">
                No
            </label>
        </div>

        <div class="col-lg-8">
            <input id="presentation_time" name="presentation_time" type="text" class="form-control" pattern="(?:[1-9]\d*|0)?(?:\.\d+)?" placeholder="d.dd (Presentation time if not infinite, in seconds)">
            <small>d.dd (Presentation time if not infinite, in seconds)</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="use_specified_seed">Use specified seed</label>
        <div class="col-lg-2">
            <label class="radio-inline" for="use_specified_seed-0">
                <input type="radio" name="use_specified_seed" id="use_specified_seed-0" value="1">
                Yes
            </label>
            <label class="radio-inline" for="use_specified_seed-1">
                <input type="radio" name="use_specified_seed" id="use_specified_seed-1" value="0">
                No
            </label>
        </div>
        <div class="col-lg-8">
            <input id="specified_seed" name="specified_seed" type="number" class="form-control" placeholder="Specified seed">
            <small>Specified seed</small>
        </div>
    </div>

    <div class="form-group">
        <label class="col-lg-2 control-label" for="attempt_facial_recognition">Attempt facial recognition</label>
        <div class="col-lg-10">
            <label class="radio-inline" for="attempt_facial_recognition-0">
                <input type="radio" name="attempt_facial_recognition" id="attempt_facial_recognition-0" value="1">
                Yes
            </label>
            <label class="radio-inline" for="attempt_facial_recognition-1">
                <input type="radio" name="attempt_facial_recognition" id="attempt_facial_recognition-1" value="0">
                No
            </label>
        </div>
    </div>
</fieldset>

<button type="submit" name="action" value="save" class="btn btn-default">Save Configuration</button>
</form>
