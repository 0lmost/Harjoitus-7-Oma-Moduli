**By Olmo Kosunen GPL 2.0**

**Alla oleva raportointi on suomeksi, mutta se käännetään myöhemmin myös englanniksi, jos moduli etenee "tuotantoon" asti**

**English version of this report coming soon**

**Tästä GitHub reposta löytyy, kaikki tiedotot joita moduuli käyttää**

# VideoEditPack - Beta state v.1.0

![image](https://user-images.githubusercontent.com/60943507/168652154-854af248-07e2-4f1e-9176-a723c4498be2.png)

**Lopputulos eli ohjelmien asennus onnistunut moduulin avulla**

                                                                                                
![image](https://user-images.githubusercontent.com/60943507/168652555-17a99538-08c6-403e-914a-92b55b75d220.png)

https://www.youtube.com/watch?v=rWjIpZxOqks&t=4s&ab_channel=Based%26Kino 

Moduulin avulla voisi vaikka editoida yllä olevan lyhytelokuvan, koska sen tekoon käytettiin moduulissa olevia sovelluksia!

Mitä moduulilla voi siis tehdä? 

**Editoida ja katsoa videoita, valmiiksi konffatut lempiasetukset sovelluksiin* 

*Asetukset eivät toimi vielä*

## Projekti ja sen käyttöönotto:

Päätin luoda moduulin, joka sisältää hyväksi todettuja videoeditointiin ja videoon liittyiä softia linuxille (Debian 11). 
Tarkoituksena on myös konffata softiin omat lempiasetukset kuten laittaa projektien fps ja resoluutio kamerani asetuksiin sopiviksi.

Softat, jotka asennan ja konffaan: Blender, Kdenlive, VLC. 

Moduuliin oli tarkoitus tulla mukaan myös DaVinci Resolve, mutta sillä ei ollut virallista tukea Debianille, joten jätin sen säätämisen tulevaisuuteen samoin Lightworksin jätin pois ja lisään sen jos kerkeän.

Aloitin luomalla masterille kansiot:

    #komento: sudo mkdir
    /srv/salt/blender
    /srv/salt/kdenlive
    /srv/salt/vlc
 
Jokaiseen kansioon tein oman init.sls tiedoston (käyttäen tekstieditori microa), jonka perusrakenne on:
    
    # komento: micro init.sls
    vlc:
      pkg.installed

    /home/olmo/.config/vlc/vlcrc:
      file.managed:
        - source: salt://vlc/vlcrc

Välissä tein testin ja laitoin kaikki luomani salt-tilat yhteen top.sls tiedostoon, joka laitetaan kansiioon /srv/salt/

    base:
      '*':
        - blender
        - kdenlive
        - vlc
       
Ajoin tilan testinä lokaalisti komennolla:
    
    sudo salt-call --local state.highstate
    
Sain onnistuneen tulosteen:

![image](https://user-images.githubusercontent.com/60943507/168825371-4943525a-346e-443b-9d1b-80430d136f3c.png)

Moduuli näyttää siis toimivan tässä vaiheessa, toki olin jo asentanut softat master-koneelleni aikaisemmin. Tila on kuitenkin todettu idempotentiksi.

## Sovellusten asetusten konfigurointi

Seuraavana vaiheena olin laittanut tavoitteeksi vaihtaa sovelluksiin lempiasetukseni, joita käytän kun lähden työstämään videoprojektia.

Asetukset olivat Kdenliveen: 

* Projetkin aikajanan asetukset defaulttina: Resoluutio 1080p ja fps 23.98 (Samat kuin kamerani asetukset yleensä)
* Valmiin työn export asetukset: Resoluutio 1080p ja fps 23.98 ja tiedostoformaatti mp4 (Asetukset lyhytelokuvilleni)

Asetukset VLC:

* Skip no frames
* Audio filter: Volume Normalizer

Asetukset blender:


Aloitin Googletmalla, missä kyseisten sovellusten config -tiedostot olivat ja tietojen mukaan ne olivat kansioissa:

* VLC: ~/.config/vlc/vlcrc
* Kdenlive: ~/.config/kdenliverc : contains the general settings of the application
* Blender: ~/.config/blender/2.79/

Lähteet: 
* https://docs.blender.org/manual/en/2.79/getting_started/installing/configuration/directories.html
* https://www.videolan.org/support/faq.html
* https://community.kde.org/Kdenlive/Configuration

Seurasin kurssilla tekemieni harjoitusten ja ohjeiden mukaisesti ja 
laitoin jokaiseen init.sls tiedostoon file.managed periaatteen mukaisesti:

    # Kdenlive
    /home/olmo/.config/kdenliverc:
      file.managed:
        - source: salt://kdenlive/kdenliverc
    
    # VLC
    /home/olmo/.config/vlc/vlcrc:
      file.managed:
        - source: salt://vlc/vlcrc
     

Ajoin tilan testinä lokaalisti komennolla:
    
    sudo salt-call --local state.highstate 

Ja sain jälleen onnistuneen tulosteen

![image](https://user-images.githubusercontent.com/60943507/168885198-be687d86-2217-4bf7-8384-6ff12d9335d8.png)

![image](https://user-images.githubusercontent.com/60943507/168885053-39b5e3a5-119e-4aa0-9222-6d45494de200.png)

    
Kaikki näytti vielä hyvältä ja kävin sovelluksissa katsomassa, että asetukset olivat tulleet voimaan.

Tähän asti olin ajanut tilat lokaalisti ja kokeillut myös toiminnan vanhalla samalla koneella olevallani minionilla ja sekin toimi.

Halusin kuitenkin tehdä moduulin testausta varten vielä täysin uuden erillisen virtuaalikoneen, joten asensin virtualboxilla itselleni uuden Debian 11
virtuaalikoneen, josta tein uuden minionin asentamalla salt-minioin.

Sain masterillani yhteyden tähän uuteen virtuaalikoneeseen ja minioniin nimeltä *ModuliMinion* ja lähdin suorittamaan isoa testiä...

    sudo salt 'ModuliMinion' state.highstate
    
 Sain tulosteen:
 
 ![image](https://user-images.githubusercontent.com/60943507/168888882-b1854aa8-0da2-4c14-b4f4-0fd69ee36a9f.png)
  
  ![image](https://user-images.githubusercontent.com/60943507/168888924-5fb4977b-949d-4a0e-8fe5-3bf03c1505fa.png)

Kuten näkyy itse sovelluspakettien asentaminen onnistuu (kuvissa toinen kerta kun ajoin moduulin, joten siksi paketit jo asennettu),
mutta file.managed tilassa mainittujen konffitiedostojen polkujen kanssa ongelmat sitten ilmenivät. 

## Ongelman selvittäminen

Mietin hetken ja tajusin ongelman johtuvan siitä kuten tulosteen kommenteissa kerrotaan: *Parent directory not present* eli tietenkään uudella minionilla ei voi olla kotihakemistoa nimeltä /home/olmo/... eli sitä mikä on masterillani.

Yritin Googlata asiaa:

-Saltin omat sivut eivät antaneet selvää ratkaisua https://docs.saltproject.io/en/latest/ref/states/all/salt.states.file.html

-En löytänyt lisää tietoa tai osannut Googlata oikealla kysymyksellä.


Yritin etsiä oliko konffitiedostoja muissa sijanneissa ja yritin siirtää niitä eri sijaintiin:

-En löytänyt muista sijanneista sovelluksiin liittyviä konffitiedostoja

-Siirsin konffitiedostot eri sijaintiin /etc/share ja muokkasin init.sls tiedostot ja sain onnistuneen tulosteen, mutta sovellukset eivät ilmeisesti saaneet otettua tietoja sieltä, koska halumiani muutoksia ei tullut.

# Lopputulos ja projektin jatkaminen

Mooduliprojekti oli osaltani pieni pettymys, koska en saanut moduulista vielä sellaista kuin haluaisin, mutta sen tekeminen oli erittäin mielenkiintoista ja innostus laittaa ja korjata moduuli täysin toimivaksi kasvoi. Jatkan siis moduulin työstämistä vielä kurssin jälkeenkin, joten jos kiinnostuit moduulista niin seuraa sen etenemistä täältä GitHubista!

### Lähteet: 
* https://docs.blender.org/manual/en/2.79/getting_started/installing/configuration/directories.html
* https://www.videolan.org/support/faq.html
* https://community.kde.org/Kdenlive/Configuration
* https://terokarvinen.com/2021/configuration-management-systems-2022-spring/
* https://terokarvinen.com/2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/
* https://docs.saltproject.io/en/latest/ref/states/all/salt.states.file.html

<!-- wp:paragraph -->
<p>Tätä dokumenttia saa kopioida ja muokata GNU General Public License (versio 2 tai uudempi) mukaisesti. <a href="http://www.gnu.org/licenses/gpl.html">http://www.gnu.org/licenses/gpl.html</a></p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Pohjana Tero Karvisen Palvelinten Hallinta kurssi, Kevät 2022 <a href="https://terokarvinen.com/2021/configuration-management-systems-2022-spring/">https://terokarvinen.com/2021/configuration-management-systems-2022-spring/</a></p>
<!-- /wp:paragraph -->
