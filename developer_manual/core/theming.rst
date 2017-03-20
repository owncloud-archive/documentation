Theming ownCloud
================

Themes can be used to customize the look and feel of any aspect of an ownCloud installation.
They can override the default *JavaScript*, *CSS*, *image*, and *template* files, as well as the *user interface translations* with custom versions.
They can also affect both the web front-end and the ownCloud Desktop client. 
However, this documentation only covers customizing the web front-end, *so far*.

.. note::
   Throughout this section of the documentation, for sakes of simplicity, it
   will be assumed that your owncloud installation directory is ``/owncloud``.
   If you’re following this guide to create or customise a theme, please make
   sure you change any references to match the location of your owncloud
   installation.

How to Create a New Theme
-------------------------

At its most basic, to create a theme requires two steps:

1. Copy and extend an existing theme or create one from scratch.
2. Enable the theme in the ownCloud Admin dashboard.

All themes, whether copied or new, must meet two key criteria, these are:

1. They must be located in a directory under the ``apps`` directory of your ownCloud installation.
2. They require a configuration file called ``appinfo/info.xml`` to be present.

appinfo/info.xml
~~~~~~~~~~~~~~~~

Here’s an example of the bare minimum which the file needs to contain: 

::

  <?xml version="1.0"?>
  <info>
      <id>theme-example</id>
      <name>Example Theme</name>
      <types>
          <theme/>
      </types>
      <dependencies>
        <owncloud min-version="10" max-version="10" />
      </dependencies>
  </info>

And here’s a longer, more complete example:

::

  <?xml version="1.0"?>
  <info>
      <id>theme-example</id>
      <name>Example Theme</name>
      <description>This App provides the ownCloud theme.</description>
      <licence>AGPL</licence>
      <author>John Doe</author>
      <version>0.0.1</version>
      <types>
          <theme/>
      </types>
      <dependencies>
          <owncloud min-version="10" max-version="10" />
      </dependencies>
  </info>

The value of the ``id`` element needs to be the name of your theme’s folder. 
We recommend that it always be prefixed with ``theme-``. 
The main reason for doing so, is that it is alphabetically sorted in a terminal when handling app folders. 

The ``type`` element needs to be the same as is listed above, so that ownCloud knows to handle the app as a theme.
The dependencies element needs to be present to set the minimum and maximum versions of ownCloud which are supported. If it’s not present, a warning will be displayed in ownCloud 10 and an error will be thrown in the upcoming ownCloud 11.

While the remaining elements are optional, they help when working with the theme in the ownCloud Admin dashboard. 
Please consider filling out as many as possible, as completely as possible.

How to Override Images
----------------------

Any image, such as the default logo, can be overridden by including one with the same path structure in your theme.
For example, let’s say that you want to replace the logo on the login-page above the credentials-box which, by default has the path: ``owncloud/core/img/logo-icon.svg``.
To override it, assuming that your custom theme was called ``theme-example`` (*which will be assumed for the remainder of the theming documentation*), add a new file with the following path: ``owncloud/apps/theme-example/core/img/logo-icon.svg``.
After the theme is activated, this image will override the default one.

Default Image Paths
~~~~~~~~~~~~~~~~~~~

To make building a new theme that much easier, below is a list of a range of the image paths used in the default theme.

