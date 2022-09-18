# ArrowheadIC
# Bevezető
- TODO ide írni egy bevezetőt, hogy mi is az Arrowhead, Arrowhead Hello World vm stb.
# Szolgálatás regisztráció
A szolgáltatás regisztációjához az alábbi informáciokra van szükség:
* Service system name: A szolgáltatás neve, melynek meg kell egyeznie a Certificate-hez tartozó rendszer nevével. A HelloWorld tutorialban a Certificate generálás automatikus, így bármilyen rendszernév megadható.
* Service definition: A szolgáltatás leírása, itt kell minden olyan információt megadni melyek jellemzik az adott szolgáltatást.
* Service PORT: Az a PORT szám amin keresztül a rendszer a saját címén elérhető. A HelloWorld tutorialban minden szolgáltatás a localhost címen keresztül érhető el.

A szolgáltatás regisztráció felülete az Index oldalról navigálva a ServiceRegistry linkre kattintva érhető el, vagy a /serviceRegistry URI-n keresztül.
A beküldés gombra kattintva a regisztrált szolgáltatás elérhetővé válik a Service Registry nyilvántartásában, melyet az Index oldalról a Services link segítségével, vagy a /services URI-n keresztül lehet elérni. 

## 1. Feladat:

- Készíts el egy új szolgáltatást. A szolgáltatás rendszerneve és leírása tetszőleges lehet, PORT számot a szabad tartományból válassz. (A foglalt PORT számokat netstat parancs segítségével ellenőrizheted környezetben.)
- Kérd le a Service Registryből az elérhető szolgáltatásokat és jegyezd fel az előző lépésben regisztrált szolgáltatáshoz tartozó ID-t. 
