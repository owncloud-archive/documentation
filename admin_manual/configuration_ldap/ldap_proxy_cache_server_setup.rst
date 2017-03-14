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
- Quota
- Mail
- Search fields (e.g., ``sAMAccountName``, ``cn``, ``sn``, ``givenName``, and ``displayName``)

How To Setup the Server
-----------------------

There's not that much to it, just the following five steps:

1. Install OpenLDAP
2. Configure the server
3. Edit the Default Configuration Directory
4. Perform a Test Search
5. Check the Logs

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
So, open ``/etc/ldap/slapd.conf`` with your text editor of choice, and add the following configuration to it. 

.. literalinclude:: examples/single-server.slapd.conf

.. note::
  This configuration only caches queries from a single Active Directory server.
  To cache queries from multiple Active Directory servers, a configuration is available below.

After you've done that, save the file, test that there are no errors in the configuration by running::

   slaptest -f /etc/ldap/slapd.conf

3. Enable the Configuration File
--------------------------------

Next, we need to tell OpenLDAP to use our configuration. 
To do so, open ``/etc/default/slapd`` and add the following line to it::

   SLAPD_CONF=/etc/ldap/slapd.conf

With that done, restart OpenLDAP by running the following command::

   service slapd restart

4. Perform a Test Search
------------------------

Now that the server's installed, configured, and running, we next need to perform a search. 
This will check that records are being correctly cached.
To do so, update the command below with values from your Active Directory server configuration, and then run it.::

  ldapsearch -H ldap://localhost -x -b "cn=users,dc=ad,dc=YOUR_DOMAIN,dc=com" -D "cn=users,dc=ad,dc=YOUR_DOMAIN,dc=com"  -LLL "(sn=Name)" -w "Password"

.. note::
   If you see warnings in the console output, they are not crucial.

5. Check the Logs 
-----------------

If the query was cached, then it will be visible in the logs. 
To check, run the following command.::

  tail -f /var/log/syslog | grep QUERY

If you see results including: ``"Query cachable"`` and ``"Query answered (x) times"``, then the setup works. 

Cache Multiple Active Directory Servers
---------------------------------------

If you have more than one that you want to cache, in ``/etc/ldap/slapd.conf`` add the following configuration instead, adjusting as necessary.

.. literalinclude:: examples/multi-server.slapd.conf

.. Links
   
.. _LDAP server implementations: https://en.wikipedia.org/wiki/List_of_LDAP_software 
.. _OpenLDAP: https://en.wikipedia.org/wiki/OpenLDAP
