#!/bin/bash
#* shree_hari

#* Setup script
#* Usecase : setup your device to run anveshan without any errors.

# colors
blue=$'\e[34m'
cyan=$'\e[36m'
red=$'\e[91m'
green=$'\e[92m'
yellow=$'\e[93m'
magenta=$'\e[95m'
reset=$'\e[0m'

# print logo
logo() {
echo -e "${green}        ,                                              ${reset}"
echo -e "${green}       ███▓▄,,▄▄▄▓█████▓▄▄,                            ${reset}"
echo -e "${green}       ██████████▀ \`█████████▌_                       ${reset}"
echo -e "${green}        █████████    ███████████                       ${reset}"
echo -e "${green}          \"▀▀▀▀\`     ████████████                    ${reset}"
echo -e "${green}        ,,▄▄,,__    ▄████████████                      ${reset}"
echo -e "${green}     ▄███████████████████████████                      ${reset}"
echo -e "${green}    ████████████${red}φ▓▓▓▓▓╚${green}██████████        ${reset}"
echo -e "${green}    ███████████${red}╫       ╫${green}█████████        ${reset}"
echo -e "${green}    ╫██████████${red}▒      ,▓${green}█████████▌       ${reset}"
echo -e "${green}     ▀████████ ${red}╬█▄▄╔╔φ${green}████████████       ${reset}"
echo -e "${green}       ▀█████${red}╬█${green}████████████████████      ${reset}"
echo -e "${green}           ${red}╙▀${green}▀▀▀▀▀▀\`\@hackersthan/█▀    ${reset}"
}

# screen clear
scrclr() {
        clear && logo && echo
}


logo

#* run with sudo
if [ "$(whoami)" != 'root' ]; then

    printf "${red}[!] Manually enter your password when asked.${reset}\n"
fi


# function to check golang installed or not
if ! command -v go &> /dev/null; then
    printf "${red}[!] GO language is not installed. Installing via apt.${reset}\n"
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt install golang-go
fi


#check GOPATH abd GOROOT
if [ -f ~/.bashrc ]; then
    if ! grep -q "export GOPATH=" ~/.bashrc && ! grep -q "export GOROOT=" ~/.bashrc; then
        echo "export GOROOT=/usr/local/go" >> ~/.bashrc
        echo "export GOPATH=\$HOME/go" >> ~/.bashrc
        echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bashrc
    fi
    source ~/.bashrc
elif [ -f ~/.zshrc ]; then
    if ! grep -q "export GOPATH=" ~/.zshrc && ! grep -q "export GOROOT=" ~/.zshrc; then
        echo "export GOROOT=/usr/local/go" >> ~/.zshrc
        echo "export GOPATH=\$HOME/go" >> ~/.zshrc
        echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.zshrc
    fi
    source ~/.zshrc
else
    echo "~/.bashrc or ~/.zshrc not found"
fi


# creating anveshan directory
if [[ -d $HOME/anveshan ]]
then
        cd "$HOME/anveshan"
else
        mkdir "$HOME/anveshan" && cd "$HOME/anveshan"
fi


# Creating a virtual python environment
sudo apt install -y python3 python3-pip python3-venv || { echo "Failed to install python3-venv. Exiting."; exit 1; }
VENV_PATH="$HOME/anveshan/venv"
python3 -m venv "$VENV_PATH"
source "$VENV_PATH/bin/activate"

echo "[+] Upgrading pip in the virtual environment..."
pip3 install --upgrade pip


# Check if --break-system-packages is required or not
if pip3 install --help | grep -q -- '--break-system-packages'; then
    bsp="--break-system-packages"
else
    bsp=""
fi


