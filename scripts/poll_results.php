<?php
include '../../config.php';
$host    = $CFG->wwwroot;

$function="local_mobile_mod_choice_get_choice_results";
$function2="local_mobile_mod_choice_get_choices_by_courses";
$token=$CFG->wstoken;
 
// Grabs choice details including title
$ch2 = curl_init();
curl_setopt($ch2, CURLOPT_URL, "$host/webservice/rest/server.php?wsfunction=$function2&wstoken=$token&moodlewsrestformat=json");
curl_setopt($ch2, CURLOPT_RETURNTRANSFER, 1);
$result2 = json_decode(curl_exec($ch2));
 
if (isset($_REQUEST['choiceid'])) {
    $choiceid=intval($_REQUEST['choiceid']);
} else if (count($result2->choices) > 0) { // accessible choices found
    $choiceid=intval($result2->choices[0]->id);
} else {
    $choiceid = 0; // default value
}
if ($choiceid < 1) {
    echo("invalid id");
}
$colour="138,0,38"; // BBK burgundy
 
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "$host/webservice/rest/server.php?wsfunction=$function&wstoken=$token&choiceid=$choiceid&moodlewsrestformat=json");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$result = json_decode(curl_exec($ch));
 
$graph_title = "";
$dropdown = "<select name='choiceid' onchange='this.form.submit()'>\n";
$dropdown .= "<option value='0'>Select</option>\n";
 
foreach ($result2->choices as $choice) {
    $dropdown .= "<option value='{$choice->id}'";
    if ($choice->id == $choiceid) {
        $graph_title = $choice->name;
        $dropdown .= " selected";
    }
    $dropdown .= ">{$choice->name}</option>\n";
}
$dropdown .= "</select>\n";
 
// data for bar graph
$chart = new stdClass();
$data = array();
$labels = array();
foreach ($result->options as $a) {
    $data[] = $a->numberofuser;
    $labels[] = $a->text." (".round($a->percentageamount,1)."%)";
}
$chart->labels = $labels;
$dataset = new stdClass();
$dataset->data = $data;
$dataset->fillColor = "rgba({$colour},0.5)";
$dataset->strokeColor = "rgba({$colour},0.8)";
$dataset->highlightFill = "rgba({$colour},0.75)";
$dataset->highlightStroke = "rgba({$colour},1)";
$chart->datasets = array($dataset);
 
curl_close($ch);
 
?>
<!doctype html>
<html>
        <head>
                <meta http-equiv="refresh" content="5" >
                <title>Bar Chart</title>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/1.0.2/Chart.min.js"></script>
        </head>
        <body>
        <center>
        <h1><?php echo($graph_title); ?></h1>
                <div id="canvas-holder">
                        <canvas id="chart-area" width="900" height="600"/>
                </div>
 
            <form><?php echo($dropdown); ?><noscript><input type="submit" value="Submit"></noscript></form>
 
        <script>
            var pieData = <?php echo json_encode($chart); ?>;
 
                        window.onload = function(){
                                var ctx = document.getElementById('chart-area').getContext('2d');
                                window.myPie = new Chart(ctx).Bar(pieData, {animationSteps : 1, responsive: false});
                        };
		</script>
        </center>
        </body>
</html>