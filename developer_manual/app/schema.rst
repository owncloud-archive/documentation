===================
Database Migrations
===================

.. sectionauthor:: Thomas Müller <thomas.mueller@tmit.eu>

ownCloud uses `Doctrine Migrations <http://www.doctrine-project.org/projects/migrations.html>`_ to manage any kind of database changes.

Any app which wants to use this mechanism has to enable it in :file:`appinfo/info.xml` by adding

.. code-block:: xml

  <use-migrations>true</use-migrations>


As soon as migrations are enabled any existing :file:`appinfo/database.xml` will be ignored on upgrade of the app.
Instead, all migration steps which have not yet been executed will be executed.

How to develop a migration
==========================

1. Enable migrations by adding the xml tag to :file:`appinfo/info.xml`

.. code-block:: xml

  <use-migrations>true</use-migrations>

2. Create a migration step

.. code-block:: bash

  ./occ migrations:generate app-name

This will create a migration step skeleton like this:

.. code-block:: php

  <?php

  namespace OCA\MyAppName\Migrations;

  use Doctrine\DBAL\Migrations\AbstractMigration;
  use Doctrine\DBAL\Schema\Schema;

  /**
   * Auto-generated Migration: Please modify to your needs!
   */
  class Version20161130090952 extends AbstractMigration
  {
      /**
       * @param Schema $schema
       */
      public function up(Schema $schema)
      {
          // this up() migration is auto-generated, please modify it to your needs

      }

      /**
       * @param Schema $schema
       */
      public function down(Schema $schema)
      {
          // this down() migration is auto-generated, please modify it to your needs

      }
  }

Within the up() method the schema changes are to be added by working on the `Class Schema <http://www.doctrine-project.org/api/dbal/2.5/class-Doctrine.DBAL.Schema.Schema.html>`_.
Within the down() method the schema changes are to be reverted. Because ownCloud only allows upgrade it is okay to leave the down() method empty.

3. Test your migration step by executing

.. code-block:: bash

   ./occ migrations:execute --up dav 20161130090952

In order to revert the migration you can run

.. code-block:: bash

   ./occ migrations:execute --down dav 20161130090952

By executing up and down you can explicitly apply the changes and roll them back - as long as down() is properly implemented.

Because all migration steps will be executed upon installation there is no explicit need for unit tests.

4. Bring the migration live

For the real app upgrade process the app version has to be increased to trigger the migrations.
This will apply all steps which have not yet been executed.

How are migrations detected and executed
========================================

For each app there will be a table holding the list of migrations which have been executed during past upgrades.
This list is compared to all migration classes in the app's migration folder :file:`appinfo/migrations` and the
migrations that are not present in the table will be executed in the order of the class names alphabetically.

===============
Database Schema
===============

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

ownCloud uses a database abstraction layer on top of either PDO, depending on the availability of PDO on the server.

The database schema is inside :file:`appinfo/database.xml` in MDB2's `XML scheme notation <http://www.wiltonhotel.com/_ext/pear/docs/MDB2/docs/xml_schema_documentation.html>`_ where the placeholders \*dbprefix* (\*PREFIX* in your SQL) and \*dbname* can be used for the configured database table prefix and database name.

An example database XML file would look like this:

.. code-block:: xml

  <?xml version="1.0" encoding="UTF-8" ?>
  <database>
   <name>*dbname*</name>
   <create>true</create>
   <overwrite>false</overwrite>
   <charset>utf8</charset>
   <table>
    <name>*dbprefix*yourapp_items</name>
    <declaration>
      <field>
        <name>id</name>
        <type>integer</type>
        <default>0</default>
        <notnull>true</notnull>
            <autoincrement>1</autoincrement>
        <length>4</length>
      </field>
      <field>
        <name>user</name>
        <type>text</type>
        <notnull>true</notnull>
        <length>64</length>
      </field>
      <field>
        <name>name</name>
        <type>text</type>
        <notnull>true</notnull>
        <length>100</length>
      </field>
      <field>
        <name>path</name>
        <type>clob</type>
        <notnull>true</notnull>
      </field>
    </declaration>
  </table>
  </database>

To update the tables used by the app, simply adjust the database.xml file and increase the app version number in :file:`appinfo/info.xml` to trigger an update.
