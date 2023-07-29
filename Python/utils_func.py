import os

import cv2
import numpy as np


def make_dir(dir_name):
    if not os.path.exists(dir_name):
        os.mkdir(dir_name)


def remove_file(filename):
    if os.path.exists(filename):
        os.remove(filename)


def resize_image(image, percent=0.5):
    h, w, _ = image.shape
    h, w = int(h * percent), int(w * percent)
    image = cv2.resize(image, (w, h))
    return image, h, w


def resize_original(image, height, width):
    image = cv2.resize(image, (width, height))
    return image


def calculate_angle(a, b, c):
    a = np.array(a)  # First
    b = np.array(b)  # Mid
    c = np.array(c)  # End

    radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
    angle = np.abs(radians * 180.0 / np.pi)

    if angle > 180.0:
        angle = 360 - angle

    return round(angle, 1)


def calculate_slope(x1, y1, x2, y2):
    m = (y2 - y1) / (x2 - x1)
    return m
