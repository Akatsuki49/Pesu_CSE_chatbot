# sahai

A new Flutter project under the chairperson of the Department of CSE,PESU.
Current status: Awaiting deployment and bug fixes

TODO: SAHAI:

Frontend:
* chat screen throwing exception for multiple line message
* login screen white portion should be till bottom of the screen
* login screen use mediaquery 
make sure login screen says department not dept
* UI for credits page
* UI for guestchat to be same as textchatscreen
chatscreen lagging rpoblem fix
* audiobutton on textchatscreen not redirecting to voicechatscreen fix
colour of drawer fix
* remove unnecessary tiles from drawer or add something in them
see if keyboard popping up only first time user opens the app possible (instead of everytime the chat screen is opened)
* add admin login(seperate site fr this) 
* add accessing all submitted questions screen that only admin has access to
try out haptic response on a new phone (sid will do)


ADDITIONS : 
LOGOUT IS INCOMPLETE, I HAVE ADDED THE SHARED PREF PART EARLIER BUT NOT WORKED OVER IT PROPERLY, IF POSSIBLE PLS LOOK INTO THAT

USE A SEPERATE FOLDER FOR CALLING API - REPO LAYER 

# 2/3/2025
## To run Sah.ai on android:
1) Have an android emulator with api 34 or above(currently using 34)
2) Allocate at least 8Gb of RAM, 2GB of VM heap, and 5 HB internal storage
3) Flutter version is at 3.29.9 and Dart is at 3.7.0
4) Then clone this repo and run on emulator

## To run Sah.ai on ios:
1) IOS simulator xcode with 18.2 ios installed
2) Change runner platform to ios 13.0 min
