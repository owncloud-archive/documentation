=====================
Database Connectivity
=====================

Database Access
---------------

.. sectionauthor:: Bernhard Posselt <dev@bernhard-posselt.com>

The basic way to run a database query is to use the database connection provided by ``OCP\\IDBConnection``.
Inside your database layer class you can now start running queries like:

.. code-block:: php

    <?php
    // db/authordao.php

    namespace OCA\MyApp\Db;

    use OCP\IDBConnection;

    class AuthorDAO {

        private $db;

        public function __construct(IDBConnection $db) {
            $this->db = $db;
        }

        public function find($id) {
            $sql = 'SELECT * FROM `*PREFIX*myapp_authors` ' .
                'WHERE `id` = ?';
            $stmt = $this->db->prepare($sql);
            $stmt->bindParam(1, $id, \PDO::PARAM_INT);
            $stmt->execute();

            $row = $stmt->fetch();

            $stmt->closeCursor();
            return $row;
        }

    }


Mappers
-------

The aforementioned example is the most basic way to write a simple database query but the more queries amass, the more code has to be written and the harder it will become to maintain it.

To generalize and simplify the problem, split code into resources and create an ``Entity`` and a ``Mapper`` class for it. The mapper class provides a way to run SQL queries and maps the result onto the related entities.

To create a mapper, inherit from the mapper baseclass and call the parent constructor with the following parameters:

* Database connection
* Table name
* **Optional**: Entity class name, defaults to ``\\OCA\\MyApp\\Db\\Author`` in the example below

.. code-block:: php

    <?php
    // db/authormapper.php

    namespace OCA\MyApp\Db;

    use OCP\IDBConnection;
    use OCP\AppFramework\Db\Mapper;

    class AuthorMapper extends Mapper {

        public function __construct(IDBConnection $db) {
            parent::__construct($db, 'myapp_authors');
        }


        /**
         * @throws \OCP\AppFramework\Db\DoesNotExistException if not found
         * @throws \OCP\AppFramework\Db\MultipleObjectsReturnedException if more than one result
         */
        public function find($id) {
            $sql = 'SELECT * FROM `*PREFIX*myapp_authors` ' .
                'WHERE `id` = ?';
            return $this->findEntity($sql, [$id]);
        }


        public function findAll($limit=null, $offset=null) {
            $sql = 'SELECT * FROM `*PREFIX*myapp_authors`';
            return $this->findEntities($sql, $limit, $offset);
        }


        public function authorNameCount($name) {
            $sql = 'SELECT COUNT(*) AS `count` FROM `*PREFIX*myapp_authors` ' .
                'WHERE `name` = ?';
            $stmt = $this->execute($sql, [$name]);

            $row = $stmt->fetch();
            $stmt->closeCursor();
            return $row['count'];
        }

    }

.. note:: The cursor is closed automatically for all **INSERT**, **DELETE**, **UPDATE** queries and when calling the methods **findOneQuery**, **findEntities**, **findEntity**, **delete**, **insert** and **update**. For custom calls using execute you should always close the cursor after you are done with the fetching to prevent database lock problems on SqLite

Every mapper also implements default methods for deleting and updating an entity based on its id::

    $authorMapper->delete($entity);

or::

    $authorMapper->update($entity);



Entities
--------

Entities are data objects that carry all the table's information for one row. 
Every Entity has an ``id`` field by default that is set to the integer type. 
Table rows are mapped from lower case and underscore separated names to pascal case attributes:

* **Table column name**: phone_number
* **Property name**: phoneNumber

.. code-block:: php

    <?php
    // db/author.php
    namespace OCA\MyApp\Db;

    use OCP\AppFramework\Db\Entity;

    class Author extends Entity {

        protected $stars;
        protected $name;
        protected $phoneNumber;

        public function __construct() {
            // add types in constructor
            $this->addType('stars', 'integer');
        }
    }

Types
-----

The following properties should be annotated by types, to not only assure that the types are converted correctly for storing them in the database (e.g., PHP casts false to the empty string which fails on PostgreSQL) but also for casting them when they are retrieved from the database.

The following types can be added for a field:

* integer
* float
* boolean

Accessing attributes
--------------------

Since all attributes should be protected, getters and setters are automatically generated for you:

