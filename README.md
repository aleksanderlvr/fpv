# fpv

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
