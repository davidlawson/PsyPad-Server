<h1>User Control Panel</h1>

<?php if (isset($message)): ?><p class="alert alert-info"><?php echo $message ?></p><?php endif ?>

<h3>Change Password</h3>
<form action="" method="post" style="margin-top: 20px;">

    <div class="form-group">
        <input class="form-control" type="password" placeholder="Existing password" name="old" style="width: 400px;">
    </div>

    <div class="form-group">
        <input class="form-control" type="password" placeholder="New password" name="password" style="width: 400px;">
    </div>

    <div class="form-group">
        <input class="form-control" type="password" placeholder="New password (confirm)" name="password_confirm" style="width: 400px;">
    </div>

    <input type="submit" value="Change Password" class="btn btn-default">

</form>