.. code-block:: php

    <?php
    // db/author.php
    namespace OCA\MyApp\Db;

    use OCP\AppFramework\Db\Entity;

    class Author extends Entity {
        protected $stars;
        protected $name;
        protected $phoneNumber;
    }

    $author = new Author();
    $author->setId(3);
    $author->getPhoneNumber()  // null

Custom Attribute to Database Column Mapping
-------------------------------------------

By default each attribute will be mapped to a database column by a certain convention, e.g. ``phoneNumber`` will be mapped to the column ``phone_number`` and vice versa. 
Sometimes it is needed though to map attributes to different columns because of backwards compatibility.
To define a custom mapping, simply override the ``columnToProperty`` and ``propertyToColumn`` methods of the entity in question:

.. code-block:: php

    <?php
    // db/author.php
    namespace OCA\MyApp\Db;

    use OCP\AppFramework\Db\Entity;

    class Author extends Entity {
        protected $stars;
        protected $name;
        protected $phoneNumber;

        // map attribute phoneNumber to the database column phonenumber
        public function columnToProperty($column) {
            if ($column === 'phonenumber') {
                return 'phoneNumber';
            } else {
                return parent::columnToProperty($column);
            }
        }

        public function propertyToColumn($property) {
            if ($column === 'phoneNumber') {
                return 'phonenumber';
            } else {
                return parent::propertyToColumn($property);
            }
        }

    }

Slugs
-----

Slugs are used to identify resources in the URL by a string rather than integer id. 
Since the URL allows only certain values, the entity ``baseclass`` provides a ``slugify`` method for it:

.. code-block:: php

    <?php
    $author = new Author();
    $author->setName('Some*thing');
    $author->slugify('name');  // Some-thing


Database Migrations
-------------------

.. sectionauthor:: Thomas Müller <thomas.mueller@tmit.eu>

ownCloud uses migration steps to perform database changes between releases. 
In most cases, these changes relate to the core database schema. 
However, other types of changes may be required.
Therefore we support three kinds of migration steps, these are:

- **Simple:** run general migration steps. These are quite similar to the `migration repair steps <https://doc.owncloud.org/api/classes/OCP.Migration.IRepairStep.html>`_.
- **SQL:** create a list of executable SQL commands.
- **Schema:** migration via schema migration operations.

Starting with ownCloud 10, this is the preferred way to perform any kind of migrations and is enabled by default within core.
Any app which wants to use this mechanism has to enable it in :file:`appinfo/info.xml`, by adding the following:

.. code-block:: xml

  <use-migrations>true</use-migrations>


**Please Be Aware:** if migrations are enabled then :file:`appinfo/database.xml` is ignored. 
From this point onwards, when an app is installed or upgraded, all outstanding migrations are executed. Below is a migration code sample for creating an application's core table. 

.. code-block:: php
   
   <?php

   namespace OCA\MyApp\Migrations;

   use OCP\Migration\ISchemaMigration;
   use Doctrine\DBAL\Schema\Schema;

   /*
    - Create initial tables for the app
    */

   class Version20171106150538 implements ISchemaMigration {

       /** @var  string */
       private $prefix;

       /**
        - @param Schema $schema
        - @param [] $options
        */
       public function changeSchema(Schema $schema, array $options) {
           $this->prefix = $options['tablePrefix'];

           if (!$schema->hasTable("{$this->prefix}mytable")) {
               $table = $schema->createTable("{$this->prefix}mytable");
               $table->addColumn('id', 'integer', [
                   'autoincrement' => true,
                   'unsigned' => true,
                   'notnull' => true,
                   'length' => 11,
               ]);
               $table->addColumn('stringfield', 'string', [
                   'length' => 255,
                   'notnull' => false,
               ]);
               $table->addColumn('intfield', 'integer', [
                   'unsigned' => true,
                   'notnull' => true,
                   'default' => 1,
               ]);
               $table->setPrimaryKey(['id']);
               $table->addUniqueIndex(['stringfield'], 'mytable_index');
           }
       }
   }

You can see examples of how to create the three migration types in the next section.

.. note:: 
   It is still necessary to increment the application's version number to trigger the execution of migrations.

How to Create a Migration
~~~~~~~~~~~~~~~~~~~~~~~~~

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
---------------------------------

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
