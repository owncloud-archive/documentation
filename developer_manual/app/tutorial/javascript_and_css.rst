======================
Add JavaScript and CSS
======================

To create a modern web application you need to write :doc:`JavaScript <../fundamentals/js>` and :doc:`CSS <../fundamentals/css>`. 

JavaScript
----------

You can use any JavaScript framework but for this tutorial we want to keep it as simple as possible and therefore only include the templating library `handlebarsjs <http://handlebarsjs.com/>`_. 
`Download the file <http://builds.handlebarsjs.com.s3.amazonaws.com/handlebars-v2.0.0.js>`_ into ``ownnotes/js/handlebars.js`` and include it at the very top of ``ownnotes/templates/main.php`` before the other scripts and styles:

.. code-block:: php

    <?php
    script('ownnotes', 'handlebars');

The ``script`` method’s first parameter specifies the application which the JavaScript should be included for.
This helps increase performance by not including the JavaScript unnecessarily. 
The script’s second parameter is the name of the JavaScript file, located in the application’s ``js`` directory, minus the ``.js`` extension.
In the case above, ``ownnotes/js/handlebars.js`` would be loaded.

.. note:: jQuery is included by default on every page.

CSS
---

To include CSS, use the template’s ``style`` method, as in the example below.
As with ``script``, the first parameter is the application to find the CSS file in and the second parameter is the name of the CSS file, minus the ``.css`` file extension.

.. code-block:: php
   
   style('ownnotes, 'style');  // adds ownnotes/css/style.css
   
Asset Management
----------------

In production environments, whether you're using HTTP/1.1 or HTTP/2, JavaScript and CSS files should be both compressed, and concatenated into as few files as possible.
Here is a list of packages that can you can use to do compress and concatenate your files:

- `JSCompress`_ (The JavaScript Compression Tool)
- `Minify`_ (CSS and JavaScript minifier)
- `minifier`_ (A simple tool for minifying CSS/JS without a big setup.)
- `matthiasmullie/minify`_ (CSS & JavaScript minifier, in PHP)
- `uglify-js`_ (A JavaScript parser, minifier, compressor and beautifier toolkit.)

.. note:: 
   ownCloud doesn't provide automatic JavaScript or CSS minification 

.. Links
   
.. _JSCompress: https://jscompress.com
.. _Minify: https://www.minifier.org
.. _minifier: https://www.npmjs.com/package/minifier
.. _matthiasmullie/minify: https://github.com/matthiasmullie/minify
.. _uglify-js: https://www.npmjs.com/package/uglify-js

