# bi-sec, 2024-01
# be careful if you only have SSH access to the system!
# Tested for debian10 

echo Disable root Login
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config

echo Define port 
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config

echo Enable public-key-Auth
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config

echo Prevent Empty Passwords
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config

echo Disable PW-Auth
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

## Install fail2ban!
# apt-get install fail2ban

# restart ssh service
#/etc/init.d ssh restart