#Fix `urllib3` and `six` package errors
read -p "removing 'urllib3' and 'six' packages from apt and installing from pip, Confirm? (Y/n): " confirm_uninstall
if [[ "$confirm_uninstall" == "y" || "$confirm_uninstall" == "Y" ]]; then
    echo "Uninstalling 'urllib3' and 'six' from apt..."
    sudo apt remove -y python3-urllib3 python3-six

    echo "Uninstalling 'urllib3' and 'six' from pip3..."
    sudo pip3 uninstall -y urllib3 six $bsp

    echo "Installing 'urllib3' and 'six' from pip3"
    sudo pip3 install urllib3 six $bsp

    echo "Packages uninstalled and reinstalled successfully."
else
    echo "Skipping uninstallation and installation of urllib3 and six."
fi


# function to upgrade pip packages
echo -e "${magenta}You have $(pip3 list --outdated | grep '[0-9\.[0-9]' | wc -l) outdated pip packages.${reset}"
read -p "${yellow}Do you want to upgrade all of them? (Y/n): ${reset}" answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    printf "${green}[*] Upgrading all pip packages${reset}\n"
    pip3 list --outdated | grep "[0-9\.[0-9]" | cut -d " " -f1 | xargs pip3 install --upgrade $bsp
else
    printf "${red}[*] Not upgrading.${reset}\n"
fi


# installing basic tools
scrclr
printf "${green}[*] apt update & upgrade${reset}\n"
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install pv curl net-tools build-essential
sudo apt -y install python3 python3-pip python3-setuptools python3-dnspython python-dev-is-python3
sudo apt -y install software-properties-common nmap npm parallel ruby-full rename findutils
sudo apt -y install libpcap-dev libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev libgmp-dev zlib1g-dev libssl-dev libffi-dev libldns-dev
sudo apt -y install jq git chromium-bsu


#\\\\\\ installing tools //////#
scrclr
printf "${magenta}[*] Installing tools ${reset}\n" | pv -qL 23
sleep 2
install_by_check() {
    local cmd="$1"
    local install_command="$2"
    if ! command -v "$cmd" &>/dev/null; then
        echo "Installing $cmd..."
        eval "$install_command"
    else
        echo "$cmd is already installed at $(command -v "$cmd")"
    fi
}

# Basics
echo "Checking and installing basic tools..."
install_by_check "uro" "pip3 install uro"
install_by_check "pipx" "pip3 install pipx"
install_by_check "urless" "pip3 install urless"
install_by_check "anew" "go install -v github.com/tomnomnom/anew@latest"

# Subdomains
echo "Checking and installing subdomain tools..."
install_by_check "bbot" "pip3 install bbot"
install_by_check "knock" "pip3 install git+https://github.com/guelfoweb/knock.git"
install_by_check "assetfinder" "go install github.com/tomnomnom/assetfinder@latest"
install_by_check "amass" "go install -v github.com/owasp-amass/amass/v4/...@master"

# Findomain
echo "Checking and installing findomain..."
if ! command -v findomain &>/dev/null; then
    echo "Installing findomain..."
    curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux.zip
    unzip findomain-linux.zip
    chmod +x findomain
    sudo mv findomain /usr/bin/findomain
    rm findomain-linux.zip
else
    echo "findomain is already installed at $(command -v findomain)"
fi

# Subdominator
echo "Checking and installing Subdominator..."
if ! pipx list | grep -q "subdominator"; then
    echo "Installing Subdominator..."
    pipx install git+https://github.com/RevoltSecurities/Subdominator
else
    echo "Subdominator is already installed."
fi

# ShrewdEye
echo "Checking and installing ShrewdEye..."
if [ ! -d "shrewdeye-bash" ]; then
    git clone https://github.com/tess-ss/shrewdeye-bash.git
    cd shrewdeye-bash
    chmod +x shrewdeye.sh
    cd ..
else
    echo "ShrewdEye is already installed."
fi

# DNS Validator
echo "Checking and installing DNSValidator..."
if [ ! -d "dnsvalidator" ]; then
    git clone https://github.com/vortexau/dnsvalidator.git
    cd dnsvalidator
    pip3 install -r requirements.txt
    python3 setup.py install
    cd ..
else
    echo "DNSValidator is already installed."
fi

# PureDNS
install_by_check "puredns" "go install github.com/d3mondev/puredns/v2@latest"
# CF-Check
install_by_check "cf-check" "go install github.com/dwisiswant0/cf-check@latest"
# MassDNS
echo "Checking and installing MassDNS..."
if [ ! -d "massdns" ]; then
    git clone https://github.com/blechschmidt/massdns.git
    cd massdns
    sudo make
    sudo make install
    cd ..
else
    echo "MassDNS is already installed."
fi

#chrome
if ! command -v google-chrome &> /dev/null; then
    echo "Google Chrome is not installed. Installing now..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
    rm google-chrome-stable_current_amd64.deb
else
    echo "Chrome is already installed."
fi


#urls
echo "Checking and installing additional tools..."
install_by_check "waymore" "pip3 install waymore"
install_by_check "xnLinkFinder" "pip3 install xnLinkFinder"
install_by_check "getJS" "go install github.com/003random/getJS/v2@latest"
install_by_check "hakrawler" "go install github.com/hakluke/hakrawler@latest"
install_by_check "gospider" "go install github.com/jaeles-project/gospider@latest"
install_by_check "katana" "go install github.com/projectdiscovery/katana/cmd/katana@latest"
install_by_check "httpx" "go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest"
install_by_check "naabu" "go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
install_by_check "cf-check" "go install github.com/dwisiswant0/cf-check@latest"

# ParamSpider
echo "Checking and installing ParamSpider..."
if [ ! -d "ParamSpider" ]; then
    git clone https://github.com/0xKayala/ParamSpider.git
    cd ParamSpider
    pip3 install -r requirements.txt
    cd ..
else
    echo "ParamSpider is already installed."
fi

# Nuclei
install_by_check "nuclei" "go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
nuclei -ut
# TruffleHog
echo "Checking and installing TruffleHog..."
if ! command -v trufflehog &>/dev/null; then
    echo "Installing TruffleHog..."
    curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sudo sh -s -- -b /usr/local/bin
else
    echo "TruffleHog is already installed at $(command -v trufflehog)"
fi

# Updating Go tools
echo "Updating Go tools..."
~/go/bin/httpx -up
nuclei -up
katana -up

#\\\\\\\\\\ wordlists /////////#
scrclr
mkdir "wordlists" && cd "wordlists"
# Function to download a wordlist if it doesn’t exist
downoad_bycheck() {
    local file_name=$1
    local url=$2

    if [[ -f "$file_name" ]]; then
        echo "$file_name already exists at $(realpath "$file_name")"
    else
        echo "Downloading $file_name..."
        wget -O "$file_name" "$url"
    fi
}

# Display message
printf "${magenta}[*] Checking and downloading important wordlists if not found${reset}\n" | pv -qL 23
# Wordlist URLs
downoad_bycheck "trickest-resolvers.txt" "https://raw.githubusercontent.com/trickest/resolvers/refs/heads/main/resolvers.txt"
downoad_bycheck "six2dez.txt" "https://gist.githubusercontent.com/six2dez/a307a04a222fab5a57466c51e1569acf/raw"
downoad_bycheck "n0kovo-huge-subdomains.txt" "https://raw.githubusercontent.com/n0kovo/n0kovo_subdomains/refs/heads/main/n0kovo_subdomains_huge.txt"
downoad_bycheck "dnscan-top10k.txt" "https://raw.githubusercontent.com/rbsec/dnscan/refs/heads/master/subdomains-10000.txt"
downoad_bycheck "best-dns-wordlist.txt" "https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt"
downoad_bycheck "assetfinder-httparchive-subdomains.txt" "https://wordlists-cdn.assetnote.io/data/automated/httparchive_subdomains_2024_05_28.txt"

