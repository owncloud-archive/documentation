================================================================================
SAML 2.0 Based SSO with Active Directory Federation Services (ADFS) and mod_shib
================================================================================

Preparation
-----------

Before you can setup SAML 2.0 based |SSOabbr| with `Active Directory Federation Services (ADFS) <https://msdn.microsoft.com/en-us/library/bb897402.aspx>`_ and mod_shib, ask your ADFS admin for the relevant server URLs.
These are:

- The SAML 2.0 single sign-on service URL, e.g., ``https://<ADFS server FQDN>/ADFS/ls``
- The IdP metadata URL, e.g., ``https://<ADFS server FQDN>/FederationMetadata/2007-06/FederationMetadata.xml``

Then, make sure that the web server is accessible with a trusted certificate:

.. code:: console

 $ sudo a2enmod ssl
 $ sudo a2ensite default-ssl
 $ sudo service apache2 restart

Installation
------------

Firstly, install `mod_shib`_.
You can do this using the following command:

.. code:: console

 $ sudo apt-get install libapache2-mod_shib2

This will install packages needed for mod_shib, including ``shibd``.
Then, generate certificates for the ``shibd`` daemon by running the following command:

.. code:: console

  sudo shib-keygen

Download and Filter the ADFS Metadata
-------------------------------------

The metadata provided by ADFS cannot be automatically imported, and must be cleaned up before using it with the file based MetadataProvider.
To do so, use ``adfs2fed.php``, as in the following command:

.. code-block:: console

  php apps/user_shibboleth/tools/adfs2fed.php \
     https://<ADFS server FQDN>/FederationMetadata/2007-06/FederationMetadata.xml \
     <AD-Domain> > /etc/shibboleth/filtered-metadata.xml

Configure shibd
---------------

Next, you need to configure ``shibd``.
To do this, in ``/etc/shibboleth/shibboleth2.xml``:

1. Use the URL of the ownCloud instance as the ``entityID`` in the ``ApplicationDefaults``, e.g.,

   .. code:: xml

    <ApplicationDefaults entityID="https://<owncloud server FQDN>/login/saml" REMOTE_USER="eppn upn">

   .. note::

    ``https://<owncloud server FQDN>/login/saml`` is just an example.  Adjust <owncloud server FQDN> to the full qualified domain name of your server.

2. Configure the SSO to use the ``entityID`` from the ``filtered-metadata.xml``, e.g.,

   .. code:: xml

    <SSO entityID="https://<ADFS server FQDN>/<URI>/">
        SAML2
    </SSO>

   .. note::

    Grab <ADFS server FQDN>/<URI>/ from the filtered-metadata.xml.

3. Configure an XML ``MetadataProvider`` with the local ``filtered-metadata.xml`` file:

   .. code:: xml

    <MetadataProvider type="XML" file="/etc/shibboleth/filtered-metadata.xml"/>

Metadata Available
------------------

Under ``https://<owncloud server FQDN>/Shibboleth.sso/Metadata`` shibd exposes the Metadata that is needed by ADFS to add the SP as a Relying party.

ADFS
----

This part needs to be done by an ADFS administrator.
Let him do his job while you continue with the Apache configuration below.

Add a Relying Party Using Metadata
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

See `AD FS 2.0 Step-by-Step Guide <https://technet.microsoft.com/en-us/library/gg317734(v=ws.10).aspx>`_ step 2.

Configure ADFS to send the userPrincipalName in the SAML token
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you have control over ADFS make it send the ``UPN`` and ``Group`` by adding the following LDAP claim rule:

- Map ``User Principal Name`` to ``UPN``
- Map ``Token Groups - Unqualified Names`` and map it to ``Group``

Change shibd ``attribute-map.xml`` to

.. code:: xml

 <Attributes xmlns="urn:mace:shibboleth:2.0:attribute-map" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
     <Attribute name="http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn" id="upn"/>
 </Attributes>

That will make the ``userPrincipalName`` available as the environment variable ``upn``.


Apache2
-------

To protect ownCloud with shibboleth you need to protect the URL with a mod_shib based ``auth``.
Currently, `we recommend protecting only the login page <https://doc.owncloud.org/server/10.0/admin_manual/enterprise/user_management/user_auth_shibboleth.html#the-apache-shibboleth-module>`_.

user_shibboleth
~~~~~~~~~~~~~~~

When the app is enabled and ownCloud is protected by mod_shib, due to the Apache 2 configuration, you should be forced to authenticate against an ADFS.
After a successful authentication you will be redirected to the ownCloud login page, where you can login as the administrator.
Double check you have a valid SAML session by browsing to https://<owncloud server FQDN>/Shibboleth.sso/Session.

In the "User Authentication" settings for Shibboleth the ``upn`` environment variables will be filled with the authenticated user’s ``userPrincipalName`` in the "Server Environment" section.

Use ``upn`` as ``uid`` and set the app mode to 'SSO Only' by running:
.. code-block:: console

  occ shibboleth:mode ssoonly
  occ shibboleth:mapping -u upn


