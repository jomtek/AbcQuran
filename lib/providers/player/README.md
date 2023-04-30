# How the player works

## The data
The audio data was collected from the [QuranicAudio](https://quranicaudio.com/) project.<br>
The timing data was mainly collected from [EveryAyah](https://everyayah.com/data/timings_files/), but it seems to be strongly unstable. We'll take a deep dive in this issue later in the docs.<br>

Audio data takes about 40GB disk space. Lesser than what the AbcQuran server can handle. Thus, the player directly gets its audio from the QuranicAudio servers.

## Basics
The player uses the `audioplayers` package, pretty much the only way to stream audio urls in Flutter (`just_audio` doesnt support Windows).<br>
The player is heavily synchronized with the cursor. If the bookmark moves, the player seeks the audio track. As the audio track moves, the bookmark is moved.<br>

## Synchronization
One of the toughest challenges while creating the player was the synchronization feature (with the bookmark/cursor). Thankfully, the EveryAyah project offers a large collection of exact timecodes for the QuranicAudio sources.

The timecodes look like so :
<img src="https://i.imgur.com/r33niJe.png">

However, there are two main issues :
- Some reciters (such as Maher Al-Mueaqly) do not have any timecode
- Some reciters (such as Abderrahman Al-Sudais) have corrupted timecodes

To address the issue, a way for any user to contribute by suggesting new timecodes should be added directly to AbcQuran.
