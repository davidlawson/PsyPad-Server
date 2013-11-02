<div class="well">
    <ul class="nav nav-pills nav-stacked">
        <li class="nav-header">Participants</li>
        <li<?php if (isset($username) && $default_participant->username == $username): ?> class="active"<?php endif ?>><a href="<?php echo $default_participant->get_link() ?>">Default Participant</a></li>
        <?php foreach($participants as $participant): ?>
            <li<?php if (isset($username) && $participant->username == $username): ?> class="active"<?php endif ?>><a href="<?php echo $participant->get_link() ?>"><?php echo $participant->username ?></a></li>
        <?php endforeach; ?>
        <li <?php if(Request::$current->action() == 'add'): ?>class="active"<?php endif ?>><a href="<?php echo URL::site('participants/add') ?>"><span class="glyphicon glyphicon-plus-sign"></span> Add participant</a></li>
    </ul>
</div><!--/.well -->