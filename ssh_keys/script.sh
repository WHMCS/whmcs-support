#!/bin/bash

echo -e "Before proceeding, ensure that SSH access is allowed for the control panel account upon which the SSH Keys will be installed."
sleep 3

# Prompt for CONTROL_PANEL and ensure only 'cpanel', 'plesk' or 'other' is accepted
while true; do
    read -p "What control panel are you using (cpanel, plesk or other)? " CONTROL_PANEL
    if [[ "$CONTROL_PANEL" == "cpanel" || "$CONTROL_PANEL" == "plesk" || "$CONTROL_PANEL" == "other" ]]; then
        break
    else
        echo "Please enter either 'cpanel', 'plesk' or 'other'."
    fi
done

if [ "$CONTROL_PANEL" == "other" ]; then
    echo "Automatic SSH Key installation is not possible for systems without the cPanel or Plesk control panels. For manual instructions, please open the following URL in a browser:"
    echo -e "\e[1;34mhttps://www.whmcs.com/members/index.php/knowledgebase/397/How-to-provide-WHMCS-Support-with-SSH-Key-Authenticated-Server-Access.html#other \e[0m"
    echo -e "\e[1;31m Bye. \e[0m"
    exit 0
fi

if [ "$CONTROL_PANEL" == "cpanel" ]; then
    echo "Executing steps for cPanel..."

    # Prompt for TARGET_USER if not provided as an argument
    if [ -z "$1" ]; then
        read -p "Please enter the target user: " TARGET_USER
    else
        TARGET_USER=$1
    fi

    # Check if the remove parameter is provided
    REMOVE_KEY=false
    if [ "$2" == "--remove" ]; then
        REMOVE_KEY=true
    fi

    if [ "$REMOVE_KEY" = true ]; then
        echo -e "Removing the WHMCS Support public SSH key from the authorized_keys"
        sudo -u $TARGET_USER bash -c "sed -i '/support@whmcs.com/d' ~/.ssh/authorized_keys"
        echo -e "\e[1;31m Done. \e[0m"
        exit 0
    fi

    echo -e "1. Adding our IP address to the local firewall"
    if [[ $(which iptables) ]] 2>/dev/null ; then
            echo "Adding our IP address to the local firewall:"
            sudo iptables -I INPUT -s 195.214.233.0/24,194.8.192.130,81.184.0.141,208.74.127.0/28,184.94.192.0/20 -j ACCEPT
            sudo ip6tables -I INPUT -s 2001:678:744::/64,2620:0:28a4:4000::/52 -j ACCEPT
    else
            echo "Command iptables is not installed"
    fi
    sleep 1
    echo -e "\e[1;31m Done. \e[0m"

    echo -e "2. Making sure PubkeyAuthentication is enabled in SSH configuration"
    sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
    sudo sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
    sudo sed -i 's/PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
    echo -e "\e[1;31m Done. \e[0m"
    sudo grep PubkeyAuthentication /etc/ssh/sshd_config
    sleep 1

    echo -e "3. Making sure .ssh directory and its files exist in the home directory of the user that will be provided to the Support Team"
    sudo -u $TARGET_USER bash -c "mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/id_dsa.pub && touch ~/.ssh/authorized_keys && touch ~/.ssh/config && chmod 600 ~/.ssh/config"
    sleep 1
    echo -e "\e[1;31m Done. \e[0m"

    sleep 1

    echo -e "4. Placing the WHMCS Support public SSH key to the authorized_keys to allow logging in using it"
    sudo -u $TARGET_USER bash -c "curl -L https://raw.githubusercontent.com/WHMCS/whmcs-support/refs/heads/main/ssh_keys/id_rsa.pub >> ~/.ssh/authorized_keys && curl -L https://raw.githubusercontent.com/WHMCS/whmcs-support/refs/heads/main/ssh_keys/id_rsa.pub && chmod 644 ~/.ssh/id_dsa.pub && chmod 644 ~/.ssh/authorized_keys"
    echo -e "\e[1;31m Done. \e[0m"
    sleep 1

    echo -e "5. Making sure PubkeyAuthentication is enabled in SSH configuration for the selected user"
    sudo -u $TARGET_USER bash -c "echo 'Host *' >> ~/.ssh/config"
    sudo -u $TARGET_USER bash -c "echo 'PubkeyAuthentication yes' >> ~/.ssh/config"

    sleep 1
    echo -e "\e[1;31m Done. \e[0m"

    echo -e "6. Reloading the sshd service to apply the above changes"
    sudo systemctl reload sshd 2>/dev/null
    # The line below exists because some distros have only ssh as an existing service nowadays
    sudo systemctl reload ssh 2>/dev/null
    sleep 1
    echo -e "\e[1;31m Done. \e[0m"
