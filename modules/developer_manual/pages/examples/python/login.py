import owncloud

oc = owncloud.Client('https://your.owncloud.install.com/owncloud/')
oc.login('msetter', 'Zaex7Thex2di')

oc.list('/')

oc.logout()
