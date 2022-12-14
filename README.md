# ArrowheadIC
# Bevezető
Ez a demo az Arrowhead Keretrendszer "Hello World" tutorialjához készült felhasználói bemutató. A demo és a bevezető nem taglalja az Arrowhead Keretrendszer felépítését, valamint a bemutatóban az Arrowhead Keretrendszerrel kapcsolatos alapvető ismeretekre épít. A bemutató célja a Mandatory Core Systems elemeinek bemutatása. Amennyiben ezekkel, a dokumentációval vagy egyéb Arrowhead Keretrendszerrel kapcsolatos információra van szükség, azt az projekt hivatalos GitHub oldalán érdemes keresni: https://github.com/eclipse-arrowhead/core-java-spring

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
Az authorizációs szabályok hozzáadása után a consumernek rendelkeznie kell a megfelelő hozzáférési jogosultságokkal, amivel kezdeményezhető az orchestrációs folyamat. A szolgáltatások közötti dinamikus összeköttetést biztosító rendszer (Orcehstrator) interfésze a ``` localhost:8441/orchestrator ``` címen érhető el. Az összeköttetés olyan szolgáltatások között történhet meg amire a rendszer a követelményeknek megfelelő szolgáltatást talál. A követelményen a ServiceRequestForm objektumban írhatóak le:
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

# Használati példa
A demo példa 2 szolgáltatás illesztését mutatja be, majd ezeket keresztül az orchestrációs folyamat végrehajtása figyelhető meg. A provider szolgáltatás a példában egy előre definiált porton várakozó HTTP szerver mely beérkező kérés esetén HTTP válaszban ad információt, valamint egy consumer rendszer amelyik ezt az információt kéri le. A szolgáltatást a 9797-es porton tettem elérhetővé. A szolgáltatások regisztrációja böngészőben elvégezhető, a localhost:8888-as címen.
 