fi

if [ "$CONTROL_PANEL" == "plesk" ]; then
    echo "Executing steps for Plesk..."

    # Prompt for TARGET_USER if not provided as an argument
    if [ -z "$1" ]; then
        read -p "Please enter the target user: " TARGET_USER
    else
        TARGET_USER=$1
    fi

    # Check if the remove parameter is provided
    REMOVE_KEY=false
    if [ "$2" == "--remove" ]; then
        REMOVE_KEY=true
    fi

    if [ "$REMOVE_KEY" = true ]; then
        echo -e "Removing the WHMCS Support public SSH key from the authorized_keys"
        sudo -u $TARGET_USER bash -c "sed -i '/support@whmcs.com/d' ~/.ssh/authorized_keys"
        echo -e "\e[1;31m Done. \e[0m"
        exit 0
    fi

    echo -e "1. Adding our IP address to the local firewall"
    if [[ $(which iptables) ]] 2>/dev/null ; then
            echo "Adding our IP address to the local firewall:"
            sudo iptables -I INPUT -s 195.214.233.0/24,194.8.192.130,81.184.0.141,208.74.127.0/28,184.94.192.0/20 -j ACCEPT
            sudo ip6tables -I INPUT -s 2001:678:744::/64,2620:0:28a4:4000::/52 -j ACCEPT
    else
            echo "Command iptables is not installed"
    fi
    sleep 1
    echo -e "\e[1;31m Done. \e[0m"

    echo -e "2. Making sure PubkeyAuthentication is enabled in SSH configuration"
    sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
    sudo sed -i 's/#PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
    sudo sed -i 's/PubkeyAuthentication no/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
    echo -e "\e[1;31m Done. \e[0m"
    sudo grep PubkeyAuthentication /etc/ssh/sshd_config
    sleep 1

    echo -e "3. Making sure .ssh directory and its files exist in the home directory of the user that will be provided to the Support Team"
    sudo -u $TARGET_USER bash -c "mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && touch ~/.ssh/config && chmod 600 ~/.ssh/config"
    sleep 1
    echo -e "\e[1;31m Done. \e[0m"

    sleep 1

    echo -e "4. Placing the WHMCS Support public SSH key to the authorized_keys to allow logging in using it"
    sudo -u $TARGET_USER bash -c "curl -L https://raw.githubusercontent.com/WHMCS/whmcs-support/refs/heads/main/ssh_keys/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
    echo -e "\e[1;31m Done. \e[0m"
    sleep 1

    echo -e "5. Making sure PubkeyAuthentication is enabled in SSH configuration for the selected user"
    sudo -u $TARGET_USER bash -c "echo 'Host *' >> ~/.ssh/config"
    sudo -u $TARGET_USER bash -c "echo 'PubkeyAuthentication yes' >> ~/.ssh/config"

    sleep 1
    echo -e "\e[1;31m Done. \e[0m"

    echo -e "6. Reloading the sshd service to apply the above changes"
    sudo systemctl reload sshd 2>/dev/null
    # The line below exists because some distros have only ssh as an existing service nowadays
    sudo systemctl reload ssh 2>/dev/null
    sleep 1
    echo -e "\e[1;31m Done. \e[0m"
fi