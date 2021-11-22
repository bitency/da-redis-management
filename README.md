# Change for Debian/Ubuntu

then you should edit sudoers use visudo or vim /etc/sudoers and add this line:


redis ALL=NOPASSWD: /bin/systemctl enable redis@*, /bin/systemctl disable redis@*, /bin/systemctl start redis@*, /bin/systemctl stop redis@*

Defaults:redis !requiretty





# DirectAdmin REDIS Management Plugin
Welcome to this repository of an unofficial DirectAdmin plugin for managing Redis instances. 

With this plugin end-users on an DirectAdmin server can easliy add and remove their redis instances.

I developed and used this plugin for over a year now on our own servers, but I decided to release it to the public! So everyone can use this.


# Installation

```
cd /usr/local/directadmin/plugins
git clone https://github.com/bitency/da-redis-management.git redis_management
sh redis_management/scripts/install.sh
cd /usr/local/directadmin/plugins/redis_management/setup
sh install.sh
```





# Configuration
By default, the plugin is working out-of-the box. But it can be needed to change serveral configuration settings.

The default settings are stored in /usr/local/directadmin/plugins/redis_management/php/Config/main.php.

If you need to change for example the location where the redis data is stored (default in /var/lib/redis), you can do this in "local.php". Please do not change this in the "main.php" config file, because this file can be overwritten when a new version of this plugin is installed.

# Update
```
cd /usr/local/directadmin/plugins/redis_management
git pull
```

# Screenshots
List Redis instances

![List Redis instances](https://raw.githubusercontent.com/bitency/da-redis-management/master/screenshots/list.png)