==================================================== =========== ====================================================
Description                                          Section     Location
==================================================== =========== ====================================================
The logo at the login-page above the credentials-box General     ``owncloud/core/img/logo-icon.svg``
The logo in the left upper corner after login                    ``owncloud/core/img/logo-icon.svg``
All files folder image                                           ``owncloud/core/img/folder.svg``
Favorites star image                                             ``owncloud/core/img/star.svg``
Shared with you/others image                                     ``owncloud/core/img/share.svg``
Shared by link image                                             ``owncloud/core/img/public.svg``
Tags image                                                       ``owncloud/core/img/tag.svg``
Deleted files image                                              ``owncloud/core/img/delete.svg``
Settings image                                                   ``owncloud/core/img/actions/settings.svg``
Search image                                                     ``owncloud/core/img/actions/search-white.svg``
Breadcrumbs home image                                           ``owncloud/core/img/places/home.svg``
Breadcrumbs separator                                            ``owncloud/core/img/breadcrumb.svg``
Dropdown arrow                                       Admin Menu  ``owncloud/core/img/actions/caret.svg``
Personal image                                                   ``owncloud/settings/img/personal.svg``
Users image                                                      ``owncloud/settings/img/users.svg``
Help image                                                       ``owncloud/settings/img/help.svg``
Admin image                                                      ``owncloud/settings/img/admin.svg``
Logout image                                                     ``owncloud/core/img/actions/logout.svg``
Apps menu - Files image                                          ``owncloud/apps/files/img/app.svg``
Apps menu - Plus image                                           ``owncloud/settings/img/apps.svg``
The favicon                                                      ``owncloud/apps/theme-example/core/img/favicon.ico``  
Upload image                                         Personal    ``owncloud/core/img/actions/upload.svg``
Folder image                                                     ``owncloud/core/img/filetypes/folder.svg``
Trash can image                                                  ``owncloud/core/img/actions/delete.svg``
==================================================== =========== ====================================================

.. note:: 
   When overriding the favicon, make sure your custom theme includes and override for both ``owncloud/apps/core/img/favicon.svg`` and ``owncloud/apps/core/img/favicon.png``, to cover any future updates to favicon handling.

How to Override the Default Colors
----------------------------------

To override the default style sheet, create a new CSS style sheet in your theme, in the theme’s ``css`` directory, called ``styles.css``.

How to Override Translations
----------------------------

.. versionadded 8.0

You can override the translation of any string in your theme. 
To do so:

1. Create the ``l10n`` folder inside your theme, for the app that you want to override.
2. In the ``l10n`` folder, create the translation file for the language that you want to customize.

For example, if you want to overwrite the German translation of *"Download"* in the files app, you would create the file ``owncloud/apps/theme-example/apps/files/l10n/de_DE.js``. Note that the structure is the same as for images. You just mimic the original file location inside your theme.
You would then put the following code in the file:

.. code-block:: js

  OC.L10N.register(
    "files",
    {
      "Download" : "Herunterladen"
    },
    "nplurals=2; plural=(n != 1);"
  );

You then need to create a second translation file, ``owncloud/apps/theme-example/apps/files/l10n/de_DE.json``, which looks like this:

.. code-block:: json

  {
    "translations": {
      "Download" : "Herunterladen"
    },
    "pluralForm" :"nplurals=2; plural=(n != 1);"
  }

Both files (``.js`` and ``.json``) are needed. 
The first is needed to enable translations in the JavaScript code and the second one is read by the PHP code and provides the data for translated terms.

.. note: 
   Only the changed strings need to be added to that file. 
   For all other terms, the shipped translation will be used.

How to Override Names, Slogans, and URLs
----------------------------------------

In addition to translations, the ownCloud theme allows a lot of the names that are shown on the web interface to be changed. 
This is done in ``defaults.php``, which needs to be located within the theme's root folder. 
You can find a sample version in ``owncloud/app/theme-example/defaults.php``. 
In there, you need to define a class named ``OC_Theme`` and implement the methods that you want to overwrite.

.. code-block:: php

  class OC_Theme {
    public function getAndroidClientUrl() {
      return 'https://play.google.com/store/apps/details?id=com.owncloud.android';
    }

    public function getName() {
      return 'ownCloud';
    }
  }

Each method must return a string. 
The following methods are available:

======================= ===============================================================
Method                  Description
======================= ===============================================================
``getAndroidClientUrl`` Returns the URL to Google Play for the Android Client.
``getBaseUrl``          Returns the base URL.
``getDocBaseUrl``       Returns the documentation URL.
``getEntity``           Returns the entity (e.g., company name) used in footers and 
                        copyright notices.
``getName``             Returns the short name of the software.
``getHTMLName``         Returns the short name of the software containing HTML strings.
``getiOSClientUrl``     Returns the URL to the App Store for the iOS Client.
``getiTunesAppId``      Returns the AppId for the App Store for the iOS Client.
``getLogoClaim``        Returns the logo claim.
``getLongFooter``       Returns the long version of the footer.
``getMailHeaderColor``  Returns the mail header color.
``getSyncClientUrl``    Returns the URL where the sync clients are listed.
``getTitle``            Returns the title.
``getShortFooter``      Returns short version of the footer.
``getSlogan``           Returns the slogan.
======================= ===============================================================

