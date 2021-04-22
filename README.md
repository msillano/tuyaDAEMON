# TuyaDAEMON project

_**TuyaDAEMON's goal is not to control some Tuya devices but to integrate the entire Tuya ecosystem in node-red, creating a new level of abstraction that includes both Tuya-cloud and all possible extensions: custom devices and logic of extended automation.**_

**Tuya ecosystem:**([_source Tuya_](https://developer.tuya.com/en/docs/iot/open-api/platform-overview/solution-overview))

![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/network_architecture.png)


_All the details of the communication are resolved by **tuyaDAEMON**, using 3 bidirectional communication channels transparently to the user:_

### LOW LEVEL MQTT (see tuya [DEAMON core](./tuyaDAEMON/README.md))

Using [node-red-contrib-tuya-smart-device](https://github.com/vinodsr/node-red-contrib-tuya-smart-device) you can exchange local MQTT communications with many Tuya devices. You receive notifications of device status changes regardless of the cause: Tuya-cloud, smartlife app, voice control. And vice versa, the commands sent by **tuyaDAEMON** are executed by the devices and all the app interfaces are kept updated in real-time. 

### HIGH LEVEL TRIGGER (see [tuyaTRIGGER](./tuyaTRIGGER/README.md))
The TRIGGERs do not connect to individual devices, but create a direct and bidirectional connection with Tuya-cloud events and 'automation', allowing complete control from anywhere of both the smartlife logic and the devices not handled by LOW-LEVEL MQTT channel (user can define 'mirror' devices: see ['Smoke detector'](https://github.com/msillano/tuyaDAEMON/wiki/mirror-device-'Smoke_Detector':-case-study)).

  Example: _Using a “Smart Home Infrared Universal Remote Controller” device you have replicas of the various remote controls on your smartphone, even better than those I had developed in 2016 (see [remoteDB](https://github.com/msillano/remotesDB)). Very well: thanks to Tuya I can now control 2 televisions, a monitor, an air conditioner, a DVB tuner, and a TV-top-box from my smartphone! There are some limitations: voice commands cannot be used, moreover, since the device does not use the MQTT protocol, it cannot be controlled at LOW LEVEL._
  _However, **Tuya-cloud** resources can be used to create a 'scene' with the sequence of commands needed to tune a TV channel, e.g. "Rai 3 HD", on the living room television. As icon I will use the RAI3 logo, as name 'tune RAI three'. Now I can use the voice command: "Hey Google, run tune Rai three"!_
  _A_ "mirror" device _standardizes this behavior in **tuyaDEAMON**, using TRIGGERS to execute commands. I can now create a node-red automation, which, if I am at home, automatically turns on the television and tunes in RAI 3 when my favorite TV series is on the air!_
````  
              tuyastatus: object
                    living.tv: object
                         channel: "RAI3 HD"
                         comment: "available: 'RAI1 HD’,’RAI2 HD’,’RAI3 HD’..."
````

### CUSTOM CHANNEL (e.g. __system_ 'fake' device)

Simple **node-red** flows constitute the interfaces to HD and SW resources, allowing the insertion of external resources, not tuya-compatible, into the system. A very useful two-tier model, consisting of a first-level represented by **tuyaDAEMON**, which standardizes the various sources and devices, to provide all data and commands in a homogeneous way to the _higher application level_. Custom channels are implemented additively with specialized flows, one for each 'fake' device. In many cases is a simple protocol interface, see [PM detector](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-'PM-detector':-case-study), that integrates a device that uses USB-COM interface.
Since the version 2.0 a generalized OO perspective, in a distributed environement, adds more power to tuyaDAEMON. It is easy to finalize the tuyaDAEMON resources in integratet projects, OO-oriented, with UI and many base devices: see [watering_sys](https://github.com/msillano/tuyaDAEMON/wiki/derived-device-'watering_sys':-case-study), a terrace watering timer, with fuzzy wheater control.

**_From version 2.0 tuyaDAEMON is a complete framework for advanced custom IOT project._**

----------------------

### node-red interfaces

**TuyaDAEMON** has a high-level interface for custom node-red logic and applications: in reading, the data of all devices are available in an RT updated global object, with a _device:capability:value_ hierarchy and names were chosen by the user.
Example:
````
              tuyastatus: object
                   humidifier: object
                       _connected: true
                       spray: "OFF"
                       output: "small"
````
In writing, the state change requests for all devices take the form of a node-red message:
````
              payload: object
                    device: "humidifier"
                    property: "spray"
                    value: "ON"
````
### REST interfaces

To make easier the interoperability with external applications, tuyaDEAMON offers also a [_**fast REST**_](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-REST) asynchronous interface with an immediate JSON response:
_Examples:_
 _Since ver. 2.0:_
 - _SET:_ `http://localhost:1984/tuyaDAEMON?device=tuya_bridge&property=relay&value=OFF`
     - answer: `{"device":"tuya_bridge","property":"switch","status":"sent"}`
 - _GET:_ `http://localhost:1984/tuyaDAEMON?device=tuya_bridge&property=relay`
     - answer: `{"device":"tuya_bridge","property":"relay","value":"ON"}`
 - _SCHEMA:_ `http://localhost:1984/tuyaDAEMON?device=tuya_bridge`.
     - answer: `{"device":"tuya_bridge","schema":{"_connected":true,"_t":1616865119,"trigger (reserved)":0,"relay":"ON","restart status":"memory"}}`
 - _LIST devices:_ `http://localhost:1984/tuyaDAEMON`.
    - answer: `{"list":["Zigbee Gateway","Smart IR 1","HAL@home","BLE MESH（SIG）Gateway","tuya_bridge","Temperature living", "Door sensor","USB siren","PIR sensor"]}`
 - _ERROR:_   `{"status":"ERROR: not found the property (switch) in 'tuya_bridge'"}`
 - _ERROR:_   `{"status":"ERROR: not found the device 'tuya_trigger'"}`
  
note: all devices accept 'GET' and 'SCHEMA' requests via _fast REST_. 

A second [_**debug REST**_](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-REST) interface is synchronous and dedicated to development applications.
See, as an example, [tuyaDAEMON.toolkit](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-toolkit), a PHP application to help users manage devices.

### DataBase interface

 **TuyaDEAMON** automatically logs user select messages and measurements on an optional DB table (`'messages'`), a useful option for control, analysis, and statistics.
  _Since ver. 2.0:_
 
 ![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/dbtuyathome03.png)
 
 --------------------
### Version 2.0
 
_With the version 2.0 tuyaDAEMON reaches 2 milestones: the ability to use and create custom devices in a [hierarchical OO perspective](https://github.com/msillano/tuyaDAEMON/wiki/ver.-2.0--milestones#oo-devices), and the ability to create distributed [TuyaDAEMON network](https://github.com/msillano/tuyaDAEMON/wiki/ver.-2.0--milestones#networking-tuyadaemon)._
 
-----------------
- _If you are interested in the reasons behind the tuyaDAEMON's project choices, you can read [why-tuyaDEAMON](https://github.com/msillano/tuyaDAEMON/wiki/why-tuyaDAEMON-%3F) - In italiano: [perché-tuyaDAEMON](perché-tuyaDEAMON.pdf)._ 

- For more documentation see also the [wiki](https://github.com/msillano/tuyaDAEMON/wiki).

