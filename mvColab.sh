#!/bin/bash
##################################################################################
# MIT License
#
# Copyright 01/08/2026 Daniel Bullimore
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##################################################################################

#run from cron every minute
#places draconian ruleset over mullvad tunnel once its connected
#function to check if mulvad is connected, changes nft rules acordingly
mvCheck10() {
	
	if  [[ "Disconnected" = $(mullvad status -v | head -1) ]]; then
		nft add table inet mvcolab
		nft delete table inet mvcolab;

	elif [[ "Connecting" = $(mullvad status -v | head -1) ]]; then
		#todo ? start a loop here checking for connected ?#
		nft add table inet mvcolab
		nft delete table inet mvcolab;
	elif [[ "Connected" = $(mullvad status -v | head -1) ]]; then
		#get table list and check if mvcolab table exists, only act if it does not.
		if ! [[ "table inet mvcolab" = $(nft list tables | grep "mvcolab") ]] ; then
			#load config file
			SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
			ALLOW_GID=`head -1  $SCRIPT_DIR/mvColab.conf | cut -d'=' -f2`

			ALLOW_HOSTS=`head -2 $SCRIPT_DIR/mvColab.conf | tail -n 1 | cut -d'=' -f2`
			 #list of allowed outbound ports
			TCP_OUT="`head -3 $SCRIPT_DIR/mvColab.conf | tail -n 1  | cut -d'=' -f2`"
			UDP_OUT="`head -4 $SCRIPT_DIR/mvColab.conf | tail -n 1 | cut -d'=' -f2`"

			#is configured for gid based permissions
			if [ "true" = $ALLOW_GID ];  then
				gid=`echo $(getent group mvpn) | cut -d':' -f3`
				echo 'add rule inet mvcolab output oif "wg0-mullvad" meta skgid != $allowGid reject comment "           (GID: allow only mvpn user group)"' | cat > $SCRIPT_DIR/mvColabGID
				else
				`echo "#" | cat > $SCRIPT_DIR/mvColabGID`
				gid=0
			fi
			 #is configured for allowed hosts only
			 if [ "true" = $ALLOW_HOSTS ]; then
				echo 'add rule inet mvcolab output oif "wg0-mullvad" ip daddr != $allowedHosts reject comment "           (Allow Hosts: allow only mvpn user group)"' | cat > $SCRIPT_DIR/mvColabDOM
				#generate ip list of allowed hosts
				ALLOWED_HOSTS="{"
				while FILE= read -r line; do
					ip=`dig +short $line | tail -n 1`
					ALLOWED_HOSTS+="$ip,"
				done < $SCRIPT_DIR/mvAllow
				ALLOWED_HOSTS+="}"
			else
				ALLOWED_HOSTS="{}"
				echo '#' | cat > $SCRIPT_DIR/mvColabURL
			fi
			#is configured for outbound tcp ports
			if ! [ "false" = "$TCP_OUT" ]; then
				echo 'add rule inet mvcolab output oif "wg0-mullvad" tcp dport { $tcpOutPorts } accept comment "               (TCP: Allow outbound ports )"' | cat > $SCRIPT_DIR/mvColabTCP
			else
				#is not configured
				TCP_OUT="{}"
				echo "#" | cat > $SCRIPT_DIR/mvColabTCP
			fi
			#is configured for outbound udp
			if ! [ "false" = $UDP_OUT ]; then
				echo 'add rule inet mvcolab output oif "wg0-mullvad" udp dport { $udpOutPorts } accept comment "               (UDP: Allow outbound ports )"' | cat > $SCRIPT_DIR/mvColabUDP
			else
				#is not configed
				UDP_OUT="{}"
				echo "#" | cat > $SCRIPT_DIR/mvColabUDP		
			fi
			#grab the dns server ip
			resolver=`echo $(cat /etc/resolv.conf | head -1) | cut -d' ' -f2`
			#split the wireguard tunnel details up
			status=`echo $(mullvad status -v | head -2) | cut -d'(' -f2 | cut -d'/' -f1`
			ip=`echo $status | cut -d':' -f1`
			port=`echo $status | cut -d':' -f2 | cut -d'/' -f1`
			protocol=`echo $status | cut -d':' -f2 | cut -d'/' -f2`

			#add security layer firewall with tunnel details
			nft -I $SCRIPT_DIR -f $SCRIPT_DIR/mvColabNFT -D wireguard=$ip -D wgPort=$port -D wgDNS=$resolver -D allowGid=$gid -D tcpOutPorts="$TCP_OUT" -D udpOutPorts="$UDP_OUT" -D allowedHosts=$ALLOWED_HOSTS;
		fi
	fi
}
#Check status every 5 seconds for one minute
for (( i=0; $i<=11; i++ )) do
	mvCheck10
	sleep 5
done
