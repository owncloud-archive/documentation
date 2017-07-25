=========================
Creating Template Content
=========================

The template file ``ownnotes/templates/part.content.php`` contains the content. 
It will just be a textarea and a button, so replace the content with the following:

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


.. code-block:: js

    (function (OC, window, $, undefined) {
    'use strict';

    $(document).ready(function () {

    var translations = {
        newNote: $('#new-note-string').text()
    };

    // this notes object holds all our notes
    var Notes = function (baseUrl) {
        this._baseUrl = baseUrl;
        this._notes = [];
        this._activeNote = undefined;
    };

    Notes.prototype = {
        load: function (id) {
            var self = this;
            this._notes.forEach(function (note) {
                if (note.id === id) {
                    note.active = true;
                    self._activeNote = note;
                } else {
                    note.active = false;
                }
            });
        },
        getActive: function () {
            return this._activeNote;
        },
        removeActive: function () {
            var index;
            var deferred = $.Deferred();
            var id = this._activeNote.id;
            this._notes.forEach(function (note, counter) {
                if (note.id === id) {
                    index = counter;
                }
            });

            if (index !== undefined) {
                // delete cached active note if necessary
                if (this._activeNote === this._notes[index]) {
                    delete this._activeNote;
                }

                this._notes.splice(index, 1);

                $.ajax({
                    url: this._baseUrl + '/' + id,
                    method: 'DELETE'
                }).done(function () {
                    deferred.resolve();
                }).fail(function () {
                    deferred.reject();
                });
            } else {
                deferred.reject();
            }
            return deferred.promise();
        },
        create: function (note) {
            var deferred = $.Deferred();
            var self = this;
            $.ajax({
                url: this._baseUrl,
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(note)
            }).done(function (note) {
                self._notes.push(note);
                self._activeNote = note;
                self.load(note.id);
                deferred.resolve();
            }).fail(function () {
                deferred.reject();
            });
            return deferred.promise();
        },
        getAll: function () {
            return this._notes;
        },
        loadAll: function () {
            var deferred = $.Deferred();
            var self = this;
            $.get(this._baseUrl).done(function (notes) {
                self._activeNote = undefined;
                self._notes = notes;
                deferred.resolve();
            }).fail(function () {
                deferred.reject();
            });
            return deferred.promise();
        },
        updateActive: function (title, content) {
            var note = this.getActive();
            note.title = title;
            note.content = content;

            return $.ajax({
                url: this._baseUrl + '/' + note.id,
                method: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(note)
            });
        }
    };

    // this will be the view that is used to update the html
    var View = function (notes) {
        this._notes = notes;
    };

    View.prototype = {
        renderContent: function () {
            var source = $('#content-tpl').html();
            var template = Handlebars.compile(source);
            var html = template({note: this._notes.getActive()});

            $('#editor').html(html);

            // handle saves
            var textarea = $('#app-content textarea');
            var self = this;
            $('#app-content button').click(function () {
                var content = textarea.val();
                var title = content.split('\n')[0]; // first line is the title

                self._notes.updateActive(title, content).done(function () {
                    self.render();
                }).fail(function () {
                    alert('Could not update note, not found');
                });
            });
        },
        renderNavigation: function () {
            var source = $('#navigation-tpl').html();
            var template = Handlebars.compile(source);
            var html = template({notes: this._notes.getAll()});

            $('#app-navigation ul').html(html);

            // create a new note
            var self = this;
            $('#new-note').click(function () {
                var note = {
                    title: translations.newNote,
                    content: ''
                };

                self._notes.create(note).done(function() {
                    self.render();
                    $('#editor textarea').focus();
                }).fail(function () {
                    alert('Could not create note');
                });
            });

            // show app menu
            $('#app-navigation .app-navigation-entry-utils-menu-button').click(function () {
                var entry = $(this).closest('.note');
                entry.find('.app-navigation-entry-menu').toggleClass('open');
            });

            // delete a note
            $('#app-navigation .note .delete').click(function () {
                var entry = $(this).closest('.note');
                entry.find('.app-navigation-entry-menu').removeClass('open');

                self._notes.removeActive().done(function () {
                    self.render();
                }).fail(function () {
                    alert('Could not delete note, not found');
                });
            });

            // load a note
            $('#app-navigation .note > a').click(function () {
                var id = parseInt($(this).parent().data('id'), 10);
                self._notes.load(id);
                self.render();
                $('#editor textarea').focus();
            });
        },
        render: function () {
            this.renderNavigation();
            this.renderContent();
        }
    };

    var notes = new Notes(OC.generateUrl('/apps/ownnotes/notes'));
    var view = new View(notes);
    notes.loadAll().done(function () {
        view.render();
    }).fail(function () {
        alert('Could not load notes');
    });


    });

    })(OC, window, jQuery);


