<?php

function generate_breadcrumbs($breadcrumbs)
{
    $output = '';
    if (count($breadcrumbs) > 0)
    {
        $output .= '<ul class="breadcrumb">';
        foreach ($breadcrumbs as $breadcrumb)
        {
            $output .=  '<li>';
            if ($breadcrumb[1] && $breadcrumb != end($breadcrumbs)) $output .= '<a href="'.URL::site($breadcrumb[1]).'">';
            $output .= $breadcrumb[0];
            if ($breadcrumb[1] && $breadcrumb != end($breadcrumbs)) $output .= '</a>';
            $output .= '</li>';
        }
        $output .= '</ul>';
    }

    return $output;
}

?><!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title><?php echo $title ?></title>
    <meta name="viewport" content="width=device-width">

    <?php foreach ($styles as $file => $type) echo HTML::style($file, array('media' => $type)), PHP_EOL ?>
    <?php foreach ($scripts as $file) echo HTML::script($file), PHP_EOL ?>
</head>
<body>

<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <!-- .navbar-toggle is used as the toggle for collapsed navbar content -->
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-responsive-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="<?php echo URL::base(TRUE) ?>">PsyPad API</a>

        <!-- Place everything within .navbar-collapse to hide it until above 768px -->
        <div class="nav-collapse collapse navbar-responsive-collapse">
            <ul class="nav navbar-nav">
                <li <?php if(Request::$current && Request::$current->controller() == 'Users'): ?>class="active"<?php endif ?>><a href="<?php echo URL::site('participants')?>">Participants</a></li>
                <li <?php if(Request::$current && Request::$current->controller() == 'Images'): ?>class="active"<?php endif ?>><a href="<?php echo URL::site('images') ?>">Images</a></li>
                <li><a href="http://www.psypad.net.au/" target="_blank">Wiki</a></li>
                <li><a href="https://github.com/davidlawson/PsyPad" target="_blank">App Repository</a></li>
                <li><a href="https://github.com/davidlawson/PsyPad-Server" target="_blank">Server Repository</a></li>
            </ul>
            <?php if (class_exists('Auth')): ?>
                <?php if (Auth::instance()->logged_in()): ?>
                    <p class="navbar-text pull-right">
                        Logged in as <?php echo Auth::instance()->get_user()->username ?> &nbsp; &nbsp; <a href="<?php echo URL::site('security/logout') ?>" class="navbar-link">Log out</a>
                    </p>
                <?php else: ?>
                    <form class="navbar-form pull-right" action="<?php echo URL::site('security/login') ?>" method="post">
                        <input class="form-control" style="width: 200px" type="text" placeholder="Username" name="username">
                        <input class="form-control" style="width: 200px" type="password" placeholder="Password" name="password">
                        <button type="submit" class="btn btn-default">Log in</button>
                    </form>
                <?php endif; ?>
            <?php endif; ?>
        </div><!-- /.nav-collapse -->
    </div>
</div>

<div class="container">

    <div class="row">
        <?php if (isset($sidebar)): ?>
            <div class="col-lg-3">
                <?php echo $sidebar ?>
            </div><!--/span-->

            <div class="col-lg-9">
                <?php echo generate_breadcrumbs($breadcrumbs); ?>
                <?php echo $content ?>
            </div>
        <?php else: ?>
            <div class="col-lg-10">
                <?php echo generate_breadcrumbs($breadcrumbs) ?>
                <?php echo $content ?>
            </div>
        <?php endif ?>
    </div>

    <hr>

    <!-- 
    <footer>
        <p>&copy; David Lawson, 2013</p>
    </footer>
    -->

</div> <!-- /container -->
</body>
</html>
