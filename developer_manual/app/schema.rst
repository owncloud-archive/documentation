===================
Database Migrations
===================

.. sectionauthor:: Thomas Müller <thomas.mueller@tmit.eu>

ownCloud uses `Doctrine Migrations`_ to manage any kind of database changes.
Any application that wants to use it has to enable it by adding the ``use-migrations``
element in :file:`appinfo/info.xml` and set it to ``true``, as in the example
below.

.. code-block:: xml

  <use-migrations>true</use-migrations>

After the next upgrade of the application, if database migrations are enabled,
outstanding migrations will be executed and existing
:file:`appinfo/database.xml` files will be ignored.

How to use migrations
=====================

1. Enable migrations by adding the ``xml`` tag to :file:`appinfo/info.xml`

.. code-block:: xml

  <use-migrations>true</use-migrations>

2. Create a migration step

.. code-block:: bash

  ./occ migrations:generate app-name

This will create a migration step skeleton like this:

.. literalinclude:: ../examples/migrations/Version20161130090952.php
   :language: php
   :linenos:

Within the up() method the schema changes are to be added by working on the
`Class Schema`_. Within the down() method the schema changes are to be reverted.
Because ownCloud only allows upgrade it is okay to leave the down() method
empty.

3. Test your migration step by executing

.. code-block:: bash

   ./occ migrations:execute --up dav 20161130090952

In order to revert the migration you can run

.. code-block:: bash

   ./occ migrations:execute --down dav 20161130090952

By executing ``up`` and ``down`` you can explicitly apply the changes and roll them back
- as long as ``down`` is fully implemented. 

.. NOTE:: 
   Because all migration steps will be executed upon installation, there is no
   explicit need for unit tests.

4. Bring the migration live

For the real application upgrade process the application version has to be
increased to trigger the migrations. This will apply all migrations which have
not yet been executed.

How are migrations detected and executed
========================================

For each application there will be a table holding the list of migrations which
have been executed during previous upgrades. This list is compared to all
migration classes in the application's migration folder
:file:`appinfo/migrations`, and the migrations that are not present in the table
will be executed in alphabetical order of the class' name.

===============
Database Schema
===============

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

ownCloud uses a database abstraction layer on top of either `PDO`_, depending on
the availability of PDO on the server. The database schema is inside
:file:`appinfo/database.xml` in MDB2's `XML scheme notation`_ where the
placeholders \*dbprefix* (\*PREFIX* in your SQL) and \*dbname* can be used for
the configured database table prefix and database name.

An example database XML file would look like this:

.. literalinclude:: ../examples/appinfo/database.xml
   :language: xml
   :linenos:

To update the tables used by the application, update database.xml and increase
the application version number in :file:`appinfo/info.xml` to trigger an update.

.. Links
   
.. _Doctrine Migrations: http://www.doctrine-project.org/projects/migrations.html
.. _Class Schema: http://www.doctrine-project.org/api/dbal/2.5/class-Doctrine.DBAL.Schema.Schema.html
.. _XML scheme notation: http://www.wiltonhotel.com/_ext/pear/docs/MDB2/docs/xml_schema_documentation.html
