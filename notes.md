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

Load Blancer:(client-strcure.io)
-----------------------------
Delivery manager ---> responsible for project changes delivery 

if UI work ----> UI work
if Backend work ----> Backend team
if DB work ----> forward to db team

listeners ---> means port numbers
here frontend is exposed to public so we can use 443(https)
in backedn we will not exposed to public so (80) is enough

manual creation for load blancer:
-------------------------------------
lanch ec2(2) ---> install and start nginx

load blancing ---> target group ---> nginx(name) ---> healths checks (2) --tinout 15 sec =--> unheclath 3 checks ---> create ---> pending gruop --> create (This is for frontend)

Now we need to send the request to target gruop:
-----------------------------------------
who will send request(load blancers)

load blancer ----> create load blancer ----> application load blancer ----> craete ---(alteset 2avaiablity zones) ------> listerns and routing (here if any tarffic is coming we are assignng to ningix) ---> create load blancer ---> now load blancer is creayted

If we recive response means it is healthy

Health check:
=============
http://IP:80 ---> if i receive respose ---> 2XX healthy(200 status code)
load blancer checks instances heath periodically
every 10 sec it will check all instances in the arget gruop

consecutive 3 health checks fails ----> If health check fails  ---> unhealthy
consecutive 3 health checks sucess ----> it is sucess

within how much time we need to receive response:
timeout ---> 5 sec -=-> max


-------------------------------------------------------------------
$ for i in 00-vpc/ 10-sg/ 20-bastion/ ; do cd $i; terraform apply -auto-approve ; cd ../; done

for backend we need load blancer
we have 2 types of infra
1. project infra ----> 1 time creation -----> (vpc,subnets...)
2. application infra ----> frequently changes ----> (instances,r53,ami .....)

load blancers,target groups,listenrs ----> project infra

diagram(robosho-infra-dev):
===============================
for load blancers do we need to create SG ---> yes --->(frontend ---> load blancer ----> backend)

so this is private vload blancer so we can't give aces to public but for testing purpose ----> for private servers acess we have created bastion host ---->  for bastions also we need to create sg ----> 
what is the inbound rule for load blancer ----> 80
allow port 80 from bastion IP

if batsion IP is restarted, IP will chanages in that case we use elastic Ip and attach to bastion host.

a sg is attached to bastion host -- sg-tjhgfyg0
a sg is attcahed to load blancer host ---sg-hlkmdrglkj

rule we can write
=================
load blancer sg rule
--------------
port : 80
target IP: instaed of giving bastion Ip we can attache sg-tjhgfyg0
instances attcahed with these sg sg-tjhgfyg0 are allaowed to connect port no 80
from now we will use custome modules


here every time devloper needs to login to bastion host to check the applictaion so instaed of we wii use VPN

how to create open VPN:
----------------------------
ec2---> comminuty tab ----> openvpn access ---> select (community image) ---> key pair ---> 

setup vp --->session40 --->1.11.0 min --->
install openvpn
for vpn also we need to create sg 


VPN:
========
we need key that needs to give in vpn floder

Headless mode:
==============
openpin.sh --> taking from chatgpt ---> to configure openvpn withoput manuval

terraform ---> infra creation
ansible ---> configuration managemnt

so we can integrate terraform and ansible together

mongodb:
---------
vpn ----> mongodb 
mongodb should should allow connection from VPN
22 and 27017

# now instance is created we need integrate with ansible
# using remote exec we will connect and trigger the ansible

Null resource:
-----------------
It is doesn't create the instances. It will fallow the terraform lifecycle. It will not do anything it will implement the standard lifecycle.
It is used to connect the instances

Null resource will not create resouce but it fallows the standard lifecycle of terraform. You can use null resource to connect instances

1. connect to the instances (anisblepull)
2. copy the scrpit
3. execute the scrpit


Ansible server ---> node 1
                    node 2



      ansible pull ---> mongodb instance(If i install ansible here) ---> this is called ansible server
so there is a command called ansible pull

pulls playbook from a VCS and execute them on target host

Terraform file provisioner
========================

instead of writing separate file like (mongodb,redis,mysql,rabbitmq). we will change the mongodb file to bootstrap.sh

redis ----> 6379
mysql ----> 3306
rabbitmq ---> 5672


IAM:
=============
user: ---> human --> credentails will leak
------
administrator access
security credentials
aws configure 
ec2 ---> SSM parameter ----> 


ROLE: ---> not human
------
roles are created for non human
EC2 ----> create role
attach permissions to this role
attach role to ec2

ALB --->listener ---> rule ---> target group
ALB(internal) ----> listerner(80) ----> fixede response
create role:
----------
IAM ---> roles ----> create ---> aws service ---> EC2 ---> next --> admin acess ---> rolename (Ec2RoleToFetchSSMparams) ---> create

we need to take this role and attach to EC2 server

we can attach the role to any instance then no need to confugure aws

How to attach:
--------------
Ec2 ---> select one Ec2 ---> add --> SG ---> MOdify IAM role ---> select ---> update

Backend Components:
-------------------
catalogue.backend.lakshmireddy.site ---> It will forwarded to catalogue target group

How we can create record
-----------------------
*.backend-lakshmireddy.site --->ALB

create dns record: 
with .backend ---name
value ---> ailas to application and classic load blancer and select region(us-east-1) Ity will display our load blancer
