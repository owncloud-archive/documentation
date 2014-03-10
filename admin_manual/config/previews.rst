Previews
========

ownCloud allows for thumbnail previews of files.
This section contains the different configuration parameters available for that functionality.

+----------------------------+-------------------------------------------------------+-----------------------------------------------------------------------+
| **Parameter**              | **Format**                                            | **Description**                                                       |
|                            |                                                       |                                                                       |
+----------------------------+-------------------------------------------------------+-----------------------------------------------------------------------+
| **Enable Previews**        | 'enable_previews' => true,                            | When enabled, default, the user will have file thumbnails visible.    |
|                            |                                                       | Disable to remove thumbnails.                                         |
|                            |                                                       |                                                                       |
+----------------------------+-------------------------------------------------------+-----------------------------------------------------------------------+
| **Preview Width**          | 'preview_max_x' => null,                              | Maximum width of the thumbnail.                                       |
|                            |                                                       | Default is null meaning no limit.                                     |
|                            |                                                       |                                                                       |
+----------------------------+-------------------------------------------------------+-----------------------------------------------------------------------+
| **Preview Height**         | 'preview_max_y' => null,                              | The maximum height of the thumbnail.                                  |
|                            |                                                       | Default is set to null meaning no limit.                              |
|                            |                                                       |                                                                       |
+----------------------------+-------------------------------------------------------+-----------------------------------------------------------------------+
| **Scale Factor**           | 'preview_max_scale_factor' => 10,                     | Scale the thumbnail by this factor.                                   |
|                            |                                                       | Default is 10.                                                        |
|                            |                                                       |                                                                       |
+----------------------------+-------------------------------------------------------+-----------------------------------------------------------------------+
| **Libreoffice Path**       | 'preview_libreoffice_path' => '/usr/bin/libreoffice', | ownCloud uses Libre Office for previews.                              |
|                            |                                                       | This parameter indicates the location of the Libre Office executable. |
|                            |                                                       |                                                                       |
+----------------------------+-------------------------------------------------------+-----------------------------------------------------------------------+
| **Libreoffice Parameters** | 'preview_office_cl_parameters' => '',                 | Use this if Libre Office requires additional arguments                |
|                            |                                                       |                                                                       |
+----------------------------+-------------------------------------------------------+-----------------------------------------------------------------------+


