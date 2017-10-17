===================
ownCloud User Types
===================

ownCloud supports six user types.
These are:

- `Anonymous`_
- `Guest`_
- `Standard User`_
- `Federated User`_
- `ownCloud Group Administrator`_
- `ownCloud Administrator`_

The following information is not an in-depth guide, but more of a high-level overview of each type.

Anonymous
---------

- Is not a regular user.
- Has access to specific content made available via public links.
- Can be password-protected (optional, enforced, policy-enforced).
- Can have an expiration date (optional, enforced, enforced dependent on password).
- Has no personal space
- Has no file ownership (ownership of uploaded/created files is directed to sharer).
- Has no use of clients.
- Quota is that of the sharer.
- Permissions are those granted by the sharer for specific content, e.g., *view-only*, *edit*, and *no file listing*.
- Can only use apps such file and viewer apps, such as PDF, and Collabora view/edit.

Guest
-----

- Is a regular user with restricted permissions (identified via e-mail address).
- Has no personal space 
- Has no file ownership (ownership of uploaded/created files is directed to sharer).
- Has access to shared space. The permissions are granted by the sharer.
- Is not bound to the 'inviting user'.
- Can log in as long as shares are available.
- Becomes deactivated when no shares are left ('Shared with guests' filter).
- Reactivated when a share is received.
- Administrators will be able to automate user cleanup ("disabled for x days").
- Can use all clients.
- Fully auditable in the enterprise edition.
- Can be promoted to group administrator or administrator, but will still have no personal space.
- Apps are specified by the admin (whitelist).

Standard User
-------------

- Is a regular user (from LDAP, ownCloud user backend, or another backend).
- Has personal space. Permissions are granted by the administrator.
- Shared space: Permissions as granted by sharer.
- Apps: All enabled, might be restricted by group membership.

Federated User
--------------

- Is not an internal user.
- Federated system can be trusted.
- Has access to shared space through users on the considered ownCloud system.
- Can share data with the considered system (accept-/rejectable).

ownCloud Group Administrator
----------------------------

- Is a regular user (from LDAP, ownCloud user backend, or another backend).
- Can manage users in their groups, such as add/remove, change quota of users in the group.
- Can add new users to their groups and can manage guests.
- Can enable and disable users.
- Can impersonate users in their groups.
- Custom group creation may be restricted to group admins.

ownCloud Administrator
----------------------

- Is a regular user (from LDAP, ownCloud user backend, or another backend).
- Can configure ownCloud features via the UI (e.g., sharing settings, app-specific configurations, external storages for users).
- Can manage users (add/remove, enable/disable, quota, group management).
- Can restrict app usage to groups (where applicable).
- Configurable access to log files.
- Mounting of external shares and local shares is disabled by default.
