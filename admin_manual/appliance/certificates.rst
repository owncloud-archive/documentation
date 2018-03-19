=======================
How to add certificates
=======================

If you want to add your own certificates for the appliance,

you will have to follow these steps.

1. Create the certificates and deposit them on your appliance.
2. Connect to your appliance either directly on the command line of your virtual machine 
   or via ssh connection to your appliance.
3. Execute the following commands:

ucr set apache2/ssl/certificate="/etc/myssl/cert.pem"
ucr set apache2/ssl/key="/etc/myssl/private.key"

Adjust the path and filename to match your certificate.

Then restart the apache2 service, using the following command:

service apache2 restart

Now your certificates will be used to access your applince.
