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
# after the pushing the changes we need to upgrade the changes
terraform init -upgrade
# we will get the vpc id from vpc floder but there is no connection b/w sg floder and vpc flodder for that we use SSM Parameter store to take the vpc id from vpc ouput and give that to sg floders

SSM parameter creation
-----------------------
aws system manager -----> parameter store ---> create parameter ----> /roboshop/dev/vpc ----> string -----> create 

# now after cr4eating parameter.tf file we will get the vpc id now we need to take that id for sg
we will read from data.tf files 

# now we have sg gruops id now we can crete ec2 instances


---------------------
ROBOSHOP-Project
======================
- both backend and database tier are in priavte subnets so they don't have public IP's
- How we can check if any problem in those 2 subnets
we have multiple solutions:
---------------------------
VPN
Bastion host /jump host: 
=======================
It is a normal instances. It enables ingress traffic . we can install required softwares.

Laptop ---> aws acoount ----> vpc ---> public subnet (bastion host) ----> ec2 ---> private subnet

there are 2 types of modules
--------------------------
1. developed our own modules
2. open source modules

custom module:
===================
pros:
-----
1. evarything is in our control
cons:
-----
we need to write lot of code
we need to maintain everyhing

Open source module:
==================
pros:
----
no need to develop everything and maintain, directly use

cons:
----
not in our control
need to depend on comminity

bastion creation:
=========================
we need sg for this also
we need allow port number 22

vpc_ids = [
  "subnet-03b4aa2e7908fbd6f",
  "subnet-028e880f61f9b0baa",
]

subnet-03b4aa2e7908fbd6f,028e880f61f9b0baa ====> for terraform it is string  but aws terraform it is string list
\so get the subnets for id's 1 (region1)
we need to convert into list and take the 1st one 

