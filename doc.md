================== ./include/engine/global.hpp ==================
// Deltatime, stb. megosztva a játékkal!
================== ./include/engine/sys/taskm/node_adder.hpp ==================
// a mode constructora, a rengeteg template-es izé.
================== ./include/engine/sys/taskm/api.hpp ==================
// ugyanúgy nincsenek task-ek, logikusan. 
================== ./include/engine/sys/taskm/nodem.hpp ==================
// node regisztráció, flagok, ezek.
================== ./include/engine/sys/taskm/node.hpp ==================
// a node struct
================== ./include/engine/sys/eventh/api.hpp ==================
// header-ök stb, ez már a system, itt nincsenek task-ek.
================== ./include/engine/sys/eventh/eventm.hpp ==================
// mivel az api csak include-olja, itt vannak ugyanúgy a definíciók hozzá. de nincsenek taskek ott
================== ./include/engine/sys/eventh/internal/storage.hpp ==================
// a izé tárolás az izébőé, tudod a template-es szar, az külön kell szerintem
================== ./include/engine/helpers/logger.hpp ==================
// a logger placeholderekkel stb
================== ./include/engine/helpers/taskm.hpp ==================
// az összes task segítség, modifier, labda izék, funkciók, etc.
================== ./include/engine/helpers/components.hpp ==================
// az összes component ami a rendszernek / játéknak kellhet, pld a renderer
================== ./include/engine/features/sound/player.hpp ==================
// ugyanúgy mint a renderer, itt vannak a defeinicíók amiket a taskek használnak api-ban
================== ./include/engine/features/sound/api.hpp ==================
// a task a player-hez. és csak simában a taskek, header-ök include-olva.
================== ./include/engine/features/renderer/api.hpp ==================
// draw, ilyen node-ok meg nem tom.
================== ./include/engine/features/renderer/renderer.hpp ==================
// a draw meg cleanup itt van deklreálva. és definiálva a cpp-ben.
================== ./include/engine/features/renderer/internal/glabs.hpp ==================
// absztrakciók az opengl-hez. csak ha többször írsz le valamit, vagy lehetne egyszerűbb.
================== ./include/engine/features/assetm/anim.hpp ==================
// animéció betöltés, olvasás, tárolás. kommunokál a renderer-el
================== ./include/engine/features/assetm/api.hpp ==================
// összes include és namespace-ekbe csavarva.
================== ./include/engine/features/assetm/sound.hpp ==================
// Hang betöltés, tárolás és management.
================== ./include/engine/features/assetm/texture.hpp ==================
//textúraa betöltés, atlasz betöltés, textúra: régió az atlaszban.
================== ./include/engine/features/input/api.hpp ==================
// a task az event regisztrációért
================== ./include/game/helpers/vec.hpp ==================
// példa helper, vec3,2 f és i talán d, etc.
================== ./include/game/game.hpp ==================
// a jtáék header-e, taskek itt és ja, a játék main.cpp-je kb. 
================== ./src/engine/sys/taskm.cpp ==================
// a taskm implementációja.
================== ./src/engine/renderer/glabs.cpp ==================
// a renderer izéje.
================== ./src/engine/renderer/renderer.cpp ==================
// a renderer implementációja
================== ./src/main.cpp ==================
================== ./src/game/game.cpp ==================
// ez a file nem kötelező, hanem helyette mindennek aminek kell implementáció ide, lehetnek mappák is.
