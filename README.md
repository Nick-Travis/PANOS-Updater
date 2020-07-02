# PANOS-Updater
Bash script(not pretty, but functional) for updating content and PAN-OS on Palo Alto Networks Firewalls.  Update the four variables at the beginnging of the file and run the script.  It will automatically reboot the firewall after the update.  This follows the steps outlined here: https://docs.paloaltonetworks.com/pan-os/9-0/pan-os-panorama-api/pan-os-xml-api-use-cases/upgrade-a-firewall-to-the-latest-pan-os-version-api.html

## Usage
chomod +x ./FirewallUpdate.sh
./FirewallUpdate.sh

## Sample Output
./FirewallUpdate.sh

API Key Retrieved!

Fetching licenses from Palo Alto Networks Servers

success

Sending command to download latest content updates


Content Download Job ID is  2

....OK

Content Install Job ID is 3

.......................................................OK

Pan-OS Download ID is  4

................................................................OK

Install Job ID is  5

....................................................................................................OK

Rebooting Firewall Now

success

Script Complete, Please wait for firewall to reboot
