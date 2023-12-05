# Tuya Cloud API (OpenAPI)

Tuya IoT Cloud is a global cloud platform that provides a comprehensive suite of [IoT capabilities](https://www.tuya.com/), including device management, scenario automation, data analytics, and industry services. It is widely used by businesses of all sizes to develop and manage IoT applications.

[Tuya OpenAPI](https://developer.tuya.com/en/docs/cloud) is a set of open Application Programming Interfaces (APIs) provided by Tuya Smart, accessible via REST (HTTP),  that enables developers to integrate Tuya Cloud services into their own applications. 

---
### node-red Tuya OpenAPI V2.0

This library implements experimental access to Tuya Cloud API to get data or perform operations programmatically, without using  the 'SmartLife App' or the 'Tuya Development Platform'.

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

### notes on OpenAPI V2.0

The tuyaAPI v. 2.0 introduces two new abstraction levels for device management: standard devices and "code". Standard devices are categorized by their function set using common codes. This allows the creation of maps also for devices that are not Tuya natives but can still be controlled using the tuyaAPI. 

Additionally, the tuyaAPI v. 2.0 introduces the concept of space and subspace for defining the spatial location of devices. Spaces represent large areas, such as a home or office, while subspaces represent smaller areas within a space, such as a living room or bedroom. This device spatial definition, in conjunction with 'groups' (association for devices from the same space and same category), allows for more granular control over device operation and enables the creation of more complex automation scenarios.


The 'standard' access
> "The standard instruction set lets you control devices from different manufacturers with a single set of instructions. However, to achieve standardization, mapping relationships shall be manually created, and Tuya cannot guarantee that all hardware products support this function."

- The "instruction set" is defined using "code" (i.e. tuya name for a property, like 'switch_1' or 'cycle_time') and then mapped to native DPs. The devices are grouped in 554 'standard categories' (@ 12/2023, see 'Get Category List' API).

The space abstraction
> "A space defines the geographical location, area, and layout information of IoT scenes, and displays the topological relationship between various smart devices in a tree structure."

- The smart home definitions ("home", "room",...) are derived from the abstract space definitions. 

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
- Some management operations (like add/remove/rename devices, create/modify automation, etc...) actually are performed using a Tuya APP (SmartLife). If you want to do thems in a custom application, you need to use CloudAPI.

### TuyaDAEMON 3.0
objectives
specifications 
   new device OpenAPI
   new pseudoDP
   alldevice update
   tools update
   migration


