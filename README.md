# TuyaDAEMON project

_**TuyaDAEMON's goal is not to control some Tuya devices but to integrate the entire Tuya ecosystem in node-red, creating a new level of abstraction that includes both Tuya-cloud and all possible extensions: MQTT and custom devices and logic of extended automation.**_

**Tuya ecosystem:**([_source Tuya_](https://developer.tuya.com/en/docs/iot/open-api/platform-overview/solution-overview))

![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/network_architecture.png)

### Advanced features that make tuyaDAEMON unique
1. Open, modular, [full documented](https://github.com/msillano/tuyaDAEMON/wiki): expressly designed for every customization need.
2. Powerful control meta-language ([command chains](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-as-event-processor#share-and-command-chains)) with an expressive power (Turing complete) not found in other IOT environments, usually limited to "IF ... THEN" automation (see [also here](https://github.com/msillano/tuyaDAEMON/wiki/why-tuyaDAEMON-%3F#2-what-is-meant-by-integrated)).
3. [ObjectOriented](https://github.com/msillano/tuyaDAEMON/wiki/ver.-2.0--milestones#oo-devices) approach for structuring super-devices that use more than one elementary device.
4. [Meta-tools](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-toolkit) for device test, definition and maintenance activities.

<hr>
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

### CUSTOM CHANNEL (see [system](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-_system) a 'fake' device)

Simple **node-red** flows constitute the interfaces to HD and SW resources, allowing the insertion of external devices, not tuya-compatible, into the system. A very useful two-tier model, consisting of a first-level represented by **tuyaDAEMON** processor, which standardizes the various sources and devices, to provide all data and commands in a homogeneous way to the _higher application level_. 

**Custom channels** are implemented additively with specialized flows, to implement 'fake' devices. 

In many cases the required interface is a simple protocol adapter, like in case of [MQTT devices](https://github.com/msillano/tuyaDAEMON/blob/main/devices/Ozone_PDMtimer/device_Ozone_PDMtimer.pdf) or in case of [PM detector](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-'PM-detector':-case-study), a device that uses USB-COM interface.

In the case of the '433 MHZ sensor gateway', the module includes a specialized adapter for each device, such as the
[weather station](https://github.com/msillano/tuyaDAEMON/wiki/case-study:-433-MHz-weather-station) which uses 3 sensors (temperature, wind, rain).

Since the version 2.0 the generalized [OO perspective](https://github.com/msillano/tuyaDAEMON/wiki/ver.-2.0--milestones#oo-devices), in a [distributed environement](https://github.com/msillano/tuyaDAEMON/wiki/ver.-2.0--milestones#networking-tuyadaemon), adds more power to tuyaDAEMON. It is easy to finalize the tuyaDAEMON resources in integrated projects, OO-oriented, with UI and many base devices: see as example the device [watering_sys](https://github.com/msillano/tuyaDAEMON/wiki/derived-device-'watering_sys':-case-study), a terrace watering timer with UI, fuzzy control from wheater, build using using 3 tuya devices.

**_From version 2.0 tuyaDAEMON is a complete framework for advanced custom IOT projects._**

----------------------

### node-red interfaces

**TuyaDAEMON** has a high-level interface for custom node-red logic and applications: in reading, the data of all devices are available in an RT updated global object (´tuyastatus´), with a _device:capability:value_ hierarchy and names were chosen by the user.
Example:
````
              tuyastatus: object
                   humidifier: object
                       _connected: true
                       spray: "OFF"
                       output: "small"
````
In writing, the commands for state change requests to all devices take the form of a node-red message:
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
  
note: all devices accept 'GET' and 'SCHEMA' requests via _fast REST_: the data comes from the 'global.tuyastatus' structure. 

A second [_**debug REST**_](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-REST) interface is synchronous and dedicated to development applications.
See, as an example, [tuyaDAEMON.toolkit](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-toolkit), a PHP application to help users manage devices.

### MQTT interface

But with version 2.1 I added to  **tuyaDAEMON** a _MQTT broker_ and a _MQTT interface_, both for events and commands. This was done thinking to UI. On PC (and portables), **node-red** offerts good interfaces, but is required some development time. **SmartLife** is good, but become fast to big to be very friendly. Interfaces can be done in **HTML/js/php** but also in this case the development is not for all. Using **MQTT** it is easy to found ready UI:
- For PC I use the client ['mqtt-explorer'](http://mqtt-explorer.com), that shows all data, locals and remotes, also with charts, and allows to send any command. Ready, car it do not requires customization. Good tool for developpers, it can be the general [purpose UI](https://github.com/msillano/tuyaDAEMON/blob/main/pics/ScreenShot_20210612210400.png?raw=true) for **tyuaDAEMON**.
- For Android, as portable UI (but also on PC with a simulator), I found very good and customizable, but still simple, the client ['IOT MQTT panel'](https://play.google.com/store/apps/details?id=snr.lab.iotmqttpanel.prod), with a nice look and JSON handling. Look equivalent to node-red.dashboard, I used it to make some specialized UI. Any UI is a file JSON. that can be exported and imported.
As an example see [here](https://github.com/msillano/tuyaDAEMON/wiki/custom-device--MQTT-'Ozone_PDMtimer'-case-study) the `node-red` and `IOT MQTT panel` implementations of the same interface, side by side.

The MQTT topics structure is simple:
> tuyaDAEMON/<remote_name>/<device_name>|'&nbsp;'/event|command[/<property_name>]  

Compare it to tuyaDAEMON standard [commands](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-as-event-processor#commands).

  So: 
  - `tuyaDAEMON/DEVPC/tuya_bridge/command/relay`   + 'ON'   is a local SET
  - `tuyaDAEMON/ANDROID/tuya_bridge/command`       + ''     is a remote GET SCHEMA
  - `tuyaDAEMON/ANDROID/ /command`                 + ''     is a remote LIST (a space is required as undefined device)
 
 Really minimal.
  
### DataBase interface

 **TuyaDEAMON** automatically logs user select messages and measurements on one or more DB tables (`'messages'`), a useful option for control, analysis, and statistics.
  _Since ver. 2.0:_
 
 ![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/dbtuyathome03.png)
 
 <hr>
 
- _For more documentation see the [wiki](https://github.com/msillano/tuyaDAEMON/wiki)._
 
- _If you are interested in the reasons behind the tuyaDAEMON's project choices, you can read [why-tuyaDEAMON](https://github.com/msillano/tuyaDAEMON/wiki/why-tuyaDAEMON-%3F) - In italiano: [perché-tuyaDAEMON](perché-tuyaDEAMON.pdf)._ 


<hr>
 
### Devices interfaces
 - Tuya device low level, via 'tuyapi' driver: see [CORE](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaDAEMON)
 - Tuya device hi level, via 'TRIGGER': see [smoke_alarm](https://github.com/msillano/tuyaDAEMON/wiki/mirror-device-'Smoke_Detector':-case-study).
 - Custom 'SW only' device, i.e. feature modules: see [system](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-_system)
 - MQTT devices, using custom driver nodes: see [PDMtimer](https://github.com/msillano/tuyaDAEMON/wiki/custom-device--MQTT-'Ozone_PDMtimer'-case-study)
 - USB-serial devices, using custom adapter: see [PM_detector](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-'PM-detector':-case-study)
 - 433 MHz sensors, using custom 433 gateway: see [Weather station](https://github.com/msillano/tuyaDAEMON/wiki/case-study:-433-MHz-weather-station)

<hr>
 
### Version 2.0
 
_With the version 2.0 tuyaDAEMON reaches 2 milestones: the ability to use and create custom devices in a [hierarchical OO perspective](https://github.com/msillano/tuyaDAEMON/wiki/ver.-2.0--milestones#oo-devices), and the ability to create distributed [TuyaDAEMON network](https://github.com/msillano/tuyaDAEMON/wiki/ver.-2.0--milestones#networking-tuyadaemon)._
 
 --------------
 ### Last [version 2.2.1](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaDAEMON)
 
 

