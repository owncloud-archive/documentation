Using Letsencrypt certificates
==============================

This page covers how to configure your web server to use with `Letsencrypt`_ as certificate authority 
for ownCloud server. Note that Letsencrypt is *not officially supported*, and this page is 
*community-maintained*. Thank you, contributors!

-  For ease of handling, particular directives related to ssl are moved into a separate file which
   is then included. This can help especially for first time issuing the certificate and resusing a configuration.
-  The examples shown are based on Ubuntu 16.04
-  Read the `certbot userguide`_ for details of commands.
-  LetsEncrypt CA issues short-lived certificates valid for 90 days. Make sure you renew the certificates at least 
   once in this period because expired certificates need reissuing. A certificate is due for renewal earliest 30 
   days before expiring. Certbot can be forced to renew via options at any time as long the certificate is valid. 

A good reading for *Strong SSL Security* measures can be found here: `Apache`_ and `NGINX`_

Requirements
------------

-  You require a domain name with a valid **A** record pointing back to your servers IP address.
   In case your server is behind a firewall, take the necessary measures to ensure that your server is world-wide
   accessible from the internet by adding firewall and port forward rules.

Installation of Letsencrypt certbot client
------------------------------------------

The latest `certbot`_ client can be installed via source from `gitgub`_ , or close to latest via `ppa`_.
 
**Option 1: via github**

Please replace ``/opt/letsencrypt`` with a path of your requirement.

::

  sudo apt-get update
  sudo apt-get install -y git
  sudo git clone https://github.com/certbot/certbot /opt/letsencrypt
  
To run certbot type

::

  sudo /opt/letsencrypt/certbot-auto

Without explicit denying by command, certbot will auto-update on each run.


**Option 2: via ppa**

::

  sudo apt-get install software-properties-common
  sudo add-apt-repository ppa:certbot/certbot
  sudo apt-get update
  sudo apt-get install certbot

To update certbot, you need to manually run

::

  sudo apt-get update
  sudo apt-get upgrade
  sudo apt-get dist-upgrade

To run certbot type

::

  sudo /usr/bin/certbot

**Register your eMail address**

Run the certbot once to prepare the environment. You should register your eMail 
address for urgent renewal and security notifications. Use the command based on
your installation method.

::

  sudo /opt/letsencrypt/certbot-auto register -email <your-eMail-address>

Onetime preparations
--------------------

Create a Letsencrypt challenge directory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It is assumed that your webserver root is in ``/var/www``. Adopt this path if different.

::

  cd /var/www
  sudo mkdir letsencrypt
  sudo chown root:www-data letsencrypt

Create Letsencrypt config files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- Create following files in the Letsencrypt directory. They will help to maintain your certfificates.
- Replace the path to certbot and the certbot script name according to your installation.
- Make all files executable except ``cli.ini`` by running ``sudo chmod +x <script-name>``
- All scripts have to be executed with ``sudo``

::

	cd /etc/Letsencrypt

**cli.ini**

This file predefines some settings used by certbot. Use the eMail address you registered with. 
Comment / uncomment the post-hook parameter according which web server you use.

.. code-block:: bash

  rsa-key-size = 4096
  email = <your-eMail-address>
  agree-tos = True
  authenticator = webroot
  webroot-path = /var/www/letsencrypt/
  post-hook "service nginx reload"
  # post-hook "apache2ctl graceful"
    
**list.sh**

This script lists all your issued certificates.

.. code-block:: bash

  #!/bin/bash

  LE_PATH="/opt/letsencrypt"
  LE_CB="certbot-auto"

  $LE_PATH/$LE_CB certificates

**renew.sh**

This script renews all your issued certificates and updates certbot when using git as installation source 
and reloads the web server configuration automatically if a certificate has been renewed.

.. code-block:: bash

  #!/bin/bash

  LE_PATH="/opt/letsencrypt"
  LE_CB="certbot-auto"

  $LE_PATH/$LE_CB renew

**renew-cron.sh**

This script renews all your issued certificates but does not upgrade certbot and is inteded 
to run via cron. It reloads the web server configuration automatically if a certificate has been renewed.

.. code-block:: bash

  #!/bin/bash

  LE_PATH="/opt/letsencrypt"
  LE_CB="certbot-auto"

  $LE_PATH/$LE_CB renew --no-self-upgrade --noninteractive

