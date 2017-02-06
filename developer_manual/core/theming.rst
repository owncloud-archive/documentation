Theming ownCloud
================

Themes can be used to customize the look and feel of ownCloud.
Themes can relate to the following topics of ownCloud:

* The web front-end
* The ownCloud Desktop client

This documentation contains only the web front-end adaptations so far.

Getting Started
===============

A good idea, when getting started with a dynamically created website, is to inspect it with the web developer tools available in the major web browsers, which include: `Google Chrome`_, `Mozilla Firefox`_, and `Safari`_. 
Among a host of other information, the developer tools show the generated HTML and the CSS code that the client (browser) is receiving.
With this information you can easily determine all you need to know about the following theme details:

* Place
* Color
* Links
* Graphics

The next thing you should do, before starting any changes, is to make a backup of your current theme(s). 
Here's an example of how to do so::

  cd path/to/your/owncloud/themes
  cp -r example mytheme

Creating and Activating a New Theme
===================================

There are two basic ways of creating new themes:

1. Create a new one from scratch.
2. Start from an existing theme and do everything step-by-step.

Perhaps the simplest way is to start with the sample theme. 
This is located in the ``themes`` folder of your ownCloud install, inside the folder called ``example``. 

Depending on how you created your new theme, it will be necessary to

* Put a new theme folder inside the ``/themes`` folder.
* Make changes to your theme.
* Activate the theme by adding the ``'theme'`` key into the ``$CONFIG`` array, in ``/config/config.php``.

Assuming that your new theme’s folder was called ``mytheme``, then you would add
``'theme' => 'mytheme'`` to ``/config/config.php``.

Structure
=========

The folder structure of a custom theme is exactly the same as the main ownCloud structure.
With it, you can override JavaScript files, images, user interface translations, and templates with your own custom versions.

We recommend the following folder naming convention:

============= ===========================
Name          Purpose
============= ===========================
``css``       Style sheets
``js``        JavaScripts
``img``       Images
``l10n``      Translation files
``templates`` PHP and HTML template files
============= ===========================

.. note: 
   Theme CSS files are always loaded *after* the default CSS files. So, your
   theme will always override any default CSS properties. 

.. _notes-for-updates:

Notes for Updates
=================

It is **not** recommended to perform changes inside the folder ``/themes/example``. 
Files inside this folder might get replaced during the next ownCloud update process.
During an update, files might get changed within the core and settings folders. 
This could result in problems, as your template files will not 'know' about these changes.

As a result, they will need to be manually merged with the updated core file, or simply be deleted (or renamed in the case of tests).
For example if ``/settings/templates/apps.php`` gets updated by a new
ownCloud version, and you have a ``/themes/MyTheme/settings/templates/apps.php``
in your template, you must merge the changes that where made within the update
with the ones you did in your template.

.. note: 
   This is unlikely and will be mentioned in the ownCloud release notes if it
   occurs.

How to Change Images and the Default Logo
=========================================

The default logo can be replaced with a new one as follows:

1. Find the path to the existing logo
2. Create a new logo
3. Replace the existing logo
4. Change the favicon

1. Find the Path to the Existing Logo
-------------------------------------

Find the location of the image or logo file that you want to replace and add an extension in case you want to re-use it later.

The images and logos available in the ownCloud default theme are:

==================================================== ==================================================
Description                                          Location
==================================================== ==================================================
The logo at the login-page above the credentials-box ``owncloud/themes/default/core/img/logo.svg``
The logo in the left upper corner after login        ``owncloud/themes/default/core/img/logo-wide.svg``
==================================================== ==================================================

2. Create a New Logo
--------------------

If you want to do a quick exchange like (1) it's important to know the size of the picture before you start creating your own logo.
To find this

1. Go to the place in the filesystem that has been shown by the web developer tool/s.
2. You can look up sizing in most cases via the file properties inside your file-manager.
3. Create a replacement logo with the same dimensions.

3. Replace the Existing Logo
----------------------------

To replace the existing logo, replace the original logo file with the newly created one.
The following image file formats are supported:

- Scalable Vector Graphics
- Portable Network Graphics
- JPEG

.. note: 
   The app icons can also be overwritten in a theme.

4. Change the Favicon
---------------------

