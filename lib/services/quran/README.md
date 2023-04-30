# How the mushaf works

## The data
The data used to generated the mushaf was mainly collected from [here](https://github.com/quran/quran.com-images/tree/master). However it contained a dozen of typos which had to be manually corrected.<br>
It is constituted of 605 TTF font files (604 pages and one basmala/meta), one for each page. Each font associates a glyph (i.e. a unicode char) with a specific word from the page.<br>
According to Quran.com, the fonts were provided by "the King Fahd Quran Complex in Saudi Arabia". Such fonts offer a very authentic reading experience, as it is more or less the same thing as if you were to read a physical qur'an.

<img src="https://i.imgur.com/n3TzKZl.png">

## Is wudu (ablution) necessary ?
Maybe it is important to know that using AbcQuran, the mushaf is _never_ fully loaded on your computer, as the font data is naturally freed by Flutter's garbage collector.<br>
According to Shaykh Salih al-Fawzan (may Allah preserve him) : "[...] we do not think that it comes under the same ruling as the Mus-haf"

## Logical display
### The fonts
In order to display the mushaf, AbcQuran directly downloads these font files from a server and caches them to `C:\Users\[user]\Documents\AbcQuran\cache\mushaf`. While a page should be loaded to the screen, the corresponding fonts are dynamically loaded in and out from the memory using a `FontLoader`.<br>
This is the work of the `mushaf_font_service`.

### The glyphs
Glyphs are mere unicode characters which, if displayed using the correct font, give a specific qur'anic word or symbol. By the way, tajweed symbols count as glyphs on their own.<br>
In order to know which glyphs to display page 259, the `glyphmap.db` SQL table is dynamically queried by the `quran_mushaf_service` in a relatively costless process.<br>
The glyphs are then processed and parsed into `Glyph` objects. Glyphs from pages 1 and 2 are naturally smaller (because of how the Madani mushaf is made). Thus they must be upscaled a bit on the translated view.

<table border="0">
 <tr>
    <td><img src="https://i.imgur.com/aJgBlAM.png"></td>
    <td><img src="https://i.imgur.com/cwVgeBx.png"></td>
 </tr>
</table>
