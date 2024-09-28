<h1 align="center">
  <a href="https://github.com/hackersthan/anveshan"><img src="https://raw.githubusercontent.com/hackersthan/anveshan/refs/heads/main/img/logo.jpg" alt="anveshan" height=250px></a>
  </h1>

anveshan is the all in one script for your recon process, It helps to find subdomains, urls, js files, parameters, screenshots, scan js files.

### Features :fire:
   - Finding subdomains from each service using tools [subdominator, bbot, amass etc.]
   - Filter live subdomains and capture screenshots
   - Finding URLs [waymore, getjs, xnlinkfinder, katana, paramspider]
   - Finding JS Files and scan them using nuclei and trufflehog


### Installation 📦
```bash
git clone https://github.com/hackersthan/anveshan.git
cd anveshan/
sudo bash setup_linux.sh
```


### Input 🧑🏻‍💻
```
~/$ bash anveshan.sh
       ,                                          
      ███▓▄,,▄▄▄▓█████▓▄▄,                        
      ██████████▀ `█████████▌_                   
       █████████    ███████████                   
         "▀▀▀▀`     ████████████                
       ,,▄▄,,__    ▄████████████                  
    ▄███████████████████████████                  
   ████████████φ▓▓▓▓▓╚██████████    
   ███████████╫       ╫█████████    
   ╫██████████▒      ,▓█████████▌   
    ▀████████ ╬█▄▄╔╔φ████████████   
      ▀█████╬█████████████████████  
          ╙▀▀▀▀▀▀▀`\@hackersthan/█▀

Enter target domain name [ex. target.com] : 
```

### Output :sound:
```bash
~/target.com-recon > tree
.
├── subs-source/
├── screenshots/
├── ips.txt
├── naabu.txt
├── subdomains.txt
├── httpx.txt
├── webdomains.txt
├── js_nuclei.txt
├── trufflehog-src.txt
├── urls/
    ├── urls-source/
    ├── js-files-sourcecode/
    ├── urls.txt
    ├── jsfiles.txt
    ├── xnParams.txt
    └── parameters.txt

8 directories, 33 files
```

<h1 align="left">
  <a href="https://github.com/hackersthan/anveshan"><img src="https://raw.githubusercontent.com/hackersthan/anveshan/refs/heads/main/img/flow.jpg" alt="flow" height=500px></a>
  </h1>
  
---

## Tools and Wordlists :flashlight:

|SUBDOMAINS  |URLS        |WORDLISTS             |SCANNERS  |
|------------|------------|----------------------|----------|
|subdominator|waymore     |six2dez.txt           |nuclei    |
|amass       |getjs       |dnscan-top10k.txt     |trufflehog|
|bbot        |xnlinkfinder|best-dns-wordlist.txt |          |
|knock       |paramspider |trickest-resolvers.txt|          |
|findomain   |katana      |                      |          |
|assetfinder |            |                      |          |
|shrewdeye   |            |                      |          |
|dnsvalidator|            |                      |          |
|puredns     |            |                      |          |
|httpx       |            |                      |          |

---

## APIs :art:
### You need to setup API Keys for these tools
```
amass        : ~/.config/amass/datasources.yaml
bbot         : ~/.config/bbot/secrets.yml
subdominator : ~/.config/Subdominator/provider-config.yaml
waymore      : ~/.config/waymore/config.yml
```

### DO NOT PUT API KEYS IN EVERY TOOL :pushpin:
`Here is a list of API Services with tool name, Please add API Key in the provided tool only.`  
`Give some of your hour to get all of these free api keys, trust me it is worth it.`
|SUBDOMINATOR|AMASS|BBOT|
|------------|-----|----|
|bevigil     |360PassiveDNS|hunterio|
|binaryedge  |ASNLookup|ip2location|
|bufferover  |Ahrefs|credshed|
|c99         |AlienVault|ipstack|
|censys      |BigDataCloud|dehashed|
|certspotter |BuiltWith|    |
|chaos       |CIRCL|    |
|dnsdumpster |CertCentral|    |
|facebook    |DNSDB|    |
|fofa        |DNSlytics|    |
|fullhunt    |DNSRepo|    |
|google      |Deepinfo|    |
|huntermap   |Detectify|    |
|intelx      |GitHub|    |
|leakix      |GitLab|    |
|netlas      |HackerTarget|    |
|quake       |IPdata|    |
|rapidapi    |IPinfo|    |
|redhuntlabs |ONYPHE|    |
|rsecloud    |Pastebin|    |
|virustotal  |PassiveTotal|    |
|securitytrails|PentestTools|    |
|shodan      |PublicWWW|    |
|whoisxmlapi |SOCRadar|    |
|zoomeyeapi  |Spamhaus|    |
|            |ThreatBook|    |
|            |URLScan|    |
|            |Yandex|    |
|            |ZETAlytics|    |