For compatibility with older browsers, the favicon (the image that appears in your browser's tab) uses ``.../owncloud/core/img/favicon.ico``.

To customize the favicon for your custom theme

1. Create a version of your logo in `.ico format`_
2. Store your custom favicon as ``.../owncloud/themes/MyTheme/core/img/favicon.ico``
3. Include ``.../owncloud/themes/your-theme-name/core/img/favicon.svg`` and ``favicon.png`` to cover any future updates to favicon handling.

How to Change the Default Colors
=================================

ownCloud provides the ability to change the background in the login page and the blue header bar on the main navigation page, visible once you log in to ownCloud. 
The definition for both is defined in the CSS element ``body-login``, which you can see the default definition for below. 
It implements a `CSS gradient`_ with support for a range of browsers, both old and new. 

.. note: 
   Not all browsers support CSS gradients.
   To find out which do, and which don’t, check `the guide on Can I Use`_.

.. code-block:: css

  /* HEADERS */
  ...
  body-login {
   /* Old browsers */
   background: #745bca;
   /* FF3.6+ */
   background: -moz-linear-gradient(top, #947bea 0%, #745bca 100%);
   /* Chrome,Safari4+ */
   background: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #947bea), color-stop(100%, #745bca));
   /* Chrome10+,Safari5.1+ */
   background: -webkit-linear-gradient(top, #947bea 0%, #745bca 100%);
   /* Opera11.10+ */
   background: -o-linear-gradient(top, #947bea 0%, #745bca 100%);
   /* IE10+ */
   background: -ms-linear-gradient(top, #947bea 0%, #745bca 100%);
   /* W3C */
   background: linear-gradient(top, #947bea 0%, #745bca 100%);
   /* IE6-9 */
   filter: progid: DXImageTransform.Microsoft.gradient( startColorstr='#947bea', endColorstr='#745bca', GradientType=0 );
  }

When changing the gradient what you most likely want to do is change ``#35537a`` and ``#ld2d42`` to the colors of your choice. 
``#35537a``, is the top color of the gradient at the login screen. 
``#ld2d42``, is the bottom color of the gradient at the login screen.

Assuming your theme is called ``MyTheme`` 

1. Update the definition of ``body-login`` in ``./YOUR_OWNCLOUD_DIRECTORY/themes/MyTheme/core/css/styles.css``.
2. Save your CSS file. 
3. Refresh the browser for the changes to take effect.

How to Change Translations
==========================

.. versionadded 8.0

You can override the translation of any strings in your theme. 
To do so, you need to do two things:

1. Create the ``l10n`` folder inside your theme, for the app that you want to override.
2. In the ``l10n`` folder, create the translation file for the language that you want to customize.

For example, if you want to override the German translation of "Download" in the ``files`` app, then you need to create the file ``themes/YOUR_THEME_NAME/apps/files/l10n/de.js``.

You then need to put the following code in the file:

.. code-block:: js

  OC.L10N.register(
    "files",
    {
      "Download" : "Herunterladen"
    },
    "nplurals=2; plural=(n != 1);"
  );

Finally, you need to create another file ``themes/THEME_NAME/apps/files/l10n/de.json`` with the same translations that look like this:

.. code-block:: json

  {
    "translations": {
      "Download" : "Herunterladen"
    },
    "pluralForm" :"nplurals=2; plural=(n != 1);"
  }

Both files (``.js`` and ``.json``) are needed with the same translations, because the first is needed to enable translations in the JavaScript code and the second one is read by the PHP code and provides the data for translated terms.

.. note: 
   Only the changed strings need to be added to that file. 
   For all other terms, the shipped translation will be used.

How to Change Names, Slogans, and URLs
======================================

In addition to translations, the ownCloud theme allows a lot of the names that are shown on the web interface to be changed. 
This is done in ``defaults.php``, which needs to be located within the theme's root folder. 
You can find a sample version in ``/themes/example/defaults.php``. 
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

.. note:: Only these methods are available in the templates, because we internally wrap around hardcoded method names.

One exception is the method ``buildDocLinkToKey`` which gets passed in a key as its first parameter. 
For core we do something like this to build the documentation link:

.. code-block:: php

  public function buildDocLinkToKey($key) {
    return $this->getDocBaseUrl() . '/server/9.0/go.php?to=' . $key;
  }

How to Test New Themes
======================

There are different options for testing themes:

* If you're using a tool like the Inspector tools inside Mozilla you can test out the CSS-Styles immediately inside the css-attributes, while you’re looking at the page.
* If you have a development server, you can test out the effects in a live environment.

.. Links
   
.. _.ico format: https://en.wikipedia.org/wiki/ICO_(file_format)
.. _CSS gradient: https://css-tricks.com/css3-gradients/
.. _Google Chrome: https://developer.chrome.com/devtools
.. _Mozilla Firefox: https://developer.mozilla.org/son/docs/Tools
.. _Safari: https://developer.apple.com/safari/tools/
.. _the guide on Can I Use: http://caniuse.com/#feat=css-gradients
