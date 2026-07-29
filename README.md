# mvpnColab
A draconian linux nftables firewall which colaborates with mullvad vpn client

Designed for a zero trust isolated host.
When you create a VPN (Virtual Private Network) the VPN host has the same level of connection to your machine as any machine on your local lan or wifi (or your cell co. or something pretending to be your cell co. RIP Kevin). Get this straight, I am in no way saying that VPN providers are untrustworthy. However if you are operating at a threat level of paranoid or above unfiltered networking to a machine you do not control is a blunder. A commercial host is likely very responsible, they do employ human beings though. Human beings are subject to temptation.

I have used mullvad vpn client for this example because it's client application uses the nftables firewall.

I am not saying I make impenetrable firewalls, I'm not even saying this is a good firewall ruleset. This is an example of how to filter the traffic of your wireguard interface.

29/07/26 - Allowed Hosts: Finished the explicitly allowed hosts feature. When allow_hosts is true in mvColab.conf out bound traffic will only pass the draconian if its destination domain name is in mvAllowUrl file. Combined with Allow_GID and or Out_Ports the user of this firewall can now narrow their VPN traffic to fine control. Allow_Host will break your browsing experience because only allowing connections to the IP listed in a domains DNS record prevents cross scripting from 3rd parties. The browser is blocked from connecting to 3rd party IP on the ethernet level. However if your mission depends on getting data to and from known machines only, Allow_Hosts will prevent those leaks. This VPN+Firewall used with a Privacy Browser might be super stealthy if you don't log into anything? And yes I know a URL is not a domain name. I don't think I'll add too many more features, its getting out of scope for a bash script. Might be nice to come back and write a AAA c++ version. That said, IP lists using [DB.SHBD](https://github.com/DanielBullimore/D.B.SHDB.git) could really crank the usability up.

29/07/26 - Allowed Ports: Added a conf file option to list 'allow only' ports. They are TCP only so far. Hopefully will get time to add type soon. Also added an option for 'explicitly allowed hosts' only, not implemented yet. And some typos fixed. ~ Daniel 

27/07/26 - Application Firewall: Using a GID based rule and a conf file I have rapidly added 'only allowed' application layer to the firewall. When allow_gid=true in mvColab.conf only applications running as mvpn usergroup will be able to pass the Draconian. No install script yet so users will have to manually add the group (groupadd mvpn). This even stops root processes from accessing the VPN tunnel. To let the zero trust draconian grant internet users will have to run processes using sudo -g mvpn <command>. In time I will add a timer so a network pass will only last a preset length of time. ~ Daniel
