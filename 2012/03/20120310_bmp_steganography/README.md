BMP Steganography example
=========================
Io Codejam - 2012310


This is a short example of digital steganography, or hiding information in plain sight.

This program hides one file (of any type) inside of another file (a 24-bit uncompressed bitmap image).

There are a few limitations, most notably the secret file cannot be larger in bytes than the image is in resolution.

How does it work?
-----------------

This works by hiding 1 byte of the secret file in every 3 bytes (or 1 pixel) of the cover file.  The least significant bits of each pixel's color values are used to hide the information.  3 bits are used for blue and red, and 2 for green, making 8 bits, or 1 byte per pixel.  Before the payload, there is a simple 4 byte header containing the length of the payload in bytes.


To encode a file:
  
    ./steg.io cover.bmp steg.io secret.bmp
    
This will create a file, secret.bmp, which is the file cover.bmp with the data from steg.io encoded within it.

To decode:

    ./steg.io secret.bmp decoded.txt
    
This will take the file secret.bmp and create a new file, decoded.txt, consisting of the data hidden in the pixel values.

Enjoy!
