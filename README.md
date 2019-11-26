# Ray Tracer
Custom simply 3D rendering engine as part of my 2019 [Pingry ISP project](https://www.pingry.org/teaching-learning/upper-school/the-pingry-independent-senior-project).

[Demo Video](https://youtu.be/qZ-yG2kiIX8)

### Background and Description
I came up with my idea for my ISP because of all the computer science projects I had worked on at Pingry. Traditionally, computer science and art seem are taught as separate disciplines. Since I opted to take mostly science classes at Pingry, I wanted to take some time to explore the overlap with art. As such, I became fascinated with 3D animation, which is a tool used in most modern animated films. I had always wondered how it worked and wanted to try it out for myself. I wanted to try and make something similar to that myself, and explored many different parts of the field before deciding on one specific part to focus on.

I ended up looking into the math of how the 2D pictures you see on the screen are generated from 3 dimensional complex shapes. This is what is known as a 3D rendering engine and is what I coded for my ISP. I spent most of my time of my time on this project doing research into the different techniques people use to render objects. It turns out to be a deceptively complex task to just "take a picture" of the state of all the objects, so I had to learn math beyond what I had learned at Pingry. Dr. Jolly, my ISP mentor, was an enormous help in this aspect, because she has a lot of experience with computer vision, which relies on similar mathematical techniques. 

My final deliverable is a very simple video clip that shows triangles, moving lights, and the camera moving through space, all generated using my custom renderer to demonstrate the various features I implemented.

### Files
 All the main code is included in `CustomRayTracer.pde` which is Java code for [Processing 3.5.3](https://processing.org/)
