import time

last_word = False  # Set flag True for work option
selected_text = False  # Set flag True for work option
all_line = True  # Set flag True for work option
text_copied = ""
clipboard_saved_string = ""
layout_01 = "`~@#$%^&" + \
            "qwertyuiop[]QWERTYUIOP{}asdfghjkl;'\\ASDFGHJKL:\"|zxcvbnm,./ZXCVBNM<>?"
layout_02 = "ёЁ\"№;%:?" + \
            "йцукенгшщзхъЙЦУКЕНГШЩЗХЪфывапролджэ\\ФЫВАПРОЛДЖЭ/ячсмитьбю.ЯЧСМИТЬБЮ,"

def computing():
    workaround()


def workaround():
    clipboard.fill_clipboard("empty")
    time.sleep(.1)
    if all_line:
        keyboard.send_keys("<shift>+<home>")
    elif selected_text:
        keyboard.send_keys("<ctrl>+c")
    elif last_word:
        time.sleep(.1)
        keyboard.send_keys("<shift>+<ctrl>+<left>")
    else:
        quit()
    time.sleep(.1)
    text_copied = clipboard.get_selection()
    fixed_text = magic(text_copied)
    time.sleep(0.1)
    clipboard.fill_clipboard(fixed_text)
    time.sleep(0.1)
    keyboard.send_keys("<ctrl>+v")


def magic(text):
    if len(text) < 1:
        quit()
    elif len(text) < 3:  # Сравним каких символов больше
        first_x = 1  # Для сравнения желательны нечётные числа
    else:
        first_x = 3

    chars_01, chars_02 = 0, 0
    for i in range(first_x):  # Какой раскладки первых символов больше: 01 или 02?
        if text[i] in layout_01:
            chars_01 += 1
        elif text[i] in layout_02:
            chars_02 += 1
    if chars_01 > chars_02:  # Разные последовательности, исходя из полученного
        layout = layout_01 + layout_02 + layout_01
    else:
        layout = layout_02 + layout_01 + layout_02

    new_text = ""
    for c in range(len(text)):  # Пропуск символов, которых "нет в раскладках"
        if not text[c] in layout:
            new_text = new_text + text[c]
        else:
            new_text = new_text + layout[layout.find(text[c]) + len(layout_01)]
    return new_text

clipboard_saved_string = clipboard.get_clipboard()
# Сохранение текущего содержимого буфера обмена
computing()
time.sleep(0.1)
clipboard.fill_clipboard(clipboard_saved_string)  # Восстановление содержимого буфера обмена
clipboard_saved_string = ""
