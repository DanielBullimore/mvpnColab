# mvpnColab
A draconian linux nftables firewall which colaborates with mullvad vpn client

Designed for a zero trust isolated host.
When you create a VPN (Virtual Private Network) the VPN host has the same level of connection to your machine as any machine on your local lan or wifi. Get this straight, I am in no way saying that VPN providers are untrustworthy. However if you are operating at a threat level of paranoid or above unfiltered networking to a machine you do not control is a blunder. A commercial host is likely very responsible, they do employ human beings though. Human beings are subject to temptation.

I have used mullvad vpn client for this example because it's client application uses the nftables firewall.

I am not saying I make impenetrable firewalls, I'm not even saying this is a good firewall ruleset. This is an example of how to filter the traffic of your wireguard interface.

29/07/26 - Allowed Ports: Added a conf file option to list 'allow only' ports. They are TCP only so far. Hopefully will get time to add type soon. Also added an option for 'explicitly allowed hosts' only, no implemented yet. And some typos fixed. ~ Daniel 

27/07/26 - Application Firewall: Using a GID based rule and a conf file I have rapidly added 'only allowed' application layer to the firewall. When allow_gid=true in mvColab.conf only applications running as mvpn usergroup will be able to pass the Draconian. No install script yet so users will have to manually add the group (groupadd mvpn). This even stops root proccess from accessing the vpn tunnel. To let the zero trust draconian grant internet users will have to run processes using sudo -g mvpn <command>. In time I will add a timer so a network pass will only last a preset length of time. ~ Daniel
