# AbcQuran contributor docs

## Table of Contents

- [The vision for AbcQuran](#vision)
- [Riverpod architecture](#riverpod)
- [Development setup](#setup)
- [Documentation](#docs)

### The vision for AbcQuran <a name="vision"></a>

AbcQuran was created as a personal reaction to the lack of fancy Islam-related software, especially in english-speaking countries. For instance, in France, the only famous "mushaf app" is quran.com, a very nicely shaped yet quite improvable project. Quran.com is sufficient in itself, however it was not open-sourced, and it deeply relies on already-existing quran data.<br>
AbcQuran stands as a mean to unravel the software engineering talents of the Muslim community around the world, proposing, God willing, an app that will please everyone. By the way, IA is coming very soon and the muslim community has unfortunately not enough been prepared to take profit from it, because of the lack of any platform for quran-related technologies.<br>
Meanwhile, AbcQuran is a sadaqa jariya that wants to be free and improved everyday by thousands of volunteers.


### Riverpod architecture <a name="riverpod"></a>

AbcQuran uses Flutter with the Riverpod package for more clarity and in order to ease the group work.
The app in itself is split in various UI-independent providers, mostly one for each feature. However, highly requested data (such as the current sura) have their own provider for performance reasons.
https://riverpod.dev/


### Development setup (make it run) <a name="setup"></a>
wip...


### Documentation <a name="docs"></a>
- [Mushaf docs](lib/services/quran/README.md)
- [Player/streamer docs](lib/providers/player/README.md)
