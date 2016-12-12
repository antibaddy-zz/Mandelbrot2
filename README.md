## Synopsis

Simple Mandelbrot Set generator for Processing 3.

![alt tag](https://github.com/antibaddy/Mandelbrot2/blob/master/screenshot.png)

## Motivation

I discovered Processing 3 via this [Youtube video](https://www.youtube.com/watch?v=fAsaSkmbF5s) and as an exercise in learning how to use it, I decided to enhance the example code so that the set is coloured and can be zoomed.

## Installation

Install Processing 3 first. Download here https://processing.org/download/?processing
Open Mandelbrot2.pde in the Processing IDE.


## Usage

- To zoom, just select an area with the mouse.
- To reset the display, press ESC


## Caveats

- Requires a square 'canvas' at present. Need to add height scaling for 'mapped' values
- Zoom feature will eventually hit the limit for the 32 bit float type
- Zoom feature assumes a square canvas
- The image is not cached and so recomputed each time the draw() function is executed.


## Contributors

Code for the Mandelbrot set is based on the [example code](https://processing.org/examples/mandelbrot.html) provided with the Processing 3 IDE.

Code for the selection rectangle is based on [sample code](http://studio.sketchpad.cc/sp/pad/view/RgPVoxbKp3/rev.1253.html) written by [Dimitry K](Dimitry K).

## License

This code is licensed under the [Creative Commons Attribution-Share Alike 3.0 License](http://creativecommons.org/licenses/by-sa/3.0/).
