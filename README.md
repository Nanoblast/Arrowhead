# ArrowheadIC
# Bevezető
Ez a demo az Arrowhead Keretrendszer "Hello World" tutorialjához készült felhasználói bemutató. A demo és a bevezető nem taglalja az Arrowhead Keretrendszer felépítését, valamint a bemutatóban az Arrowhead Keretrendszerrel kapcsolatos alapvető ismeretekre támaszkodik. A bemutató célja a Mandatory Core System rendszerek bemutatása. Amennyiben ezekkel, a dokumentációval vagy egyéb Arrowhead Keretrendszerrel kapcsolatos információra van szüksége, azt az projekt hivatalos GitHub oldalán találja a leírásban: https://github.com/eclipse-arrowhead/core-java-spring#orchestrator

# Első lépések
A rendszer haszálata előtt lépéseket szükséges elvégezni:
- Lokális adatbázis elindítása: ``` service mariadb start ```
- Indítás után érdemes az adatbázis elindulását ellenőrizni. Amennyiben  ``` service mariadb status ``` parancs hatására  ``` running ``` státuszban lévő  a szolgáltatás a rendszer indításra kész.
- Második feladat az Arrowhead Keretrendszer komponenseit szükséges elindítni, ehhez az alábbi utasítás szükséges:  ``` /home/sysop/utils/start_services.sh ``` Az indítás néhány percet vesz igénybe, a rendszer elindulása ellenőrizhető a ``` netstat -tlpn ``` parancs segítségével. A szükséges szolgáltatások a ``` 8441, 8443, 8445, 18441, 18443, 18445``` porton indulnak el. Ezek után a rendszer használatra kész. 

# Service registry
A szolgáltatások regisztrációjáért és lekérdéséért felelős modult a  ``` localhost:8443 ``` címen lehet elérni. A rendszer a HTTP kéréseknél TLS titkosítást használ, melyhez P12-es tanúsítványokra van szükség. Az egyszerűség kedvéért a demoban a tanusítványmenedzsmenttel nem kell foglalkozni, azt előre elkészített tanúsítvánnyal (pl Sysos tanúsítvány) vagy automatizált scripttel oldjuk meg. Ugyanakkor a mélyebben érdeklődöknek érdemes áttanulmányozni a hivatalos leírás tanúsítványokra vonatkozó fejezeteit. 

Érdemes a Service Registry tartalmát listázni, ezzel validálható, hogy a rendszer elfogadja a használt tanúsítványt. A lekérdezéshez az alábbi utasítás használható: ``` curl -v -s --insecure --cert-type P12 --cert /usr/share/arrowhead/certificates/testcloud2/sysop.p12:123456 -X GET https://localhost:8443/serviceregistry/mgmt | jq ```

Szolgáltatás regisztrációjához minden szolgáltatáshoz új tanúsítványokat kell létrehozni. Ezek a lépések a Hello World demoban automatizáltan történnek, a regisztrációs felület böngészőből a ``` localhost:8888/serviceregistry ``` oldalon érhető el. Regisztráció után érdemes az új szolgáltatást az előző lépésben használt lekérdezéssel validálni. 

# Authentication 

# Orchestrator
