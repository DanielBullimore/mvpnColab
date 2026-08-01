# mvpnColab
A draconian linux nftables firewall which colaborates with mullvad vpn client

Designed for a zero trust isolated host.
When you create a VPN (Virtual Private Network) the VPN host has the same level of connection to your machine as any machine on your local lan or wifi (or your cell co. or something pretending to be your cell co. RIP Kevin). Get this straight, I am in no way saying that VPN providers are untrustworthy. However if you are operating at a threat level of paranoid or above, unfiltered networking to a machine you do not control is a blunder. A commercial host is likely very responsible, they do employ human beings though. Human beings are subject to temptation.
I have used mullvad vpn client for this example because it's client application uses the nftables firewall.I am not saying I make impenetrable firewalls, I'm not even saying this is a good firewall ruleset. This is an example of how to filter the traffic of your wireguard interface.

_INSTALL_
mvColabInstaller.sh must be run as root. Download the files [mvColab.conf,mcColab.sh,mvColabNFT,mvColabInstall.sh] and place them in a dedicated directory. Run mvColabInstaller.sh as root. It will create four nft include files [mvColabUDP,mvColabTCP,mvColabGID,mvColabDOM] and one allow hosts file [mvAllow]. Sometimes the crond takes awhile to pick up the the file created in /etc/con.d/mvColab. The firewall will now run automatically when your mullvad vpn client connects.

_CONFIGURE_
mvColab.conf has four options:
allow_gid - When true the firewall will only allow processes run as usergroup mvpn. When false any process will be allowed.
allow_hosts - When true the firewall will only allow outbound connections to IP address which the domain names listed in mvAllow file resolve to. When false outbound connections are allowed to any ip.
tcp_out_ports - When a brace enclosed port list is set e,g, { 80,443,8333 } outbound connections will only be allowed to those TCP ports, When false no TCP ports are allowed.
udp_out_ports - When a brace enclosed port list is set e,g, { 5555,7777 } outbound connections will only be allowed to those UDP ports, When false no UDP ports are allowed.
*The mvAllow file is where allowed hosts should be listed, one host per line.
**The ruleset prioritises blocking gid and allowing mvpn to continue, then allowing hosts, then allowing ports, then blocking everything not specifically allowed in true draconian style.

_OPERATION_
Having configured your options in mvColab.conf and added any domain names to mvAllow. Use the MUllvad client app/cli as usual to connect to a VPN host. Once connection is established check the firewall is operating by running `sudo nft list ruleset` the two tables from mvColabNFT should be among the listed results. If they are not, manually run `sudo mvColab.sh` make note of any error output and kindly raise an issue at https://www.github.com/danielbullimore/mvpnColab. Should there be no error output, ctrl+c and run `sudo nft list ruleset` again. If the tables are now present this is a cron.d problem. I have found a restart fixes it but my debian is non-standard. You could manually `sudo crontab -e` to run mvColab.sh every minute as root.
If you have enabled allow_gid you will have to start processes requiring VPN access with `sudo -u <user> -g mvpn <command>`. Insure -u <user> is used. It is unwise to run applications or random processes as root! I don't recommend using mvpn group for anything, add no users to it give it control over no binaries,files or directories. Explicitly forcing the user to start processes with the intention of using it over VPN is a designed security feature to stop leaks. Remember if no unintended information gets out then no unintended information can be used against your operation.

_Change Log_

01/08/2026 - Added install script, outbound UDP port list and outbound TCP port list. Renamed some files. The installer sets very restrictive file permissions and creates some files. The cron.d file was difficult to sight in. It does work eventually on its on

29/07/26 - Allowed Hosts: Finished the explicitly allowed hosts feature. When allow_hosts is true in mvColab.conf out bound traffic will only pass the draconian if its destination domain name is in mvAllowUrl file. Combined with Allow_GID and or Out_Ports the user of this firewall can now narrow their VPN traffic to fine control. Allow_Host will break your browsing experience because only allowing connections to the IP listed in a domains DNS record prevents cross scripting from 3rd parties. The browser is blocked from connecting to 3rd party IP on the ethernet level. However if your mission depends on getting data to and from known machines only, Allow_Hosts will prevent those leaks. This VPN+Firewall used with a Privacy Browser might be super stealthy if you don't log into anything? And yes I know a URL is not a domain name. I don't think I'll add too many more features, its getting out of scope for a bash script. Might be nice to come back and write a AAA c++ version. That said, IP lists using [DB.SHBD](https://github.com/DanielBullimore/D.B.SHDB.git) could really crank the usability up.

29/07/26 - Allowed Ports: Added a conf file option to list 'allow only' ports. They are TCP only so far. Hopefully will get time to add type soon. Also added an option for 'explicitly allowed hosts' only, not implemented yet. And some typos fixed. ~ Daniel 

27/07/26 - Application Firewall: Using a GID based rule and a conf file I have rapidly added 'only allowed' application layer to the firewall. When allow_gid=true in mvColab.conf only applications running as mvpn usergroup will be able to pass the Draconian. No install script yet so users will have to manually add the group (groupadd mvpn). This even stops root processes from accessing the VPN tunnel. To let the zero trust draconian grant internet users will have to run processes using sudo -g mvpn <command>. In time I will add a timer so a network pass will only last a preset length of time. ~ Daniel
