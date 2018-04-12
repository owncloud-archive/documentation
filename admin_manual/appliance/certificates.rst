=======================
How to add certificates
=======================

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