# create if  DNS files if  don’t exist
echo "Creating  DNS files..."
if [[ ! -f dns.txt ]]; then
    cat best-dns-wordlist.txt six2dez.txt dnscan-top10k.txt | anew dns.txt
    echo "dns.txt contains best-dns-wordlist.txt, six2dez.txt, and dnscan-top10k.txt in it." >> readme
fi

if [[ ! -f dns2.txt ]]; then
    cat six2dez.txt dnscan-top10k.txt | anew dns2.txt
    echo "dns2.txt contains six2dez.txt and dnscan-top10k.txt in it." >> readme
fi

rm -f best-dns-wordlist.txt six2dez.txt dnscan-top10k.txt

# Amass and Waymore config files
echo "Downloading Amass and Waymore config files if not present..."
mkdir -p "$HOME/anveshan/.config/amass"
mkdir -p "$HOME/anveshan/.config/waymore"

downoad_bycheck "$HOME/anveshan/.config/amass/datasources.yaml" "https://raw.githubusercontent.com/owasp-amass/amass/refs/heads/master/examples/datasources.yaml"
downoad_bycheck "$HOME/anveshan/.config/amass/config.yaml" "https://raw.githubusercontent.com/owasp-amass/amass/refs/heads/master/examples/config.yaml"
downoad_bycheck "$HOME/anveshan/.config/waymore/config.yml" "https://raw.githubusercontent.com/xnl-h4ck3r/waymore/refs/heads/main/config.yml"

# Fresh resolvers
scrclr
printf "${magenta}[*] Getting fresh resolvers for 120 seconds if not already fetched${reset}\n" | pv -qL 23

if [[ ! -f resolvers.txt ]]; then
    timeout 120 dnsvalidator -tL trickest-resolvers.txt -threads 25 -o resolvers.txt
    printf "${yellow}[$] Got $(wc -l < resolvers.txt) fresh resolvers${reset}\n" | pv -qL 23
else
    echo "Resolvers file already exists at $(realpath resolvers.txt)"
fi

cd ../
sleep 2
#\\\\\\\\\ screen clear ///////#
scrclr
printf "${magenta}You need to add API Keys for [AMASS] [BBOT] [SUBDOMINATOR] in these config files${reset}\n"
printf "${yellow}amass: $HOME/anveshan/.config/amass/datasources.yaml${reset}\n"
printf "${yellow}bbot: $HOME/.config/bbot/secrets.yml${reset}\n"
printf "${yellow}subdominator: $HOME/.config/Subdominator/provider-config.yaml${reset}\n"
echo
printf "${magenta}Also add VIRUSTOTAL and URLSCAN API Keys in waymore config file to get more urls.${reset}\n"
printf "${yellow}waymore: $HOME/anveshan/.config/waymore/config.yml${reset}\n"
echo
read -p "${red}You want to open these files in notepad? [Y/n] ${reset} " apianswer
if [[ "$apianswer" == [Yy] ]]; then
        if command -v notepad &> /dev/null; then
        editor="notepad"
    elif command -v nano &> /dev/null; then
        editor="nano"
    elif command -v vim &> /dev/null; then
        editor="vim"
    elif command -v gedit &> /dev/null; then
        editor="gedit"
    else
        printf "${red}No  text editor found. Please use notepad, nano, vim, or gedit.${reset}\n"
        exit 1
    fi
    $editor "$HOME/anveshan/.config/amass/datasources.yaml" \
            "$HOME/.config/bbot/secrets.yml" \
            "$HOME/.config/Subdominator/provider-config.yaml" \
            "$HOME/anveshan/.config/waymore/config.yml"
else
    :
fi

echo
printf "${red} script : setup.sh executed succesfully. ${reset}\n"
printf "${yellow} check 'cd $HOME/anveshan' folder.${reset}\n"
printf "${red} [&] Happy Hacking ;D${reset}\n"

#deactivating the python virtual envirnment
deactivate

#iti
