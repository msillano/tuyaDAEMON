# TuyaDAEMON project


_**TuyaDAEMON's goal is to integrate the entire Tuya ecosystem into node-red, and not just to control some devices, creating a new level of abstraction that includes both Tuya-cloud and all possible custom extensions.**_

**Tuya ecosystem:**([_source Tuya_](https://developer.tuya.com/en/docs/iot/open-api/platform-overview/solution-overview))

![](./pics/network_architecture.png)

**TuyaDAEMON** has a high-level interface: in reading, the data of all devices are available in an updated global RT object, with a _device:capability:value hierarchy_, with names chosen by the user.
Example:


