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

::

  include /etc/ldap/schema/core.schema
  include /etc/ldap/schema/cosine.schema
  include /etc/ldap/schema/nis.schema
  include /etc/ldap/schema/inetorgperson.schema

  pidfile /var/run/slapd/slapd.pid
  argsfile /var/run/slapd/slapd.args

  loglevel any

  modulepath /usr/lib/ldap
  moduleload back_ldap.la
  moduleload back_mdb.la
  moduleload rwm

  sizelimit 500
  tool-threads 1

  backend ldap

  database ldap
  readonly yes
  protocol-version 3
  rebind-as-user
  
  # ------------------- CHANGE ME ------------------- #

  uri "ldap://YOUR_AD_URL_OR_IP:389"       # Hostname or IP Address of your Active Directory server
  suffix "dc=ad,dc=YOUR_DOMAIN,dc=com"     # Your domain's search suffix
  rootdn "dc=ad,dc=YOUR_DOMAIN,dc=com"     # Your domain's root dn

  # ------------------- CHANGE ME ------------------- #

  overlay rwm
  rwm-map attribute uid sAMAccountName
  rwm-map attribute mail proxyAddresses
  moduleload pcache.la

  overlay pcache
  pcache mdb 100000 1 1000 100
  pcacheAttrset 0 *
  pcacheTemplate (sn=) 0 3600
  pcacheTemplate (cn=) 0 3600
  pcachePersist TRUE
  directory /var/lib/ldap

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

.. note::
   If you see warnings in the console output, they are not crucial.

4. Perform a Test Search
------------------------

Now that the server's installed, configured, and running, we next need to perform a search. 
This will check that records are being correctly cached.
To do so, replace ``ldap://localhost`` and ``dc=YOUR_DOMAIN`` in the command below with values from your Active Directory server configuration, and then run it.::

  ldapsearch -H ldap://localhost -x -b "cn=users,dc=ad,dc=YOUR_DOMAIN,dc=com" -D "cn=users,dc=ad,dc=YOUR_DOMAIN,dc=com"  -LLL "(sn=Name)" -w "Password"

5. Check the Logs 
-----------------

If the query was cached, then it will be visible in the logs. 
To check, run the following command.::

  tail -f /var/log/syslog | grep QUERY

If you see results, then the setup works. 

Cache Multiple Active Directory Servers
---------------------------------------

If you have more than one that you want to cache, in ``/etc/ldap/slapd.conf`` add the following configuration instead, adjusting as necessary.::

  include			/etc/ldap/schema/core.schema
  include			/etc/ldap/schema/cosine.schema
  include			/etc/ldap/schema/nis.schema
  include			/etc/ldap/schema/inetorgperson.schema

  pidfile			/var/run/slapd/slapd.pid
  argsfile			/var/run/slapd/slapd.args

  loglevel			any

  modulepath		/usr/lib/ldap
  moduleload		rwm
  moduleload		pcache.la
  moduleload		back_ldap.la
  moduleload		back_mdb.la
  moduleload		back_meta.la

  sizelimit			500
  tool-threads		1

  database			meta
  norefs			yes

  # ------------------- CHANGE ME ------------------- #

  suffix			"dc=YOUR_DOMAIN,dc=com" 
  rootdn			"cn=admin,dc=YOUR_DOMAIN,dc=com" 
  rootpw			"Password" 
  overlay			pcache 
  uri				"ldap://YOUR_FIRST_AD_URL_OR_IP:389/cn=users,dc=ad,dc=YOUR_DOMAIN,dc=com" 
  suffixmassage		"cn=users,dc=ad,dc=YOUR_DOMAIN,dc=com" "cn=users,dc=ad,dc=YOUR_DOMAIN,dc=com"
  idassert-bind		bindmethod=simple
                    binddn="CN=ldapsearch,cn=users,dc=ad,DC=YOUR_DOMAIN,dc=com"
                    credentials="Password"

  uri				"ldap://YOUR_FIRST_AD_URL_OR_IP:389/cn=users,dc=int,dc=YOUR_DOMAIN,dc=com" 
  suffixmassage		"cn=users,dc=int,dc=YOUR_DOMAIN,dc=com" "cn=users,dc=int,dc=YOUR_DOMAIN,dc=com" 
  idassert-bind		bindmethod=simple
                    binddn="cn=Administrator,cn=Users,dc=ad,dc=YOUR_DOMAIN,dc=com"
                    credentials="Password"

  # ------------------- CHANGE ME ------------------- #

  pcache			mdb 100000 1 1000 100
  pcacheAttrset		0 *
  pcacheTemplate	(sn=) 0 3600
  pcacheTemplate	(cn=) 0 3600
  pcachePersist		TRUE
  directory			/var/lib/ldap

.. Links
   
.. _LDAP server implementations: https://en.wikipedia.org/wiki/List_of_LDAP_software 
.. _OpenLDAP: https://en.wikipedia.org/wiki/OpenLDAP
