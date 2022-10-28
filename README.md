#docker_lxde

This project aims at providing a minimal Ubuntu with LXDE desktop inside a Docker container.

The good reason to do this is related with teaching. Using a Docker container prepared by the teacher and shared in a BYOD (bring your own device) class it is possible to provide the same learning experience to all students, without dependencies form the Operating System installed on the personal devices. An alternative approach is based on the VirtualBox tool, which, based on previous experiences (here reference to labreti5 repo), is less immediate and depends of a number of OS dependent adjustments.

The internal architecture of the Docker is made of three main functions:

  * a desktop environment providing a comfortable graphical interface. We have used LXDE, which is lightweight and easy to use.
  * an X server that bridges the X graphical interface through VNC. We used the TightVNC, a stable and actively maintained product with a long history
  * a VNC client that renders the VNC interface through a web server. For this we used the novnc tool

In conclusion, the user reaches the dockerized desktop across a browser.

To configure his/her computer the student has to:

  * install the "Docker Desktop" application on the computer
  * download a script that builds the dockerized desktop: a long download operation is needed the first time it is used
  * builds the container from the command line

To use the desktop container the student 

  * opens the Docker Desktop application
  * launches the desktop container from the Docker Desktop graphical interface
  * browses the URL https://localhost:8060

Only one command line operation is required, and, once the container is built, the container is readily deployed and accessed with mouse operations.