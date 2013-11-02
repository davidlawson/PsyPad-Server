<h1>Add Participant</h1>

<?php if (isset($error)): ?><p class="alert alert-danger"><?php echo $error ?></p><?php endif ?>

<form action="" method="post" style="margin-top: 20px;">

    <div class="form-group">
        <input class="form-control" type="text" placeholder="Username" name="username" style="width: 400px;">
    </div>

    <input type="submit" value="Add Participant" class="btn btn-default">

</form>
