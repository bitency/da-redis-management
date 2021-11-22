#!/bin/bash


    apt-get -y install sudo
    apt-get -y install redis-server


# Determine PHP version
PHP_VERSION=$(php -i | grep 'PHP Version');

# Remount /tmp with execute permissions (only if /tmp partition exists and is read-only)
REMOUNT_TMP=false
if [ "$(mount | grep /tmp | grep noexec)" ]; then
    mount -o remount,exec /tmp

    REMOUNT_TMP=true
fi

# Install php-redis module (if not installed yet)
if [ ! "$(php -m | grep redis)" ]; then
    if [[ $PHP_VERSION == *"7."* ]]; then
        yes '' | pecl install -f redis
    else
        yes '' | pecl install -f redis-2.2.8
    fi
fi

# Enable redis php extension in custom php.ini (if not enabled yet)
if [ ! "$(cat /usr/local/php74/lib/php.conf.d/45-custom.ini | grep redis.so)" ]; then
    echo -e "\n; Redis\nextension=redis.so" >> /usr/local/php74/lib/php.conf.d/45-custom.ini
fi

# Restart apache
sudo /bin/systemctl restart httpd

# Remount /tmp with noexec permissions (if needed)
if [ "$REMOUNT_TMP" = true ] ; then
    mount -o remount,noexec /tmp
fi

# Create instances folder for redis instances
mkdir -p /etc/redis/instances

# Chown instances folder
chown -R redis.redis /etc/redis/instances

# Remove existing sudo /bin/systemctl script
rm -f /lib/systemd/system/redis*

# Copy new sudo /bin/systemctl scripts
cp -a redis@.service /lib/systemd/system/
cp -a redis.service /lib/systemd/system/

# Reload sudo /bin/systemctl daemons
systemctl daemon-reload
sudo /bin/systemctl daemon-reload

# Enable main service
systemctl enable redis@.service
sudo /bin/systemctl enable redis@.service

# Fix SUDO Debian/Ubuntu
echo "redis ALL=NOPASSWD: /bin/systemctl enable redis@*, /bin/systemctl disable redis@*, /bin/systemctl start redis@*, /bin/systemctl stop redis@*" >> /etc/sudoers
echo "Defaults:redis !requiretty" >> /etc/sudoers

# Copy sudoers file
# cp -a redis.sudoers /etc/redis

# Fix sudoers file permissions
chown root.root /etc/redis
