<h1>Image Sets</h1>

<ul>
    <?php foreach($imagesets as $imageset): ?>
        <li><a href="<?php echo str_replace($_SERVER['DOCUMENT_ROOT'], '', $imageset->path) ?>"><?php echo $imageset->name ?></a> [<a href="/images/<?php echo $imageset->id?>/delete" onclick="return confirm('Are you sure?')">delete</a>]</li>
    <?php endforeach; ?>
</ul>
<h2>Upload</h2>
<?php if (isset($message)) echo '<div>'.$message.'</div>' ?>
<form action="" method="POST" enctype="multipart/form-data" class="form-horizontal">
    <div class="form-group">
        <label for="file" class="col-lg-1 control-label">File</label>
        <div class="col-lg-1">
            <input type="file" name="file">
        </div>
    </div>
    <div class="form-group">
        <label for="name" class="col-lg-1 control-label">Name</label>
        <div class="col-lg-4">
            <input type="text" name="name" class="form-control">
            <br><button type="submit" class="btn btn-default">Upload</button>
        </div>
    </div>
</form>
