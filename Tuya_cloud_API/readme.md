# Tuya Cloud API (OpenAPI)

Tuya IoT Cloud is a global cloud platform that provides a comprehensive suite of [IoT capabilities](https://www.tuya.com/), including device management, scenario automation, data analytics, and industry services. It is widely used by businesses of all sizes to develop and manage IoT applications.

[Tuya OpenAPI](https://developer.tuya.com/en/docs/cloud) is a set of open Application Programming Interfaces (APIs) provided by Tuya Smart, accessible via REST (HTTP),  that enables developers to integrate Tuya Cloud services into their own applications. 

---
### node-red Tuya OpenAPI V2.0

This library implements experimental access to Tuya Cloud API to get data or perform operations programmatically, without using  the 'SmartLife Ap'p or the 'Tuya Development Platform'.

To start with Tuya IoT Cloud, you must create a developer account and register your devices, to get the credentials (see [here for references](https://github.com/msillano/tuyaDAEMON/wiki/50.-Howto:-add-a-new-device-to-tuyaDAEMON#1-preconditions)). You can then start using the `nr_Tuya_OpenAPI_2.0` to develop and manage your node-red IoT applications.

The `nr_Tuya_OpenAPI_2.0` is a minimal implementation, for testing and API exploration.

#### Config

- SET `client_id` and `device_id` in  'Settings CLICK 'On Start' TAB' node una tantum. 
- SET your Tuya `SecretKey` in (all) 'Sign signStr with secret' nodes.
- Update URL var with your regional [tuya data center](https://github.com/tuya/tuya-home-assistant/blob/main/docs/regions_dataCenters.md) in ALL second function nodes.  
- All flows are very similar, with a few differences - read the flow comments node for the required customizations.

#### notes:
 - You will need to add `node-red-contrib-crypto-js-dynamic` from the palette manager.
 - TuyaAPI uses `codes` (tuya names for DPs) and not DPs. The output of the 'Get SCHEMA V2.0' flow maps DPs <=> codes.
 - API reference:
     - IoT-Core: Start [here](https://developer.tuya.com/en/docs/cloud) (registration required). 
 - This project is derived from the project by NotEnoughTech (https://github.com/notenoughtech/NodeRED-Projects/tree/master/Tuya%20Cloud%20API)

---
### Tuya Cloud API and TuyaDAEMON

The ability to access OpenAPI simply can open up interesting scenarios in TuyaDAEMON. Let's look at the various aspects:

Device control
- Local access to real device properties is quite good with tuya-smart-device node and only in some rare cases the access via CloudAPI can be useful.
- Devices such as WiFi sensors, which cannot be managed with tuya-smart-device node, are currently controlled in TuyaDAEMON with TRIGGER. Although the Trigger technique is reliable and more stable than CloudAPI, it has limitations in reading numerical measurements.
In this case, the use of CloudAPI (e.g. API Query_Properties) could be valid.
- Some subdevices (using a hub) could also benefit from CloudAPI, when not all DPs are accessible.
  
Device Management
- Some non-local aspects of device management (e.g. space (home), groups, automation) are only partially manageable via TRIGGER + Automation. If you want advanced applications in these areas, using CloudAPI must be necessary.
- Some management operations (like add/remove/rename devices, automation, etc...) actually are performed using a Tuya APP (SmartLife). If you want to do thems in a custom application, you need to use CloudAPI.

### notes on OpenAPI V2.0



