<script>
    $(function () {
        $("input,select,textarea").not("[type=submit]").jqBootstrapValidation({
            submitError: function($form, event, errors)
            {
                alert('Please fix the '+Object.keys(errors).length+' errors on the form before continuing.');
            }
        });

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
                return {
                    value: value,
                    valid: false,
                    message: "You specified "+numStaircases+" staircases but provided "+splitValue.length+" here."
                };
            }

            return {
                value: value,
                valid: value.match(/^(([0-9]+)\/)*[0-9]+]*$/),
                message: "Invalid format"
            };
        }
        else
        {
            return {
                value: value,
                valid: true
            };
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
                return {
                    value: value,
                    valid: false,
                    message: "You specified "+numStaircases+" staircases but provided "+splitValue.length+" here."
                };

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

            return {
                value: value,
                valid: valid,
                message: message
            };
        }
        else
        {
            return {
                value: value,
                valid: true
            };
        }
    }
</script>
<?php if (isset($message)): ?><p class="alert alert-success"><?php echo $message ?></p><?php endif ?>
<form action="" method="POST" class="form-inline">
    <fieldset>
        <div class="form-group">
            <select id="configuration_load" name="configuration_load" class="form-control" style="width: 210px">
                <?php $configurations = $default_participant->configurations->find_all(); ?>
                <?php if ($configurations->count() > 0): ?><option>-</option><?php endif ?>
                <?php foreach($configurations as $a_configuration): ?>
                    <option value="<?php echo $a_configuration->id ?>">Default Participant / <?php echo $a_configuration->name ?></option>
                <?php endforeach ?>

                <?php foreach($participants as $participant): ?>
                    <?php $configurations = $participant->configurations->find_all(); ?>
                    <?php if ($configurations->count() > 0): ?><option>-</option><?php endif ?>
                    <?php foreach($configurations as $a_configuration): ?>
                        <option value="<?php echo $a_configuration->id ?>"><?php echo $participant->username ?> / <?php echo $a_configuration->name ?></option>
                    <?php endforeach ?>
                <?php endforeach ?>
            </select>
            <button type="submit" name="action" onclick="if ($('#configuration_load option:selected').text() == '-') {alert('Please select a configuration to load.'); return false;} else return confirm('Are you sure you want to continue? (this will overwrite data!)')" value="load" class="btn btn-danger">Load Configuration</button>

            <select id="configuration_copy" name="configuration_copy" class="form-control" style="width: 210px; margin-left: 20px;">
                <?php $configurations = $default_participant->configurations->find_all(); ?>
                <option>-</option>
                <?php foreach($default_participant->configurations->find_all() as $a_configuration): ?>
                    <option value="<?php echo $a_configuration->id ?>">Default Participant / <?php echo $a_configuration->name ?></option>
                <?php endforeach ?>
                <option value="new:default">Default Participant / New Configuration</option>

                <?php foreach($participants as $participant): ?>
                    <?php $configurations = $participant->configurations->find_all(); ?>
                    <option>-</option>
                    <?php foreach($participant->configurations->find_all() as $a_configuration): ?>
                        <option value="<?php echo $a_configuration->id ?>"><?php echo $participant->username ?> / <?php echo $a_configuration->name ?></option>
                    <?php endforeach ?>
                    <option value="new:<?php echo $participant->username ?>"><?php echo $participant->username ?> / New Configuration</option>
                <?php endforeach ?>
            </select>
            <button type="submit" name="action" onclick="if ($('#configuration_copy option:selected').text() == '-') {alert('Please select a configuration to copy.'); return false;} else return confirm('Are you sure you want to continue? (this will overwrite data!)')" value="copy" class="btn btn-success">Copy Configuration</button>
            <button type="submit" name="action" onclick="return confirm('Are you sure you want to delete this configuration?')" value="delete" class="btn btn-danger" style="margin-left: 20px;">Delete</button>
        </div>

    </fieldset>
</form>

