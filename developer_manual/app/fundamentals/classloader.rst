===============
The Classloader
===============

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

The classloader is provided by ownCloud and loads all your classes automatically. The only thing left to include by yourself are 3rd party libraries. Those should be loaded in :file:`lib/AppInfo/Application.php`.

PSR-4 Autoloading
-----------------

Since ownCloud 9.1 there is a PSR-4 autoloader in place. 
The namespace ``\\OCA\\MyApp`` is mapped to :file:`/apps/myapp/lib/`. 
Afterward, normal PSR-4 rules apply, so a folder is a namespace section in the same casing and the class name matches the file name.

If your ``appid`` can not be turned into the namespace by upper-casing the first character, you can specify it in your ``appinfo/info.xml`` by providing a field called ``namespace``. 
The required namespace is the one which comes after the top level namespace ``OCA\\``, e.g.: for ``OCA\\MyBeautifulApp\\Some\\OtherClass`` the needed namespace would be ``MyBeautifulApp`` and would be added to the ``info.xml`` in the following way:

  .. code-block:: xml

    <?xml version="1.0"?>
    <info>
       <namespace>MyBeautifulApp</namespace>
       <!-- other options here ... -->
    </info>

A second PSR-4 root is available when running tests. 
``\\OCA\\MyApp\\Tests`` is thereby mapped to :file:`/apps/myapp/tests/`.

Legacy Autoloading
------------------

The legacy classloader, deprecated since 9.1, is still in place and works like this:

* Take the full qualifier of a class

.. code-block:: php

    \OCA\MyApp\Controller\PageController

* If it starts with ``\\OCA``, then include the file from the apps directory
* Cut off ``\\OCA``

.. code-block:: php

    \MyApp\Controller\PageController

* Convert all characters to lowercase

.. code-block:: php

    \myapp\controller\pagecontroller

* Replace \\ with /

.. code-block:: php

    /myapp/controller/pagecontroller

* Append .php

.. code-block:: php

    /myapp/controller/pagecontroller.php

* Prepend /apps because of the ``OCA`` namespace and include the file

.. code-block:: php

    require_once '/apps/myapp/controller/pagecontroller.php';

**In other words**: In order for the ``PageController`` class to be autoloaded, the class ``\\OCA\\MyApp\\Controller\\PageController`` needs to be stored in the :file:`/apps/myapp/controller/pagecontroller.php` 

