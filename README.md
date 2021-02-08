# TuyaDAEMON project

_**TuyaDAEMON's goal is not to control some Tuya devices but to integrate the entire Tuya ecosystem in node-red, creating a new level of abstraction that includes both Tuya-cloud and all possible extensions: custom devices and logic of extended automation.**_

**Tuya ecosystem:**([_source Tuya_](https://developer.tuya.com/en/docs/iot/open-api/platform-overview/solution-overview))

![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/network_architecture.png)


_All the details of the communication are resolved by **tuyaDAEMON**, using 3 bidirectional communication channels transparently to the user:_

### LOW LEVEL MQTT (see tuya [DEAMON core](./tuyaDAEMON/README.md))

Using [node-red-contrib-tuya-smart-device](https://github.com/vinodsr/node-red-contrib-tuya-smart-device) you can exchange local MQTT communications with many Tuya devices. You receive notifications of device status changes regardless of the cause: Tuya-cloud, smartlife app, voice control. And vice versa, the commands sent by **tuyaDAEMON** are executed by the devices and all the app interfaces are kept updated in real-time. 

### HIGH LEVEL TRIGGER (see [tuyaTRIGGER](./tuyaTRIGGER/README.md))
The TRIGGERs do not connect to individual devices, but create a direct and bidirectional connection with Tuya-cloud events and 'automation', allowing complete control from anywhere of both the smartlife logic and the devices not handled by LOW-LEVEL MQTT channel (user can define 'mirror' devices: see ['siren mirror'](./extra/siren%20mirror/README.md)).

  Example: _Using a “Smart Home Infrared Universal Remote Controller” device you have replicas of the various remote controls on your smartphone, even better than those I had developed in 2016 (see [remoteDB](https://github.com/msillano/remotesDB)). Very well: thanks to Tuya I can now control 2 televisions, a monitor, an air conditioner, a DVB tuner, and a TV-top-box from my smartphone! There are some limitations: voice commands cannot be used, moreover, since the device does not use the MQTT protocol, it cannot be controlled at LOW LEVEL._
  _However, **Tuya-cloud** resources can be used to create a 'scene' with the sequence of commands needed to tune a TV channel, e.g. "Rai 3 HD", on the living room television. As icon I will use the RAI3 logo, as name 'tune rai three'. Now I can use the voice command: "Hey Google, run tune Rai three"!_
  _A_ "mirror" device _standardizes this behavior in **tuyaDEAMON**, using TRIGGERS to execute commands. I can now create a node-red automation, which, if I am at home, automatically turns on the television and tunes in RAI 3 when my favorite TV series is on the air!_
````  
              tuyastatus: object
                    living.tv: object
                         channel: "RAI3 HD"
                         comment: "available: 'RAI1 HD’,’RAI2 HD’,’RAI3 HD’..."
````

### CUSTOM CHANNEL (see [_system](./tuyaDAEMON/README.md) 'fake' device)
Simple **node-red** flows constitute the interfaces to HD and SW resources, allowing the insertion of external resources, not tuya-compatible, into the system. A very useful two-tier model, consisting of a first-level represented by **tuyaDAEMON**, which standardizes the various sources and devices, to provide all data and commands in a homogeneous way to the _higher application level_. Custom channels are implemented additively with specialized flows, one for each 'fake' device.

Example: _I also want to integrate some 24H weather forecasts with [weathermaps](https://openweathermap.org/) and local PM10 measurements (with ad hoc [HW, serial USB interface](https://www.banggood.com/search/pm2.5-pm10-detector-module-dust-sensor-2.8-inch-lcd.html)) into the system for better management of both the internal air conditioning and the outdoor terrace watering system. Two 'fake' devices can be defined:_ 
````
            tuyastatus: object
                  weather 24H: object
                        _id: "8fa7972******"
                        _appid: "b1b15e88fa79722541******"
                        tmin: "3.5"
                        tmax: "11.8"
                        rain: "5"
                  air quality: object
                        PM10: "3.5"
                        PM2.5: "11.8"
                        PM10 today: [3.6,3.6,3.7,4.1, 4.3, 3.9,3.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
````

  _Two simple **node-red** flows update this data, say every hour._

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
  - _GET:_ `http://localhost:1984/tuyaDAEMON?device=tuya_bridge&property=switch`
    - answer:`{"device":"tuya_bridge","property":"switch","value":"OFF"}`
 - _SET:_ `http://localhost:1984/tuyaDAEMON?device=tuya_bridge&property=switch&value=OFF`
    - answer: `{"status":"sended"}`
 - _SCHEMA:_ `http://localhost:1984/tuyaDAEMON?device=tuya_bridge`.
    - answer: `{"_connected":true,"_t":1611594148,"reserved (trigger)":0,"switch":"OFF"}`
 - _LIST devices:_ `http://localhost:1984/tuyaDAEMON`.
    - answer: `["Zigbee Gateway","Smart IR 1","HAL@home","BLE MESH（SIG）Gateway","tuya_bridge","Temperature living", "Door sensor","USB siren","PIR sensor","external T"]`

note: all devices accept 'GET' and 'SCHEMA' requests via _fast REST_. 

A second [_**debug REST**_](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-REST) interface is synchronous and dedicated to development applications.
See, as an example, [tuyaDAEMON.toolkit](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-toolkit), a PHP application to help devices management.

### DataBase interface

 **TuyaDEAMON** automatically logs user select messages and measurements on a DB table (`'messages'`), a useful option for control, analysis and statistics.
 
_If you are interested in the reasons behind the tuyaDAEMON's project choices, you can read [why-tuyaDEAMON](https://github.com/msillano/tuyaDAEMON/wiki/why-tuyaDAEMON-%3F) - In italiano: [perché-tuyaDAEMON](perché-tuyaDEAMON.pdf)._ 



