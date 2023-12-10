import cv2
import numpy as np


def image_to_numpy(fname):
    """
    Convert an image to a numpy array
    """
    # return iio.imread(fname)
    return cv2.imread(fname, cv2.IMREAD_UNCHANGED)


def img2coe4444(image_filename, coe_filename):
    """
    Convert an image to a coe file for use in Vivado.
    Each channel is 4 bits wide (including alpha).
    """
    # read in image
    image = image_to_numpy(image_filename)
    # get image dimensions
    height = image.shape[0]
    width = image.shape[1]
    channels = image.shape[2]
    # check if image is RGBA
    if channels != 4:
        raise ValueError('Image must be RGBA')
    # open coe file
    with open(coe_filename, 'w') as f:
        # write header
        f.write('memory_initialization_radix=16;\n')
        f.write('memory_initialization_vector=\n')
        # write image data
        for y in range(height):
            for x in range(width):
                # get pixel
                pixel = image[y, x]
                # get pixel data
                r = pixel[0]
                g = pixel[1]
                b = pixel[2]
                a = pixel[3]
                # convert to 4-bit
                r = r >> 4
                g = g >> 4
                b = b >> 4
                a = a >> 4
                # write to file
                f.write('{:01X}{:01X}{:01X}{:01X},'.format(a, r, g, b))
            # write newline
            f.write('\n')
        # write footer
        f.write(';')


def img2rom4444(image_filename, rom_filename):
    """
    Convert an image to a rom file for use in the inferred ROM.
    The rom file must be a text files with just the binary values (instead of hex).
    No header or footer is needed, just the image data. One word per line.
    """
    # read in image
    image = image_to_numpy(image_filename)
    # get image dimensions
    height = image.shape[0]
    width = image.shape[1]
    channels = image.shape[2]
    # check if image is RGBA
    if channels != 4:
        raise ValueError('Image must be RGBA')
    # open rom file
    with open(rom_filename, 'w') as f:
        # write image data
        for y in range(height):
            for x in range(width):
                # get pixel
                pixel = image[y, x]
                # get pixel data
                r = pixel[0]
                g = pixel[1]
                b = pixel[2]
                a = pixel[3]
                # convert to 4-bit
                r = r >> 4
                g = g >> 4
                b = b >> 4
                a = a >> 4
                line = ''
                pixel_num = r + (g << 4) + (b << 8) + (a << 12)
                for i in range(16):
                    if pixel_num & (1 << i) != 0:
                        line = '1' + line
                    else:
                        line = '0' + line
                # assert that line is 16 bits
                assert len(line) == 16
                # write to file
                f.write(line + '\n')


if __name__ == '__main__':
    # img2coe4444('forest_tiles_fixed.png', 'forest_tiles_fixed.coe')
    img2rom4444('forest_tiles_fixed.png', 'forest_tiles_fixed.rom')