Provider:
![alt text](https://github.com/Nanoblast/Arrowhead/blob/main/Arrowhead/captures/serviceregistry.JPG?raw=true)
Consumer:
![alt text](https://github.com/Nanoblast/Arrowhead/blob/main/Arrowhead/captures/consumer.JPG?raw=true)

A szolgáltatások regisztrációját ezek után érdemes ellenőrizni. Az alábbi kódrészlet a rendszerben elérhető a korábbiakban regisztrált szolgáltatásokat listázza a Service Registryből kapott válaszban:
```json
   {
      "id": 496,
      "serviceDefinition": {
        "id": 48,
        "serviceDefinition": "arrowhead-demo-consumer",
        "createdAt": "2022-11-02T15:23:55Z",
        "updatedAt": "2022-11-02T15:23:55Z"
      },
      "provider": {
        "id": 39,
        "systemName": "arrowhead-demo-client",
        "address": "127.0.0.1",
        "port": 9798,
        "authenticationInfo": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttDE8cOgBnXeYq5k2CuFqKAGG1J5GL5FAudqDyw1iBeX+aSU+2avzclh+HKzmB2/EPr10RZjTOl6SjkIqjx/HT0jS/9gm8ibeybVlAfzna5lznEKuwiTl7S+Yxb0coBaRC0p8HLXvt8axL7hVyNHlGdVClwO+LQYUnDYR+PG8jqvSWLmA0tXTnFggiKofhqLbwIw0An6+ISsUq7iRxaQsdfGUJbrzFarw9B6bGqwgkLS4C7TuVH1YVrKpyB+f1e+hU5kseAPr1EsCK+s6dYYHzVcF3vVWe70/UO5riawQiM7iJWC5bVhoDAjpFkIwSbwtfeDYNj5rvL+6FliWk3R/QIDAQAB",
        "createdAt": "2022-11-02T15:23:55Z",
        "updatedAt": "2022-11-02T15:23:55Z"
      },
      "serviceUri": "registeredService",
      "endOfValidity": "2023-08-24T11:03:02Z",
      "secure": "NOT_SECURE",
      "version": 0,
      "interfaces": [
        {
          "id": 1,
          "interfaceName": "HTTP-SECURE-JSON",
          "createdAt": "2021-12-02T12:49:48Z",
          "updatedAt": "2021-12-02T12:49:48Z"
        }
      ],
      "createdAt": "2022-11-02T15:23:55Z",
      "updatedAt": "2022-11-02T15:23:55Z"
    },
    {
      "id": 497,
      "serviceDefinition": {
        "id": 49,
        "serviceDefinition": "arrowhead-demo-provider",
        "createdAt": "2022-11-02T15:24:19Z",
        "updatedAt": "2022-11-02T15:24:19Z"
      },
      "provider": {
        "id": 40,
        "systemName": "arrowhead-demo-server",
        "address": "127.0.0.1",
        "port": 9797,
        "authenticationInfo": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttDE8cOgBnXeYq5k2CuFqKAGG1J5GL5FAudqDyw1iBeX+aSU+2avzclh+HKzmB2/EPr10RZjTOl6SjkIqjx/HT0jS/9gm8ibeybVlAfzna5lznEKuwiTl7S+Yxb0coBaRC0p8HLXvt8axL7hVyNHlGdVClwO+LQYUnDYR+PG8jqvSWLmA0tXTnFggiKofhqLbwIw0An6+ISsUq7iRxaQsdfGUJbrzFarw9B6bGqwgkLS4C7TuVH1YVrKpyB+f1e+hU5kseAPr1EsCK+s6dYYHzVcF3vVWe70/UO5riawQiM7iJWC5bVhoDAjpFkIwSbwtfeDYNj5rvL+6FliWk3R/QIDAQAB",
        "createdAt": "2022-11-02T15:24:19Z",
        "updatedAt": "2022-11-02T15:24:19Z"
      },
      "serviceUri": "registeredService",
      "endOfValidity": "2023-08-24T11:03:02Z",
      "secure": "NOT_SECURE",
      "version": 0,
      "interfaces": [
        {
          "id": 1,
          "interfaceName": "HTTP-SECURE-JSON",
          "createdAt": "2021-12-02T12:49:48Z",
          "updatedAt": "2021-12-02T12:49:48Z"
        }
      ],
      "createdAt": "2022-11-02T15:24:19Z",
      "updatedAt": "2022-11-02T15:24:19Z"
    }
```
Az Authorizációs sablont a fenti json válasz paramétereivel kell kitölteni. A consumer ID-t a kliens providere, a provider ID-t pedig a szerver azonosítója fogja megadni. Továbbá szükség van még a szerver serviceDefinition azonosítójára is. Az összeállított üzenet az alábbi módon néz ki:

```json
{
  "consumerId": "39",
  "interfaceIds": [
    "1"
  ],
  "providerIds": [
    "40"
  ],
  "serviceDefinitionIds": [
    "49"
  ]
}
```

A kérés beküldése utána a rendszer válasza tartalmazza az elkészült hozzáférési szabályt:
```json
{
  "data": [
    {
      "id": 12,
      "consumerSystem": {
        "id": 39,
        "systemName": "arrowhead-demo-client",
        "address": "127.0.0.1",
        "port": 9798,
        "authenticationInfo": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttDE8cOgBnXeYq5k2CuFqKAGG1J5GL5FAudqDyw1iBeX+aSU+2avzclh+HKzmB2/EPr10RZjTOl6SjkIqjx/HT0jS/9gm8ibeybVlAfzna5lznEKuwiTl7S+Yxb0coBaRC0p8HLXvt8axL7hVyNHlGdVClwO+LQYUnDYR+PG8jqvSWLmA0tXTnFggiKofhqLbwIw0An6+ISsUq7iRxaQsdfGUJbrzFarw9B6bGqwgkLS4C7TuVH1YVrKpyB+f1e+hU5kseAPr1EsCK+s6dYYHzVcF3vVWe70/UO5riawQiM7iJWC5bVhoDAjpFkIwSbwtfeDYNj5rvL+6FliWk3R/QIDAQAB",
        "createdAt": "2022-11-02T15:23:55Z",
        "updatedAt": "2022-11-02T15:23:55Z"
      },
      "providerSystem": {
        "id": 40,
        "systemName": "arrowhead-demo-server",
        "address": "127.0.0.1",
        "port": 9797,
        "authenticationInfo": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttDE8cOgBnXeYq5k2CuFqKAGG1J5GL5FAudqDyw1iBeX+aSU+2avzclh+HKzmB2/EPr10RZjTOl6SjkIqjx/HT0jS/9gm8ibeybVlAfzna5lznEKuwiTl7S+Yxb0coBaRC0p8HLXvt8axL7hVyNHlGdVClwO+LQYUnDYR+PG8jqvSWLmA0tXTnFggiKofhqLbwIw0An6+ISsUq7iRxaQsdfGUJbrzFarw9B6bGqwgkLS4C7TuVH1YVrKpyB+f1e+hU5kseAPr1EsCK+s6dYYHzVcF3vVWe70/UO5riawQiM7iJWC5bVhoDAjpFkIwSbwtfeDYNj5rvL+6FliWk3R/QIDAQAB",
        "createdAt": "2022-11-02T15:24:19Z",
        "updatedAt": "2022-11-02T15:24:19Z"
      },
      "serviceDefinition": {
        "id": 49,
        "serviceDefinition": "arrowhead-demo-provider",
        "createdAt": "2022-11-02T15:24:19Z",
        "updatedAt": "2022-11-02T15:24:19Z"
      },
      "interfaces": [
        {
          "id": 1,
          "interfaceName": "HTTP-SECURE-JSON",
          "createdAt": "2021-12-02T12:49:48Z",
          "updatedAt": "2021-12-02T12:49:48Z"
        }
      ],
      "createdAt": "2022-11-03T17:10:27.250491Z",
      "updatedAt": "2022-11-03T17:10:27.250491Z"
    }
  ],
  "count": 1
}
```

Ezzel minden előfeltétel teljesült, hogy a consumer orhcestrációs kérést indítson. A serviceRequest objektumnak tartalmazni kell minden olyan információt amivel a rendszer azonosítani tudja a feltételeket kielgítő szolgáltatásokat a Service Registryben:

```json
{
  "requesterSystem" : {
    "systemName" : "arrowhead-demo-client",
    "address" : "127.0.0.1",
    "port" : 9798,
    "authenticationInfo" : "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsBnrg7kgYJqsAObZ87Qb1BITnzt4mx+MwKuC2UOWsIgq8tE+3+g24HgrUlIlxCm7uczhZRmM/rSEqMgL4dszpYqz1+eFgCXaawegTWJa4yrCurcrC5rLXfHtydOojlOG1qb9Ij+0inJLR7msnj4oYSlHKinj9oDIq+xk2feB3lh7SI9zS1u13c+iBjw7NCwfq41NJXm4+iWGJwd1S2M7N7/qjBf3o0iz7SqElNP2DZxpjw32k8Vtqq+RPFPNsWiukOya/5c5WKhBjieRIX0NMdFlTzlo8jzdpSFnGN8kuByfHfWDJTvrUJoR6aOz2TzKXbTiZPDuH9cgbNJQQra8uQIDAQAB"
  },
  "requesterCloud" : null,
  "requestedService" : {
    "serviceDefinitionRequirement" : "arrowhead-demo-provider",
    "interfaceRequirements" : [ "HTTP-SECURE-JSON" ],
    "securityRequirements" : null,
    "metadataRequirements" : null,
    "versionRequirement" : null,
    "minVersionRequirement" : null,
    "maxVersionRequirement" : null,
    "pingProviders" : false
  },
  "orchestrationFlags" : {
    "onlyPreferred" : false,
    "overrideStore" : true,
    "externalServiceRequest" : false,
    "enableInterCloud" : false,
    "enableQoS" : false,
    "matchmaking" : true,
    "metadataSearch" : false,
    "triggerInterCloud" : false,
    "pingProviders" : false
  },
  "preferredProviders" : [ ],
  "commands" : { },
  "qosRequirements" : { }
}
```
A válasz tartalmazza az orchestrációs információt amely a providerhez való csatlakozási paramétereket tartalmazza.
Az orchestrációs válasz:

```json
{
  "response": [
    {
      "provider": {
        "id": 40,
        "systemName": "arrowhead-demo-server",
        "address": "127.0.0.1",
        "port": 9797,
        "authenticationInfo": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttDE8cOgBnXeYq5k2CuFqKAGG1J5GL5FAudqDyw1iBeX+aSU+2avzclh+HKzmB2/EPr10RZjTOl6SjkIqjx/HT0jS/9gm8ibeybVlAfzna5lznEKuwiTl7S+Yxb0coBaRC0p8HLXvt8axL7hVyNHlGdVClwO+LQYUnDYR+PG8jqvSWLmA0tXTnFggiKofhqLbwIw0An6+ISsUq7iRxaQsdfGUJbrzFarw9B6bGqwgkLS4C7TuVH1YVrKpyB+f1e+hU5kseAPr1EsCK+s6dYYHzVcF3vVWe70/UO5riawQiM7iJWC5bVhoDAjpFkIwSbwtfeDYNj5rvL+6FliWk3R/QIDAQAB",
        "createdAt": "2022-11-02T15:24:19Z",
        "updatedAt": "2022-11-02T15:24:19Z"
      },
      "service": {
        "id": 49,
        "serviceDefinition": "arrowhead-demo-provider",
        "createdAt": "2022-11-02T15:24:19Z",
        "updatedAt": "2022-11-02T15:24:19Z"
      },
      "serviceUri": "registeredService",
      "secure": "NOT_SECURE",
      "metadata": {},
      "interfaces": [
        {
          "id": 1,
          "interfaceName": "HTTP-SECURE-JSON",
          "createdAt": "2021-12-02T12:49:48Z",
          "updatedAt": "2021-12-02T12:49:48Z"
        }
      ],
      "version": 0,
      "authorizationTokens": null,
      "warnings": []
    }
  ]
}
```

A válaszból pl jq segítségével kényelmesen illeszthetőek az adatok, az alábbi példa az orchestrációs adatok felhasználásval csatlakozik a providerehz és kéri le az információt:

```
curl -X GET $(jq -r '.[] | .[] | .provider.address' out.log):$(jq -r '.[] | .[] | .provider.port' out.log)
```
