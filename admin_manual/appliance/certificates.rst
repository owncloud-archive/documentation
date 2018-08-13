=======================
How To Add Certificates
=======================

Let's Encrypt App
~~~~~~~~~~~~~~~~~

Univention offers an easy way to get secure certificates with their Let's Encrypt app.
To install it:

- In the **Univention Appcenter**, click on **Software** and search for **Let's Encrypt**.
- Go to the **App Settings** and generate an certificate by entering your **domain name(s)**.
- After the certificate is generated, restart the web server (or the appliance).

.. figure:: ../images/appliance/ucs/letsencrypt.png
   :alt: Let's Encrypt

.. figure:: ../images/appliance/ucs/letsencrypt-settings.png
   :alt: App Settings

Import your own certificates
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want to use your own SSL certificates for the appliance, you have to follow these three steps:

1. Create the certificates and deposit them on your appliance.
2. Connect to your appliance either directly on the command line of your virtual machine
   or via ssh connection to your appliance.
3. Execute the following commands:

::

  ucr set apache2/ssl/certificate="/etc/myssl/cert.pem"
  ucr set apache2/ssl/key="/etc/myssl/private.key"

.. note:: Remember to adjust the path and filename to match your certificate.

Once you've completed these steps, restart Apache using the following command:

::

  service apache2 restart

Now your certificates will be used to access your appliance.

If you want to limit the access to your server exclusively to HTTPS, use this command:

::

   ucr set apache2/force_https=yes
