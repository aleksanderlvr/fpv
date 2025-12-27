# fpv

Telemetry screen - EdgeTX v. 2.11.0 - GX12

The LUA file can only be edited in a suitable editor, see below. It must not contain so-called BOM characters. The file name must not be longer than 6 characters, otherwise the GX12 will ignore the file.


Display Elements Detail
Row 1 - Situational Awareness

Flight Mode (3 char): MAN, STB, RTL, etc.
GPS Satellites: "S##" format (blinks if <10)
HDOP: "H#.#" format (displayed only if <10)
Link Quality: Percentage or RSSI in dBm

Row 2 & 3 - Power System

Battery Voltage: ##.#V format (blinks if below warning threshold)
Current Draw: #.#A format
Battery Percentage: ##% format (blinks if <20%)
Capacity Used: #.##Ah format

Row 4 & 5 - Navigation

Distance from Home: #.#km format (medium font)
Altitude MSL: ###m format
Ground Speed: ##kph format
Heading: @### degrees format
ETA: Minutes:seconds to home at cruise speed

Row 6 - Alert Status
Priority-based warning display (highest priority shown):

RTL ACTIVE (flashing, inverted text)
BATTERY CRITICAL (<14.0V, inverted text)
LOW GPS (<10 satellites, inverted text)
BATTERY LOW (<14.8V, inverted text)
WEAK SIGNAL (<-80 dBm, inverted text)
ALL OK (normal operations)

-----------------------------------
 MAN    S12  H1.2            95%        
-----------------------------------
 16.4V      2.5A              87%       
 0.45Ah                       
-----------------------------------
 2.5km      125m                        
 55kph  @045         2:43               
----------------------------------
              ALL OK
----------------------------------

Possible editors:

1. Visual Studio Code (VS Code)
Set encoding without BOM:
Click the encoding label in the bottom status bar (e.g., UTF-8).
Choose Save with encoding → UTF-8 (not “UTF-8 with BOM”).
Also configurable in settings:
“files.encoding”: “utf8”

2. Sublime Text
Default is UTF-8 without BOM.
To make sure:
File → Save with Encoding → UTF-8
Avoid choosing UTF-8 with BOM.

3. Notepad++
Go to Encoding menu.
Select UTF-8 (without BOM).
Then save the file.

4. Atom
Default is UTF-8 without BOM.
Can confirm/change via:
Bottom right encoding status → select UTF-8 (no BOM).

5. JetBrains IDEs (IntelliJ, PyCharm, WebStorm, etc.)
File → File Encoding → UTF-8
Usually BOM-less by default, but you can confirm in Settings.

6. nano (terminal editor)
Saves plain text by default — no BOM unless manually inserted.
Just edit and save normally.

7. Vim / Neovim
Ensure no BOM with:
:set nobomb
:w
This ensures the UTF-8 file is BOM-free.

8. Emacs
Save with:
C-x RET f utf-8 RET
C-x C-s

Ensures UTF-8 without BOM.

🧠 Notes on BOM
BOM (Byte Order Mark) is not needed for UTF-8 and can cause problems in contexts like:
HTML/JS serving on the web
Compilers (e.g., C/C++/Java)
Scripts (Python, shell)
Most tools default to UTF-8 without BOM today.
