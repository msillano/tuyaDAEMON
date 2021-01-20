# TuyaDAEMON project


_**TuyaDAEMON's goal is to integrate the entire Tuya ecosystem into node-red, and not just to control some devices, creating a new level of abstraction that includes both Tuya-cloud and all possible custom extensions.**_

**Tuya ecosystem:**([_source Tuya_](https://developer.tuya.com/en/docs/iot/open-api/platform-overview/solution-overview))

![](./pics/network_architecture.png)

**TuyaDAEMON** has a high-level interface: in reading, the data of all devices are available in an updated global RT object, with a _device:capability:value hierarchy_, with names chosen by the user.
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
                    device: "umidificatore"
                    property: "spray"
                    value: "ON"
````
All the details of the communication are resolved by **tuyaDAEMON**, using 3 bidirectional communication channels transparently to the user:

###LOW LEVEL MQTT (see tuya [DEAMON core](./tuyaDAEMON/README.md))

Using [node-red-contrib-tuya-smart-device](https://github.com/vinodsr/node-red-contrib-tuya-smart-device) you can exchange MQTT communications with many Tuya devices. You receive notifications of device status changes regardless of the cause: Tuya-cloud, smartlife app, voice control. And vice versa, the commands sent by **tuyaDAEMON** are executed by the devices and all the app interfaces are kept updated in real time. 

###HI LEVEL TRIGGER (see [tuyaTRIGGER](./tuyaTRYGGER/README.md))
The triggers do not connect to individual devices, but create a direct and bidirectional connection with Tuya-cloud events and 'automations', allowing complete control of both the smartlife logic and the devices not handled by LOW-LEVEL MQTT channel ('mirror' devices: see ['siren mirror'](./extra/siren%20mirror/README.md)).
