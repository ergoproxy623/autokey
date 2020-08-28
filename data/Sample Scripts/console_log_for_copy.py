import time
import re
time.sleep(0.25)
text = clipboard.get_selection()
time.sleep(0.25)
text = text.replace(';', '')
time.sleep(0.25)
keyboard.send_key("<right>")
time.sleep(0.25)
keyboard.send_key("<enter>")
time.sleep(0.25)
keyboard.send_keys("console.log( %s )" % text)