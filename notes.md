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


