<h1>User List</h1>

<ul>
<?php foreach($users as $user): ?>

    <li><?php echo $user->username ?> (<?php echo $user->email ?>)</li>

<?php endforeach; ?>
</ul>