**delete.sh**

This script deletes a issued certificate. Use the ``list.sh`` script to list issued certificates.

.. code-block:: bash

  #!/bin/bash

  LE_PATH="/opt/letsencrypt"
  LE_CB="certbot-auto"

  read -p "Which certificate do you want to delete: " -r -e answer
  if [ -n $answer ]; then
    $LE_PATH/$LE_CB delete --cert-name $answer
  fi

**<your-domain-name>.sh**

As an example, this script creates a certificate for following domain / subdomains. You can add or 
remove subdomains as necessary. Use your own domain / subdomain names. The first (sub)domain name used in the 
script is taken for naming the directories created by certbot. Note: you can create different certificates 
for different subdomains by creating different scripts.

- mydom.tld
- www.mydom.tld
- sub.mydom.tld

.. code-block:: bash

  #!/bin/bash
  # export makes the variable available for all sub processes
  
  LE_PATH="/opt/letsencrypt"
  LE_CB="certbot-auto"

  export DOMAINS="-d mydom.tld -d www.omydom.tld -d sub.mydom.tld"

  $LE_PATH/$LE_CB certonly --config /etc/letsencrypt/cli.ini $DOMAINS # --dry-run

You can enable the ``--dry-run`` option which does a test run of the client only.

Webserver setup and issue a certificate
---------------------------------------

For better readability, follow the links to setup your webserver and issue a certificate.

Apache
~~~~~~

:ref:`letsencrypt-apache-label`

NGINX
~~~~~

:ref:`letsencrypt-nginx-label`

SSL Server Test
---------------

After you have successfully setup the web server and installed the certificate, you can test the security 
of your web server. To do so, you can use the free service of `SSL Labs`_. See an example screenshot of a 
test run below.

.. figure:: images/ssllabs.png
   :scale: 30%

Renewing certificates
---------------------

**Manual renewing**

To avoid expiration of certificates, consider this task at least under 90 days.
If you have provided your eMail address, you will get reminder notifications.

.. code-block:: bash

  sudo /etc/letsencrypt/renew.sh

**Automatic renewing via crontab**

Defined by parameters, certificates are only renewed if they are due. Therefore you can run a cron job 
on a more frequent basis without effectively triggering renewal. A weekly check is sufficient. This job is setup 
on each Saturday at 03:30 in the morning. If you want to use own values, you can check them at `crontab.guru`_ 
or modify the script for other options.

Setup of crontab parameters to configure the timing

::

  *     *     *   *    *      command to be executed
  -     -     -   -    -
  |     |     |   |    |
  |     |     |   |    +----- day of week (0 - 6) (Sunday=0)
  |     |     |   +------- month          (1 - 12)
  |     |     +--------- day of month     (1 - 31)
  |     +----------- hour                 (0 - 23)
  +------------- min                      (0 - 59)

Run following command to edit the job list. It is important to use ``sudo`` to derive proper permissions.

::

  sudo crontab -e
  
Add the following at the end

::

  30 03 * * 6 /etc/letsencrypt/renew-cron.sh
  
.. Note::
   Check your logs regularly for successful renewals!
  
Adding or removing domains from the certificate
-----------------------------------------------

- If you want to add a domain like ``test.mydom.tld`` to your certificate, just add 
  the domain in the domain shell script above, rerun it and reload the web server config. 
  This can be useful when migrating from subdirectory to subdomain access.
- If you want to remove a subdomain like ``www.mydom.tld`` from your certificate issued, 
  you need to delete the certificate with the ``delete.sh`` script an set up a new one. 
  This also implies that you need to comment the ``inlcude`` directive and follow the 
  steps afterwards.


.. Links

.. _Letsencrypt: https://letsencrypt.org
.. _gitgub: https://github.com/certbot/certbot
.. _ppa: https://launchpad.net/~certbot/+archive/ubuntu/certbot
.. _certbot: https://certbot.eff.org
.. _certbot userguide: https://certbot.eff.org/docs/using.html
.. _ssl_dhparam: http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_dhparam
.. _SSL Labs: https://www.ssllabs.com/ssltest/
.. _crontab.guru: https://crontab.guru
.. _Apache: https://raymii.org/s/tutorials/Strong_SSL_Security_On_Apache2.html
.. _NGINX: https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html