``displayName`` and email are only relevant for ``autoprovisioning`` mode.
Add Claims in ADFS and map them in the ``attribute-map.xml`` if needed.

Testing
-------

- Close the browser tab to kill the session.
- Then visit ``https://<owncloud server FQDN>`` again.
- You should be logged in automatically.
- Close the tab or delete the cookies to log out.
- To make the logout work see the Logout section in this document.

Configuring  SSO
----------------

- On the ADFS Server:
    - Add "Windows Authentication" to the "Service" -> "Authentication Methods" for "Intranet"
    - Run the following Powershell script for Firefox:

::

    # Save the list of currently supported browser user-agents to a variable
    $browsers=Get-ADFSProperties | Select -ExpandProperty WIASupportedUseragents

    # Add Mozilla/5.0 user-agent to the list
    $browsers+="Mozilla/5.0"

    # Apply the new list
    Set-ADFSProperties -WIASupportedUseragents $browsers

    # Turn off Extended Protection
    #Set-ADFSProperties –ExtendedProtectionTokenCheck None

    # Restart the AD FS service
    Restart-Service ADFSsrv

- On the Windows client:

  - For Internet Explorer, Edge, and Chrome

    - In the "Internet Settings" -> "Security" -> "Local Intranet"
    - Click on "Sites"
    - Click on "Advanced"
    - Add your ADFS machine with ``https://<ADFS server FQDN>/`` and click OK.
    - Click on "customize level"
    - Find "User Authentication"
    - Check "Automatic login only for Intranet zone"

  - For Firefox

    - Open "about:config"
    - Accept the warning
    - Search for ``network.negotiate-auth.trusted-uris`` and set it to the FQDN of your ADFS server
    - Search for ``network.automatic-ntlm-auth.trusted-uris`` and set it to the FQDN of your ADFS server

Now if you logged into the domain and open your ownCloud server in the browser of your choice you should get directly to your ownCloud files without a login.

Debugging
---------

In ``/etc/shibboleth/shibd.logger`` set the overall behavior to debug:

.. code-block:: ini

 # set overall behavior
 log4j.rootCategory=DEBUG, shibd_log, warn_log
 [...]

After a restart ``/var/log/shibbloeth/shibd.log`` will show the parsed SAML requests and also which claims / attributes were found and mapped, or why not.

Browsers
--------

-  For Chrome there is a `SAML Chrome Panel <https://chrome.google.com/webstore/detail/saml-chrome-panel/paijfdbeoenhembfhkhllainmocckace>`__ that allows checking the SAML messages in the developer tools reachable via F12.
-  For Firefox there is `SAML tracer <https://addons.mozilla.org/de/firefox/addon/saml-tracer/>`__
-  In the Network tab of the developer extension make sure that "preserve logs" is enabled in order to see the redirects without wiping the existing network requests

Logout
------

In SAML scenarios the session is held on the SP as well as the IdP.
Killing the SP session will redirect you to the IdP where you are still logged in, causing another redirect that creates a new SP session, making logout impossible.
Killing only the IdP session will allow you to use the SP session until it expires.

There are multiple ways to deal with this:

1. By default ownCloud shows a popup telling the user to close the browser tab. That kills the SP session. If the whole browser is closed the IdP may still use a Kerberos-based authentication to provide SSO in effect making logout impossible.
2. Hide the logout action in the personal menu via CSS. This forces users to log out at the IdP.

OAuth2
------

In upcoming versions the clients will use OAuth2 to obtain a device specific token to prevent session expiry, making the old ``/oc-shib/remote.php/nonshib-webdav`` obsolete

Further Reading
---------------

- `ADFS 2.0 Step-by-Step Guide: Federation with Shibboleth 2 and the InCommon Federation <https://technet.microsoft.com/en-us/library/gg317734%28v=ws.10%29.aspx>`_
- `ADFS: How to Invoke a WS-Federation Sign-Out <https://social.technet.microsoft.com/wiki/contents/articles/1439.ad-fs-how-to-invoke-a-ws-federation-sign-out.aspx>`_
- `Shibboleth Service Provider Integration with ADFS <https://blog.kloud.com.au/2014/10/29/shibboleth-service-provider-integration-with-adfs/>`_
- https://github.com/rohe/pysfemma/blob/master/tools/adfs2fed.py
- https://technet.microsoft.com/de-de/library/gg317734(v=ws.10).aspx#BKMK_EditClaimRulesforRelyingPartyTrust
- https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPApplication#NativeSPApplication-BasicConfiguration(Version2.4andAbove)
- https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPMetadataProvider#NativeSPMetadataProvider-XMLMetadataProvider
- https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPServiceSSO

.. Text substitutions

.. |SSOabbr| raw:: html

  <abbr title="Single Sign-On">SSO</abbr>

.. Links

.. _mod_shib: https://packages.ubuntu.com/search?keywords=libapache2-mod-shib
