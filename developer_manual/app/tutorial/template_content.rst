=========================
Creating Template Content
=========================

As noted in :ref:`the controllers section of the tutorial <routes_and_controllers_controllers_label>`, templates are, effectively, not much more than the original PHP files, which were a combination of PHP and HTML.
However, they can also contain conditional logic, as you can see in the example
below.

This template, in ``ownnotes/templates/part.content.php``,contains the core form elements for creating notes.

.. note:: 
   ``$l->t()`` is used to make your strings :doc:`translatable <../advanced/l10n>` and ``p()`` is used :doc:`to print escaped HTML <../fundamentals/templates>`

.. code-block:: php

    <script id="content-tpl" type="text/x-handlebars-template">
        {{#if note}}
            <div class="input"><textarea>{{ note.content }}</textarea></div>
            <div class="save"><button><?php p($l->t('Save')); ?></button></div>
        {{else}}
            <div class="input"><textarea disabled></textarea></div>
            <div class="save"><button disabled><?php p($l->t('Save')); ?></button></div>
        {{/if}}
    </script>
    <div id="editor"></div>

