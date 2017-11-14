===============================
Hardening and Security Guidance
===============================

ownCloud aims to ship with secure defaults that do not need to get modified by 
administrators. However, in some cases some additional security hardening can be 
applied in scenarios were the administrator has complete control over 
the ownCloud instance. This page assumes that you run ownCloud Server on Apache2 
in a Linux environment.

.. note:: ownCloud will warn you in the administration interface if some 
   critical security-relevant options are missing. However, it is still up to 
   the server administrator to review and maintain system security.
   
Limit on Password Length
------------------------

ownCloud uses the `bcrypt`_ algorithm, and thus for security and performance reasons, e.g., denial of service as CPU demand increases exponentially, it only verifies the first 72 characters of passwords. 
This applies to all passwords that you use in ownCloud: user passwords, passwords on link shares, and passwords on external shares.

Operating system
----------------

.. _dev-urandom-label:

Give PHP read access to ``/dev/urandom``
*****************************************

ownCloud uses a `RFC 4086 ("Randomness Requirements for Security")`_ compliant 
mixer to generate cryptographically secure pseudo-random numbers. This means 
that when generating a random number ownCloud will request multiple random 
numbers from different sources and derive from these the final random number.

The random number generation also tries to request random numbers from 
``/dev/urandom``, thus it is highly recommended to configure your setup in such 
a way that PHP is able to read random data from it.

.. note:: When having an ``open_basedir`` configured within your ``php.ini`` file,
   make sure to include ``/dev/urandom``.

Enable hardening modules such as SELinux
****************************************

It is highly recommended to enable hardening modules such as SELinux where 
possible. See :doc:`../../installation/selinux_configuration` to learn more about 
SELinux.

Deployment
----------

Place data directory outside of the web root
********************************************

It is highly recommended to place your data directory outside of the Web root 
(i.e. outside of ``/var/www``). It is easiest to do this on a new 
installation.

.. Doc on moving data dir coming soon
.. You may also move your data directory on an existing 
.. installation; see :doc:``

Disable preview image generation
********************************

ownCloud is able to generate preview images of common filetypes such as images 
or text files. By default the preview generation for some file types that we 
consider secure enough for deployment is enabled by default. However, 
administrators should be aware that these previews are generated using PHP 
libraries written in C which might be vulnerable to attack vectors.

For high security deployments we recommend disabling the preview generation by 
setting the ``enable_previews`` switch to ``false`` in ``config.php``. As an 
administrator you are also able to manage which preview providers are enabled by 
modifying the ``enabledPreviewProviders`` option switch.

.. _use_https_label:

Use HTTPS
---------

Using ownCloud without using an encrypted HTTPS connection opens up your server 
to a man-in-the-middle (MITM) attack, and risks the interception of user data 
and passwords. It is a best practice, and highly recommended, to always use 
HTTPS on production servers, and to never allow unencrypted HTTP.

How to setup HTTPS on your Web server depends on your setup; please consult the 
documentation for your HTTP server. The following examples are for Apache.

Redirect all unencrypted traffic to HTTPS
*****************************************

To redirect all HTTP traffic to HTTPS administrators are encouraged to issue a 
permanent redirect using the 301 status code. When using Apache this can be 
achieved by adding a setting such as the following in the Apache VirtualHosts 
configuration containing the ``<VirtualHost *:80>`` entry::

  Redirect permanent / https://example.com/

.. _enable-hsts-label:

Enable HTTP Strict Transport Security
*************************************

While redirecting all traffic to HTTPS is good, it may not completely prevent 
man-in-the-middle attacks. Thus administrators are encouraged to set the HTTP 
Strict Transport Security header, which instructs browsers to not allow any 
connection to the ownCloud instance using HTTP, and it attempts to prevent site 
visitors from bypassing invalid certificate warnings.

This can be achieved by setting the following settings within the Apache 
VirtualHost file containing the ``<VirtualHost *:443>`` entry::

  <IfModule mod_headers.c>
    Header always set Strict-Transport-Security "max-age=15552000; includeSubDomains"
  </IfModule>

If you don't have access to your Apache configuration it is also possible to add this
to the main ``.htaccess`` file shipped with ownCloud. Make sure you're adding it below
the line::

  #### DO NOT CHANGE ANYTHING ABOVE THIS LINE ####
  
This example configuration will make all subdomains only accessible via HTTPS.
If you have subdomains not accessible via HTTPS, remove ``includeSubDomains``.

