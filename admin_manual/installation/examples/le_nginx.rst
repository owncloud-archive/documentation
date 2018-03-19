.. _letsencrypt-nginx-label:
Setup NGINX and issue a certificate
-----------------------------------

The following is an example configuration, please adopt to your exact needs.

**NGINX ssl_dhparam**

If not already present, add a `ssl_dhparam`_ directive and a new certificate with stronger keys
improving Forward Secrecy. The openssl command may take a while - be patient. You can place the
cetificate into any directory of choice.

::

  sudo openssl dhparam -out /etc/nginx/dh4096.pem 4096
  
Add the following directive to your common ssl configuration:

.. code-block:: nginx

  ssl_dhparam /etc/nginx/dh4096.pem;

**Add the /.well-known/acme-challenge location in your server directive for port 80**

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

**Prepare the server directive at port 443**

It is easiest, if you create a seperate file for the following ``ssl`` directives. If these directives
already exist in this server block, delete them and include the file instead. When the certificate has 
been created, you can use this file in any ssl server block for which the certificate is valid without 
reissuing.

::

  cd /etc/nginx/
  sudo mkdir ssl_rules
  
Ceate a file named ``ssl_mydom.tld`` in the newly created directory. 

.. code-block:: nginx

  # ssl rules for mydom.tld
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
    listen 443 ssl http2 ;
    server_name mydom.tld;
 
    # ssl letsencrypt
  # include /etc/nginx/ssl_rules/ssl_mydom.tld;
  
    #...
  }

Commenting the ``inlcude`` directive is necessary, because the certificate files currently do not exists.

**Test your NGINX config and enable it**

To test your configuration run 

::

  sudo nginx -t
  
It should reply without errors. 

Load your new NGINX configuration:

::

  sudo service nginx reload

Creating certificates
~~~~~~~~~~~~~~~~~~~~~

**Issue the certificates for the first time**

Check that you have commented out the ``include`` directive as stated above and run

::

  sudo /etc/letsencrypt/<your-domain-name>.sh

To double check the issued certificate, run the ``list.sh`` script.

::

  sudo /etc/letsencrypt/list.sh

**Uncomment the include directive in the NGINX configuration**

When successfully issuing the certificate for the first time, the certificate files exist 
and you can uncomment the ``include`` directive to use them with ssl.

.. code-block:: nginx

  server {
    listen 443 ssl http2 ;
    server_name mydom.tld;
 
    # ssl letsencrypt
    include /etc/nginx/ssl_rules/ssl_mydom.tld;
  
    #...
  }

**Reload the nginx configuration**

::

  sudo service nginx reload

Your web server is now ready to serve https request for the given domain using the issued certificates.

.. Links

.. _ssl_dhparam: http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_dhparam
