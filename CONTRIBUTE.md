# AbcQuran contributor docs

## Table of Contents

- [The vision for AbcQuran](#vision)
- [Riverpod architecture](#riverpod)
- [Development setup (make it run)](#setup)
- [Help us with the audio](#sync)
- [Documentation](#docs)

### The vision for AbcQuran <a name="vision"></a>

AbcQuran was created as a personal reaction to the lack of fancy Islam-related software, especially in English-speaking countries. For instance, in France, the only famous "mushaf app" is [Quran.com](https://quran.com), a very nicely shaped yet quite improvable project. [Quran.com](https://quran.com) is sufficient in itself, however it was not open-sourced, and it deeply relies on already-existing qur'an data.<br>
AbcQuran stands as a mean to unravel the software engineering talents of the Muslim community around the world, offering, God willing, an app that will please everyone. By the way, IA is coming very soon and the muslim community has unfortunately not been prepared enough to profit from it, mainly because of the lack of  platform for quranic technologies.<br>
Meanwhile, AbcQuran is a sadaqa jariya that aims at being free and improved everyday by thousands of volunteers.


### Riverpod architecture <a name="riverpod"></a>

AbcQuran uses Flutter with the Riverpod package for more clarity and in order to ease group work.
The app in itself is split between various UI-independent providers, roughly one for each feature. However, highly requested data (such as the current sura) have their own provider for performance reasons.
https://riverpod.dev/


### Development setup (make it run) <a name="setup"></a>
wip...


### Help us with the audio<a name="sync"></a>
🔊 Help us synchronize the audio data
- [English tutorial](https://www.youtube.com/watch?v=CL2cN2zhCm0)
- [French tutorial](https://www.youtube.com/watch?v=p4eLZa9lC0M)


### Documentation <a name="docs"></a>
- [Mushaf docs](lib/services/quran/README.md)
- [Player/streamer docs](lib/providers/player/README.md)
