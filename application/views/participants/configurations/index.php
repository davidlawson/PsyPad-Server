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
