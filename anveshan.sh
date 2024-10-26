#!/bin/bash
# shree_hari

# Basic recon script
# Usecase : Finding subdomains, urls, js files, parameters

# Current version
current_version="v1.0.0"

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
echo -e "${green}       ,                                             ${reset}"
echo -e "${green}      ███▓▄,,▄▄▄▓█████▓▄▄,                           ${reset}"
echo -e "${green}      ██████████▀ \`█████████▌_                      ${reset}"
echo -e "${green}       █████████    ███████████                      ${reset}"
echo -e "${green}         \"▀▀▀▀\`     ████████████                   ${reset}"
echo -e "${green}       ,,▄▄,,__    ▄████████████                     ${reset}"
echo -e "${green}    ▄███████████████████████████                     ${reset}"
echo -e "${green}   ████████████${red}φ▓▓▓▓▓╚${green}██████████       ${reset}"
echo -e "${green}   ███████████${red}╫       ╫${green}█████████       ${reset}"
echo -e "${green}   ╫██████████${red}▒      ,▓${green}█████████▌      ${reset}"
echo -e "${green}    ▀████████ ${red}╬█▄▄╔╔φ${green}████████████      ${reset}"
echo -e "${green}      ▀█████${red}╬█${green}████████████████████     ${reset}"
echo -e "${green}          ${red}╙▀${green}▀▀▀▀▀▀\`\@hackersthan/█▀  ${red}${current_version}   ${reset}"
}

logo


# check for latest version
check_for_updates() {
    echo -e "${yellow}Checking for updates...${reset}"

    local latest_file_version
    latest_file_version=$(curl -s https://raw.githubusercontent.com/hackersthan/anveshan/refs/heads/main/anveshan.sh | grep 'current_version' | cut -d '=' -f2 | tr -d ' "')

    # Compare versions
    if [ "$latest_file_version" != "$current_version" ]; then
        if printf '%s\n' "$latest_file_version" "$current_version" | sort -V | head -n1 | grep -q "$current_version"; then
            echo -e "${red}A newer version ($latest_file_version) is available!${reset}"
            read -p "${red}Would you like to update? [y/n]: ${reset}" update_choice
            if [[ "$update_choice" == [Yy] ]]; then
                curl -o "$0" https://raw.githubusercontent.com/hackersthan/anveshan/refs/heads/main/anveshan.sh
                echo -e "${green}Updated to version $latest_file_version. Please re-run the script.${reset}"
                exit 0
            else
                echo -e "${yellow}Proceeding with the current version.${reset}"
            fi
        fi
    else
        echo -e "${green}You are using the latest version: $current_version${reset}"
    fi
}

check_for_updates


# screen clear
scrclr() {
        clear && logo && echo
}

#adding help section
if [[ $1 == "--help" ]] | [[ $1 == "-h" ]]; then
    echo "Usage:"
    echo "${green}  bash anveshan.sh${reset}"
    echo "Options:"
    echo "${green}  --help  Show this help message${reset}"
    exit 0
fi


# wordlist for DNS Brute-Forcing
choose_wordlist() {
    printf "${magenta}Select a wordlist for DNS Brute-Forcing:${reset}\n"
    printf "${yellow}1) dns.txt  [best-dns-wordlist ++]     [Size: 9M,   Takes longer time]${reset}\n"
    printf "${yellow}2) dns2.txt [six2dez + dnscan-top10k]  [Size: 112K, Takes less time]${reset}\n"
    read -p "${green}Enter your choice [1/2]: ${reset}" choice

    case $choice in
        1)
            wordlist="$HOME/anveshan/wordlists/dns.txt"
            ;;
        2)
            wordlist="$HOME/anveshan/wordlists/dns2.txt"
            ;;
        *)
            printf "${red}Invalid choice. Exiting.${reset}\n"
            exit 1
            ;;
    esac

    printf "${green}Using wordlist: $wordlist${reset}\n"
}


# reading domain name
read -p "${magenta}Enter target domain name [ex. target.com] : ${reset}" domain
echo ""

if [[ -d "$domain-recon" ]]
then
        cd "$domain-recon"
else
        mkdir "$domain-recon" && cd "$domain-recon"
fi


# choosing wordlist
choose_wordlist
scrclr


# Activating the virtual python environment
VENV_PATH="$HOME/anveshan/venv"

if [[ -d "$VENV_PATH" ]]; then
    source "$VENV_PATH/bin/activate"
    echo "Virtual environment activated."
else
    echo "Virtual environment not found. Please run setup_linux.sh first."
    exit 1
fi




#=====================================#
#=============SUBDOMAINS==============#
#=====================================#


#\\\\\\\\\\\\ subdominator ///////////#
printf "${magenta}[+] running subdominator...${reset}\n" | pv -qL 23
subdominator -d $domain -o subdominator.txt
echo


