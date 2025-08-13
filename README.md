# Dokumentáció

## Feladatkezelő

Lakik: engine/core/taskm - api.hpp
- namespace: taskm
- több: taskm::internal
- publikus API funkciói: *ajánlott namespace használat!*
  - taskm::task | csinál egy task objektumot,
    - paraméterek: *egyik sem kötelező*
      - Kondíció (taskm::condition(lambda/function/bool/void)) | (functionről később!)
      - Process (taskm::process(lambda/function))
      - ID (unsigned int, lehet nem scoped enumból!)
      - Modifier (taskm::mod(function&function/lambda&lambda))
    - Módosítani is képes! hozzá tud adni egy már létező feladathoz új paramétereket
    - Példa: c++'''TaskID my_task = task(condition(true), process(&function), process(function))'''
    - Vigyázz! a processbe nem adhatsz be stateful lambdát csak function wrapperen keresztül!
    - Visszaad: taskm::TaskID az ID-vel amit beállítottál (vagy szemét)
  - taskm::graph | csinál egy graph objektumot
    - paraméterek: *egyik sem kötelező*
      - Connection (taskm::connection(TaskID from, TaskID to, [unsigned int determiner]))
      - Determiner (taskm::determiner((unsigned int, function<void>(task_tuple**, dctx&))))
    - Vigyázz! nem szerkeszthet ez!
    - Majd engine::use(graph) hogy az engine felimserje.
    - Visszaadja: a graph idt


## Funkciók

Lakik: engine/core/function - Nincs api.hpp csak function.hpp
function támogatja a stateful és stateless lambdákat is. Csak c++'''function<ReturnType>(stateful, stateless, funcptr)'''
DE, az nem támogatja a paramétereket, ahoz hogy legyenek paraméterek: c++'''function<ReturnType(...)>(ide is jöhet akármelyik)'''

## Eventek

Lakik: engine/core/eventh - api.hpp













# Dokumentáció

## Feladatok

**Helye:** 'engine/core/taskm/api.hpp'
**Namespace:** 'taskm' (Publikus API), 'taskm::internal'

**Publikus API használata:**

### taskm::task
Csinál / Szerkeszt egy task objektumot ID alapján
**Paraméterek:** *(Akármelyikből opcionálisan akármennyit!)*
- **Kondíció** - taskm::condition(lambda | function | bool | void(azaz true)). *Funkcióról később [itt](#Funkciók)* 
  Ez internálisan egy bool-t vissza adó funkció, amikor az összes igaz akkor le fut a feladat.
- **Folyamat** - taskm::process(lambda | functon | void(üres)).
  Ez az ami lefut, az összes amit hozzáadtál sorrendben fog lefutni.
- **ID**       - taskm::id(int... | unscoped enum)
  Megváltoztatja az id-t TaskID-ban, nincsen sok értelme, manuálisan is lehetne.
- **Módosító** - taskm:mod(lambda&lambda | function&function) *vagy persze function::null*
  A folyamat előtt vagy után fut le. **Fontos!** ha valamit hozzáadsz a végére majd szerkeszted akkor az új dolgok ezt folyamatként fogják felismerni

### taskm::graph


## Funkciók

**Helye:** 'engine/core/function/function.hpp' *igen, nincsen api.hpp*
**Leírás:** Csak egy szimpla function wrapper, csak egy komplikált struct
**Működés:** function<ReturnType>::make(stateful lambda | stateless lambda | funcptr) *Argument nélküli* VAGY function<ReturnType>::make<%Signature%>(...) ha szükséged van paraméterekre pld: determiner, de ott megoldja azt a taskm::determiner
