<?php

############## Add new references here  ##################
############## Adjust when editing docs ##################

$mapping = array(
    'admin-background-jobs'   => '/admin_manual/configuration/server/background_jobs_configuration.html',
    'admin-dir_permissions'   => '/admin_manual/installation/installation_wizard.html#post-installation-steps-label',
    'admin-encryption'        => '/admin_manual/configuration/files/encryption_configuration.html',
    'admin-external-storage'  => '/admin_manual/configuration/files/external_storage_configuration_gui.html',
    'admin-install'           => '/admin_manual/installation/index.html',
    'admin-ldap'              => '/admin_manual/configuration/user/user_auth_ldap.html',
    'admin-provisioning-api'  => '/admin_manual/configuration/user/user_provisioning_api.html',
    'admin-sharing'           => '/admin_manual/configuration/files/file_sharing_configuration.html',
    'admin-sharing-federated' => '/admin_manual/configuration/files/federated_cloud_sharing_configuration.html',
    'admin-source_install'    => '/admin_manual/installation/source_installation.html',
    'admin-backup'            => '/admin_manual/maintenance/backup.html',
    'admin-cli-upgrade'       => '/admin_manual/configuration/server/occ_command.html#command-line-upgrade',
    'admin-performance'       => '/admin_manual/configuration/server/oc_server_tuning.html',
    'admin-config'            => '/admin_manual/configuration/server/config_sample_php_parameters.html',
    'admin-db-conversion'     => '/admin_manual/configuration/database/db_conversion.html',
    'admin-security'          => '/admin_manual/configuration/server/harden_server.html',
    'admin-email'             => '/admin_manual/configuration/server/email_configuration.html',
    'admin-reverse-proxy'     => '/admin_manual/configuration/server/reverse_proxy_configuration.html',
    'admin-php-fpm'           => '/admin_manual/installation/configuration_notes_and_tips.html#php-fpm-tips-label',
    'admin-transactional-locking' => '/admin_manual/configuration/files/files_locking_transactional.html',
    'admin-code-integrity' => '/admin_manual/issues/code_signing.html',
    'admin-setup-well-known-URL' => '/admin_manual/issues/general_troubleshooting.html#service-discovery',
    'admin-marketplace-apps' => '/admin_manual/upgrading/marketplace_apps.html',
    'admin-logfiles' => '/admin_manual/issues/general_troubleshooting.html#logfiles',

    'admin-enterprise-license' => '/admin_manual/enterprise_installation/license_keys_installation.html',

    'developer-theming'       => '/developer_manual/core/theming.html',
    'developer-code-integrity'=> '/developer_manual/app/code_signing.html',

    'user-encryption'         => '/user_manual/files/encrypting_files.html',
    'user-files'              => '/user_manual/files/index.html',
    'user-manual'             => '/user_manual',
    'user-sharing-federated'  => '/user_manual/files/federated_cloud_sharing.html',
    'user-sync-calendars'     => '/user_manual/pim/calendar.html#synchronizing-calendars-using-caldav',
    'user-sync-contacts'      => '/user_manual/pim/contacts.html#synchronizing-address-books',
    'user-trashbin'           => '/user_manual/files/deleted_file_management.html',
    'user-versions'           => '/user_manual/files/version_control.html',
    'user-webdav'             => '/user_manual/files/access_webdav.html',
);

############# Do not edit below this line #################

$from = isset($_GET['to']) ? $_GET['to'] : '';
$proto = isset($_SERVER['HTTPS']) ? 'https' : 'http';
$name = $_SERVER['HTTP_HOST'];
$path = dirname($_SERVER['REQUEST_URI']);
$location = "$proto://$name$path";

header('HTTP/1.1 302 Moved Temporarily');
if (array_key_exists($from, $mapping)) {
    header('Location: ' . $location . $mapping[$from]);
} else {
    if (strpos($from, 'admin-') === 0) {
        header('Location: ' . $location . '/admin_manual');
    } else if (strpos($from, 'developer-') === 0) {
        header('Location: ' . $location . '/developer_manual');
    } else {
        header('Location: ' . $location . '/user_manual');
    }
}
