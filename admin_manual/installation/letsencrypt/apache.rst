Setup Apache
============

The following is an example setup process for Apache, please adopt to your exact needs.

Apache SSLOpenSSLConfCmd DHParameters
-------------------------------------

For Apache 2.4.8 or later and OpenSSL 1.0.2 or later, you can generate and specify your `Diffie-Hellman`_ (DH) params file.
If not already present, add an `SSLOpenSSLConfCmd`_ directive and a new certificate with stronger keys (which improves `forward secrecy`_).
The OpenSSL command may take a quite a while to complete, so please be patient.

You can place the certificate into any directory of your choice.
We recommend ``/etc/apache2/`` in this guide, just for the sake of simplicity.

::

  sudo openssl dhparam -out /etc/apache2/dh4096.pem 4096

Add the following directive to your common SSL configuration:

.. code-block:: apacheconf

  SSLOpenSSLConfCmd DHParameters /etc/apache2/dh4096.pem

Add the ``/.well-known/acme-challenge`` location in your Virtual Host directive for port 80

.. code-block:: apacheconf

  <virtualHost *.80>
    ServerName mydom.tld

    Alias /.well-known/acme-challenge/ /var/www/letsencrypt/.well-known/acme-challenge/
    <Directory "/var/www/letsencrypt/.well-known/acme-challenge/">
        Options None
        AllowOverride None
        ForceType text/plain
        RedirectMatch 404 "^(?!/\.well-known/acme-challenge/[\w-]{43}$)"
    </Directory>

    # ...
  </virtualHost>

Prepare a virtualHost directive for port 443
--------------------------------------------

It is easiest, if you create a separate file for the following ``SSL`` directives.
If these directives already exist in this Virtual Host, delete them and include the file instead.
When the certificate has been created, you can use this file in any SSL Virtual Host for which the certificate is valid, without
reissuing.

::

  cd /etc/apache2/
  sudo mkdir ssl_rules

Create a file named ``ssl_mydom.tld`` in the newly created directory.

.. code-block:: apacheconf

   # ssl rules for mydom.tld
   # eases letsencrypt initial cert issuing

   SSLEngine on

   SSLCertificateChainFile  /etc/letsencrypt/live/mydom.tld/fullchain.pem
   SSLCertificateKeyFile    /etc/letsencrypt/live/mydom.tld/privkey.pem
   SSLCertificateFile       /etc/letsencrypt/live/mydom.tld/cert.pem

To reduce the SSL performance penalty, we recommend you use the `SSLUseStapling`_ and `SSLStaplingCache`_ directives:
Here’s an example configuration:

::

   SSLUseStapling on
   SSLStaplingCache         shmcb:/tmp/stapling_cache(2097152)

Then adopt your Virtual Host block:

.. code-block:: apacheconf

  <virtualHost *:443>
    ServerName mydom.tld

    # ssl letsencrypt
    # Include /etc/apache2/ssl_rules/ssl_mydom.tld

    #...
  </virtualHost>

Commenting the ``Include`` directive is required, because the certificate files currently do not exist.

Test and enable your Apache configuration
-----------------------------------------

To test your configuration run

::

  sudo apache2ctl -t # You can also use: sudo apache2ctl configtest

It should reply without errors.
Load your new Apache configuration:

::

  sudo apache2ctl graceful

Creating certificates
~~~~~~~~~~~~~~~~~~~~~

Check that you have commented out the ``Include`` directive as stated above and run the following command:

::

  sudo /etc/letsencrypt/<your-domain-name>.sh

To double check the issued certificate, run the ``list.sh`` script.

::

  sudo /etc/letsencrypt/list.sh

If successful, you will see output similar to that below, when the command completes:

::

  Saving debug log to /var/log/letsencrypt/letsencrypt.log

  -------------------------------------------------------------------------------
  Found the following certs:
    Certificate Name: mydom.tld
      Domains: mydom.tld
      Expiry Date: 2018-06-18 10:57:18+00:00 (VALID: 89 days)
      Certificate Path: /etc/letsencrypt/live/mydom.tld/fullchain.pem
      Private Key Path: /etc/letsencrypt/live/mydom.tld/privkey.pem
  -------------------------------------------------------------------------------

When successfully issuing the certificate for the first time, the certificate files exist and you can un-comment the ``Include`` directive to use them with SSL.

.. code-block:: apacheconf

  <virtualHost *:443>
    ServerName mydom.tld

    # ssl letsencrypt
    Include /etc/apache2/ssl_rules/ssl_mydom.tld

    #...
  </virtualHost>

Reload the Apache configuration
-------------------------------

::

  sudo service apache2 reload

Your web server is now ready to serve https request for the given domain using the issued certificates.

.. Links

.. _SSLOpenSSLConfCmd: https://httpd.apache.org/docs/trunk/mod/mod_ssl.html#sslopensslconfcmd
.. _forward secrecy: https://scotthelme.co.uk/perfect-forward-secrecy/
.. _Diffie-Hellman: https://en.wikipedia.org/wiki/Diffie–Hellman_key_exchange
.. _SSLUseStapling: https://httpd.apache.org/docs/trunk/mod/mod_ssl.html#sslusestapling
.. _SSLStaplingCache: https://httpd.apache.org/docs/trunk/mod/mod_ssl.html#sslstaplingcache
