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
if [ `whoami` != 'root' ];then
    printf "${red}[!] YOU ARE NOT ROOT${reset}\n"
    printf "${red}[!] Run with root OR manually enter password when asked.${reset}\n"
fi

# function to check golang installed or not
if ! command -v go &> /dev/null; then
    printf "${red}[!] GO language is not installed. Installing via apt.${reset}\n"
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt install golang-go
fi

# function to upgrade pip packages
echo -e "${magenta}You have %d outdated pip packages.${reset}" "$(pip3 list --outdated | grep \'[0-9\.[0-9]\' | wc -l)"
read -p "${yellow}Do you want to upgrade all of them? (y/n): ${reset}" answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    printf "${green}[*] Upgrading all pip packages${reset}\n"
    pip3 list --outdated | grep "[0-9\.[0-9]" | cut -d " " -f1 | xargs pip3 install --upgrade --break-system-packages
    pip3 list --outdated | grep "[0-9\.[0-9]" | cut -d " " -f1 | xargs pip3 install
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

# creating anveshan directory
if [[ -d $HOME/anveshan ]]
then
        cd "$HOME/anveshan"
else
        mkdir "$HOME/anveshan" && cd "$HOME/anveshan"
fi

#\\\\\\ installing tools //////#
scrclr
printf "${magenta}[*] Installing tools ${reset}\n" | pv -qL 23
sleep 2

#basics
pip3 install uro
pip3 install uro --break-system-packages
pip3 install pipx
pip3 install pipx --break-system-packages
pip3 install urless
pip3 install urless --break-system-packages
go install -v github.com/tomnomnom/anew@latest

#subdomains
pip3 install bbot
pip3 install bbot --break-system-packages
pip3 install git+https://github.com/guelfoweb/knock.git
pip3 install git+https://github.com/guelfoweb/knock.git --break-system-packages
go install github.com/tomnomnom/assetfinder@latest
go install -v github.com/owasp-amass/amass/v4/...@master

#findomain
curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux.zip
unzip findomain-linux.zip
chmod +x findomain
sudo mv findomain /usr/bin/findomain

#subdomainator
git clone https://github.com/RevoltSecurities/Subdominator.git
cd Subdominator
pip3 install -r requirements.txt
pip3 install -r requirements.txt --break-system-packages
python3 setup.py install
cd ../

#shrewdeye
git clone https://github.com/tess-ss/shrewdeye-bash.git
cd shrewdeye-bash
chmod +x shrewdeye.sh
cd ../


#dnsvalidator
git clone https://github.com/vortexau/dnsvalidator.git
cd dnsvalidator
pip3 install -r requirements.txt
pip3 install -r requirements.txt --break-system-packages
python3 setup.py install
cd ../

#puredns
go install github.com/d3mondev/puredns/v2@latest
#cf-check
go install github.com/dwisiswant0/cf-check@latest


#massdns
git clone https://github.com/blechschmidt/massdns.git
cd massdns
sudo make
sudo make install
cd ../

#chrome
sudo apt-get install libxss1 libappindicator1 libindicator7 -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome*.deb -y


#urls
pip3 install waymore
pip3 install xnLinkFinder
pip3 install waymore --break-system-packages
pip3 install xnLinkFinder --break-system-packages
go install github.com/003random/getJS/v2@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/jaeles-project/gospider@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/dwisiswant0/cf-check@latest


#paramspider
git clone https://github.com/0xKayala/ParamSpider.git
cd ParamSpider
pip3 install -r requirements.txt
pip3 install -r requirements.txt --break-system-packages
cd ../


#nuclei
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
nuclei -ut
#trufflehog
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sudo sh -s -- -b /usr/local/bin


#update go tools
httpx -up
nuclei -up
katana -up


#\\\\\\\\\\ wordlists /////////#
scrclr
mkdir "wordlists" && cd "wordlists"

printf "${magenta}[*] downloading important wordlists ${reset}\n" | pv -qL 23
wget -O trickest-resolvers.txt https://raw.githubusercontent.com/trickest/resolvers/refs/heads/main/resolvers.txt
wget -O six2dez.txt https://gist.githubusercontent.com/six2dez/a307a04a222fab5a57466c51e1569acf/raw
wget -O n0kovo-huge-subdomains.txt https://raw.githubusercontent.com/n0kovo/n0kovo_subdomains/refs/heads/main/n0kovo_subdomains_huge.txt
wget -O dnscan-top10k.txt https://raw.githubusercontent.com/rbsec/dnscan/refs/heads/master/subdomains-10000.txt
wget -O best-dns-wordlist.txt https://wordlists-cdn.assetnote.io/data/manual/best-dns-wordlist.txt
wget -O assetfinder-httparchive-subdomains.txt https://wordlists-cdn.assetnote.io/data/automated/httparchive_subdomains_2024_05_28.txt

#\\\\\ creating dns files /////#
cat best-dns-wordlist.txt six2dez.txt dnscan-top10k.txt | anew dns.txt
cat six2dez.txt dnscan-top10k.txt | anew dns2.txt

echo "dns.txt contains best-dns-wordlist.txt, six2dez.txt and dnscan-top10k.txt in it." >> readme
echo "dns2.txt contains six2dez.txt and dnscan-top10k.txt in it." >> readme
rm best-dns-wordlist.txt
rm six2dez.txt
rm dnscan-top10k.txt

#\\ downloading amass config //#
mkdir -p $HOME/.config/amass
wget -O ~/anveshan/.config/amass/datasources.yaml https://raw.githubusercontent.com/owasp-amass/amass/refs/heads/master/examples/datasources.yaml
wget -O ~/anveshan/.config/amass/config.yaml https://raw.githubusercontent.com/owasp-amass/amass/refs/heads/master/examples/config.yaml
wget -O ~/anveshan/.config/waymore/config.yml https://raw.githubusercontent.com/xnl-h4ck3r/waymore/refs/heads/main/config.yml


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
printf "${yellow}amass: ~/anveshan/.config/amass/config.yaml${reset}\n"
printf "${yellow}bbot: ~/.config/bbot/secrets.yml${reset}\n"
printf "${yellow}subdominator: ~/.config/Subdominator/provider-config.yaml${reset}\n"
echo
printf "${magenta}Also add VIRUSTOTAL and URLSCAN API Keys in waymore config file to get more urls.${reset}\n"
printf "${yellow}waymore: ~/anveshan/.config/waymore/config.yml${reset}\n"
echo
read -p "${red}You want to open these files in notepad? [y/n] ${reset} " apianswer
if [[ "$apianswer" == [Yy] ]]; then
        open ~/anveshan/.config/amass/config.yaml $HOME/.config/bbot/secrets.yml $HOME/.config/Subdominator/provider-config.yaml ~/anveshan/.config/waymore/config.yml
else
        :
fi

echo
printf "${red} script : setup.sh executed succesfully. ${reset}\n"
printf "${yellow} check 'cd $HOME/anveshan' folder to understand tools and files tree.${reset}\n"

#iti
