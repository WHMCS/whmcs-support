# WHMCS Support SSH Keys

This repository contains the public SSH Keys for the WHMCS Technical Support team.

## Usage
### cPanel and Plesk

A helper script `script.sh` is provided for your convenience to automate the installation of the WHMCS Support SSH Public Key and addition of the required IP addresses to iptables for cPanel and Plesk servers.

```
sh <(curl https://raw.githubusercontent.com/whmcs/whmcs-support/main/ssh_keys/script.sh || wget -O - https://raw.githubusercontent.com/whmcs/whmcs-support/main/ssh_keys/script.sh)
```

### Other

If the server hosting WHMCS uses a different control panel or has no control panel, refer to your control panel or OS documentation for instructions to add SSH Keys and allow the following IP addresses:

```
208.74.120.226
195.214.233.0/24
194.8.192.130
81.184.0.141
208.74.127.0/28
184.94.197.2
2001:678:744::/64
2620:0:28a4:4000::/52
```

## Removal

Once the support request is resolved, you may remove the WHMCS Support SSH key:

```
sed -i '/support@whmcs.com/d' ~/.ssh/authorized_keys
```

## Useful Links
* [How to provide WHMCS Support with SSH Key Authenticated Server Access](https://www.whmcs.com/members/knowledgebase/397/How-to-provide-WHMCS-Support-with-SSH-Key-Authenticated-Server-Access.html)
* [What credentials should I provide to WHMCS Technical Support?](https://www.whmcs.com/members/knowledgebase/401/What-credentials-should-I-provide-to-WHMCS-Technical-Support.html)
* [Technical Support Ticket Submission Guidelines](https://www.whmcs.com/members/knowledgebase/58/Technical-Support-Ticket-Submission-Guidelines.html)