# Windows Assignment

for this assignemnt, the lab in the Ansible assignment was used to configure
the Windows server - WS01 with ip address of 192.168.72.130.
Using the variables, it is needed to change the IP addresses in the playbook accordingly

The domain used in this example is somedomain.loc.
It is expected that the server is in a workgroup, and not in a domain.

The playbook also configures the DNS Client on WS01 to 127.0.0.1,
as the DNS zone for somedomain.loc resides on the test machine (so name resolution could work)

RDCMan.zip was used as the file to be placed in the IIS website, downloaded from:
https://download.sysinternals.com/files/RDCMan.zip

Ansible was used for the purpose of learning.

## points of improvment