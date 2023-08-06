# bhop-server-stuff

- metamod https://www.sourcemm.net/downloads.php?branch=stable

- sourcemod https://www.sourcemod.net/downloads.php?branch=stable
	- test

- tickrate enabler (CS:S) https://github.com/daemon32/tickrate_enabler/releases/tag/0.5

- ~~DHooks2 https://github.com/peace-maker/DHooks2/releases~~ included in sourcemod 1.11 and higher

- SteamWorks
	- https://github.com/KyleSanderson/SteamWorks/releases
	- https://forums.alliedmods.net/showthread.php?t=229556
	- (latest windows build) https://users.alliedmods.net/~kyles/builds/SteamWorks/SteamWorks-git132-windows.zip

- https://github.com/hermansimensen/eventqueue-fix

- https://github.com/hermansimensen/bash2

- https://github.com/shavitush/Oryx-AC/tree/dev
	- merge some of the prs too

- stripper:source
	- https://forums.alliedmods.net/showthread.php?t=39439
	- http://www.bailopan.net/stripper/snapshots/

- bhoptimer https://github.com/shavitush/bhoptimer/

- https://github.com/Nairdaa/shavit-newmaps

- https://github.com/Haze1337/Sound-Manager

- https://github.com/rtldg/smwhitelist
	- extension needed: https://forums.alliedmods.net/showthread.php?t=162489&page=36#351

- momsurffix2 https://github.com/GAMMACASE/MomSurfFix

- rngfix
	- https://forums.alliedmods.net/showthread.php?t=310825
	- https://github.com/jason-e/rngfix

- (CS:S) https://github.com/PMArkive/random-shavit-bhoptimer-stuff/blob/main/landfix.sp

- https://github.com/GAMMACASE/HeadBugFix

- https://github.com/blankbhop/jhud

- https://github.com/rtldg/sm_closestpos

- https://github.com/rtldg/mpbhops_but_working

- showplayerclips https://github.com/GAMMACASE/ShowPlayerClips

- showtriggers https://github.com/ecsr/showtriggers

- wrsj https://github.com/rtldg/wrsj
	- ripext https://github.com/ErikMinekus/sm-ripext
	- or sm-json https://github.com/clugg/sm-json

- unreal https://github.com/rtldg/unrealphys

- https://github.com/nosoop/SM-PluginMangler
	- `bind p "say !plugins refresh_stale"`

- connect announce https://forums.alliedmods.net/showthread.php?t=77306?t=77306
	- replace eventually

- https://github.com/kidfearless/Misc-Sourcemod-Plugins/blob/master/kid-replaybackups.sp

- ljstats
	- todo: upload error-free version...

- https://github.com/Nairdaa/gap

- shavit's thirdperson.sp https://forums.alliedmods.net/showthread.php?p=1776475

- https://github.com/blankbhop/bhoptimer-firstjumptick

- noslide https://github.com/shavitush/noslide
	- double check works right with timer?

- https://github.com/rtldg/edge-helper

- paint https://forums.alliedmods.net/showthread.php?p=2541664
	- doesn't work properly on doors? fix this eventually...

- https://github.com/rtldg/nfo-websync

- csgo stuff
	- csgo movement unlocker https://forums.alliedmods.net/showthread.php?t=255298
	- https://github.com/hermansimensen/NoViewPunch

- databases
	- shavit
	- ljstats


symlink the maps folder


.cfg files to edit
```
game/cfg/sourcemod/sourcemod.cfg:

sm_datetime_format "%Y/%m/%d - %H:%M:%S"
sm_flood_time 0.20
sm_vote_progress_console 1
sm_vote_progress_client_console 1
```
