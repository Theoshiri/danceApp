import datetime
from tkinter import *

import cv2
from PIL import Image, ImageTk

root = Tk()
root.title('Camera App')
# root.geometry('640x520')
root.minsize(646, 530)
root.maxsize(646, 530)
root.configure(bg='#58F')

cap = cv2.VideoCapture(0)
if (cap.isOpened() == False):
    print("Unable to read camera feed")


def captureImage():
    image = Image.fromarray(img1)
    time = str(datetime.datetime.now().today()).replace(':', "_") + '.jpg'
    image.save(time)


def exitWindow():
    cap.release()
    cv2.destroyAllWindows()
    root.destroy()
    root.quit()


f1 = LabelFrame(root, bg='red')
f1.pack()
l1 = Label(f1, bg='red')
l1.pack()

b2 = Button(root, fg='white', bg='red', activebackground='white', activeforeground='red', text='EXIT ❌ ', relief=RIDGE,
            height=200, width=20, command=exitWindow)
b2.pack(side=LEFT, padx=40, pady=5)

while True:
    img = cap.read()[1]
    img = cv2.flip(img, 1)
    img1 = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    img = ImageTk.PhotoImage(Image.fromarray(img1))
    l1['image'] = img
    root.update()
