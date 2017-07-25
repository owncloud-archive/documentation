======================
Add JavaScript and CSS
======================

To create a modern webapp you need to write :doc:`JavaScript<js>`. 
You can use any JavaScript framework but for this tutorial we want to keep it as simple as possible and therefore only include the templating library `handlebarsjs <http://handlebarsjs.com/>`_. 
`Download the file <http://builds.handlebarsjs.com.s3.amazonaws.com/handlebars-v2.0.0.js>`_ into **ownnotes/js/handlebars.js** and include it at the very top of **ownnotes/templates/main.php** before the other scripts and styles:

.. code-block:: php

    <?php
    script('ownnotes', 'handlebars');

.. note:: jQuery is included by default on every page.

