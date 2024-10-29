#!/bin/bash
# shree_hari
# Usecase : setup your device to run anveshan without any errors.
# Usage: Run `bash setup_linux.sh`.
# Logs: Logs actions and errors to setup_log.txt

# Current version
current_version="v1.1.0"

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
    echo -e "${green}           ${red}╙▀${green}▀▀▀▀▀▀\`\@hackersthan/█▀  setup_version : ${current_version}   ${reset}"
}

# log file to check errors
log_file="setup_log.txt"
exec > >(tee -a "$log_file") 2>&1

logo

# check for latest version
check_for_updates() {
    echo -e "${yellow}Checking for updates...${reset}"

    local latest_file_version
    latest_file_version=$(curl -s https://raw.githubusercontent.com/hackersthan/anveshan/main/setup_linux.sh | grep 'current_version' | cut -d '=' -f2 | tr -d ' "')

    # Compare versions
    if [ "$latest_file_version" != "$current_version" ]; then
        if printf '%s\n' "$latest_file_version" "$current_version" | sort -V | head -n1 | grep -q "$current_version"; then
            echo -e "${red}A newer version ($latest_file_version) is available!${reset}"
            read -p "${red}Would you like to update? [y/n]: ${reset}" update_choice
            if [[ "$update_choice" == [Yy] ]]; then
                curl -o "$0" https://raw.githubusercontent.com/hackersthan/anveshan/main/setup_linux.sh
                echo -e "${green}Updated to version $latest_file_version. Please re-run the script.${reset}"
                exit 0
            else
                echo -e "${yellow}Proceeding with the current version.${reset}"
            fi
        else
            echo -e "${green}You are using the latest version: $current_version${reset}"
            echo
        fi
    else
        echo -e "${green}You are using the latest version: $current_version${reset}"
        echo
    fi
}

check_for_updates

# screen clear
scrclr() {
    clear && logo && echo
}

#adding help section
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage:"
    echo -e "${green}  bash setup_linux.sh${reset}"
    echo "Options:"
    echo -e "${green}  --help  Show this help message${reset}"
    exit 0
fi

#* run with sudo
if [ "$(whoami)" != 'root' ]; then

    printf "${red}[!] Manually enter your password when asked.${reset}\n"
fi

# function to check golang installed or not
if ! command -v go &>/dev/null; then
    printf "${red}[!] GO language is not installed. Installing via apt.${reset}\n"
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt install golang-go
else
    echo "[*] golang is already installed."
fi

#check GOPATH abd GOROOT
if [ -f ~/.bashrc ]; then
    if ! grep -q "export GOPATH=" ~/.bashrc && ! grep -q "export GOROOT=" ~/.bashrc; then
        echo "export GOROOT=/usr/local/go" >>~/.bashrc
        echo "export GOPATH=\$HOME/go" >>~/.bashrc
        echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >>~/.bashrc
    fi
    source ~/.bashrc
elif [ -f ~/.zshrc ]; then
    if ! grep -q "export GOPATH=" ~/.zshrc && ! grep -q "export GOROOT=" ~/.zshrc; then
        echo "export GOROOT=/usr/local/go" >>~/.zshrc
        echo "export GOPATH=\$HOME/go" >>~/.zshrc
        echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >>~/.zshrc
    fi
    source ~/.zshrc
else
    echo "~/.bashrc or ~/.zshrc not found"
fi

# creating anveshan directory
if [[ -d $HOME/anveshan ]]; then
    cd "$HOME/anveshan"
else
    mkdir "$HOME/anveshan" && cd "$HOME/anveshan"
fi

# Creating a virtual python environment
sudo apt install -y python3 python3-pip python3-venv || {
    echo "Failed to install python3-venv. Exiting."
    exit 1
}
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
printf "${green}[*] apt update, upgrade and basic tools${reset}\n"
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

#basics
pip3 install uro pipx urless $bsp
go install -v github.com/tomnomnom/anew@latest

#subdomains
pip3 install bbot git+https://github.com/guelfoweb/knock.git $bsp
go install github.com/tomnomnom/assetfinder@latest
go install -v github.com/owasp-amass/amass/v4/...@master

#findomain
if ! command -v findomain &>/dev/null; then
    curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux.zip
    unzip findomain-linux.zip
    chmod +x findomain
    sudo mv findomain /usr/bin/findomain
else
    echo "[*] findomain is already installed."
fi

#subdomainator
pipx install git+https://github.com/RevoltSecurities/Subdominator

#shrewdeye
if [ ! -d "shrewdeye-bash" ]; then
    git clone https://github.com/tess-ss/shrewdeye-bash.git
    cd shrewdeye-bash
    chmod +x shrewdeye.sh
    cd ../
else
    echo -e "${red}[*] shrewdeye already installed ${reset}"
fi

#dnsvalidator
if ! command -v dnsvalidator &>/dev/null; then
    git clone https://github.com/vortexau/dnsvalidator.git
    cd dnsvalidator
    pip3 install -r requirements.txt $bsp
    python3 setup.py install
    cd ../
else
    echo -e "${red}[*] dnsvalidator is already installed ${reset}"
fi

#puredns
go install github.com/d3mondev/puredns/v2@latest
#cf-check
go install github.com/dwisiswant0/cf-check@latest

#massdns
if ! command -v massdns &>/dev/null; then
    git clone https://github.com/blechschmidt/massdns.git
    cd massdns
    sudo make
    sudo make install
    cd ../
else
    echo -e "${red}[*] massdns is already installed.${reset}"
fi

#chrome
if ! command -v google-chrome &>/dev/null; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
    rm google-chrome-stable_current_amd64.deb
else
    echo "[*] Chrome is already installed."
fi

#urls
pip3 install waymore $bsp
pip3 install xnLinkFinder $bsp
go install github.com/003random/getJS/v2@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/jaeles-project/gospider@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/dwisiswant0/cf-check@latest

#paramspider
if [ ! -d "ParamSpider" ]; then
    git clone https://github.com/0xKayala/ParamSpider.git
    cd ParamSpider
    pip3 install -r requirements.txt $bsp
    cd ../
else
    echo -e "${red}[*] ParamSpider already installed ${reset}"
fi

#nuclei
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
nuclei -ut
#trufflehog
if ! command -v google-chrome &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sudo sh -s -- -b /usr/local/bin
else
    echo "[*] trufflehog is already installed."
fi

#updating some golang tools
~/go/bin/httpx -up
nuclei -up
katana -up

#\\\\\\\\\\ wordlists /////////#
scrclr
mkdir "wordlists" && cd "wordlists"

# Download wordlists if they don't exist
download_ifnotexist() {
    local file="$1"
    local url="$2"

    if [ ! -f "$file" ]; then
        echo -e "${green}[+] Downloading $file ${reset}"
        wget -q -O "$file" "$url"
    else
        echo -e "${red}[*] $file already exists, skipping download. ${reset}"
    fi
}

download_ifnotexist "trickest-resolvers.txt" "https://raw.githubusercontent.com/trickest/resolvers/refs/heads/main/resolvers.txt"
download_ifnotexist "six2dez.txt" "https://gist.githubusercontent.com/six2dez/a307a04a222fab5a57466c51e1569acf/raw"
download_ifnotexist "n0kovo-huge-subdomains.txt" "https://raw.githubusercontent.com/n0kovo/n0kovo_subdomains/refs/heads/main/n0kovo_subdomains_huge.txt"
download_ifnotexist "dnscan-top10k.txt" "https://raw.githubusercontent.com/rbsec/dnscan/refs/heads/master/subdomains-10000.txt"
download_ifnotexist "best-dns-wordlist.txt" "https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt"
download_ifnotexist "assetfinder-httparchive-subdomains.txt" "https://wordlists-cdn.assetnote.io/data/automated/httparchive_subdomains_2024_05_28.txt"

# Create DNS files if they don't exist
if [ ! -f "dns.txt" ]; then
    echo -e "${green} [*] Creating dns.txt ${reset}"
    cat best-dns-wordlist.txt six2dez.txt dnscan-top10k.txt | anew dns.txt
else
    echo -e "${red}[*] dns.txt already exists, skipping download. ${reset}"
fi

if [ ! -f "dns2.txt" ]; then
    echo -e "${green} [*] Creating dns2.txt ${reset}"
    cat six2dez.txt dnscan-top10k.txt | anew dns2.txt
else
    echo -e "${red}[*] dns2.txt already exists, skipping download. ${reset}"
fi

# save
echo "dns.txt contains best-dns-wordlist.txt, six2dez.txt, and dnscan-top10k.txt." >>readme
echo "dns2.txt contains six2dez.txt and dnscan-top10k.txt." >>readme
rm -f best-dns-wordlist.txt six2dez.txt dnscan-top10k.txt

#\\ downloading config files //#
AMASS_CONFIG_DIR="$HOME/anveshan/.config/amass"
WAYMORE_CONFIG_DIR="$HOME/anveshan/.config/waymore"

# Create directories if they don't exist
mkdir -p "$AMASS_CONFIG_DIR"
mkdir -p "$WAYMORE_CONFIG_DIR"

# Function to download configuration files if they don't exist
download_ifconfignotexist() {
    local configfile="$1"
    local configurl="$2"

    if [ ! -f "$configfile" ]; then
        echo -e "${green} [+] Downloading $(basename "$configfile") ${reset}"
        wget -q -O "$configfile" "$configurl"
    else
        echo -e "${red}[*] $(basename "$configfile") already exists, skipping download. ${reset}"
    fi
}

download_ifconfignotexist "$AMASS_CONFIG_DIR/datasources.yaml" "https://raw.githubusercontent.com/owasp-amass/amass/refs/heads/master/examples/datasources.yaml"
download_ifconfignotexist "$AMASS_CONFIG_DIR/config.yaml" "https://raw.githubusercontent.com/owasp-amass/amass/refs/heads/master/examples/config.yaml"
download_ifconfignotexist "$WAYMORE_CONFIG_DIR/config.yml" "https://raw.githubusercontent.com/xnl-h4ck3r/waymore/refs/heads/main/config.yml"

#\\\\\\ getting resolvers /////#
scrclr
printf "${magenta}[*] getting fresh resolvers in 120 seconds ${reset}\n" | pv -qL 23
timeout 120 dnsvalidator -tL trickest-resolvers.txt -threads 25 -o resolvers.txt
printf "${yellow}[$] we got $(cat resolvers.txt | wc -l) fresh resolvers${reset}\n" | pv -qL 23
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
    if command -v notepad &>/dev/null; then
        editor="notepad"
    elif command -v gedit &>/dev/null; then
        editor="gedit"
    elif command -v nano &>/dev/null; then
        editor="nano"
    else
        printf "${red}No text editor found. Please open these API config files manually.${reset}\n"
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
