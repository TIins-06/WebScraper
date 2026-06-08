Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "C:\Users\GZ060\Desktop\AI??\Workers\WebScraper"
WshShell.Run "python server.py", 0, False