.. note:: This requires the ``mod_headers`` extension in Apache.

Proper SSL configuration
************************

Default SSL configurations by Web servers are often not state-of-the-art, and 
require fine-tuning for an optimal performance and security experience. The 
available SSL ciphers and options depend completely on your environment and 
thus giving a generic recommendation is not really possible.

We recommend using the `Mozilla SSL Configuration Generator`_ to generate a 
suitable configuration suited for your environment, and the free `Qualys 
SSL Labs Tests`_ gives good guidance on whether your SSL server is correctly 
configured.

Also ensure that HTTP compression is disabled to mitigate the BREACH attack.

Use a dedicated domain for ownCloud
-----------------------------------

Administrators are encouraged to install ownCloud on a dedicated domain such as 
cloud.domain.tld instead of domain.tld to gain all the benefits offered by the 
Same-Origin-Policy.

Ensure that your ownCloud instance is installed in a DMZ
--------------------------------------------------------

As ownCloud supports features such as Federated File Sharing we do not consider
Server Side Request Forgery (SSRF) part of our threat model. In fact, given all our
external storage adapters this can be considered a feature and not a vulnerability.

This means that a user on your ownCloud instance could probe whether other hosts
are accessible from the ownCloud network. If you do not want this you need to 
ensure that your ownCloud is properly installed in a segregated network and proper 
firewall rules are in place.

Serve security related Headers by the Web server
------------------------------------------------

Basic security headers are served by ownCloud already in a default environment. 
These include:

- ``X-Content-Type-Options: nosniff``
	- Instructs some browsers to not sniff the mimetype of files. This is used for example to prevent browsers from interpreting text files as JavaScript.
- ``X-XSS-Protection: 1; mode=block``
	- Instructs browsers to enable their browser side Cross-Site-Scripting filter.
- ``X-Robots-Tag: none``
	- Instructs search machines to not index these pages.
- ``X-Frame-Options: SAMEORIGIN``
	- Prevents embedding of the ownCloud instance within an iframe from other domains to prevent Clickjacking and other similar attacks.

These headers are hard-coded into the ownCloud server, and need no intervention 
by the server administrator.

For optimal security, administrators are encouraged to serve these basic HTTP 
headers by the Web server to enforce them on response. To do this Apache has to 
be configured to use the ``.htaccess`` file and the following Apache 
modules need to be enabled:

- mod_headers
- mod_env

Administrators can verify whether this security change is active by accessing a 
static resource served by the Web server and verify that the above mentioned 
security headers are shipped.

Use Fail2ban
------------

Another approach to hardening the server(s) on which your ownCloud installation rest is using an intrusion detection system. 
An excellent one is `Fail2ban`_.
Fail2ban is designed to protect servers from brute force attacks. 
It works by monitoring log files (such as those for *ssh*, *web*, *mail*, and *log* servers) for certain patterns, specific to each server, and taking actions should those patterns be found. 

Actions include banning the IP from which the detected actions are being made from. 
This serves to both make the process more difficult as well as to prevent DDOS-style attacks.
However, after a predefined time period, the banned IP is normally un-banned again. 

This helps if the login attempts were genuine, so the user doesn't lock themselves out permanently. 
An example of such an action is users attempting to brute force login to a server via ssh.
In this case, Fail2ban would look for something similar to the following in ``/var/log/auth.log``.

:: 

    Mar 15 11:17:37 yourhost sshd[10912]: input_userauth_request: invalid user audra [preauth]
    Mar 15 11:17:37 yourhost sshd[10912]: pam_unix(sshd:auth): check pass; user unknown
    Mar 15 11:14:51 yourhost sshd[10835]: PAM 2 more authentication failures; logname= uid=0 euid=0 tty=ssh ruser= rhost=221.194.44.231  user=root
    Mar 15 11:14:57 yourhost sshd[10837]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=221.194.44.231  user=root
    Mar 15 11:14:59 yourhost sshd[10837]: Failed password for root from 221.194.44.231 port 46838 ssh2
    Mar 15 11:15:04 yourhost sshd[10837]: message repeated 2 times: [ Failed password for root from 221.194.44.231 port 46838 ssh2]
    Mar 15 11:15:04 yourhost sshd[10837]: Received disconnect from 221.194.44.231: 11:  [preauth]

.. note:: 
   If you’re not familiar with what’s going on, this snippet highlights a number of failed login attempts being made.

Using Fail2ban to secure an ownCloud login
******************************************

