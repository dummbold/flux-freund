<p align="right"><img width="220" height="52" alt="dgpt" src="https://github.com/user-attachments/assets/e763407f-dff7-4a2b-9bbd-d04cf14373ff" /></p>



>🇺🇸🇬🇧🇫🇷🇪🇸🇮🇹🇪🇺🇺🇦🇦🇺🇫🇮🇨🇿🇧🇷🇨🇦🇰🇿🇨🇴🇲🇶🇳🇬🇸🇨🇪🇭🇺🇾🇺🇬🏳️🏴‍☠️
>
>_International users:_
>
>_This Text is intentionally written in german language. Please use your Browsers translation feature. A translation from german into other languages mainly generates better results then a translation from any language (especially english) into german due to the linguistic specifications of the languages. German is one of the most complex languages that can easyly be auto-translated into less complex languages. Thanks for your compliance an let me know your experience._
>
>
---
# FLUX•Freund

Die [accurat] FLUX 850 USV ist eine preisgünstiges Gerät zur unterbrechungsfreien Stromversorgung für kleine Büros bzw. das HomeOffice. Sie verfügt neben dem eingebauten Display auch über einen USB-Anschluss über den Telemetriedaten ausgelesen werden können. 

![Mittel (FLUX860)](https://github.com/user-attachments/assets/e759710c-8a02-4935-a9b5-5228db25ede6)

Leider gibt es vom Hersteller nur eine Windows-Software dafür. Das LINUX USV-Management-System NUT erkennt jedoch die Elektronik und stellt auch den richtigen Treiber zur Verfügung. Allerdings ist die Einrichtung ziemlich komplex und für normale Menschen ohne Expertenwissen kaum durchführbar. Dank der **DeutschlandGPT** gibt es hier die Lösung. 

Der **FLUX•Freund** ist ein Shellscript für Linux zur schnellen Installation des NUT-Servers zur Nutzung mit dem FLUX. Es ist nur nötig ein Passwort einzugeben. Alles andere macht das Script. Wer keinen Linux-Rechner hat sollte überlegen einen Raspberry PI anzuschaffen. NUT sollte selbst auf einem kleinen Pi Zero 2 laufen. So kann man für eine geringe Investition die USV im Netzwerk monitoren.

<img width="725" height="329" alt="raspizero" src="https://github.com/user-attachments/assets/84029b31-a10a-428c-b562-e2d7f4e39503" />

Empfehlenwert ist ein Upgrade mit einem LAN-HAT, der USB-A und LAN zur Verfügung stellt - der Pi Zero 2 hat nur einen Micro-USB-Anschluss!

<img width="357" height="295" alt="pizerolanhat" src="https://github.com/user-attachments/assets/c7964237-e55e-4613-9e14-10eb446a22e5" />

Nach der Einrichtung stehen die Daten am Port :3493 bereit (keine Website!). Man kann man die Daten in Linux mit dem NUT-Monitor anschauen (sehr rudimentär) aber sie auch problemlos in Homeassistant übernehmen! Es gibt eine NUT Integration die auf den Server zugreift und alle Daten in Homeassistant zur Verfügung stellt. Das sieht dann so aus:

![hanut](https://github.com/user-attachments/assets/0f6139a7-e8b9-48aa-ae9e-54f6055923c6)

‼️**ACHTUNG:** Die Umschaltung des USV-Systemmodus von "line" auf "battery" wird erst nach rund 20 Sekunden in HAOS registriert. Das ist für eine Warnmeldung über HAOS viel zu lang. Die Schuld liegt hier an HAOS, dass die Daten nicht oft genug von der USV holt. Man kann dieses Problem über zwei Wege lösen: Ein Script auf dem Linux Server, sodass dieser die Daten sendet (anstatt dass HAOS sie abholt) – oder am einfachsten über MQTT. Ein MQTT-Topic landet verzögerungsfrei auf dem HAOS-Server und kann dort verarbeitet werden.

Trotz dieser Einschränkung viel Spaß!