.. note:: 
   Only these methods are available in the templates, because we internally wrap around hardcoded method names.

One exception is the method ``buildDocLinkToKey`` which gets passed in a key as its first parameter. 
For core we do something like this to build the documentation link:

.. code-block:: php

  public function buildDocLinkToKey($key) {
    return $this->getDocBaseUrl() . '/server/9.0/go.php?to=' . $key;
  }


How to Test a Theme
-------------------

There are different options for testing themes:

* If you're using a tool like the Inspector tools inside Mozilla you can test out the CSS-Styles immediately inside the css-attributes, while you’re looking at the page.
* If you have a development server, you can test out the effects in a live environment.

Settings Page Registration
--------------------------

How Can an App Register a Section in the Admin or Personal Section?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As of ownCloud 10.0, apps must register admin and personal section settings in ``info.xml``.
As a result, all calls to ``OC_App::registerPersonal`` and ``OC_App::registerAdmin`` should now be removed. 
The settings panels of any apps that are still using these calls will now be rendered in the "Additional" section of the dashboard .

For each panel an app wishes to register, two things are required: 

1. An update to ``info.xml``
2. A controller class

Updating info.xml
^^^^^^^^^^^^^^^^^

First, an entry must be added into the ``<settings>`` element in ``info.xml``, specifying the class name responsible for rendering the panel. 
These will be loaded automatically when an app is enabled. 
For example, to register an admin and a personal section would require the following configuration..

::

  <settings>
        <personal>OCA\MyApp\PersonalPanel::class</personal>
        <admin>OCA\MyApp\AdminPanel::class</admin>
  </settings>

The Controller Class
^^^^^^^^^^^^^^^^^^^^

Next, a controller class which implements the ``OCP\Settings\ISettings`` interface must be created to represent the panel. 
Doing so enforces that the necessary settings panel information is returned. 
The interface specifies three methods:

 - getSectionID
 - getPanel
 - getPriority

**getSectionID:** This method returns the identifier of the section that this panel should be shown under. 
ownCloud Server comes with a predefined list of sections which group related settings together; the intention of which is to improve the user experience. 
This can be found here in `this example`_: 

**getPanel:** This method returns the ``OCP\Template`` or ``OCP\TemplateReponse`` which is used to render the panel. 
The method may also return ``null`` if the panel should not be shown to the user.

**getPriority:** An integer between 0 and 100 representing the importance of the panel (higher is more important). 
Most apps should return a value:

- between 20 and 50 for general information. 
- greater than 50 for security information and notices. 
- lower than 20 for tips and debug output.

Here’s an example implementation of a controller class for creating a personal panel in the security section.

::

    <?php

    namespace OCA\YourApp

    use OCP\Settings\ISettings;
    use OCP\Template;

    class PersonalPanel extends ISettings {
    
        const PRIORITY = 10;
    
        public function getSectionID() {
            return 'security';
        }

        public function getPriority() {
            return self::PRIORITY;
        }

        public function getPanel() {
            // Set the template and assign a template variable
            return (new Template('app-name', 'template-name'))->assign('var', 'value');
        }
    }

Create Custom Sections
~~~~~~~~~~~~~~~~~~~~~~

At the moment, there is no provision for apps creating their own settings sections. 
This is to encourage sensible and intelligent grouping of the settings panels which in turn should improve the overall user experience. 
If you think a new section should be added to core however, please create a PR with the appropriate changes to ``OC\Settings\SettingsManager``.

.. Links
   
.. _.ico format: https://en.wikipedia.org/wiki/ICO_(file_format)
.. _CSS gradient: https://css-tricks.com/css3-gradients/
.. _Google Chrome: https://developer.chrome.com/devtools
.. _Mozilla Firefox: https://developer.mozilla.org/son/docs/Tools
.. _Safari: https://developer.apple.com/safari/tools/
.. _the guide on Can I Use: http://caniuse.com/#feat=css-gradients
.. _this example: https://github.com/owncloud/core/blob/master/lib/private/Settings/SettingsManager.php#L195   

