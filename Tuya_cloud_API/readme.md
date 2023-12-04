# Tuya Cloud API V.2.0

Tuya IoT Cloud is a global cloud platform that provides a comprehensive suite of IoT capabilities, including device management, scenario automation, data analytics, and industry services. It is widely used by businesses of all sizes to develop and manage IoT applications.

This library implements experimental access to Tuya Cloud API via REST to get data or perform operations programmatically, without using  the SmartLife App.

To start with Tuya IoT Cloud, you must create a developer account and register your devices. You can then start using the Tuya IoT Cloud APIs to develop and manage your IoT applications, as usual (see [here for references](https://github.com/msillano/tuyaDAEMON/wiki/50.-Howto:-add-a-new-device-to-tuyaDAEMON#1-preconditions)).

The "Tuya Cloud API V2.0" is a minimal node-red implementation, for testing and API exploration.

### Config

- SET 'client_id' and 'device_id' in  'Settings CLICK 'On Start' TAB' node una tantum. 
- SET your Tuya SecretKey in (all) 'Sign signStr with secret' nodes.
- Update URL var with your regional [tuya data center](https://github.com/tuya/tuya-home-assistant/blob/main/docs/regions_dataCenters.md) in ALL second function nodes.  
- All flows are very similar, with a few differences - read the flow comments node for the required customizations.


### notes:
 - You will need to add `node-red-contrib-crypto-js-dynamic` from the palette manager.
 - TuyaAPI uses `codes` (tuya names for DPs) and not DPs. The output of the 'Get SCHEMA V2.0' flow maps DPs <=> codes.
 - API reference:
     - IOT-Core: [https://developer.tuya.com/en/docs/cloud/device-connection-service?id=Kb0b8geg6o761]( https://developer.tuya.com/en/docs/cloud/device-connection-service?id=Kb0b8geg6o761)
 - This project is derived from the project by NotEnoughTech (https://github.com/notenoughtech/NodeRED-Projects/tree/master/Tuya%20Cloud%20API)
