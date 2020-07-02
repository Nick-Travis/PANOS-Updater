#Variables
firewallIP='172.16.5.101'
version='8.1.11'
userID='admin'
password='admin'

#Monitor Job function
function Monitor {
    #echo "jobID sent to function is "$1
    JobStatus=PEND
    while [ "$JobStatus" == "PEND" ]
    do
      JobStatus=`curl -k -s -X GET 'https://'$firewallIP'/api/?type=op&cmd=<show><jobs><id>'$1'</id></jobs></show>&key='$APIKey''| awk -F '<result>' {'print $3'} | awk -F '<' {'print $1'}`
      sleep 2
      if [[ "$JobStatus" == "PEND" ]]
      then
        printf "."
      fi
    done
    echo $JobStatus
}
#Get API key from firewall
APIKey=`curl -k -s -X GET 'https://'$firewallIP'/api/?type=keygen&user='$userID'&password='$password''| awk -F '>' {'print $4'} | awk -F '<' {'print $1'}`
#echo $APIKey
echo 'API Key Retrieved!'

#Retreive License Keys From Server
echo "Fetching licenses from Palo Alto Networks Servers"
curl -k -s -X GET 'https://'$firewallIP'/api/?type=op&cmd=<request><license><fetch></fetch></license></request>&key='$APIKey''| awk -F 'status="' {'print $2'} | awk -F '"' {'print $1'}

#Download Latest Content Updates
echo 'Sending command to download latest content updates'

JobID=`curl -k -s -X GET 'https://'$firewallIP'/api/?type=op&cmd=<request><content><upgrade><download><latest/></download></upgrade></content></request>&key='$APIKey''| awk -F '>' {'print $5'} | awk {'print $6'} | awk -F '<' {'print $1'}`

#Monitor Download Job
echo "Content Download Job ID is " $JobID
Monitor $JobID

#Install latest Content Updates
InstallContentJobID=`curl -k -s -X GET 'https://'$firewallIP'/api/?type=op&cmd=<request><content><upgrade><install><version>latest</version></install></upgrade></content></request>&key='$APIKey''|awk -F '>' {'print $5'}| awk -F '<' {'print $1'} | awk {'print $7'}`

#Monitor Install Job
echo "Content Install Job ID is "$InstallContentJobID
Monitor $InstallContentJobID

#Check for PAN-OS Updates
curl -k -s -X GET 'https://'$firewallIP'/api/?type=op&cmd=<request><system><software><check></check></software></system></request>&key='$APIKey'' >> /dev/null

#Download PAN-OS
DownloadPANosID=`curl -k -s -X GET 'https://'$firewallIP'/api/?type=op&cmd=<request><system><software><download><version>'$version'</version></download></software></system></request>&key='$APIKey''|awk -F 'job>' {'print $2'} | awk -F '<' {'print $1'}`

#Monitor Download jobs
echo "Pan-OS Download ID is " $DownloadPANosID
Monitor $DownloadPANosID

#Install PAN-OS
InstallPANOSJobID=`curl -k -s -X GET 'https://'$firewallIP'/api/?type=op&cmd=<request><system><software><install><version>'$version'</version></install></software></system></request>&key='$APIKey''|awk -F 'job>' {'print $2'} | awk -F '<' {'print $1'}`

#Check Install Status
echo "Install Job ID is " $InstallPANOSJobID
Monitor $InstallPANOSJobID

#Reboot
echo "Rebooting Firewall Now"
curl -k -s -X GET 'https://'$firewallIP'/api/?type=op&cmd=<request><restart><system></system></restart></request>&key='$APIKey'' | awk -F 'status="' {'print $2'} | awk -F '"' {'print $1'}
echo "Script Complete, Please wait for firewall to reboot"
