Roboshop-vpc:
=================

After creating vpc we have opened all ports to everyone so we need to make secure

frontend:
---------
80 ---> http --> public
22 ----> shh ----> admins logins
443 ----> https ----> public secure

# before creating instances we need security gruops
# we will create sg module
