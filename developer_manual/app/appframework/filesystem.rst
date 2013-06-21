.. include:: ../app/filesystem.rst


File System
-----------

ownCloud's core business is to provide access to your files and to files shared with you by others. In the API for apps in the lib folder are a few classes which can be used to create, delete and modify files which are available for the current user. Below you can find the class diagram containing the most important classes for the file system API.

.. figure:: http://s3.postimg.org/gqk0sv1hv/File_System.jpg
    :width: 500px
    :align: center
    :alt: Class diagram of the file system.
    :figclass: align-center
    
OC Package
~~~~~~~~~~
The three OC_* classes are part of the API for applications. The OC_Files class can be used for retrieved the actual content of a file or directory (by creating a ZIP file for example). The OC_FileSystem class deprecated and simply forward the method calls to OC\Files\FileSystem. Finnaly the OC_FileSystemView class is an extension of the View class and again doesn't add any extra functionality.

Files Package
~~~~~~~~~~~~~
The OC\Files package consist of three important classes, the View, FileSystem and Mapper classes. Below you can find a short description of each of these classes. This complete package is missing a lot of documentation on method level.

FileSystem
^^^^^^^^^^
The FileSystem class is completely static, so only one "instance" exists. The FileSystem consists of several Mounts which can be anywhere in the complete file system. All these mounts together creates a file system for the logged in user. This file system is constructed at the beginning using the local directory of the user and the shared mount points from other user in ownCloud. The file system consists of a mount Manager where one or more mounts are contained in. There is a default view for the file system, which is the view from the root of the file system. Most operations are just passed to this root view.

Via this FileSystem instance you can retrieve different mount points with which you can access the Storage instances and then access the files accordingly.

View
^^^^

Using the view class, ownCloud can create a certain "view" in which you can work with files within this view. The set of directories is restricted by a certain virtual root. This "fake" root is provided when constructing a View. Actual operations on files are passed to a Storage object. Some of the actions possible are getting the path to a certain file, get a mount point of a storage object for a certain path. Action like creating a directory and get information about a directory or file are directed to the Storage object for that file or directory. This is done by getting all Storage object for a given path from the FileSystem class and then execute the operation on each of these Storage instances.

Mapper
^^^^^^
The mapper class can be used to translate relative URL's to absolute URL's.


Mount Package
~~~~~~~~~~~~~
Within the Mount package, only two classes can be found: the Manager and the Mount class. The FileSystem consists of a Manager instance which can be used to retrieve mount points. With this manager you can retrieve Mounts by using a path or by a Storage ID (every Storage in a Mount has it's own ID)

Storage Package
^^^^^^^^^^^^^^^

After retrieving a Mount using the FileSystem and the Manager, you can access, or create a Storage instance within this Mount. Storage is an interface containing the minimum set of operation needed for ownCloud. The implementation Common implementation all these basic operations using the standard PHP functionality. Local, MappedLocal and Temporary are all extension to this common implementation. But as you might notice, here you can add support for different file systems, simply extend the common implementation or implement the Storage interface. 

Cache Package
^^^^^^^^^^^^

In the Storage interface, there are a few method declared for retrieving objects from the Cache package. The Cache class is used for the Metadata cache for the filesystem. The cache needs to be retrieved by using the getFileInfo method from the FileSystem class.

The Watcher can be used to check for any updates on files or directories and changes the cache accordingly. The permission class is used to get and update permissions on files. The scanner is used to scan items which are not yet in the cache and adds them. The Storage class in this package is fairly simply and contains the storage id and numeric id for a given Storage instance.


Workflow
~~~~~~~~

So how does a simple request for Storage object looks like. There are two options; by directly creating a view for a certain fake root or by using the File system. Below you can a sequence diagram of the workflow of initializing the FileSystem and getting the path of the local version of a file. 

.. figure:: http://s3.postimg.org/uy9phie6r/sequence_File_System.jpg
    :width: 500px
    :align: center
    :alt: Sequence diagram of the file system.
    :figclass: align-center

Here you can see how the FileSystem creates an initial view using the root and starts creating mounts and adds these to the Manager. In the second action you can see how the View uses the FileSystem to get the right storage. And after that passing the operation to the correct Storage instance.

