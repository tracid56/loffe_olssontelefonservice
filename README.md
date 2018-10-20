# Olsson telefonservice
Ett script som låter ett speciellt jobb sälja telefoner

### KRAV

 - [pNotify](https://github.com/Nick78111/pNotify) krävs för notifikationer
  
 - esx

### Config

   - ```local phoneName = 'esx_phone3'``` ändra till namnet du har för item på telefonen, server.lua
   - ```local price = 250``` pris att köpa in en ny telefon, server.lua
   
   - gå in i client.lua så ser du vad du ska ändra. ~rad 40, 165 & 268. Vet du inte vad du ska ändra, ändra inte

### Installation

 - Ladda ner alla scripts under krav

 - Lägg in alla scripten i din resources mapp
 
 - Kör sql filen
 
 - För att sätta dig själv som jobbet, skriv /setjob id olsson 0-3
 
 - Gå in i server.cfg och skriv ```start loffe_olssontelefonservice```
