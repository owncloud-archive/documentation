======
OAuth2
======

What is it?
-----------

Quoting `RFC 6749`_:

  The OAuth 2.0 authorization framework enables a third-party application to obtain limited access to an HTTP service,
  either on behalf of a resource owner by orchestrating an approval interaction between the resource owner and the HTTP
  service, or by allowing the third-party application to obtain access on its own behalf.

::

     +----------+
     | Resource |
     |   Owner  |
     |          |
     +----------+
          ^
          |
         (B)
     +----|-----+          Client Identifier      +---------------+
     |         -+----(A)-- & Redirection URI ---->|               |
     |  User-   |                                 | Authorization |
     |  Agent  -+----(B)-- User authenticates --->|     Server    |
     |          |                                 |               |
     |         -+----(C)-- Authorization Code ---<|               |
     +-|----|---+                                 +---------------+
       |    |                                         ^      v
      (A)  (C)                                        |      |
       |    |                                         |      |
       ^    v                                         |      |
     +---------+                                      |      |
     |         |>---(D)-- Authorization Code ---------'      |
     |  Client |          & Redirection URI                  |
     |         |                                             |
     |         |<---(E)----- Access Token -------------------'
     +---------+       (w/ Optional Refresh Token)

OAuth2 support is available via `an OAuth2 application`_, available from the ownCloud Marketplace.
The aim of it is to:

- Connect the ownCloud clients (both desktop and mobile) in a standardized and secure way
- To make integrations in 3rd party software easier by providing an authorization interface.

Benefits
--------

Connecting Clients via OAuth2
-----------------------------

Revoking Sessions
-----------------

Administration
--------------

Installing the app
~~~~~~~~~~~~~~~~~~

Place the content of this repository in **owncloud/apps/oauth2**.

Using the app
~~~~~~~~~~~~~

Endpoints
^^^^^^^^^

================= =======================================
Description       URI
================= =======================================
Authorization URL ``/index.php/apps/oauth2/authorize``
Access Token URL  ``/index.php/apps/oauth2/api/v1/token``
================= =======================================

Protocol Flow
^^^^^^^^^^^^^

Client Registration
''''''''''''''''''''

First the clients have to be registered in the admin settings: ``/index.php/settings/admin?sectionid=additional#oauth2``.
You need to specify a name for the client (the name is unrelated to the OAuth 2.0 protocol and is just used to recognize it later) and the redirection URI.
A client identifier and client secret is being generated when adding a new client.
They both consist of 64 characters.

For further information about client registration, please refer to `the official client registration RFC from the IETF`_.

Authorization Request
''''''''''''''''''''''

For every registered client an authorization request can be made.
The client redirects the resource owner to the authorization URL and requests authorization.
The following URL parameters have to be specified:

================= ========== ========================================================================================
Parameter         Required   Description
================= ========== ========================================================================================
``response_type``  yes       Needs to be `code` because at this time only the authorization code flow is implemented.
``client_id``      yes       The client identifier obtained when registering the client.
``redirect_uri``   yes       The redirection URI specified when registering the client.
``state``          no        Can be set by the client "to maintain state between the request and callback".
                             See `RFC 6749`_ for more information.
================= ========== ========================================================================================

For further information about client registration, please refer to `the official authorization request RFC from the IETF`_.

Authorization Response
'''''''''''''''''''''''

After the resource owner's authorization the app redirects to the `redirect_uri` specified in the authorization request and adds the authorization code as URL parameter `code`.
An authorization code is valid for 10 minutes.

For further information about client registration, please refer to `the official authorization response RFC from the IETF`_.

Access Token Request
''''''''''''''''''''

With the authorization code the client can request an access token using the access token URL.
`Client authentication`_ is done using basic authentication with the client identifier as username and the client secret as password.
The following URL parameters have to be specified:

================= ============================= ===================================================
Parameter         Required                      Description
================= ============================= ===================================================
``grant_type``                                  Either ``authorization_code`` or ``refresh_token``.
``code``          if the grant type
                  `authorization_code` is used.
``redirect_uri``  if the grant type
                  `authorization_code` is used.
``refresh_token`` if the grant type
                  `refresh_token` is used.
================= ============================= ===================================================

For further information about client registration, please refer to `the official access token request RFC from the IETF`_.

Access Token Response
'''''''''''''''''''''

The app responses to a valid access token request with an JSON response like the following.
An access token is valid for 1 hour and can be refreshed with a refresh token.

.. code-block:: json

  {
      "access_token" : "1vtnuo1NkIsbndAjVnhl7y0wJha59JyaAiFIVQDvcBY2uvKmj5EPBEhss0pauzdQ",
      "token_type" : "Bearer",
      "expires_in" : 3600,
      "refresh_token" : "7y0wJuvKmj5E1vjVnhlPBEhha59JyaAiFIVQDvcBY2ss0pauzdQtnuo1NkIsbndA",
      "user_id" : "admin",
      "message_url" : "https://www.example.org/owncloud/index.php/apps/oauth2/authorization-successful"
  }

For further information about client registration, please refer to `the official access token response RFC from the IETF`_.

Basic Configuration
~~~~~~~~~~~~~~~~~~~

Restricting Usage
~~~~~~~~~~~~~~~~~



Limitations
~~~~~~~~~~~

Since no user passwords are handled by the app at all only master key encryption is working (similar to `the Shibboleth app`_).


.. Links

.. _an OAuth2 application: https://marketplace.owncloud.com/apps/oauth2
.. _the Shibboleth app: https://marketplace.owncloud.com/apps/user_shibboleth
.. _the official client registration RFC from the IETF: https://tools.ietf.org/html/rfc6749#section-2
.. _the official authorization request RFC from the IETF: https://tools.ietf.org/html/rfc6749#section-4.1.1
.. _the official authorization response RFC from the IETF: https://tools.ietf.org/html/rfc6749#section-4.1.2
.. _the official access token request RFC from the IETF: https://tools.ietf.org/html/rfc6749#section-4.1.3
.. _the official access token response RFC from the IETF: https://tools.ietf.org/html/rfc6749#section-4.1.4
.. _RFC 6749: https://tools.ietf.org/html/rfc6749#section-4.1.1
.. _Client authentication: https://tools.ietf.org/html/rfc6749#section-2.3
