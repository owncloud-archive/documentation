.. _letsencrypt-apache-label:
Setup Apache and issue a certificate
------------------------------------

The following is an example configuration, please adopt to your exact needs.

**Apache SSLOpenSSLConfCmd DHParameters**

For Apache 2.4.8 or later and OpenSSL 1.0.2 or later, you can generate and specify your DH params file. 
Please search the internet if you have older versions.

If not already present, add a `SSLOpenSSLConfCmd`_ directive and a new certificate with stronger keys
improving Forward Secrecy. The openssl command may take a while - be patient. You can place the
cetificate into any directory of choice.

::

  sudo openssl dhparam -out /etc/nginx/dh4096.pem 4096
  
Add the following directive to your common ssl configuration:

.. code-block:: apacheconf

  SSLOpenSSLConfCmd DHParameters /etc/apache2/dh4096.pem

**Add the /.well-known/acme-challenge location in your virtualHost directive for port 80**

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
  
**Prepare the virtualHost directive at port 443**

It is easiest, if you create a seperate file for the following ``SSL`` directives. If these directives
already exist in this virtualHost, delete them and include the file instead. When the certificate has 
been created, you can use this file in any ssl virtualHost for which the certificate is valid without 
reissuing.

::

  cd /etc/apache2/
  sudo mkdir ssl_rules
  
Ceate a file named ``ssl_mydom.tld`` in the newly created directory. 

.. code-block:: apacheconf

  # ssl rules for mydom.tld
  # eases letsencrypt initial cert issuing

        SSLEngine on

        SSLCertificateChainFile  /etc/letsencrypt/live/mydom.tld/fullchain.pem
        SSLCertificateKeyFile    /etc/letsencrypt/live/mydom.tld/privkey.pem
        SSLCertificateFile       /etc/letsencrypt/live/mydom.tld/cert.pem

        SSLUseStapling on
        SSLStaplingCache         shmcb:/tmp/stapling_cache(2097152)
        # Add other directives like SSLCipherSuite on demand

Then adopt your virtualHost block:

.. code-block:: apacheconf

  <virtualHost *.443>
    ServerName mydom.tld
 
    # ssl letsencrypt
  # Include /etc/apache2/ssl_rules/ssl_mydom.tld
  
    #...
  </virtualHost>

Commenting the ``Inlcude`` directive is necessary, because the certificate files currently do not exists.

**Test your Apache config and enable it**

To test your configuration run 

::

  sudo apachectl -t
  
It should reply without errors. 

Load your new Apache configuration:

::

  sudo apache2ctl graceful

Creating certificates
~~~~~~~~~~~~~~~~~~~~~

**Issue the certificates for the first time**

Check that you have commented out the ``Include`` directive as stated above and run

::

  sudo /etc/letsencrypt/<your-domain-name>.sh

To double check the issued certificate, run the ``list.sh`` script.

::

  sudo /etc/letsencrypt/list.sh

**Uncomment the Include directive in the Apache configuration**

When successfully issuing the certificate for the first time, the certificate files exist 
and you can uncomment the ``Include`` directive to use them with ssl.

.. code-block:: nginx

  <virtualHost *.443>
    ServerName mydom.tld
 
    # ssl letsencrypt
    Include /etc/apache2/ssl_rules/ssl_mydom.tld
  
    #...
  </virtualHost>

**Reload the Apache configuration**

::

  sudo apache2ctl graceful

Your web server is now ready to serve https request for the given domain using the issued certificates.

.. Links

.. _SSLOpenSSLConfCmd: http://httpd.apache.org/docs/current/mod/mod_ssl.html
