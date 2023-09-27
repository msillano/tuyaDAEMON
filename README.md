
_**TuyaDAEMON's primary objective is not merely controlling some devices or providing a unique user interface. Instead, it focuses on seamlessly integrating the entire Tuya ecosystem into node-red, thereby establishing a new level of abstraction encompassing the Tuya cloud, any IOT device of every brand, any custom device, REST, MQTT, DB, and extended automation logic. TuyaDAEMON serves as an open framework for advanced custom IoT development.**_

**Tuya ecosystem:**([_source Tuya_](https://developer.tuya.com/en/docs/iot/open-api/platform-overview/solution-overview))

![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/network_architecture.png)

TuyaDAEMON is a powerful and versatile IoT development framework that can be used to create a wide variety of projects. It is easy to use for beginners, but also has powerful features that appeal to experienced developers.

### Advanced features that make tuyaDAEMON unique
TuyaDAEMON has some unique features that make it stand out from the competition. These features include:

1. Open, modular, [full documented](https://github.com/msillano/tuyaDAEMON/wiki): expressly designed for every customization need.
2. TuyaDAEMON is borns to work with any Tuya device without hacking, but it is also open to all devices, custom or from other firms. This makes it a more flexible framework than some of its competitors (see 'study cases' on [wiki](https://github.com/msillano/tuyaDAEMON/wiki)). 
3. [ObjectOriented](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#oo-devices) approach that makes it easy to create complex projects.
4. Powerful control meta-language ([command chains](https://github.com/msillano/tuyaDAEMON/wiki/30.-tuyaDAEMON-as-event-processor#share-and-command-chains)) with an expressive power (Turing complete) not found in other IOT environments, usually limited to "IF ... THEN" automation (see [also here](https://github.com/msillano/tuyaDAEMON/wiki/10.-why-tuyaDAEMON-%3F#2-what-is-meant-by-integrated)).
5. [Meta-tools](https://github.com/msillano/tuyaDAEMON/wiki/90.-tuyaDAEMON-toolkit) for device test, maintenance, and documentation activities.
6. Applications and programmer's notes [repository](https://github.com/msillano/tuyaDEAMON-applications). 

If you are looking for an IoT development framework that is powerful, versatile, and easy to use, then TuyaDAEMON is a good option to consider.

 _All the details of the communication with devices are resolved by **tuyaDAEMON**, using 3 bidirectional communication channels transparently to the user:_

### LOW LEVEL MQTT (see tuya [DEAMON core](./tuyaDAEMON/README.md) + CORE_devices)

Using [node-red-contrib-tuya-smart-device](https://github.com/vinodsr/node-red-contrib-tuya-smart-device) you can exchange local MQTT communications with many Tuya devices. You receive notifications of device status changes regardless of the cause: Tuya-cloud, smartlife app, or voice control. And vice versa, the commands sent by **tuyaDAEMON** are executed by the devices, and all the app interfaces are kept updated in real-time. 

### HIGH LEVEL TRIGGER (see [tuyaTRIGGER](./tuyaTRIGGER/README.md) + MIRROR_devices)
The TRIGGERs do not connect to individual devices, but create a direct and bidirectional connection with Tuya-cloud events and 'automation', allowing complete control from anywhere of both the smartlife logic and the devices not handled by LOW-LEVEL MQTT channel. In the cases where a device relies on cloud servers (see [Tuya info](https://support.tuya.com/en/help/_detail/K9tjtiy33x3qf)) user can define 'mirror' devices: see ['Smoke detector' case-study](https://github.com/msillano/tuyaDAEMON/wiki/mirror-device-'Smoke_Detector':-case-study)) to access the features of the device.

  Example: _Using a “Smart Home Infrared Universal Remote Controller” device you have replicas of the various remote controls on your smartphone, even better than those I had developed in 2016 (see [remoteDB](https://github.com/msillano/remotesDB)). Very well: thanks to Tuya I can now control 2 televisions, a monitor, an air conditioner, a DVB tuner, and a TV top box from my smartphone! There are some limitations: voice commands cannot be used, moreover, since the device does not use the MQTT protocol, it cannot be controlled at the LOW LEVEL._
  _However, **Tuya-cloud** resources can be used to create a 'scene' with the sequence of commands needed to tune a TV channel, e.g. "Rai 3 HD", on the living room television. As the icon, I will use the RAI3 logo, as the name: 'tune RAI three'. Now I can use the voice command: "Hey Google, run tune Rai three"!_
  _A_ "mirror" device _standardizes this behavior in **tuyaDEAMON**, using TRIGGERS to execute commands. I can now create Node-RED automation, which, if I am at home, automatically turns on the television and tunes in RAI 3 when my favorite TV series is on the air!_
````  
              tuyastatus: object
                    living.tv: object
                         tvchannel: "RAI3 HD"
                         comment: "available: 'RAI1 HD’,’RAI2 HD’,’RAI3 HD’..."
````

### CUSTOM CHANNEL (see [system](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-_system) and 'fake' devices)

Simple **node-red** flows constitute the interfaces to HD and SW resources, allowing the insertion of external devices, not Tuya-compatible, into the system. A very useful two-tier model, consisting of a first-level represented by **tuyaDAEMON** processor, which standardizes the various sources and devices, to provide all data and commands in a homogeneous way to the _higher application level_ (see TuyaDAEMON [application model](https://github.com/msillano/tuyaDEAMON-applications#tuyadeamon-model-for-applications)). 

**Custom channels** are implemented additively with specialized flows, to implement 'fake' devices. 

In many cases, the required interface is a simple protocol adapter, like in case of [MQTT devices](https://github.com/msillano/tuyaDAEMON/blob/main/devices/Ozone_PDMtimer/device_Ozone_PDMtimer.pdf) or in case of [PM detector](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-'PM-detector':-case-study), a device that uses USB-COM interface.

In the case of the '433 MHZ sensor gateway', the module includes a specialized adapter for each device, such as the
[weather station](https://github.com/msillano/tuyaDAEMON/wiki/case-study:-433-MHz-weather-station) which uses 3 sensors (temperature, wind, rain).

Since version 2.0 the generalized [OO perspective](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#oo-devices), in a [distributed environement](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#networking-tuyadaemon), adds more power to tuyaDAEMON. It is easy to finalize the tuyaDAEMON resources in integrated projects, OO-oriented, with UI and many base devices: see as an example the device [watering_sys](https://github.com/msillano/tuyaDAEMON/wiki/derived-device-'watering_sys':-case-study), a terrace watering timer with UI, fuzzy control from wheater, build using 3 tuya devices.

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

To make easier the interoperability with external applications, tuyaDEAMON offers also (Since ver. 2.0) a [_**fast REST**_](https://github.com/msillano/tuyaDAEMON/wiki/70.-tuyaDAEMON-REST) asynchronous interface with an immediate JSON response:
_Examples:_
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

A second [_**debug REST**_](https://github.com/msillano/tuyaDAEMON/wiki/70.-tuyaDAEMON-REST) interface is synchronous and dedicated to development applications.
See, as an example, [tuyaDAEMON.toolkit](https://github.com/msillano/tuyaDAEMON/wiki/90.-tuyaDAEMON-toolkit), a PHP application to help users manage devices.

### MQTT interface

But with version 2.1 I added to  **tuyaDAEMON** a _MQTT broker_ and a _MQTT interface_, both for events and commands. This was done thinking to UI. On PC (and portables), **node-red** offers good interfaces, but is required some development time. **SmartLife** UI is good, but become fast too big to be very friendly. Interfaces can be done in **HTML/js/php** but also in this case the development is not for all (see [example](https://github.com/msillano/tuyaDEAMON-applications/wiki/note-3-%E2%80%90-dynamic-HTML-pages)). Using **MQTT** it is easy to find ready UI:
- For PC I use the client ['mqtt-explorer'](http://mqtt-explorer.com), which shows all data, locals, and remotes, also with charts, and allows to send any command ([use example](https://github.com/msillano/tuyaDAEMON/raw/main/pics/Immagine%202022-04-07%20184055.png)). Ready, car does not require customization. A good tool for developers, it can be the general [purpose UI](https://github.com/msillano/tuyaDAEMON/blob/main/pics/ScreenShot_20210612210400.png) for **tyuaDAEMON**.
<table><tr><td>
 <img  src="https://github.com/msillano/tuyaDAEMON/blob/main/pics/ScreenShot_20210612210400.png?raw=true">
</td><td>
 <img src="https://github.com/msillano/tuyaDAEMON/blob/main/pics/Immagine%202022-04-07%20184055.png?raw=true">
</td></tr></table>

- For Android, as portable UI (but also on PC with a simulator), I found very good and customizable, but still simple, the client ['IOT MQTT panel'](https://play.google.com/store/apps/details?id=snr.lab.iotmqttpanel.prod), with a nice look and JSON handling. The look is equivalent to node-red.dashboard, I used it to make some specialized UI. Any UI is a file JSON. that can be exported and imported.
As an example see [here](https://github.com/msillano/tuyaDAEMON/wiki/custom-device--MQTT-'Ozone_PDMtimer'-case-study) the `node-red` and `IOT MQTT panel` implementations of the same interface, side by side.

The MQTT topics structure is simple:
> tuyaDAEMON/<remote_name>/<device_name>|'&nbsp;'/events|commands[/<property_name>]  

Compare it to tuyaDAEMON standard [commands](https://github.com/msillano/tuyaDAEMON/wiki/30.-tuyaDAEMON-as-event-processor#commands).

  So: 
  - `tuyaDAEMON/DEVPC/tuya_bridge/commands/relay`   + 'ON'   is a local SET
  - `tuyaDAEMON/ANDROID/tuya_bridge/commands`       + ''     is a remote GET SCHEMA
  - `tuyaDAEMON/ANDROID/ /commands`                 + ''     is a remote LIST (a space is required as undefined device)
 
 Really minimal.
  
### DataBase interface

 **TuyaDEAMON** automatically logs user select messages and measurements on one or more DB tables (`'messages'`), a useful option for control, analysis, and statistics.
  _Since ver. 2.0:_
 
 ![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/dbtuyathome03.png)

 - As far as the use of the DB is concerned, see the [programmer's notes](https://github.com/msillano/tuyaDEAMON-applications#programmers-notes).
 <hr>
 
- _For more documentation see the [wiki](https://github.com/msillano/tuyaDAEMON/wiki)._
 
- _If you are interested in the reasons behind the tuyaDAEMON's project choices, you can read [why-tuyaDEAMON](https://github.com/msillano/tuyaDAEMON/wiki/10.-why-tuyaDAEMON-%3F) - In italiano: [perché-tuyaDAEMON](perché-tuyaDEAMON.pdf)._ 


<hr>
 
### Devices interfaces
 - Tuya device low level, via 'tuyapi' driver: see [CORE](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaDAEMON)
 - Tuya device hi level, via 'TRIGGER': see [smoke_alarm](https://github.com/msillano/tuyaDAEMON/wiki/mirror-device-'Smoke_Detector':-case-study).
 - Custom 'SW only' device, i.e. feature modules: see [system](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-_system)
 - MQTT devices, using custom driver nodes: see [PDMtimer](https://github.com/msillano/tuyaDAEMON/wiki/custom-device--MQTT-'Ozone_PDMtimer'-case-study)
 - USB-serial devices, using custom adapter: see [PM_detector](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-'PM-detector':-case-study)
 - 433 MHz sensors, using custom 433 gateway: see [Weather station](https://github.com/msillano/tuyaDAEMON/wiki/case-study:-433-MHz-weather-station)
 
### Examples: 
 - YAWT (Yet Another Watering Timer), 8 zones watering, using REST and a WEB map interface, see [here](https://www.instructables.com/YAWT-Yet-Another-Watering-Timer/).

<hr>

### New: [tuyaDEAMON-applications](https://github.com/msillano/tuyaDEAMON-applications) repository.
 <hr>

### Version 2.0
 
_With the version 2.0 tuyaDAEMON reaches 2 milestones: the ability to use and create custom devices in a [hierarchical OO perspective](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#oo-devices), and the ability to create distributed [TuyaDAEMON network](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#networking-tuyadaemon)._
 
  _Last [version 2.2.2](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaDAEMON)_
 
 ---------------
This project is a work-in-progress: it is provided "as is", without warranties of any kind, implicit or explicit.<br>
English is not my first language. I apologize for any mistakes.

 ### Acknowledgment
 _A heartfelt thanks to all the people who contributed with observations and advice._
 
 