- **VirusTotal**: [VirusTotal](https://www.virustotal.com)
- **Chaos**: [Chaos](https://chaos.projectdiscovery.io)
- **Dnsdumpter**: [Dnsdumpster](https://dnsdumpster.com)
- **Whoisxml**: [WhoisXML](https://whois.whoisxmlapi.com)
- **SecurityTrails**: [SecurityTrails](https://securitytrails.com)
- **Bevigil**: [Bevigil](https://bevigil.com/)
- **Binaryedge**: [BinaryEdge](https://binaryedge.io)
- **Fullhunt**: [Fullhunt](https://fullhunt.io)
- **Rapidapi**: [RapidAPI](https://rapidapi.com)
- **Bufferover**: [Bufferover](https://tls.bufferover.run/)
- **Certspotter**: [Certspotter](https://sslmate.com/certspotter)
- **Censys**: [Censys](https://search.censys.io/)
- **Fullhunt**: [Fullhunt](https://fullhunt.io/)
- **Zoomeye**: [Zoomeye](https://www.zoomeye.org/)
- **Netlas**: [Netlas](https://netlas.io/)
- **Leakix**: [Leakix](https://leakix.net/)
- **Redhunt**: [Redhunt](https://devportal.redhuntlabs.com/) [PAID]
- **Shodan** : [Shodan](https://shodan.io)
- **Huntermap** : [Hunter](https://hunter.how/)
- **Google**: [Google](https://programmablesearchengine.google.com/controlpanel/create)
- **Facebook**: [Facebook](https://developers.facebook.com/)
- **Quake**: [Quake](https://quake.360.cn/)
- **RapidFinder**: [RapidFinder](https://rapidapi.com/Glavier/api/subdomain-finder3/pricing)
- **RapidScan**: [RapidScan](https://rapidapi.com/sedrakpc/api/subdomain-scan1/pricing)
- **Fofa**: [Fofa](https://en.fofa.info/)
- **CodeRog**: [CodeRog](https://rapidapi.com/coderog-coderog-default/api/subdomain-finder5/pricing)
- **C99**: [C99](https://subdomainfinder.c99.nl/) [PAID]
- **RSECloud**: [RSECloud](https://rsecloud.com/search)
- **Myssl**: [Myssl](https://myssl.com)
- **Racent**: [Racent](https://face.racent.com)
- **Intelx**: [Intelx](intelx.io)
- **IPData**: [IPData](https://ipdata.co)
- **Gitlab**: [Gitlab](https://about.gitlab.com)
- **Github**: [Github](https://github.com)
- **Onyphe**: [Onyphe](http://Onyphe.io)
- **Twitter**: [Twitter](https://twitter.com)
- **Alienvault**: [Alienvault](https://otx.alienvault.com)


#### Dnsdumpter and Google API Keys is tricky, here is the way to access it :

   - Dnsdumpter Setup:
      
     - Visit [Dnsdumpster](https://dnsdumpster.com)
     - Search any domain and view request using Burpsuite or Inspect tool.
     - Copy the `csrftoken from cookie header` and `csrfmiddlewaretoken from body` and paste in your yaml file like this
        ```
        dnsdumpster:
           - csrftoken:csrfmiddlewaretoken
        ```

      <h1 align="left">
        <img src="https://raw.githubusercontent.com/hackersthan/anveshan/refs/heads/main/img/dnsdumpsterAPI.png" width="500px">
        <br>
      </h1>

   - Google Setup:

     - Visit [here](https://programmablesearchengine.google.com/controlpanel/create) and create a search engine [choose all web option].
     - copy your `CX ID`
     - Create your google api key [here](https://developers.google.com/custom-search/v1/introduction)
     - Click `Get a Key` button and create a new project with any name you want
     - After creating and completing your api key is generated and press show key then copy it
     - Paste CX API and Google API Keys like this
     ```
        google:
           - CXID:GOOGLEAPIKEY
      ```

      <h1 align="left">
        <img src="https://raw.githubusercontent.com/hackersthan/anveshan/refs/heads/main/img/googleAPI.png" width="500px">
        <br>
     </h1>

---

### Credit 🙏🏻
  **Special thanks to the authers of these tools.
    They have worked very hard and dedicated a lot of their time, we should thank them.**
    
  - [subdominator](https://github.com/RevoltSecurities/Subdominator)
  - [bbot](https://github.com/blacklanternsecurity/bbot)
  - [amass](https://github.com/owasp-amass/amass)
  - [knock](https://github.com/guelfoweb/knock)
  - [findomain](https://github.com/Findomain/Findomain)
  - [assetfinder](https://github.com/tomnomnom/assetfinder)
  - [shrewdeye-bash (shrewdeye.app)](https://github.com/tess-ss/shrewdeye-bash)
  - [dnsvalidator](https://github.com/vortexau/dnsvalidator)
  - [trickest-resolvers](https://github.com/trickest/resolvers)
  - [puredns](https://github.com/d3mondev/puredns)
  - [httpx](https://github.com/projectdiscovery/httpx)
  - [waymore](https://github.com/xnl-h4ck3r/waymore)
  - [getjs](https://github.com/003random/getJS)
  - [xnlinkfinder](https://github.com/xnl-h4ck3r/xnLinkFinder)
  - [katana](https://github.com/projectdiscovery/katana)
  - [paramspider](https://github.com/0xKayala/ParamSpider)
  - [nuclei](https://github.com/projectdiscovery/nuclei)
  - [trufflehog](https://github.com/trufflesecurity/truffleHog)


### Issues 📬  
   Report issues [here](https://github.com/hackersthan/anveshan/issues).

  
### Disclaimer ❗️
  1. The User is solely responsible for the misuse or unlawful use of any Content. Hacking and cybersecurity laws vary by jurisdiction. By engaging with the Content, you agree to take full responsibility for your actions
  2. Some Content may include or link to third-party materials. The User agrees to respect all applicable intellectual property laws, including copyrights and trademarks, when engaging with this Content.
  3. Always read full script before runnnig it, Never run any script blindly.

❤️🇮🇳