On Ubuntu, you can install Fail2ban using the following commands:

::

    apt update && apt upgrade
    apt install fail2ban

Fail2ban installs several default filters for *Apache*, *NGINX*, and various other services, but none for ownCloud. 
Given that, we have to define our own filter.
To do so, you first need to make sure that ownCloud uses your local timezone for writing log entries; otherwise, fail2ban cannot react appropriately to attacks. 
To do this, edit your ``config.php`` file and add the following line:

::

    'logtimezone' => 'Europe/Berlin',

.. note:: 
   Adjust the timezone to the one that your server is located in, based on `PHP's list of supported timezones`_.

This change takes effect as soon as you save ``config.php``. 
You can test the change by:

#. Entering false credentials at your ownCloud login screen
#. Checking the timestamp of the resulting entry in ownCloud's log file.

Next, define a new Fail2ban filter rule for ownCloud.
To do so, create a new file called ``/etc/fail2ban/filter.d/owncloud.conf``, and insert the following configuration:

::

    [Definition]
    failregex={.*Login failed: \'.*\' \(Remote IP: \'<HOST>\'\)"}
    ignoreregex =

This filter needs to be loaded when Fail2ban starts, so a further configuration entry is required to be added in ``/etc/fail2ban/jail.d/defaults-debian.conf``, which you can see below:

::

    [owncloud]
    enabled = true
    port = 80,443
    protocol = tcp
    filter = owncloud
    maxretry = 3
    bantime = 10800
    logpath = /var/owncloud_data/owncloud.log

This configuration:

#. Enables the filter rules for TCP requests on ports 80 and 443. 
#. Bans IPs for 10800 seconds (3 hours). 
#. Sets the path to the log file to analyze for malicious logins

.. note::
  The most important part of the configuration is the ``logpath`` parameter. 
  If this does not point to the correct log file, Fail2ban will either not work properly or refuse to start.

After saving the file, restart Fail2ban by running the following command:

::

    service fail2ban restart

To test that the new ownCloud configuration has been loaded, use the following command:

::

    fail2ban-client status

If "owncloud" is listed in the console output, the filter is both loaded and active.
If you want to test the filter, run the following command, adjusting the path to your ``owncloud.log``, if necessary:

::

    fail2ban-regex /var/owncloud_data/owncloud.log /etc/fail2ban/filter.d/owncloud.conf

The output will look similar to the following, if you had one failed login attempt:

::

    fail2ban-regex /var/www/owncloud_data/owncloud.log /etc/fail2ban/filter.d/owncloud.conf

    Running tests
    =============

    Use   failregex file : /etc/fail2ban/filter.d/owncloud.conf
    Use         log file : /var/www/owncloud_data/owncloud.log


    Results
    =======

    Failregex: 1 total
    |-  #) [# of hits] regular expression
    |   1) [1] {.*Login failed: \'.*\' \(Remote IP: \'<HOST>\'\)"}
    `-

    Ignoreregex: 0 total

    Date template hits:
    |- [# of hits] date format
    |  [40252] ISO 8601
    `-

    Lines: 40252 lines, 0 ignored, 1 matched, 40251 missed

The ``Failregex`` counter increments by 1 for every failed login attempt.
To un-ban an IP, which was locked either during testing or unintentionally, use the following command:

::

    fail2ban-client set owncloud unbanip <IP>

You can check the status of your ownCloud filter with the following command:

::

    fail2ban-client status owncloud

This will produce an output similar to this:

::

    Status for the jail: owncloud
    |- filter
    |  |- File list:    /var/www/owncloud_data/owncloud.log
    |  |- Currently failed: 1
    |  `- Total failed: 7
    `- action
       |- Currently banned: 0
       |  `- IP list:
       `- Total banned: 1

.. Links

.. _Mozilla SSL Configuration Generator: https://mozilla.github.io/server-side-tls/ssl-config-generator/
.. _Qualys SSL Labs Tests: https://www.ssllabs.com/ssltest/
.. _RFC 4086 ("Randomness Requirements for Security"): https://tools.ietf.org/html/rfc4086#section-5.2
.. _Fail2ban: https://www.fail2ban.org/wiki/index.php/Main_Page
.. _short guide from Digital Ocean: https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04
.. _bcrypt: https://en.m.wikipedia.org/wiki/Bcrypt
.. _PHP's list of supported timezones: https://secure.php.net/manual/en/timezones.php
