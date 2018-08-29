=======================================================
How To Install and Configure an LDAP Proxy-Cache Server
=======================================================

Background
----------

To reduce network traffic overhead and avoid problems either logging in or performing user searches while sharing, it's an excellent idea to implement an LDAP proxy cache.

An LDAP proxy cache server, similar to other kinds of caching servers, is a special type of LDAP replica. It can cache a range of LDAP records, often resulting in improved LDAP server performance.

Specifically, the records which need to be cached, for improved ownCloud performance, are:

- Users that are allowed to log in
- Groups (limited to the allowed users)
- Search fields (e.g., ``sAMAccountName``, ``cn``, ``sn``, ``givenName``, and ``displayName``)

How To Setup the Server
-----------------------

There's not that much to it, just the following five steps:

1. Install OpenLDAP
2. Configure the server
3. Edit the default configuration directory
4. Perform a test search
5. Check the logs
6. Configure ownCloud LDAP app

Let's begin.

1. Install OpenLDAP 
--------------------

There are a number of `LDAP server implementations`_ available. 
The one used in this guide is `OpenLDAP`_.

.. note::
   While OpenLDAP does work on any operating system, for the purposes of this guide, we'll be using a Debian-based Linux distribution. 

Firstly, log in as root, and update your system, to ensure that you're using the latest packages.::

   apt-get update && apt-get upgrade -y

Next, install OpenLDAP and its associated packages.::

   apt-get install slapd ldap-utils -y

2. Configure the Server
-----------------------

With OpenLDAP installed and running, you now need to configure the server.
One way of doing so, is to create a configuration file.
So, create ``/etc/ldap/slapd.conf`` with your text editor of choice, and add the following configuration to it. 

.. literalinclude:: examples/single.slapd.conf

.. note::
  This configuration only caches queries from a single Active Directory server.
  To cache queries from multiple Active Directory servers, a configuration is available below.

After you've done that, save the file, test that there are no errors in the configuration by running::

   slaptest -f /etc/ldap/slapd.conf

.. note::
   If you see warnings in the console output, they are not crucial.

3. Enable the configuration file
--------------------------------

Next, we need to tell OpenLDAP to use our configuration. 
To do so, open ``/etc/default/slapd`` and add the following line to it::

   SLAPD_CONF=/etc/ldap/slapd.conf

With that done, restart OpenLDAP by running the following command::

   service slapd restart

4. Open the log 
-----------------

Open another terminal and see the systemlog with the following command.::

  tail -f /var/log/syslog | grep QUERY

If there is no such file, you need to install rsyslog with.

::

  apt install rsyslog 

5. Perform a test search
------------------------

Now that the server's installed, configured, and running, we next need to perform a search. 
This will check that records are being correctly cached.
To do so, update the command below with values from your Active Directory server configuration, and then run it.::

  ldapsearch -h localhost -x -LLL -D "cn=admin,cn=users,dc=example,dc=com" -b "cn=users,dc=example,dc=com" -w "Password" "(cn=Administrator)" name

or

  ldapsearch -H ldaps://localhost:636 -x -LLL -D "cn=admin,cn=users,dc=example,dc=com" -b "cn=users,dc=example,dc=com" -W "(cn=Administrator)" name

-h = host address (Example: localhost or 192.168.1.1)
-H = host address (Example: ``ldap://`` or ``ldaps://`` hostname or ip and port :389 or :636 )
-x = simple authentication
-b = Search Base, (Example: "cn=Users,dc=example,dc=com")
-D = User with permissions (Example: "cn=Admin,dc=example,dc=com")
-LLL = Show only results, no extra information
-w = Password ("Password")
-W = Password, will ask for password and hide your input
"(cn=Administrator)" = Filter the search
name = Show only this attributes

If you see results including: ``"Query cachable"`` and ``"Query answered (x) times"``, then the setup works. 


6. Configure ownCloud LDAP App
--------------------------------

Login as ownCloud admin in your ownCloud server.

Click on the dropdown menu in the top-left corner next to "Files", then on Apps. 

Click on "Not enabled", and enable the "LDAP user and group backend" App.

Go to the admin dropdown menu in the top-right corner, select "Admin".

In the administration section, click on the left side on "LDAP".


Configure Server-Tab

First enter the server address, either IP or DN.

You can click on the button to detect your servers port or enter it manually.

Next, enter the dn of the user, you want to log in with and in the next line enter the password.

Then you can click on "detect base dn" or enter it manually. then click on "test base dn".

If you fulfill all the requirements you should get a green light and "configuration ok" message.


Configure Users

Select the objectclass for the users, for example "user".

Verify your settings; where you will see the number of users being found.


Configure Login Attributes

A configuration appears by default, adjusted it to your users configuration. 

If required, adjust the login parameters additional login attributes.


You can check users with any of the allowed login options. You can adjust them or leave them the way they are.


Configure Groups

Select all the objectclasses for your groups, for example "group". Verify your settings.


Configure Advanced

Configuration Active should be selected.

Adjust the Cache TTL (time to live) value as required.   

ownCloud usually autoselects the best settings for each AD configuration.

Check if the Group-Member association is "Member (AD)".
That's important for the users being shown in their respective groups.

Select "Nested groups", if you have them.


Configure Expert

"Internal Username Attribute" 

Here we need to set "cn" for the users being shown with their unique name. 
If you leave that field empty, each user will get a unique uid as a string of numbers and letters.

Clear the Username and Groupname Mapping and test your configuration by clicking on the buttons below.


Navigate to Admin -> Users and check if all your users are listed properly, and shown in the right groups.

Go to the homepage of your ownCloud server and try to share something with one of your users

If everything is set up correctly, you now have an LDAP proxy server to your active directory that will

reduce the network traffic by caching the searches your perform.

Cache Multiple Active Directory Servers
---------------------------------------

If you have more than one that you want to cache, in ``/etc/ldap/slapd.conf`` add the following configuration instead, 
adjusting as necessary. The ownCloud LDAP app settings are the same as in section 6.

.. literalinclude:: examples/Multi-AD.slapd.conf

.. Links

.. _ownCloud Doc: https://doc.owncloud.com/server/latest/admin_manual/configuration/user/user_auth_ldap.html?highlight=ldap
.. _LDAP server implementations: https://en.wikipedia.org/wiki/List_of_LDAP_software
.. _OpenLDAP: https://en.wikipedia.org/wiki/OpenLDAP


