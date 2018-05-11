Setup NGINX
===========

The following is an example setup process for NGINX, please adapt it to your exact needs.

NGINX ssl_dhparam
-----------------

If not already present, add an `ssl_dhparam`_ directive and a new certificate with stronger keys for Diffie-Hellmann_ based key exchange (which improves `forward secrecy`_).
The OpenSSL command may take a while to complete, so please be patient.
You can place the certificate into any directory you choose.
However, in this guide we recommend ``/etc/nginx/``, just for the sake of simplicity.

::

  sudo openssl dhparam -out /etc/nginx/dh4096.pem 4096

Add the following directive to your common SSL configuration:

.. code-block:: nginx

  ssl_dhparam /etc/nginx/dh4096.pem;

Add the ``/.well-known/acme-challenge`` location in your server directive for port 80

.. code-block:: nginx

   server {
     listen 80 ;
     server_name mydom.tld;

     location /.well-known/acme-challenge {
         default_type "text/plain";
         root /var/www/letsencrypt;
     }
     # ...
   }

Prepare a server directive for port 443
---------------------------------------

It is easiest, if you create a separate file for the following ``ssl_*`` directives.
If these directives already exist in this server block, delete them and include the file instead.
When the certificate has been created, you can use this file in any SSL server block for which the certificate is valid without
reissuing.

::

  cd /etc/nginx/
  sudo mkdir ssl_rules

Create a file named ``ssl_mydom.tld`` in the newly created directory.

.. code-block:: nginx

   # SSL rules for mydom.tld
   # eases letsencrypt initial cert issuing

   ssl on;

   ssl_certificate         /etc/letsencrypt/live/mydom.tld/fullchain.pem;
   ssl_certificate_key     /etc/letsencrypt/live/mydom.tld/privkey.pem;
   ssl_trusted_certificate /etc/letsencrypt/live/mydom.tld/cert.pem;

   ssl_stapling on;
   ssl_stapling_verify on;
   ssl_session_timeout 5m;

Then adopt your server block:

.. code-block:: nginx

  server {
    listen 443 ssl http2;
    server_name mydom.tld;

    # ssl letsencrypt
    # include /etc/nginx/ssl_rules/ssl_mydom.tld;

    #...
  }

.. note::
   Commenting the ``include`` directive is necessary, because the certificate files currently do not exist.

Test and enable your NGINX configuration
----------------------------------------

To test your configuration run

::

  sudo nginx -t

It should reply without errors.

Load your new NGINX configuration:

::

  sudo service nginx reload

Creating certificates
~~~~~~~~~~~~~~~~~~~~~

Check that you have commented out the ``include`` directive as stated above and run the following command:

::

  sudo /etc/letsencrypt/<your-domain-name>.sh

If successful, you will see output similar to that below, when the command completes:

::

  Saving debug log to /var/log/letsencrypt/letsencrypt.log

  -------------------------------------------------------------------------------
  Would you be willing to share your email address with the Electronic Frontier
  Foundation, a founding partner of the Let's Encrypt project and the non-profit
  organization that develops Certbot? We'd like to send you email about EFF and
  our work to encrypt the web, protect its users and defend digital rights.
  -------------------------------------------------------------------------------
  (Y)es/(N)o: Y
  Obtaining a new certificate
  Performing the following challenges:
  http-01 challenge for mydom.tld
  Using the webroot path /var/www/html for all unmatched domains.
  Waiting for verification...
  Cleaning up challenges
  Running post-hook command: service nginx reload

  IMPORTANT NOTES:
   1. Congratulations! Your certificate and chain have been saved at:
      /etc/letsencrypt/live/mydom.tld/fullchain.pem
      Your key file has been saved at:
      /etc/letsencrypt/live/mydom.tld/privkey.pem
      Your cert will expire on 2018-06-18. To obtain a new or tweaked
      version of this certificate in the future, simply run certbot
      again. To non-interactively renew *all* of your certificates, run
      "certbot renew"
   2. Your account credentials have been saved in your Certbot
      configuration directory at /etc/letsencrypt. You should make a
      secure backup of this folder now. This configuration directory will
      also contain certificates and private keys obtained by Certbot so
      making regular backups of this folder is ideal.
   3. If you like Certbot, please consider supporting our work by:

      Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
      Donating to EFF:                    https://eff.org/donate-le

To double check the issued certificate, run the ``list.sh`` script as follows.

::

  sudo /etc/letsencrypt/list.sh

If successful, you should see output similar to the following:

::

  Saving debug log to /var/log/letsencrypt/letsencrypt.log

  -------------------------------------------------------------------------------
  Found the following certs:
    Certificate Name: mydom.tld
      Domains: mydom.tld
      Expiry Date: 2018-06-18 13:20:34+00:00 (VALID: 89 days)
      Certificate Path: /etc/letsencrypt/live/mydom.tld/fullchain.pem
      Private Key Path: /etc/letsencrypt/live/mydom.tld/privkey.pem
  -------------------------------------------------------------------------------

As the SSL certificate has been successfully issued by Let’s Encrypt, you can un-comment the ``include`` directive for your domain’s SSL rules, in the server block configuration.

.. code-block:: nginx

  server {
    listen 443 ssl http2 ;
    server_name mydom.tld;

    # ssl letsencrypt
    include /etc/nginx/ssl_rules/ssl_mydom.tld;

    #...
  }

Reload the NGINX configuration
------------------------------

::

  sudo service nginx reload

Your web server is now ready to serve https request for the given domain using the issued certificates.

.. Links

.. _ssl_dhparam: http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_dhparam
.. _forward secrecy: https://scotthelme.co.uk/perfect-forward-secrecy/
.. _Diffie-Hellman: https://en.wikipedia.org/wiki/Diffie–Hellman_key_exchange
