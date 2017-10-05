=================
How to Install It
=================

The install process is a little involved, but not too much. 
To keep it succinct, you need to:

- :ref:`Download <appliance-download-label>` and :ref:`install <appliance-download-label>` the appliance 
- Step through :ref:`the configuration wizard <appliance-download-label>`
- :ref:`Activate <appliance-download-label>` the configured appliance 

After that, you can access the running instance of ownCloud and :ref:`further configure it <appliance-download-label>` to suit your needs. 

.. _appliance-download-label:

Download the Appliance
----------------------

First off, you need to download the ownCloud X (10.0.1) Trial Appliance from `the
ownCloud download page`_ and click "**DOWNLOAD NOW**". 
This will display a form, which you can see a sample of below, which you'll need to fill out. 
It will ask you for the following details:

- Email address
- Download version (*ESXi*, *VirtualBox*, *VMware*, *KVM*)
- Your first, last, and company names, and your country of origin

.. image:: ../images/appliance/download-form.png
   :alt: The ownCloud X Trial Appliance download form.

After you've filled out the form, click "**DOWNLOAD OWNCLOUD**" to begin the download of the virtual appliance.

.. note::
   The virtual appliance files are around 1.4GB in size, so may take some time, depending on your network bandwidth.

.. _appliance-install-label:

Install the Appliance
---------------------

Once you've downloaded the virtual appliance file, import it into your virtualization software, accept the T's & C's of the license agreement, and launch it.
The example below shows this being done using VirtualBox.

.. image:: ../images/appliance/import-the-virtual-appliance.png
   :alt: Importing the ownCloud X Trial Appliance OVA file into VirtualBox and accepting the software license agreement terms and conditions.

.. _appliance-start-label:

Start the Appliance
-------------------

Once imported, start the appliance. 
Doing so launches the installer wizard which helps you specify the core configuration.
This includes:

**Localization settings:** Here, you can specify the language, timezone, and keyboard layout. 
Domain and network configuration: These settings can be either obtained automatically, via a DHCP lookup, or provided manually. 

**Domain setup:** This lets you manage users and permissions directly within the ownCloud installation in the virtual appliance, or to make use of an existing Active Directory or UCS domain.

**Account information:** This lets you specify your organisation's name, the email address (used for receiving the license which you'll need to activate the appliance), and the administrator password. Note, this password is for the administrator (or root user) of the virtual machine, not for the ownCloud installation.

**Host settings:** This lets you specify the fully-qualified domain name of the virtual appliance, as well as an LDAP Base DN. 

Once you've provided all of the required information, you can then finish the wizard, which will finish building the virtual appliance. Make sure that you double-check the information provided, so that you don't have to start over.

.. _appliance-activate-label:

Activate the Appliance
----------------------

When the wizard completes, the virtual machine will be almost ready to use.
You then need only retrieve the license file from the email which was sent to you and upload it.
The page to do that from can be found by opening your browser to the IP address of the virtual appliance, as you can see below.
The installer may instruct you to use ``https://`` to access the activation page. If this gives an error in the browser, then remove the ``https://``.

.. image:: ../images/appliance/activate-the-virtual-appliance.png
   :alt: Activate the ownCloud X Trial Appliance.

.. _appliance-administer-label:

Administer the Appliance
------------------------

Once activated, you should be redirected to the appliance login page, which you can see below.
Login using the password that you supplied during the configuration wizard earlier.

.. image:: ../images/appliance/login-to-the-virtual-appliance.png
   :alt: Administer the ownCloud X Trial Appliance.

.. note:: 
   If you are not redirected to the appliance login page, you can open it using the following url: ``https://<ip address of the virtual machine>/univention-management-console``.

After you've done so, you will now be at the Univention management console, which you can see below.

.. image:: ../images/appliance/univention-management-console.png
   :alt: The Univention Management Console.

The management console allows you to manage the virtual appliance (1), covering such areas as: *users*, *devices*, *domains*, and *software*.
You will also be able to access the ownCloud web interface (2). 

.. note:: 
   The default username for the ownCloud is: ``owncloud`` and so is the password.
   The password is **not** the password you supplied during the configuration wizard.

.. Links
   
.. _VMware: https://www.vmware.com
.. _KVM: https://www.linux-kvm.org/page/Main_Page
.. _Xen: https://www.xenproject.org/developers/teams/hypervisor.html 
.. _Hyper-V: https://www.microsoft.com/en-us/cloud-platform/server-virtualization
.. _the press release: https://owncloud.com/enterprise-appliance-production-faq/
.. _purchase the license key: https://owncloud.com/contact
.. _the ownCloud download page: https://owncloud.com/download

