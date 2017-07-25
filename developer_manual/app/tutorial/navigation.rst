=====================
Creating a Navigation
=====================

The template file ``ownnotes/templates/part.navigation.php`` contains the navigation. 
ownCloud defines many handy :doc:`CSS styles <css>` which we are going to reuse to style the navigation. 
Adjust the file to contain only the following code:

.. note:: 
   ``$l->t()`` is used to make your strings :doc:`translatable <l10n>` and ``p()`` is used :doc:`to print escaped HTML <templates>`

.. code-block:: php

    <!-- translation strings -->
    <div style="display:none" id="new-note-string"><?php p($l->t('New note')); ?></div>

    <script id="navigation-tpl" type="text/x-handlebars-template">
        <li id="new-note"><a href="#"><?php p($l->t('Add note')); ?></a></li>
        {{#each notes}}
            <li class="note with-menu {{#if active}}active{{/if}}"  data-id="{{ id }}">
                <a href="#">{{ title }}</a>
                <div class="app-navigation-entry-utils">
                    <ul>
                        <li class="app-navigation-entry-utils-menu-button svg"><button></button></li>
                    </ul>
                </div>

                <div class="app-navigation-entry-menu">
                    <ul>
                        <li><button class="delete icon-delete svg" title="delete"></button></li>
                    </ul>
                </div>
            </li>
        {{/each}}
    </script>

    <ul></ul>