#\\\\\\\\\\\\\\\ amass ///////////////#
printf "${magenta}[+] running amass ...${reset}\n" | pv -qL 23
timeout 1200 amass enum -passive -d $domain -norecursive -nocolor -config $HOME/anveshan/.config/amass/datasources.yaml -o amassP
timeout 1200 amass enum -active -d $domain -nocolor -config $HOME/anveshan/.config/amass/datasources.yaml -o amassA
cat amassP amassA | cut -d " " -f1 | grep "$domain" | anew amass.txt
echo


#\\\\\\\\\\\\\\\ knock ///////////////#
printf "${magenta}[+] running knock${reset}\n" | pv -qL 23
mkdir knockpy/
knockpy -d $domain --recon --save knockpy
cat knockpy/*.json  | grep '"domain"' | cut -d '"' -f4 | anew knockpy.txt
echo


#\\\\\\\\\\\\\ findomain /////////////#
printf "${magenta}[+] running findomain${reset}\n" | pv -qL 23
findomain -t $domain -u findomain.txt
echo


#\\\\\\\\\\\\ assetfinder ////////////#
printf "${magenta}[+] running assetfinder${reset}\n" | pv -qL 23
assetfinder -subs-only $domain | anew assetfinder.txt
echo


#\\\\\\\\\\\\\\\ bbot ////////////////#
printf "${magenta}[+] running bbot${reset}\n" | pv -qL 23
sudo bbot -t $domain -f subdomain-enum  -rf passive -o output -n bbot -y
cp output/bbot/subdomains.txt bbot.txt
echo


#\\\\\\\\\\\\\ shrewdeye /////////////#
printf "${magenta}[+] running shrewdeye${reset}\n" | pv -qL 23
bash $HOME/anveshan/shrewdeye-bash/shrewdeye.sh -d $domain
echo

#\\\\\\\\\\\\\\ combine //////////////#
printf "${yellow}[*] combine all the result${reset}\n" | pv -qL 23
sed "s/\x1B\[[0-9;]*[mK]//g" *.txt | sed 's/\*\.//g' | anew psubdomains.txt



#\\\\\\\\\\\\ screen clear ///////////#
scrclr
printf "${yellow}[+] dns bruteforce${reset}\n" | pv -qL 23
puredns bruteforce "$wordlist" $domain -r $HOME/anveshan/wordlists/resolvers.txt -w bruteforce.txt
echo 

printf "${yellow}[+] resolving subdomains${reset}\n" | pv -qL 23
cat psubdomains.txt bruteforce.txt | anew lets-resolve.txt
puredns resolve lets-resolve.txt -r $HOME/anveshan/wordlists/resolvers.txt -w resolved.txt
cat resolved.txt | anew subdomains.txt
echo "$domain" | anew subdomains.txt

#\\\\\\\\\\\\\\ cleanup //////////////#
mkdir subs-source/
mv subdominator.txt subs-source/
mv amass.txt subs-source/
mv amassA subs-source/
mv amassP subs-source/
mv knockpy subs-source/
mv knockpy.txt subs-source/
mv findomain.txt subs-source/
mv assetfinder.txt subs-source
mv bbot.txt subs-source/
mv output/ subs-source/bbot-output/
mv *output.txt subs-source/
rm lets-resolve.txt
rm resolved.txt
rm bruteforce.txt


#\\\\\\\\\\\\ screen clear ///////////#
scrclr
printf "${yellow}[$] Found $(cat subdomains.txt | wc -l) subdomains${reset}\n" | pv -qL 23
sleep 2 && echo

#\\\\\\\\\\\\\\\ httpx ///////////////#
printf "${magenta}[*] getting webdomains using httpx ${reset}\n" | pv -qL 23
$HOME/go/bin/httpx -l subdomains.txt -ss -pa -sc -fr -title -td -location -retries 3 -silent -nc -o httpx.txt
cat httpx.txt | cut -d " " -f1 | anew webdomains.txt
mv output/ screenshots/

#\\\\\\\\\\\\\\\\ ips ////////////////#
cat httpx.txt | grep -E -o '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | anew ips.txt
cat subs-source/knockpy/*.json | jq '.[] .ip[]' | cut -d '"' -f2 | anew ips.txt


#\\\\\\\\\\\\ screen clear ///////////#
scrclr
printf "${yellow}[$] Found $(cat subdomains.txt | wc -l) subdomains${reset}\n" | pv -qL 23
printf "${yellow}[$] Found $(cat webdomains.txt | wc -l) webdomains${reset}\n" | pv -qL 23
sleep 3 && echo

#\\\\\\\\\\\\ port scanning //////////#
printf "${magenta}[+] port scanning using naabu : top 1000 ports ${reset}\n" | pv -qL 23
naabu -list subdomains.txt -tp 1000 -rate 2000 -o naabu.txt
#cat ips.txt | cf-check | naabu -tp 1000 -rate 2000 -o naabu-ip.txt
echo && echo
printf "${yellow}[$] Found $(cat naabu.txt | wc -l) open web_ports${reset}\n" | pv -qL 23
#printf "${yellow}[$] Found $(cat naabu-ip.txt | wc -l) open ports on IPs${reset}\n" | pv -qL 23
sleep 3



#=====================================#
#================URLS=================#
#=====================================#

#\\\\\\\\\\\\ screen clear ///////////#
scrclr

printf "${magenta}[*] finding urls ${reset}\n" | pv -qL 23
mkdir urls/ && cd urls/

printf "${yellow} [+] waymore ${reset}\n" | pv -qL 23
waymore -i $domain -mode U -c $HOME/anveshan/.config/waymore/config.yml -oU waymore.txt

printf "${yellow} [+] getJS ${reset}\n" | pv -qL 23
getJS --input ../webdomains.txt --output getjs.txt --complete

printf "${yellow} [+] xnlinkfinder ${reset}\n" | pv -qL 23
xnLinkFinder -i waymore.txt -d 3 -sf $domain -o xnUrls.txt -op xnParams.txt

printf "${yellow} [+] finding parameters ${reset}\n" | pv -qL 23
python3 $HOME/anveshan/tools/ParamSpider/paramspider.py --domain $domain --level high | uro | anew parameters.txt

printf "${yellow} [+] Katan for js files ${reset}\n" | pv -qL 23
katana -list ../webdomains.txt -jc -em js,json,jsp,jsx,ts,tsx,mjs -d 3 -nc -o katana.txt

# combine
sed "s/\x1B\[[0-9;]*[mK]//g" waymore.txt getjs.txt xnUrls.txt parameters.txt katana.txt | anew urls.txt
mkdir urls-source/
mv waymore.txt urls-source/
mv getjs.txt urls-source/
mv xnUrls.txt urls-source/
mv katana.txt urls-source/



#=====================================#
#=================JS==================#
#=====================================#


#\\\\\\\\\\\\ screen clear ///////////#
scrclr

printf "${magenta}[*] extracting js files and finding secrets ${reset}\n" | pv -qL 23
cat urls.txt | grep -Ei ".+\.js(?:on|p|x)?$" | $HOME/go/bin/httpx -mc 200 | anew jsurls.txt

#\\\\\\\\getting live js files////////#
$HOME/go/bin/httpx -l jsurls.txt -sr -sc -mc 200 -ct -nc | grep -v "text/html" | cut -d " " -f1 | anew jsfiles.txt
mv output/ js-source/

#\\\\\\\nuclei on live js files///////#
scrclr
printf "${magenta}[*] finding secrets inside $(cat jsfiles.txt | wc -l) js files${reset}\n" | pv -qL 23
cat jsfiles.txt | nuclei -t $HOME/nuclei-templates/http/exposures/tokens/ | tee -a js_nuclei.txt
mv js_nuclei.txt ../


#\\\\\\\trufflehog on source code/////#
printf "${magenta}[*] trufflehog scanning on webdomains source${reset}\n" | pv -qL 30
trufflehog filesystem js-source/response | tee -a trufflehog-src.txt
mv trufflehog-src.txt ../ && cd ../




#=====================================#
#==============HIGHLIGHT==============#
#=====================================#
scrclr
logo
printf "${magenta}[*] script executed successfully, here are the key highlights${reset}\n" | pv -qL 23
echo
printf "${red} [+] Subdomains${reset}\n" | pv -qL 23
printf "${yellow} [$] Found %d subdomains${reset}\n" "$(cat subdomains.txt | wc -l)" | pv -qL 23
printf "${yellow} [$] Found %d webdomains${reset}\n" "$(cat webdomains.txt | wc -l)" | pv -qL 23
echo
printf "${red} [+] Ports${reset}\n" | pv -qL 23
printf "${yellow} [$] Found %d open web_ports${reset}\n" "$(cat naabu.txt | wc -l)" | pv -qL 23
echo
printf "${red} [+] URLs${reset}\n" | pv -qL 23
printf "${yellow} [$] Found %d urls${reset}\n" "$(cat urls/urls.txt | wc -l)" | pv -qL 23
echo
printf "${red} [+] Scanning${reset}\n" | pv -qL 23
printf "${yellow} [$] Found %d nuclei secrets in %d js files${reset}\n" "$(cat js_nuclei.txt | wc -l)" "$(cat urls/jsfiles.txt | wc -l)" | pv -qL 23
printf "${yellow} [$] Found %d trufflehog secrets in js files source code${reset}\n" "$(cat trufflehog-src.txt | grep -i "raw" | wc -l)" | pv -qL 23
echo
printf "${red} [&] Happy Hacking ;D${reset}\n" | pv -qL 23

# iti
