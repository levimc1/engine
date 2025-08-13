# Dokumentáció

## Feladatkezelő

Lakik: engine/core/taskm
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