<form action="" method="POST" class="form-horizontal">
    <fieldset>
        <legend>General Settings</legend>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="name">Configuration Name</label>
            <div class="col-lg-10">
                <input id="name" name="name" type="text" class="form-control" value="<?php echo $configuration->name ?>">
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="enabled">Enabled</label>
            <div class="col-lg-10">
                <label class="radio-inline" for="enabled-0">
                    <input type="radio" name="enabled" id="enabled-0" value="1"<?php if ($configuration->enabled): ?> checked="checked"<?php endif ?>>
                    Yes
                </label>
                <label class="radio-inline" for="enabled-1">
                    <input type="radio" name="enabled" id="enabled-1" value="0"<?php if (!$configuration->enabled): ?> checked="checked"<?php endif ?>>
                    No
                </label>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="practice_configuration">Is practice configuration</label>
            <div class="col-lg-10">
                <label class="radio-inline" for="practice_configuration-0">
                    <input type="radio" name="practice_configuration" id="practice_configuration-0" value="1"<?php if ($configuration->practice_configuration): ?> checked="checked"<?php endif ?>>
                    Yes
                </label>
                <label class="radio-inline" for="practice_configuration-1">
                    <input type="radio" name="practice_configuration" id="practice_configuration-1" value="0"<?php if (!$configuration->practice_configuration): ?> checked="checked"<?php endif ?>>
                    No
                </label>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="position">Order</label>
            <div class="col-lg-10">
                <input id="position" name="position" type="number" class="form-control" value="<?php echo $configuration->position ?>">
                <p class="help-block"></p>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="day_of_week">Day of week this configuration applies</label>
            <div class="col-lg-10">
                <label class="checkbox-inline" for="day_of_week_mon">
                    <input type="checkbox" name="day_of_week_mon" id="day_of_week_mon" value="1"<?php if ($configuration->day_of_week_mon): ?> checked="checked"<?php endif ?>>
                    Mon
                </label>
                <label class="checkbox-inline" for="day_of_week_tue">
                    <input type="checkbox" name="day_of_week_tue" id="day_of_week_tue" value="1"<?php if ($configuration->day_of_week_tue): ?> checked="checked"<?php endif ?>>
                    Tue
                </label>
                <label class="checkbox-inline" for="day_of_week_wed">
                    <input type="checkbox" name="day_of_week_wed" id="day_of_week_wed" value="1"<?php if ($configuration->day_of_week_wed): ?> checked="checked"<?php endif ?>>
                    Wed
                </label>
                <label class="checkbox-inline" for="day_of_week_thu">
                    <input type="checkbox" name="day_of_week_thu" id="day_of_week_thu" value="1"<?php if ($configuration->day_of_week_thu): ?> checked="checked"<?php endif ?>>
                    Thu
                </label>
                <label class="checkbox-inline" for="day_of_week_fri">
                    <input type="checkbox" name="day_of_week_fri" id="day_of_week_fri" value="1"<?php if ($configuration->day_of_week_fri): ?> checked="checked"<?php endif ?>>
                    Fri
                </label>
                <label class="checkbox-inline" for="day_of_week_sat">
                    <input type="checkbox" name="day_of_week_sat" id="day_of_week_sat" value="1"<?php if ($configuration->day_of_week_sat): ?> checked="checked"<?php endif ?>>
                    Sat
                </label>
                <label class="checkbox-inline" for="day_of_week_sun">
                    <input type="checkbox" name="day_of_week_sun" id="day_of_week_sun" value="1"<?php if ($configuration->day_of_week_sun): ?> checked="checked"<?php endif ?>>
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
                        <option value="<?php echo $image_sequence->id ?>"<?php if ($configuration->imageset == $image_sequence): ?> selected="selected"<?php endif ?>><?php echo $image_sequence->name ?></option>
                    <?php endforeach ?>
                </select>

                <a href="<?php echo URL::site('images') ?>" class="btn btn-default" style="margin-top: 10px" target="_blank">Manage image sequences</a>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="loop_animated_images">Loop animated images</label>
            <div class="col-lg-10">
                <label class="radio-inline" for="loop_animated_images-0">
                    <input type="radio" name="loop_animated_images" id="loop_animated_images-0" value="1"<?php if ($configuration->loop_animated_images): ?> checked="checked"<?php endif ?>>
                    Yes
                </label>
                <label class="radio-inline" for="loop_animated_images-1">
                    <input type="radio" name="loop_animated_images" id="loop_animated_images-1" value="0"<?php if (!$configuration->loop_animated_images): ?> checked="checked"<?php endif ?>>
                    No
                </label>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="animation_frame_rate">Animation frame rate</label>
            <div class="col-lg-10">
                <input id="animation_frame_rate" name="animation_frame_rate" type="number" class="form-control" value="<?php echo $configuration->animation_frame_rate ?>">
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
                    <input type="radio" name="use_staircase_method" id="use_staircase_method-0" value="1"<?php if ($configuration->use_staircase_method): ?> checked="checked"<?php endif ?>>
                    Yes
                </label>
                <label class="radio-inline" for="use_staircase_method-1">
                    <input type="radio" name="use_staircase_method" id="use_staircase_method-1" value="0"<?php if (!$configuration->use_staircase_method): ?> checked="checked"<?php endif ?>>
                    No
                </label>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="number_of_staircases">Number of staircases</label>
            <div class="col-lg-10">
                <input id="number_of_staircases" name="number_of_staircases" type="number" class="form-control" placeholder="Number of staircases" value="<?php echo $configuration->number_of_staircases ?>">
                <p class="help-block"></p>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="staircase_start_level">Start level</label>
            <div class="col-lg-10">
                <input id="staircase_start_level" name="staircase_start_level" type="text" data-validation-callback-callback="multipleValues" placeholder="Staircase separator: '/', e.g. 50/60/20" class="form-control" value="<?php echo $configuration->staircase_start_level ?>">
                <small>Staircase separator: '/', e.g. 50/60/20</small>
                <p class="help-block"></p>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="number_of_reversals">Number of reversals</label>
            <div class="col-lg-10">
                <input id="number_of_reversals" name="number_of_reversals" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 6/6/6" value="<?php echo $configuration->number_of_reversals ?>">
                <small>Staircase separator: '/', e.g. 6/6/6</small>
                <p class="help-block"></p>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="hits_to_finish">Floor/ceiling hits to finish</label>
            <div class="col-lg-10">
                <input id="hits_to_finish" name="hits_to_finish" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 2/2/2" value="<?php echo $configuration->hits_to_finish ?>">
                <small>Staircase separator: '/', e.g. 2/2/2</small>
                <p class="help-block"></p>

            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="staircase_min_level">Minimum level</label>
            <div class="col-lg-10">
                <input id="staircase_min_level" name="staircase_min_level" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 0/0/0" value="<?php echo $configuration->staircase_min_level ?>">
                <small>Staircase separator: '/', e.g. 0/0/0</small>
                <p class="help-block"></p>

            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="staircase_max_level">Maximum level</label>
            <div class="col-lg-10">
                <input id="staircase_max_level" name="staircase_max_level" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 100/100/100" value="<?php echo $configuration->staircase_max_level ?>">
                <small>Staircase separator: '/', e.g. 100/100/100</small>
                <p class="help-block"></p>

            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="delta_values">∆ values</label>
            <div class="col-lg-10">
                <input id="delta_values" name="delta_values" type="text" data-validation-callback-callback="deltaValues" class="form-control" value="<?php echo $configuration->delta_values ?>" placeholder="E.g. 8,4,2,2,2,2/16,8,4,2,2,2/2,2,2,2,2,2">
                <small>E.g. 8,4,2,2,2,2/16,8,4,2,2,2/2,2,2,2,2,2</small>
                <p class="help-block"></p>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="num_wrong_to_get_easier"># wrong to get easier</label>
            <div class="col-lg-10">
                <input id="num_wrong_to_get_easier" name="num_wrong_to_get_easier" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 1/1" value="<?php echo $configuration->num_wrong_to_get_easier ?>">
                <small>Staircase separator: '/', e.g. 1/1/1</small>
                <p class="help-block"></p>

            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="num_correct_to_get_harder"># correct to get harder</label>
            <div class="col-lg-10">
                <input id="num_correct_to_get_harder" name="num_correct_to_get_harder" type="text" data-validation-callback-callback="multipleValues" class="form-control" placeholder="Staircase separator: '/', e.g. 2/2/2" value="<?php echo $configuration->num_correct_to_get_harder ?>">
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
                <input id="questions_per_folder" name="questions_per_folder" type="text" pattern="([0-9A-z]+:[0-9]+,)*([0-9A-z]+:[0-9]+)" placeholder="&lt;level&gt;:&lt;count&gt;,&lt;level&gt;:&lt;count&gt;..." class="form-control" value="<?php echo $configuration->questions_per_folder ?>">
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
                <input id="background_colour" name="background_colour" type="color" class="form-control" value="<?php echo $configuration->background_colour ?>">
                <small>#XXXXXX (hexadecimal RGB)</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="show_exit_button">Show exit button</label>
            <div class="col-lg-10">
                <label class="radio-inline" for="show_exit_button-0">
                    <input type="radio" name="show_exit_button" id="show_exit_button-0" value="1"<?php if ($configuration->show_exit_button): ?> checked="checked"<?php endif ?>>
                    Yes
                </label>
                <label class="radio-inline" for="show_exit_button-1">
                    <input type="radio" name="show_exit_button" id="show_exit_button-1" value="0"<?php if (!$configuration->show_exit_button): ?> checked="checked"<?php endif ?>>
                    No
                </label>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="exit_button_position">Exit button position</label>
            <div class="col-lg-2">
                <input id="exit_button_x" name="exit_button_x" type="number" class="form-control" placeholder="X position" value="<?php echo $configuration->exit_button_x ?>">
                <small>X position</small>
            </div>
            <div class="col-lg-2">
                <input id="exit_button_y" name="exit_button_y" type="number" class="form-control" placeholder="Y position" value="<?php echo $configuration->exit_button_y ?>">
                <small>Y position</small>
            </div>
            <div class="col-lg-2">
                <input id="exit_button_w" name="exit_button_w" type="number" class="form-control" placeholder="Width" value="<?php echo $configuration->exit_button_w ?>">
                <small>Width</small>
            </div>
            <div class="col-lg-2">
                <input id="exit_button_h" name="exit_button_h" type="number" class="form-control" placeholder="Height" value="<?php echo $configuration->exit_button_h ?>">
                <small>Height</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="exit_button_colour">Exit button colour</label>
            <div class="col-lg-4">
                <input id="exit_button_bg" name="exit_button_bg" type="color" class="form-control" value="<?php echo $configuration->exit_button_bg ?>">
                <small>#XXXXXX (background)</small>
            </div>
            <div class="col-lg-4">
                <input id="exit_button_fg" name="exit_button_fg" type="color" class="form-control" value="<?php echo $configuration->exit_button_fg ?>">
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
                    <input type="radio" name="num_buttons" id="num_buttons-0" value="1"<?php if ($configuration->num_buttons == 1): ?> checked="checked"<?php endif ?>>
                    1
                </label>
                <label class="radio-inline" for="num_buttons-1">
                    <input type="radio" name="num_buttons" id="num_buttons-1" value="2"<?php if ($configuration->num_buttons == 2): ?> checked="checked"<?php endif ?>>
                    2
                </label>
                <label class="radio-inline" for="num_buttons-2">
                    <input type="radio" name="num_buttons" id="num_buttons-2" value="3"<?php if ($configuration->num_buttons == 3): ?> checked="checked"<?php endif ?>>
                    3
                </label>
                <label class="radio-inline" for="num_buttons-3">
                    <input type="radio" name="num_buttons" id="num_buttons-3" value="4"<?php if ($configuration->num_buttons == 4): ?> checked="checked"<?php endif ?>>
                    4
                </label>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="button_text">Button text</label>
            <div class="col-lg-2">
                <input id="button1_text" name="button1_text" type="text" class="form-control" placeholder="Button 1" value="<?php echo $configuration->button1_text ?>">
                <small>Button 1</small>
            </div>
            <div class="col-lg-2">
                <input id="button2_text" name="button2_text" type="text" class="form-control" placeholder="Button 2" value="<?php echo $configuration->button2_text ?>">
                <small>Button 2</small>
            </div>
            <div class="col-lg-2">
                <input id="button3_text" name="button3_text" type="text" class="form-control" placeholder="Button 3" value="<?php echo $configuration->button3_text ?>">
                <small>Button 3</small>
            </div>
            <div class="col-lg-2">
                <input id="button4_text" name="button4_text" type="text" class="form-control" placeholder="Button 4" value="<?php echo $configuration->button4_text ?>">
                <small>Button 4</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="button_bg">Background colours</label>
            <div class="col-lg-2">
                <input id="button1_bg" name="button1_bg" type="color" class="form-control" value="<?php echo $configuration->button1_bg ?>">
                <small>B1 #XXXXXX</small>
            </div>
            <div class="col-lg-2">
                <input id="button2_bg" name="button2_bg" type="color" class="form-control" value="<?php echo $configuration->button2_bg ?>">
                <small>B2 #XXXXXX</small>
            </div>
            <div class="col-lg-2">
                <input id="button3_bg" name="button3_bg" type="color" class="form-control" value="<?php echo $configuration->button3_bg ?>">
                <small>B3 #XXXXXX</small>
            </div>
            <div class="col-lg-2">
                <input id="button4_bg" name="button4_bg" type="color" class="form-control" value="<?php echo $configuration->button4_bg ?>">
                <small>B4 #XXXXXX</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="button_text">Text colours</label>
            <div class="col-lg-2">
                <input id="button1_fg" name="button1_fg" type="color" class="form-control" value="<?php echo $configuration->button1_fg ?>">
                <small>B1 #XXXXXX</small>
            </div>
            <div class="col-lg-2">
                <input id="button2_fg" name="button2_fg" type="color" class="form-control" value="<?php echo $configuration->button2_fg ?>">
                <small>B2 #XXXXXX</small>
            </div>
            <div class="col-lg-2">
                <input id="button3_fg" name="button3_fg" type="color" class="form-control" value="<?php echo $configuration->button3_fg ?>">
                <small>B3 #XXXXXX</small>
            </div>
            <div class="col-lg-2">
                <input id="button4_fg" name="button4_fg" type="color" class="form-control" value="<?php echo $configuration->button4_fg ?>">
                <small>B4 #XXXXXX</small>
            </div>
        </div>

        <!-- Text input-->
        <div class="form-group">
            <label class="col-lg-2 control-label" for="button_pos">Button positions</label>

            <label class="col-lg-1 control-label small-label">Button 1</label>
            <div class="col-lg-2">
                <input id="button1_x" name="button1_x" type="number" class="form-control" placeholder="X position" value="<?php echo $configuration->button1_x ?>">
                <small>X position</small>
            </div>
            <div class="col-lg-2">
                <input id="button1_y" name="button1_y" type="number" class="form-control" placeholder="Y position" value="<?php echo $configuration->button1_y ?>">
                <small>Y position</small>
            </div>
            <div class="col-lg-2">
                <input id="button1_w" name="button1_w" type="number" class="form-control" placeholder="Width" value="<?php echo $configuration->button1_w ?>">
                <small>Width</small>
            </div>
            <div class="col-lg-2">
                <input id="button1_h" name="button1_h" type="number" class="form-control" placeholder="Height" value="<?php echo $configuration->button1_h ?>">
                <small>Height</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-3 control-label small-label">Button 2</label>
            <div class="col-lg-2">
                <input id="button2_x" name="button2_x" type="number" class="form-control" placeholder="X position" value="<?php echo $configuration->button2_x ?>">
                <small>X position</small>
            </div>
            <div class="col-lg-2">
                <input id="button2_y" name="button2_y" type="number" class="form-control" placeholder="Y position" value="<?php echo $configuration->button2_y ?>">
                <small>Y position</small>
            </div>
            <div class="col-lg-2">
                <input id="button2_w" name="button2_w" type="number" class="form-control" placeholder="Width" value="<?php echo $configuration->button2_w ?>">
                <small>Width</small>
            </div>
            <div class="col-lg-2">
                <input id="button2_h" name="button2_h" type="number" class="form-control" placeholder="Height" value="<?php echo $configuration->button2_h ?>">
                <small>Height</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-3 control-label small-label">Button 3</label>
            <div class="col-lg-2">
                <input id="button3_x" name="button3_x" type="number" class="form-control" placeholder="X position" value="<?php echo $configuration->button3_x ?>">
                <small>X position</small>
            </div>
            <div class="col-lg-2">
                <input id="button3_y" name="button3_y" type="number" class="form-control" placeholder="Y position" value="<?php echo $configuration->button3_y ?>">
                <small>Y position</small>
            </div>
            <div class="col-lg-2">
                <input id="button3_w" name="button3_w" type="number" class="form-control" placeholder="Width" value="<?php echo $configuration->button3_w ?>">
                <small>Width</small>
            </div>
            <div class="col-lg-2">
                <input id="button3_h" name="button3_h" type="number" class="form-control" placeholder="Height" value="<?php echo $configuration->button3_h ?>">
                <small>Height</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-3 control-label small-label">Button 4</label>
            <div class="col-lg-2">
                <input id="button1_x" name="button4_x" type="number" class="form-control" placeholder="X position" value="<?php echo $configuration->button4_x ?>">
                <small>X position</small>
            </div>
            <div class="col-lg-2">
                <input id="button1_y" name="button4_y" type="number" class="form-control" placeholder="Y position" value="<?php echo $configuration->button4_y ?>">
                <small>Y position</small>
            </div>
            <div class="col-lg-2">
                <input id="button1_w" name="button4_w" type="number" class="form-control" placeholder="Width" value="<?php echo $configuration->button4_w ?>">
                <small>Width</small>
            </div>
            <div class="col-lg-2">
                <input id="button1_h" name="button4_h" type="number" class="form-control" placeholder="Height" value="<?php echo $configuration->button4_h ?>">
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
                    <input type="radio" name="require_next" id="require_next-0" value="1"<?php if ($configuration->require_next): ?> checked="checked"<?php endif ?>>
                    Yes
                </label>
                <label class="radio-inline" for="require_next-1">
                    <input type="radio" name="require_next" id="require_next-1" value="0"<?php if (!$configuration->require_next): ?> checked="checked"<?php endif ?>>
                    No
                </label>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="time_between_each_question">Time between each question (s)</label>
            <div class="col-lg-4">
                <input id="time_between_each_question" name="time_between_each_question_mean" type="text" pattern="(?:[1-9]\d*|0)?(?:\.\d+)?" class="form-control" placeholder="d.dd (Mean)" value="<?php echo $configuration->time_between_each_question_mean ?>">
                <small>d.dd (Mean)</small>
            </div>
            <div class="col-lg-4">
                <input id="time_between_each_question" name="time_between_each_question_plusminus" type="text" pattern="(?:[1-9]\d*|0)?(?:\.\d+)?" class="form-control" placeholder="d.dd (± variation)" value="<?php echo $configuration->time_between_each_question_plusminus ?>">
                <small>d.dd (± variation)</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="infinite_presentation_time">Infinite presentation time</label>
            <div class="col-lg-2">
                <label class="radio-inline" for="infinite_presentation_time-0">
                    <input type="radio" name="infinite_presentation_time" id="infinite_presentation_time-0" value="1"<?php if ($configuration->infinite_presentation_time): ?> checked="checked"<?php endif ?>>
                    Yes
                </label>
                <label class="radio-inline" for="infinite_presentation_time-1">
                    <input type="radio" name="infinite_presentation_time" id="infinite_presentation_time-1" value="0"<?php if (!$configuration->infinite_presentation_time): ?> checked="checked"<?php endif ?>>
                    No
                </label>
            </div>

            <div class="col-lg-8">
                <input id="presentation_time" name="presentation_time" type="text" class="form-control" pattern="(?:[1-9]\d*|0)?(?:\.\d+)?" placeholder="d.dd (Presentation time if not infinite, in seconds)" value="<?php echo $configuration->presentation_time ?>">
                <small>d.dd (Presentation time if not infinite, in seconds)</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="use_specified_seed">Use specified seed</label>
            <div class="col-lg-2">
                <label class="radio-inline" for="use_specified_seed-0">
                    <input type="radio" name="use_specified_seed" id="use_specified_seed-0" value="1"<?php if ($configuration->use_specified_seed): ?> checked="checked"<?php endif ?>>
                    Yes
                </label>
                <label class="radio-inline" for="use_specified_seed-1">
                    <input type="radio" name="use_specified_seed" id="use_specified_seed-1" value="0"<?php if (!$configuration->use_specified_seed): ?> checked="checked"<?php endif ?>>
                    No
                </label>
            </div>
            <div class="col-lg-8">
                <input id="specified_seed" name="specified_seed" type="number" class="form-control" placeholder="Specified seed" value="<?php echo $configuration->specified_seed ?>">
                <small>Specified seed</small>
            </div>
        </div>

        <div class="form-group">
            <label class="col-lg-2 control-label" for="attempt_facial_recognition">Attempt facial recognition</label>
            <div class="col-lg-10">
                <label class="radio-inline" for="attempt_facial_recognition-0">
                    <input type="radio" name="attempt_facial_recognition" id="attempt_facial_recognition-0" value="1"<?php if ($configuration->attempt_facial_recognition): ?> checked="checked"<?php endif ?>>
                    Yes
                </label>
                <label class="radio-inline" for="attempt_facial_recognition-1">
                    <input type="radio" name="attempt_facial_recognition" id="attempt_facial_recognition-1" value="0"<?php if (!$configuration->attempt_facial_recognition): ?> checked="checked"<?php endif ?>>
                    No
                </label>
            </div>
        </div>
    </fieldset>

    <button type="submit" name="action" value="save" class="btn btn-default">Save Configuration</button>
</form>
