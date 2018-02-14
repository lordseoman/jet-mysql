# jet-mysql
MySQL container for Jet

ScratchPad For Demo Setup
-=-=-=-=-=-=-=-=-=-=-=-=-

Need latest debian server install only.
Minimum 8GB RAM, 500GB HDD, NTP setup and running.

Ports open from <OfficeIP> to ports 80, 443, 22

A URL to access the web portal eg. http://jet.croutons.com/

Ports open from Jet server to edge device.
Access details to get into the edge device.
Ports open from <OfficeIP> to edge device.

Jet server needs access to the Internet to download packages.
If a proxy server is used we need both HTTP and HTTPS settings.

The Jet server needs a default route out to the Internet that does
not go through the edge device (External Network). This allows Jet
to be accessed from the Internet so we can run the demo. It also needs an interface on
the internal network that connects to the edge device internal 
interface. 

In order to do edge testing/demo we also need a small VM on both the
Internal and External Networks so we can install anything needed 
using the External Network and then test using the Internal network.
We will need SSH and RPD access to the client from <OfficeIP> and
SSH access from the Jet Server.


