# ArrowheadIC
# Bevezető
Ez a demo az Arrowhead Keretrendszer "Hello World" tutorialjához készült felhasználói bemutató. A demo és a bevezető nem taglalja az Arrowhead Keretrendszer felépítését, valamint a bemutatóban az Arrowhead Keretrendszerrel kapcsolatos alapvető ismeretekre épít. A bemutató célja a Mandatory Core System rendszerek bemutatása. Amennyiben ezekkel, a dokumentációval vagy egyéb Arrowhead Keretrendszerrel kapcsolatos információra van szüksége, azt az projekt hivatalos GitHub oldalán találja: https://github.com/eclipse-arrowhead/core-java-spring

# Első lépések
A rendszer haszálata előtt az alábbi lépéseket szükséges elvégezni:
- Lokális adatbázis elindítása: ``` service mariadb start ```
- Indítás után érdemes az adatbázis elindulását ellenőrizni. Amennyiben  ``` service mariadb status ``` parancs hatására  ``` running ``` státuszban lévő  a szolgáltatás a rendszer indításra kész.
- Második feladat az Arrowhead Keretrendszer komponenseinek elindítása, ehhez az alábbi utasítás szükséges:  
```
/home/sysop/utils/start_services.sh 
``` 
Az indítás néhány percet vesz igénybe, a rendszer elindulása ellenőrizhető a 
``` netstat -tlpn ``` 
parancs segítségével. A szükséges szolgáltatások a ``` 8441, 8443, 8445, 18441, 18443, 18445``` portokon indulnak el. Ezek után a rendszer használatra kész. 

# Service registry
A szolgáltatások regisztrációjáért és lekérdezéséért felelős modult a  ``` localhost:8443/serviceregistry ``` címen lehet elérni. A rendszer a HTTP kéréseknél TLS titkosítást használ, melyhez P12-es tanúsítványokra van szükség. Az egyszerűség kedvéért a demoban a tanusítványmenedzsmenttel nem kell foglalkozni, azt előre elkészített tanúsítvánnyal (pl Sysop tanúsítvány) vagy automatizált scripttel oldjuk meg. Ugyanakkor a mélyebben érdeklődöknek érdemes áttanulmányozni a hivatalos leírás tanúsítványokra vonatkozó fejezeteit. 

Érdemes a Service Registry tartalmát listázni, ezzel validálható, hogy a rendszer elfogadja a használt tanúsítványt. A lekérdezéshez az alábbi utasítás használható: 
```bash
curl -v -s --insecure --cert-type P12 --cert /usr/share/arrowhead/certificates/testcloud2/sysop.p12:123456 -X GET https://localhost:8443/serviceregistry/mgmt | jq 
```

Szolgáltatás regisztrációjához minden szolgáltatáshoz új tanúsítványokat kell létrehozni. Ezek a lépések a Hello World demoban automatizáltan történnek, a regisztrációs felület böngészőből a ``` localhost:8888/serviceregistry ``` oldalon érhető el. Regisztráció után érdemes az új szolgáltatást az előző lépésben használt lekérdezéssel validálni. 

# Authorization 
Az Authorization a szolgáltatások közötti hozzáférési szabályokat kezeli. Az demoban az authorizációs szabályok direkt, kézi meghatalmazással kerülnek beállításra, viszont komplexebb szinten lehetőség van a szabályokat rugalmasabban, dinamikusabban kezelni. Hozzáférési szabály hozzáadásához a ``` localhost:8445/authorization/mgmt/intracloud ``` címre szükséges egy érvényes intracloud szabályt beküldeni, a minta lentebb látható:

```json
{
  "consumer": {
    "address": "string",
    "authenticationInfo": "string",
    "port": 0,
    "systemName": "string"
  },
  "providerIdsWithInterfaceIds": [
    {
      "id": 0,
      "idList": [
        0
      ]
    }
  ],
  "serviceDefinitionId": 0
}
```

Sikeres hozzáadás esetén a kérés válaszában a provider és a consumer információ megjelennek az IntracloudRuleList objektumban. Amennyiben egy provider hozzáférést kapott a consumerhez megkezdhető az orchestrációs folyamat.

# Orchestrator
```
POST /orchestrator/orchestration
```
Az authrizációs szabályok hozzáadása után a consumernek rendelkeznie kell a megfelelő hozzáférési jogosultságokkal, amivel kezdeményezhető az orchestrációs folyamat. A szolgáltatások közötti dinamikus összeköttetést biztosító rendszer (Orcehstrator) interfésze a ``` localhost:8441/orchestrator ``` címen érhető el. Az összeköttetés olyan szolgáltatások között történhet meg amire a rendszer a követelményeknek megfelelő szolgáltatást talál. A követelményen a ServiceRequestForm objektumban írhatóak le:
```json
{
  "requesterSystem": {
    "systemName": "string",
    "address": "string",
    "port": 0,
    "authenticationInfo": "string"
  },
  "requestedService": {
    "serviceDefinitionRequirement": "string",
    "interfaceRequirements": [
      "string"
    ],
    "securityRequirements": [
      "NOT_SECURE", "CERTIFICATE", "TOKEN"
    ],
    "metadataRequirements": {
      "additionalProp1": "string",
      "additionalProp2": "string",
      "additionalProp3": "string"
    },
    "versionRequirement": 0,
    "maxVersionRequirement": 0,
   "minVersionRequirement": 0
  },
  "preferredProviders": [
    {
      "providerCloud": {
        "operator": "string",
        "name": "string"
      },
      "providerSystem": {
        "systemName": "string",
        "address": "string",
        "port": 0
      }
    }
  ],
  "orchestrationFlags": {
    "additionalProp1": true,
    "additionalProp2": true,
    "additionalProp3": true
  }
}
```
