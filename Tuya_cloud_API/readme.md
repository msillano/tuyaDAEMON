# Tuya Cloud API V.2.0

Tuya IoT Cloud is a global cloud platform that provides a comprehensive suite of IoT capabilities, including device management, scenario automation, data analytics, and industry services. It is widely used by businesses of all sizes to develop and manage IoT applications.

This library implements experimental access to Tuya Cloud API via REST to get data or perform operations programmatically, without the use of  the SmartLife App.

To get started with Tuya IoT Cloud, you will need to create a developer account and register your devices. You can then start using the Tuya IoT Cloud APIs to develop and manage your IoT applications, as usual required (see [here](https://github.com/msillano/tuyaDAEMON/wiki/50.-Howto:-add-a-new-device-to-tuyaDAEMON#1-preconditions)).

The "Tuya Cloud API V2.0" is a minimal node-red implementation, just for testing and API exploration.

### Config

- SET 'client_id' and 'device_id' in  'Settings CLICK 'On Start' TAB' node una tantum. 

- SET SecretKey in (all) 'Sign signStr with secret' nodes

### notes:
 - You will need to add `node-red-contrib-crypto-js-dynamic` from palette manager.
 
 - TuyaAPI uses 'codes' (tuya names for DPs) and not DPs. The output of the 'Get SCHEMA V2.0' flow maps DPs <=> codes.
 - API reference:
     - IOT-Core: https://developer.tuya.com/en/docs/cloud/device-connection-service?id=Kb0b8geg6o761
 - This project is derived from the project by NotEnoughTech (https://github.com/notenoughtech/NodeRED-Projects/tree/master/Tuya%20Cloud%20API)
