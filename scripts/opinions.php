<?php

// Get answers submitted to an "in your opinion" forum

$forums = ws('local_mobile_mod_forum_get_forums_by_courses', 'courseids[0]=14'); # LPM

if (isset($_REQUEST['forumid'])) {
    $forumid = $_REQUEST['forumid'];
} elseif ( 1 ) {
    $forumid = $result[0]->id;
} else {
    $forumid = 0; # default
}

$question = '';

$select  = "<select name='forumid' onchange='this.form.submit()'>\n";
$select .= "<option value='0'>Select</option>\n";

foreach ($forums as $forum) {
    $select .= "<option value='{$forum->id}'";
    if ($forum->id == $forumid) {
        $question = $forum->name;
        $select .= " selected";
    }
    $select .= ">{$forum->name}</option>\n";
}
$select .= "</select>\n";

$forum    = ws('mod_forum_get_forum_discussions_paginated', "forumid=$forumid");
$opinions = $forum->discussions;

function ws($function, $params) {
    $c       = curl_init();
    $url_ws  = "https://moodle.slapp.space/webservice/rest/server.php";
    $wstoken = 'b926992720820536bc8e15dceb726311';
    $url     = "$url_ws?wsfunction=$function&wstoken=$wstoken&moodlewsrestformat=json";
    if ($params) {
        $url = $url . "&$params";
    }
    curl_setopt($c, CURLOPT_URL, $url);
    curl_setopt($c, CURLOPT_RETURNTRANSFER, 1);
    return json_decode(curl_exec($c));
}

?>
<!doctype html>
<html>
<head>
    <meta http-equiv="refresh" content="10">
    <title>In Your Opinion</title>
</head>
<body>
<h1><?php echo($question) ?></h1>
<ul>
<?php foreach ($opinions as $opinion) {
    echo("<li>{$opinion->subject}</li>");
} ?>
</ul>
<form><?php echo($select) ?><noscript><input type="submit" value="Submit"></noscript></form>
</body>
</html>
