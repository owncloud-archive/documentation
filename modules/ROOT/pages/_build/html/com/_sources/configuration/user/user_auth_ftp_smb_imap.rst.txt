===========================================
User Authentication with IMAP, SMB, and FTP
===========================================

You may configure additional user backends in ownCloud's configuration file (:file:`config/config.php`) using the following syntax:

.. code-block:: php

  <?php

  "user_backends" => [
      0 => [
          "class"     => ...,
          "arguments" => [
              0 => ...
          ],
      ],
  ],

.. note:: 
   A non-blocking or correctly configured SELinux setup is needed for these backends to work, if SELinux is enabled on your server.. 
   Please refer to :ref:`the SELinux documentation <selinux-config-label>` for further details.

Currently the `External user support app`_ (user_external), *which is not enabled by default*, provides three backends. 
These are:

- `IMAP`_
- `SMB`_
- `FTP`_

See :doc:`../../installation/apps_management_installation` for more information.

IMAP
----

Provides authentication against IMAP servers.

========== ==========================================================================
Option     Value/Description
========== ==========================================================================
Class      ``OC_User_IMAP``.
Arguments  A mailbox string as defined `in the PHP documentation`_.
Dependency `PHP's IMAP extension`_. See :doc:`../../installation/source_installation` 
           for instructions on how to install it.
========== ==========================================================================

Example
~~~~~~~

.. code-block:: php

  <?php

  "user_backends" => [
      0 => [
          "class"     => "OC_User_IMAP",
          "arguments" => [
              // The IMAP server to authenticate against
              '{imap.gmail.com:993/imap/ssl}', 
              // The domain to send email from
              'example.com'
          ],
      ],
  ],
  
.. warning:: 
   The second ``arguments`` parameter ensures that only users from that domain are allowed to login. 
   When set, after a successful login, the domain will be stripped from the email address and the rest used as an ownCloud username. 
   For example, if the email address is ``guest.user@example.com``, then ``guest.user`` will be the username used by ownCloud.

SMB
---

Provides authentication against Samba servers.

========== ==============================================================================================
Option     Value/Description
========== ==============================================================================================
Class      ``OC_User_SMB``.
Arguments  The samba server to authenticate against.
Dependency `PECL's smbclient extension`_ or :doc:`smbclient <../../configuration/files/external_storage/smb>`.
========== ==============================================================================================

Example
~~~~~~~

.. code-block:: php

  <?php

  "user_backends" => [
      0 => [
          "class"     => "OC_User_SMB",
          "arguments" => [
              0 => 'localhost'
          ],
      ],
  ],

FTP
---

Provides authentication against FTP servers.


=============== =========================================================================
Option          Value/Description
=============== =========================================================================
Class           ``OC_User_FTP``.
Arguments       The FTP server to authenticate against.
Dependency      `PHP's FTP extension`_. See :doc:`../../installation/source_installation` 
                for instructions on how to install it.
=============== =========================================================================

Example
~~~~~~~

.. code-block:: php

  <?php

  "user_backends" => [
      0 => [
          "class"     => "OC_User_FTP",
          "arguments" => [
              0 => 'localhost'
          ],
      ],
  ],
  
.. Links
   
.. _PHP's IMAP extension: http://www.php.net/manual/en/book.imap.php
.. _PECL's smbclient extension: https://pecl.php.net/package/smbclient
.. _PHP's FTP extension: http:/www.php.net/manual/en/book.ftp.php
.. _External user support app: https://github.com/owncloud/apps
.. _in the PHP documentation: http://www.php.net/manual/en/function.imap-open.php
