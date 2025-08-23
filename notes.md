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

