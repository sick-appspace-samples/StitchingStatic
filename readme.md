## StitchingStatic
Demonstrating image stitching in a static scene using several 2D cameras.
### Description
This sample performs stitching in a non-moving scene. That is the same object was observed at the same time by multiple devices. The images must have a decent overlap for plane estimation to work. If a good plane estimate is already available, stitching can be performed with plane estimation off.
In this particular case the data used is the same for other samples this means, that some of the image pairs are in fact taken at different times. There is
logic in the app that compensates for this.

### How to Run
Starting this sample is possible either by running the App (F5) or debugging (F7+F10). Setting breakpoint on the first row inside the 'main' function allows debugging step-by-step after 'Engine.OnStarted' event. Results can be seen in the image viewer on the DevicePage. Restarting the Sample may be necessary to show images after loading the web-page.
To run this Sample a device with SICK Algorithm API and AppEngine >= V2.8.0 is required. For example SIM4000 with latest firmware. Alternatively the Emulator in AppStudio 2.4 or higher can be used.

### Topics
Algorithm, Image-2D, Stitching, Sample, SICK-AppSpace
