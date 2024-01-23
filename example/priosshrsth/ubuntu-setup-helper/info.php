<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <style type="text/css">
        html, body {
            padding: 0 !important;
            margin: 0 !important;
        }

        table {
            width: 90vw !important;
        }

        table > tbody:first-child > tr:first-child > td {
            background: #777bb3 !important;
        }
    </style>
    <title>Local PHP - <?php echo phpversion(); ?> </title>
    <meta name="ROBOTS" content="NOINDEX,NOFOLLOW,NOARCHIVE"/>

    <link rel="stylesheet" href="https://unpkg.com/purecss@2.0.6/build/pure-min.css" integrity="sha384-Uu6IeWbM+gzNVXJcM9XV3SohHtmWE+3VGi496jvgX1jyvDTXfdK+rfZc8C1Aehk5" crossorigin="anonymous">
</head>
<body>
<?php phpinfo(); ?>
</body>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('table').forEach(t => {
            t.classList.add('pure-table', 'pure-table-bordered', 'pure-table-striped')
        })
    })
</script>
</html>
