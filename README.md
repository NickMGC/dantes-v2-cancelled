

<!--This is the markdown readme. View the pretty format on the webpage
-->
![logo](./art/logos/logo/logoHD.png)
___
# VS Dantes
If you just want to play the mod, play it [here](https://itz-miles.github.io/website/play).

# Building From Source

## Haxe
You must have [the most up-to-date version of Haxe](https://haxe.org/download/) (4.3.1+) in order to compile.

## Visual Studio / Visual Studio Code

Install [Visual Studio Code](https://code.visualstudio.com/download).

For language support, debugging, linting, and documentation, install the [Vs Haxe Extension Pack](https://marketplace.visualstudio.com/items?itemName=vshaxe.haxe-extension-pack).

For Lime / OpenFL project support, install the [Lime Extension](https://marketplace.visualstudio.com/items?itemName=openfl.lime-vscode-extension).

`windows` For compiling the game on windows, install [Visual Studio 19](https://visualstudio.microsoft.com/vs/older-downloads/#visual-studio-2019-and-other-products) and ONLY these components:
```
MSVC v142 - VS 2019 C++ x64/x86 build tools
Windows SDK (10.0.17763.0)
```

## Command Prompt/Terminal

 These methods send you to a terminal, which will be used to install libraries and compile the game.
 
`windows`
```
Vs Code: View > Terminal 

Start Menu: Click on the Start button, type "PowerShell" or "Command Prompt" in the search bar, and select the respective application from the search results.

File Explorer: Navigate to the desired location and enter "powershell" or "cmd" in the address bar to open with the current location set as the working directory.

Run Dialog: Press the Windows key + R to open the Run dialog, type "powershell" or "cmd", and press Enter.
```


## Haxe Module Manager
To install HMM for installing and managing libraries needed for Vs Dantes, run the following command:
`haxelib install hmm`

To install the libraries listed in hmm.json, run the following command:
`haxelib run hmm install`

## Compilation
Run the correlating commands in the terminal that match your build target to compile.

`windows`
```
lime test windows
lime test windows -debug
lime build windows
```

`html5`
``` 
lime test html5
lime test html5 -debug
lime build html5
```

# Credits:

©name ©name ©name ©It'z_Miles - 2023 - Some rights reserved.

Vs Dantes is not an official FUNKIN' product. Not assosiated with The Funkin' Crew.

## Vs Dantes Team
* Flying Felt Boot - Director, Artist, Charter
* Nick - Co-Owner, Artist, Coder, UI Designer, Charter
* SansPZSG - Composer, Charter
* PlankDev - Coder, chad
* MrHat - Concept artist, quality assurance guy
* Iccer - Concept artist
* Abrikos - UX Designer, Beta tester
* Dieloski - Voiced Dantes
* My dad?!?!? - Voiced Dagon
* Miles Fuqua - Developer/Parallax3D <img src="./assets/shared/images/icons/miles.png" width="16">
* github - [contributors](https://github.com/Itz-Miles/vsdantesdevbuildbackstoryfunny/graphs/contributors) <img src= "./assets/shared/images/icons/github.png" width="16">

## Special Thanks
* Dieloski - Moral help
* Alex_km - Helped with Dantes sprites
* Sheeesh - Helped with menuBG art
* D4rkwinged - Made chromatic scales for Dagon and Me lol
* FistiQ - Made chromatic scales for Monster Dantes
* Cracsthor - Made Phamton Muff

## Psych Engine
* Shadow Mario - Programmer/Owner of Psych <img src="./assets/shared/images/icons/shadowmario.png" width="16">
* shubs - New Input System <img src="./assets/shared/images/icons/shubs.png" width="16">
* PolybiusProxy - HxCodec Video Support <img src="./assets/shared/images/icons/polybiusproxy.png" width="16">
* Keoiki - Note Splash Animations <img src="./assets/shared/images/icons/keoiki.png" width="16">
* github - [contributors](https://github.com/ShadowMario/FNF-PsychEngine/graphs/contributors) <img src= "./assets/shared/images/icons/github.png" width="16">

## Funkin' Crew
* ninjamuffin99 - Programmer of Friday Night Funkin' <img src="./assets/shared/images/icons/ninjamuffin99.png" width="16">
* PhantomArcade -	Animator of Friday Night Funkin' <img src="./assets/shared/images/icons/phantomarcade.png" width="16">
* evilsk8r - Artist of Friday Night Funkin' <img src="./assets/shared/images/icons/evilsk8r.png" width="16">
* kawaisprite - Composer of Friday Night Funkin' <img src="./assets/shared/images/icons/kawaisprite.png" width="16">
* github - [contributors](https://github.com/FunkinCrew/Funkin/graphs/contributors) <img src= "./assets/shared/images/icons/github.png" width="16">

