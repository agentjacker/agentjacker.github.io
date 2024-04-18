<?php
if (!isset($_SERVER['PHP_AUTH_USER'])) {
    header('HTTP/1.1 401 Unauthorized');
    header('WWW-Authenticate: Basic realm="xxx.com Your password will be unencrypted"');
    echo 'Authorization Required.';
    exit;
} else {
    // Validate the username and password here if needed
    $username = $_SERVER['PHP_AUTH_USER'];
    $password = $_SERVER['PHP_AUTH_PW'];
    // Example of checking the credentials
    // Replace this with your actual authentication logic
    if ($username !== 'your_username' || $password !== 'your_password') {
        header('HTTP/1.1 401 Unauthorized');
        header('WWW-Authenticate: Basic realm="xxx.com Your password will be unencrypted"');
        echo 'Invalid Credentials.';
        exit;
    }

}
?>
