#!/bin/bash
############################
#                          #
#  mvColab intstall script #----> Run As Root
#                          #
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
##################################################################################
#                                                                                #
#       This firewall activates when your Mullvad VPN client is connected.       #
#       It will block all out bound traffic to the VPN host that is not          #
#       preconfigured in mvColab.conf and mvAllow files. It will also block      #
#       all inbound traffic from the host which was not initiated by             #
#       an outbound connection from your machine.                                #
#       - this installer will create a usergroup                                 #
#         it will add a cron file to /etc/cron.d                                 #
#         the software will add tables tables to nftables                        #
#	      very restrictive modes will be added to all mvColab files                #
#                                                                                #
##################################################################################
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null && pwd)"
groupadd mvpn
chown -R root:root $SCRIPT_DIR
chmod =0500 $SCRIPT_DIR/mvColab.sh
chmod =0400 $SCRIPT_DIR/mvColabNFT
touch $SCRIPT_DIR/mvColabDOM
chmod =0400 $SCRIPT_DIR/mvColabDOM
touch $SCRIPT_DIR/mvColabGID
chmod =0400 $SCRIPT_DIR/mvColabGID
touch $SCRIPT_DIR/mvAllow
chmod =0660 $SCRIPT_DIR/mvAllow
touch $SCRIPT_DIR/mvColabTCP
chmod =0400 $SCRIPT_DIR/mvColabTCP
touch $SCRIPT_DIR/mvColabUDP
chmod =0400 $SCRIPT_DIR/mvColabUDP
chmod =0600 $SCRIPT_DIR/mvColab.conf
chmod =0500 $SCRIPT_DIR/mvColabInstall.sh
`cat > /etc/cron.d/mvColab <<EOL
PATH=/usr/sbin/:/usr/bin/
SHELL=/bin/bash

* * * * * root $SCRIPT_DIR/mvColab.sh

EOL`
