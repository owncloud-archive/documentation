JavaScript and CSS Asset Management
===================================

In production environments, whether you're using HTTP/1.1 or HTTP/2, JavaScript and CSS files should be both compressed, and concatenated into as few files as possible.
Given that, here is a list of packages that can you can use to do compress and concatenate your files:

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
