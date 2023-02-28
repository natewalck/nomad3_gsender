# Nomad 3 gSender configs

These configurations are for use with the [Carbide 3D Nomad 3](https://shop.carbide3d.com/collections/cnc-machines/products/nomad-3) using the [Sienci gSender g-code sender](https://github.com/Sienci-Labs/gsender)


Hardware
--------
These configs cover using the BitZero v2 which comes with the Nomad 3.

To use the 3D Probe, you will need additional hardware:
* [CNC 3D Edge Finder](https://www.amazon.com/dp/B0B46Y6GG7)
* [Mini XLR to XLR](https://www.amazon.com/dp/B09NN3MX9V)

To get the probe hooked up correctly, you will need to use a multimeter to identify the order of the wires in the BitZero port (Mini-XLR).

[crpalmer](https://github.com/crpalmer) mentioned a method for figuring this out on the Carbide 3D Community forum:
```
The pinout of the bit zero on the pro is (+V, gnd, signal) which is what is needed for the probe. I forget exactly how the shapeoko pins are ordered, but I figured it out with a multimeter (identify ground then use it to identify +V and that leaves the signal pin).
```

When the 3D Probe is hooked up correctly, there will be a green light on by default which turns red when the probe has been triggered. Test this *before* actually trying to use it on stock.

To see it in action, check out the YouTube video here: https://www.youtube.com/watch?v=egqN0CKX2lw

Quick Start
-----------
The quickest way to get started is as follows:
* Import config.json
* Import macros.json

This will pre-populate a basic Nomad 3 config and macros for the BitZero and 3D Probe.

Additionally, a tool change macro will be configured which runs the BitSetter Tool Change macro. This has not been thoroughly tested, so *be cautious*.

Additional notes
----------------
* When the door opens, it triggers a feed hold. The only way I could figure out how to resume was by typing `~` into the console to resume. There should be a way to do this on door close, but I have not figured that part out yet.
* Sometimes a fast jog will go just a little bit too far and trigger the Z endstop, causing an alarm and halting the machine. If you resume and move in Z negative position a few times, it'll get out of this state.
