**Olmo Kosunen GPL 2.0**

# VideoEditPack
![image](https://user-images.githubusercontent.com/60943507/168652154-854af248-07e2-4f1e-9176-a723c4498be2.png)

[![Watch the video]([https://youtu.be/rWjIpZxOqks] 

![image](https://user-images.githubusercontent.com/60943507/168652555-17a99538-08c6-403e-914a-92b55b75d220.png)



Lopputulos: SS softat auki ja YT video

Mitä voi tehdä? : Editoida ja katsoa videoita , valmiiksi konffatut lempiasetukset

## Projekti ja sen käyttöönotto:

Päätin luoda moduulin, joka sisältää hyväksi todettuja videoeditointiin ja videoon liittyiä softia linuxille (Debian 11). Tarkoituksena on myös konffata softiin omat lempiasetukset kuten laittaa projektien fps olemaan ja resoluution 

Aloitin luomalla masterille kansiot:

    /srv/salt/blender
    /srv/salt/kdenlive
    /srv/salt/vlc
 
Jokaiseen kansioon tein oman init.sls tiedoston ,jonka perusrakenne on:

    vlc:
      pkg.installed

    ###/home/olmo/.config/vlc/vlcrc:
    ###  file.managed:
    ##    - source: salt://vlc/vlcrc

Välissä tein testin ja laitoin kaikki luomani salt-moduulit yhteen top.sls tiedostoon, joka laitetaan kansiioon /srv/salt/

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
Asetukset olivat kdenliveen: 

* Projetkin aikajanan asetukset defaulttina: Resoluutio 1080p ja fps 23.98 (Samat kuin kamerani asetukset yleensä)
* Valmiin työn export asetukset: Resoluutio 1080p ja fps 23.98 ja tiedostoformaatti mp4 (Asetukset lyhytelokuvilleni)

Asetukset vlc:

* Skip no frames
* Audio filter: Volume Normalizer

Asetukset blender:


Aloitin Googletmalla, missä kyseisten sovellusten config -tiedostot olivat ja tietojen mukaan ne olivat kansioissa:

* VLC: $(HOME)/.config/vlc/vlcrc
* Kdenlive: ~/.config/kdenliverc : contains the general settings of the application
* Blender: $HOME/.config/blender/2.79/

    
  

