# mvpnColab
A draconian linux nftables firewall which colaborates with mullvad vpn client

Designed for a zero trust isolated host.
When you create a VPN (Virtual Private Network) the VPN host has the same level of connection to your machine as any machine on your local lan or wifi. Get this straight, I am in no way saying that VPN providers are untrustworthy. However if you are operating at a threat level of paronoid or above unfiltered networking to a machine you do not control is a blunder. A comerical host is likely very responsable, they do employ human beings though. Human beings are subject to temptation.

I have used mullvad vpn client for this example becuase it's client application uses the nftables firewall.

I am not saying I make inpenatrable firewalls, I'm not even saying this is a good firewall ruleset. This is an example of how to filter the traffic of your wireguard interface.
