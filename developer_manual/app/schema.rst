===================
Database Migrations
===================

.. sectionauthor:: Thomas Müller <thomas.mueller@tmit.eu>

ownCloud uses migration steps to perform any changes between versions. 
In most cases, these changes are changes to the database schema, but it is not only limited to them.
Therefore we support three kinds of migration steps: simple, SQL and schema.

There are currently three supported migration types:

- **Simple.** This allows general migration steps to be executed. These are quite similar to the `migration repair steps <https://doc.owncloud.org/api/classes/OCP.Migration.IRepairStep.html>`_.
- **SQL.** This allows you to create a list of executable SQL commands.
- **Schema.** This allows migration via schema migration operations.

Starting with ownCloud 10, this is the preferred way to perform any kind of migrations and is enabled by default within core.
Any app which wants to use this mechanism has to enable it in :file:`appinfo/info.xml`, by adding the following:

.. code-block:: xml

  <use-migrations>true</use-migrations>

As soon as migrations are enabled, any existing :file:`appinfo/database.xml` will be ignored, when the app is upgraded and all outstanding migrations will be executed.

.. note:: 
   It is still necessary to increment the application's version number to trigger the execution of migrations.

How to Create a Migration
=========================

1. Enable migrations by adding the XML tag to :file:`appinfo/info.xml`

.. code-block:: xml

  <use-migrations>true</use-migrations>

2. Create a migration step

.. code-block:: bash

  ./occ migrations:generate app-name {simple, SQL, schema}

A Simple Migration Step
~~~~~~~~~~~~~~~~~~~~~~~

The simple migration step skeleton looks like this:

.. code-block:: php

    <?php
    namespace OCA\testing\Migrations;

    use OCP\Migration\ISimpleMigration;
    use OCP\Migration\IOutput;

    /**
     * Auto-generated migration step: Please modify to your needs!
     */
    class Version20170213125339 implements ISimpleMigration {
        /**
         * @param IOutput $out
         */
        public function run(IOutput $out) {
            // auto-generated - please modify it to your needs
        }
    }

A SQL Migration Step
~~~~~~~~~~~~~~~~~~~~

A SQL migration step skeleton looks like this:

.. code-block:: php

    <?php
    namespace OCA\testing\Migrations;

    use OCP\IDBConnection;
    use OCP\Migration\ISqlMigration;

    /**
     * Auto-generated migration step: Please modify to your needs!
     */
    class Version20170213125430 implements ISqlMigration {

        /**
         * @param IDBConnection $connection
         * @return array of sql statements
         */
        public function sql(IDBConnection $connection) {
            // auto-generated - please modify it to your needs
        }
    }

Within the ``sql()`` method you can generate any number of SQL commands. 
The generated commands will be returned as an array, and the statements will be executed afterward. 

.. note:: 
   Please do not execute any generated SQL statements directly on the database.

The parameter ``$connection`` can be used to retrieve a database platform object or to test if tables exist.
In order to create cross-compatible SQL code, please use the platform object or generate SQL commands for each supported database system.

A Schema Migration Step
~~~~~~~~~~~~~~~~~~~~~~~

A schema migration step skeleton looks like this:

.. code-block:: php

    <?php
    namespace OCA\testing\Migrations;

    use Doctrine\DBAL\Schema\Schema;
    use OCP\Migration\ISchemaMigration;

    /**
     * Auto-generated migration step: Please modify to your needs!
     */
    class Version20170213125427 implements ISchemaMigration {
        public function changeSchema(Schema $schema, array $options) {
            // auto-generated - please modify it to your needs
        }
    }

Within the ``changeSchema()`` method, you can use the `Class Schema <http://www.doctrine-project.org/api/dbal/2.5/class-Doctrine.DBAL.Schema.Schema.html>`_ to manipulate the existing database schema. 
This is the preferred way to manipulate the schema.

3. Test your migration step

.. code-block:: bash

   ./occ migrations:execute dav 20161130090952

Because all migration steps will be executed upon installation, there is no explicit need for unit tests.

4. Deploy the migration(s)

To trigger the migrations, the app version has to be increased.
Doing so applies all steps which have not yet been executed.

How to Update the Database Schema
=================================

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

ownCloud uses a database abstraction layer on top of `PDO`_, depending on its availability on the server.
The database schema is contained in :file:`appinfo/database.xml`, and uses MDB2's `XML scheme notation <http://www.wiltonhotel.com/_ext/pear/docs/MDB2/docs/xml_schema_documentation.html>`_.
The placeholders \*dbprefix* (\*PREFIX* in your SQL) and \*dbname* can be used for the configured database table prefix and database name.

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

To update the tables used by the app: adjust the ``database.xml`` file to reflect the changes which you want to make. 
Then, increment the app version number in :file:`appinfo/info.xml` to trigger an update.

.. links
   
.. _PDO: https://secure.php.net/manual/en/book.pdo.php
