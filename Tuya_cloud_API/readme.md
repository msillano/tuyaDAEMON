# Tuya Cloud API (OpenAPI)

Tuya IoT Cloud is a global cloud platform that provides a comprehensive suite of [IoT capabilities](https://www.tuya.com/), including device management, scenario automation, data analytics, and industry services. It is widely used by businesses of all sizes to develop and manage IoT applications.

[Tuya OpenAPI](https://developer.tuya.com/en/docs/cloud) is a set of open Application Programming Interfaces (APIs) provided by Tuya Smart, accessible via REST (HTTP),  that enables developers to integrate Tuya Cloud services into their own applications. 

---
### notes on Tuya OpenAPI V2.0

The OpenAPI v. 2.0 introduces two new abstraction levels for device management: standard devices and "code". Standard devices are categorized by their function set using common codes. This allows the creation of maps also for devices that are not Tuya natives but can still be controlled using the tuyaAPI. 

Additionally, the tuyaAPI v. 2.0 introduces the concept of space and subspace for defining the spatial location of devices. Spaces represent large areas, such as a home or office, while subspaces represent smaller areas within a space, such as a living room or bedroom. This device spatial definition, in conjunction with 'groups', allows for more granular control over device operation and enables the creation of more complex automation scenarios.

The 'standard' access
> "The standard instruction set lets you control devices from different manufacturers with a single set of instructions. However, to achieve standardization, mapping relationships shall be manually created, and Tuya cannot guarantee that all hardware products support this function."

- The "property set" (Tuya classed as 'status' - Read enabled, and 'instruction' - Write enabled) of a device is defined using "code" (i.e. Tuya name for a property, like 'switch_1' or 'cycle_time') and then mapped to native DPs. The devices are grouped in 554 'standard categories' (@ 12/2023, see 'Get Category List' API).

The space abstraction
> "A space defines the geographical location, area, and layout information of IoT scenes, and displays the topological relationship between various smart devices in a tree structure."

- The smart-home definitions ("home", "room",...) are derived from the abstract space definitions.
- Limits: 100 devices per space (subspace), 100 subspaces per space (subspace), 10 subspaces deep. 

The device group
> "A device group is a collection of devices with the same features, allowing users to manage and control a large number of devices as a whole. For example, turn devices on or off, and create scheduled tasks."

- A group is, in OOP terms, a 'derived device': a collection of devices of the same type (see    [TuyaDEAMON OO capabilities](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#oo-devices))
- All devices in a group must belong to the same space.
- A group inherits DPs (and not 'code') from devices to define the group's properties. 
- Limits: 50  groups per space, 100 devices per group.
  
---
### node-red Tuya OpenAPI V2.0

This node-red flow implements experimental access to Tuya Cloud API to get data or perform operations programmatically, without using  the 'SmartLife App' or the 'Tuya Development Platform'.

To start with Tuya IoT Cloud, you must create a developer account and register your devices, to get the credentials (see [here for references](https://github.com/msillano/tuyaDAEMON/wiki/50.-Howto:-add-a-new-device-to-tuyaDAEMON#1-preconditions)). You can then start using the `nr_Tuya_OpenAPI_2.0` flow to develop and manage your node-red IoT applications.

The `nr_Tuya_OpenAPI_2.0` flow is a minimal implementation, for testing and API exploration, essentially an examples collection.

#### Config

- SET `client_id` and `device_id` and regional [tuya data center](https://github.com/tuya/tuya-home-assistant/blob/main/docs/regions_dataCenters.md) in  'Settings CLICK 'On Start' TAB' node una tantum. 
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
- Devices such as WiFi sensors, which cannot be managed with tuya-smart-device node, are currently controlled in TuyaDAEMON with TRIGGER. Although the Trigger technique is reliable and more stable than CloudAPI, it has limitations in reading numerical measurements. In this case, the use of CloudAPI (e.g. API Query_Properties) could be valid.
- Some subdevices (using a hub) could also benefit from CloudAPI, when not all DPs are accessible via tuya-smart-device node.
  
Device Management
- Some non-local aspects of device management (e.g. space (home), groups, automation) are only partially manageable via TRIGGER + Automation. If you want advanced applications in these areas, using CloudAPI must be necessary.
- Some operations (like add/remove/rename devices, create/modify automation, etc...) actually are performed using a Tuya APP (SmartLife). If you want to do thems in a custom application, you can use CloudAPI.

> _In conclusion, I believe, in an open strategy, that it is useful to create a new optional communication channel (core_OPENAPI) into TuyaDEAMON, to be used only in essential cases, to minimize the dependence of TuyaDAEMON on the evolution and strategy of Tuya Cloud._

---
### core_OPENAPI custom device
objectives
- Complete the access to Tuya devices, potentially getting all data available from the Tuya Cloud. 
- Extend the TuyaDEAMON/Tuya Cloud collaboration in areas (space, groups, automation, etc.) application-related.
- Use (and implementation) of core_OPENAPI minimal, optional, and complete (all API must be callables).
- Minimal minds that API URL construction and  mapping code <=> DP are user-local, defined in call parameters, and not global: this to exclude global.alldevices extensions. 
  
specifications

   The new device OPENAPI automatically gets and refreshes the token, and exposes only one property. and two new [pseudoDP](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#pseudodp),  usables on any real/virtual tuyaDEAMON device (not on fake):

- callAPI DP:   Allows calls to any API, so the input data must be complete.
     - Input
         - method (string)
         - APIurl (URI) (like "/v2.0/cloud/scene/rule?space_id=123456789")
         - body (JSON)  (like {"properties":{"switch_1":false}} )
     - Output:
         - The JSON structure from OpenAPI, processed only in error case
   

- APIstatus pseudoDP: uses the Tuya API 'query_properties', is a replacement for "GET schema". Using this Tuya API as the advantage that the API result includes also the DPs.
     - Input: none
     - Output:  a msg for TuyaDAEMON log or an error msg.

- APIinstruction pseudoDP,  which uses the Tuya API 'send_properties', is a replacement for "MULTIPLE SET":
     - Input: an object with couples (code: value) required by OpenAPI and a DP map required by log.
     - Output: a msg for TuyaDAEMON log: as 'value' the JSON result from OpenAPI or an error msg.

   alldevice update
   tools update
   migration

