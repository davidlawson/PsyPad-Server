<?php if(isset($participant)): ?>
    <?php if ($participant->username != 'default'): ?>
        <form action="" method="POST" style="float: right; width: 200px; text-align: right;" onsubmit="return confirm('Are you sure you want to delete this participant?')">
            <button type="submit" name="action" value="delete" class="btn btn-danger">Delete Participant</button>
        </form>
    <?php endif ?>

    <h2>Configurations</h2>
    <ol>
        <?php foreach($configurations as $configuration): ?>
            <li><a href="<?php echo $configuration->edit_link() ?>"><?php echo $configuration->name ?></a> [<?php if ($configuration->enabled):?>enabled<?php else: ?>disabled<?php endif; ?>, order=<?php echo $configuration->position ?>]</li>
        <?php endforeach; ?>
        <?php if (count($configurations) == 0): ?>
            <em>No configurations found.</em>
        <?php endif; ?>
    </ol>

    <h3>Practice Configurations</h3>
    <ol>
        <?php foreach($practice_configurations as $configuration): ?>
            <li><a href="<?php echo $configuration->edit_link() ?>"><?php echo $configuration->name ?></a> [<?php if ($configuration->enabled):?>enabled<?php else: ?>disabled<?php endif; ?>, order=<?php echo $configuration->position ?>]</li>
        <?php endforeach; ?>
        <?php if (count($practice_configurations) == 0): ?>
            <em>No practice configurations found.</em>
        <?php endif; ?>
    </ol>

    <a class="btn btn-default" href="/participants/<?php echo $participant->username ?>/configurations/add">Add configuration</a>

    <h2 style="margin-top: 20px;">Logs</h2>

    <?php if(count($logs) == 0): ?>
        No logs uploaded.
    <?php endif; ?>
    <?php foreach($logs as $log): ?>

        <h2><small>Log timestamp: <?php echo date('j/n/Y H:i:s', $log->log_timestamp) ?> (<?php echo $log->log_timestamp ?>)<?php if($log->upload_timestamp): ?>, upload timestamp: <?php echo date('j/n/Y H:i:s', $log->upload_timestamp) ?>
                <?php endif; ?></small></h2>
        <textarea readonly class="form-control" rows="20" style="display:inline;width:37%;font-family: monospace"><?php
            // Print out each reversal for a staircase
            echo "Summary\n";
            echo "Test date: " . date('j/n/Y H:i:s', $log->log_timestamp) . "\n";

            // First determine if it is a staircase or MOCS
            // and record start and end times
            // Also record if it is a practice test
            // Note one question MOCS treated slightly differently from >1 question MOCS
            $start_time = 0;
            $end_time = 0;
            $found_config = 0;

            foreach (preg_split("/((\r?\n)|(\r\n?))/", $log->data) as $line)
            {
                $exploded = explode("|", $line);
                if (count($exploded) == 3 && $exploded[1] == "test_begin")
                {
                    if ($temp = json_decode($exploded[2]))
                    {
                        $staricase_method = $temp->use_staircase_method == 1;
                        $staricase_number = $temp->number_of_staircases;
                        $staricase_max_level = $temp->staircase_max_level;
                        $staricase_min_level = $temp->staircase_min_level;
                        $start_time = $exploded[0];
                        $questions_per_folder = $temp->questions_per_folder; // "1:1" for one question MOCS
                        // which probably indicates survey
                        echo $temp->name . "\n";
                        if ($temp->practice_configuration)
                            echo "Practice: yes\n";
                        else
                            echo "Practice: no\n";

                        $found_config = 1;
                    }
                }
                if (count($exploded) == 3 && $exploded[1] == "test_finished")
                    $end_time = $exploded[0];
            }

            if ($found_config == 0)
            {
                echo "Could not process log file";
            }
            else
            {
                // now record reversals for stiarcases, and % correct for MOCS
                if ($staricase_method)
                {
                    $reversal_count = array(); // indexed by staircase number
                    $reversal_value = array(); // indexed by staircase number and reversal number
                    $seen_min = array(); // indexed by staircase number
                    $not_seen_max = array(); // indexed by staircase number
                    $min_stim = explode("/", $staricase_min_level); // indexed by staircase number
                    $max_stim = explode("/", $staricase_max_level); // indexed by staircase number

                    for ($i = 0; $i < $staricase_number; $i++)
                    {
                        $reversal_count[$i] = 0;
                        $seen_min[$i] = 0;
                        $not_seen_max[$i] = 0;
                    }
                    foreach (preg_split("/((\r?\n)|(\r\n?))/", $log->data) as $line)
                    {
                        $exploded = explode("|", $line);
                        if (count($exploded) == 3)
                        {
                            if ($exploded[1] == "currentStaircase") // record the current staricase
                                $stair = $exploded[2];

                            if ($exploded[1] == "presented_image")
                            { // record the current stim value
                                $temp = explode("/", $exploded[2]);
                                $stim = $temp[0];
                                $correct_button = substr($temp[1], 0, 1);
                            }

                            if ($exploded[1] == "reversal")
                            { // record stim value at reversal
                                $reversal_value[$stair][$reversal_count[$stair]] = $stim;
                                $reversal_count[$stair]++;
                            }

                            if ($exploded[1] == "button_press" && array_key_exists($stair, $min_stim) && // check if min seen
                                substr($exploded[2], 0, 1) == $correct_button && $stim == $min_stim[$stair]
                            )
                            {
                                $seen_min[$stair]++;
                            }

                            if ($exploded[1] == "button_press" && array_key_exists($stair, $max_stim) && // check if max !seen
                                substr($exploded[2], 0, 1) != $correct_button && $stim == $max_stim[$stair]
                            )
                            {
                                $not_seen_max[$stair]++;
                            }
                        }
                    }
                    foreach ($reversal_count as $i => $value)
                    {
                        echo "Staircase: " . $i . "\n";
                        echo "\tNot seen max: " . $not_seen_max[$i] . "\n";
                        echo "\tSeen min: " . $seen_min[$i] . "\n";
                        for ($j = 0; $j < $value; $j++)
                        {
                            echo "\tReversal " . ($j + 1) . ": " . $reversal_value[$i][$j] . "\n";
                        }
                    }
                } else
                {
                    // record (in)correct for each stim level
                    $correct_count = array();
                    $incorrect_count = array();
                    echo "MOCS\n";
                    foreach (preg_split("/((\r?\n)|(\r\n?))/", $log->data) as $line)
                    {
                        $exploded = explode("|", $line);
                        if (count($exploded) == 3)
                        {
                            if ($exploded[1] == "presented_image")
                            { // record the current stim value
                                $temp = explode("/", $exploded[2]);
                                $stim = $temp[0];
                                $correct_button = substr($temp[1], 0, 1);
                                if (!array_key_exists($stim, $correct_count))
                                    $correct_count[$stim] = 0;
                                if (!array_key_exists($stim, $incorrect_count))
                                    $incorrect_count[$stim] = 0;
                            }
                            if ($exploded[1] == "button_press")
                            { // count correct or incorrect
                                if ($questions_per_folder == "1:1")
                                {
                                    printf("Pressed %s\n", $exploded[2]); // if only one question, just print button
                                } else
                                {
                                    if ($correct_button == substr($exploded[2], 0, 1))
                                        $correct_count[$stim]++;
                                    else
                                        $incorrect_count[$stim]++;
                                }
                            }
                        }
                    }

                    if ($questions_per_folder != "1:1")
                    { // don't print table i fonly one question
                        printf("Level Correct Incorrect Correct(%%)\n");
                        ksort($correct_count); // put in numeric order of level (key in correct_count[])
                        foreach ($correct_count as $i => $value)
                        {
                            if ($correct_count[$i] + $incorrect_count[$i] > 0)
                                printf("%5d %6d %8d %8.1f%%\n", $i, $correct_count[$i], $incorrect_count[$i], $correct_count[$i] / ($correct_count[$i] + $incorrect_count[$i]) * 100);
                            else
                                printf("%5d %6d %8d ???\n", $i, $correct_count[$i], $incorrect_count[$i]);
                        }
                    }
                }
                echo "Start time: " . date('j/n/Y H:i:s', $start_time) . "\n";
                echo "End time  : " . date('j/n/Y H:i:s', $end_time) . "\n";
                $d = $end_time - $start_time;
                $m = floor($d / 60.0);
                if ($d >= 0)
                    echo "Duration  : " . $m . " minutes " . ($d - 60 * $m) . " seconds" . "\n";
            }
        ?></textarea>
        <textarea readonly class="form-control" style="display:inline;width:60%"rows="20"><?php echo $log->data ?></textarea>

    <?php endforeach; ?>

<?php else: ?>
    <h2>Participant Management</h2>
    <p>Please select a participant to the left.</p>
    <p><a href="/export/logs">Export all logs</a></p>
<?php endif; ?>
