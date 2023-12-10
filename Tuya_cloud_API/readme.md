# Tuya Cloud API (OpenAPI)

[IoT Cloud](https://www.tuya.com/) by Tuya Smart is a global cloud platform that provides a comprehensive suite of IoT capabilities, including device management, scenario automation, data analytics, and industry services. Businesses of all sizes rely on Tuya IoT Cloud to develop and manage their IoT applications.

[Tuya OpenAPI](https://developer.tuya.com/en/docs/cloud) is a set of open Application Programming Interfaces (APIs) provided by Tuya Smart, accessible via REST (HTTP), which enables developers to seamlessly integrate Tuya Cloud services into their own applications.

### notes on Tuya OpenAPI V2.0

 The OpenAPI v. 2.0 (since June 20, 2023) uses two abstraction levels for device management: _standard devices_ and _code_. Standard devices are categorized by their set of properties, defined by `codes`: a map links `code` to device `DP`. This allows the creation of DP maps for devices that are not Tuya natives but can still be controlled using the Tuya Cloud. 

Additionally, OpenAPI v. 2.0 introduces the concept of _space_ and _subspace_ for defining the spatial location of devices. Spaces represent large areas, such as a home or office, while subspaces represent smaller areas within a space, such as a living room or bedroom.

note:
  - OpenAPI v. 2.0 also introduces _virtual devices_ (i.e. SW-only models from custom projects or TuyaGo) not to be confused with TyaDAEMON's _virtual devices_ (subdevices: Tuya HW devices using a hub). The _Tuya virtual devices_ do not affect TuyaDEAMON.
  - For APPs (SmartLife) Max. Limits (2023-09-19) see [here](https://support.tuya.com/en/help/_detail/K9q79msw3accz).

**The 'standard' access**
> "The _standard instruction set_ lets you control devices from different manufacturers with a single set of instructions. However, to achieve standardization, mapping relationships shall be manually created, and Tuya cannot guarantee that all hardware products support this function."

- The "property set" (classed by Tuya as 'status' - Read enabled, and 'instruction' - Write enabled) of a device is defined using _code_ (i.e. Tuya name for a property, like 'switch_1' or 'cycle_time') and then mapped to native DPs.
- All devices are grouped into 554 'standard categories' (@ 12/2023, see 'Get Category List' API).
  
> **TuyaDAEMON** manages devices individually and defines access rules on a single DP basis. This allows users to specialize individual devices based on their function. In object-oriented programming terms, users can define  _single_derived devices_. <br> For instance, a [switch-1CH](https://github.com/msillano/tuyaDAEMON/blob/main/devices/switch-1CH/device_switch-1CH.pdf), when employed as a [tuya-bridge](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaTRIGGER), has its `countdown` property unavailable to users (check [note 2](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaTRIGGER#mqtt-tuya_bridge-tests-requres-core_mqtt)) due to its prior utilization for "trigger" purposes.

**The space abstraction**
> "A _space_ defines the geographical location, area, and layout information of IoT scenes, and displays the topological relationship between various smart devices in a tree structure."

- It is recursive: a space/subspace can contain subspaces.
- The smart-home definitions ("home", "room",...) are derived from the abstract space definitions.
- Limits: 100 devices per space/subspace, 100 subspaces per space/subspace, 10 max space tree deep. 

**The device group**
> "A device group is a collection of devices with the same features, allowing users to manage and control a large number of devices as a whole. For example, turn devices on or off, and create scheduled tasks."

- All devices in a group must belong to the same space
- A group inherits only a few instructions (but not the  _status_) DPs (and not _code_) from devices to define the group's properties.
- A group is, in OOP terms, like a 'derived device': a collection of devices of the same type. Like a device, a group is shown on the main page, the users can send manually some commands and a group offers basic time scheduling.
- But a Tuya 'group' IS NOT functionally equivalent to a device: Groups have their own API for set/get properties (`Query Group Properties`, `Send Group Properties`); a group cannot be used in _smart scenes_ neither in conditions nor in actions. Groups of groups are not allowed. This greatly limits the usefulness of groups.
- Limits: 50  groups per space, 100 devices per group.

> **TuyaDAEMON** offers users a complete [OO recursive paradigm](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#oo-devices) for devices, with all patterns: _composition, aggregation, use_ and instruction _inheritance, override_, at the cost of creating some 'shares'. In TuyaDAEMON, any derived device IS a device.
  
---
### node-red Tuya OpenAPI V2.0

This node-red flow [https://github.com/msillano/tuyaDAEMON/blob/main/Tuya_cloud_API/nr_Tuya_OpenAPI_2.0.json.zip](https://github.com/msillano/tuyaDAEMON/blob/main/Tuya_cloud_API/nr_Tuya_OpenAPI_2.0.json.zip) implements experimental access to Tuya Cloud API to get data or perform instructions programmatically, without using  the 'SmartLife App' or the 'Tuya Development Platform' or 'TuyaDEAMON'.

To start with Tuya IoT Cloud, you must create a Tuya developer account and register your devices, to get the credentials (see [here for references](https://github.com/msillano/tuyaDAEMON/wiki/50.-Howto:-add-a-new-device-to-tuyaDAEMON#1-preconditions)). You can then start using the `nr_Tuya_OpenAPI_2.0` flow to develop and manage your node-red IoT applications.

The `nr_Tuya_OpenAPI_2.0` flow is a minimal implementation, for testing and API exploration, essentially an examples collection.

#### Config
- SET `client_id` and `device_id` and regional Tuya [data center](https://github.com/tuya/tuya-home-assistant/blob/main/docs/regions_dataCenters.md) in  `Settings CLICK 'On Start' TAB` node una tantum. 
- SET your Tuya `SecretKey` in (all) `Sign signStr with secret` nodes.
- All flows are very similar, with a few differences - read the flow comments node for the required customizations.

**notes:**
 - You may need to add `node-red-contrib-crypto-js-dynamic` from the palette manager.
 - OpenAPI uses `codes` (tuya names for DPs) and not DPs. The output of the `Get SCHEMA V2.0` flow maps DPs <=> codes.
 - API reference:
     - IoT-Core: Start [here](https://developer.tuya.com/en/docs/cloud) (registration required). 
 - This project is derived from the project by NotEnoughTech ([https://github.com/notenoughtech/NodeRED-Projects/tree/master/Tuya Cloud API](https://github.com/notenoughtech/NodeRED-Projects/tree/master/Tuya%20Cloud%20API))

---
### TuyaDAEMON and Tuya Cloud API
The ability to access OpenAPI can open up interesting scenarios in TuyaDAEMON. Let's explore the various aspects:

**Device Control**

* Local access to Tuya real (WiFi) device properties is quite good with the `tuya-smart-device` node, and only in rare cases the access via CloudAPI can be useful.

* Tuya devices such as WiFi low-power sensors, which cannot be managed with the `tuya-smart-device` node, are currently controlled in TuyaDAEMON with TRIGGER. While the Trigger technique is reliable and more stable than CloudAPI, it has limitations in reading numerical measurements. In such cases, the use of CloudAPI (e.g., API `Query_Properties`) could be beneficial.

* Some subdevices (using a hub) could also benefit from CloudAPI when not all DPs are accessible via the tuya-smart-device node.

**Device Management**

* Some non-basic aspects of device control (e.g., spaces (home), groups, automation) are only partially manageable via TRIGGER + Automation. If you want advanced applications in these areas, the use of CloudAPI is necessary.

* Some operations (such as adding/removing/renaming devices, creating/modifying smart scenes, etc.) are actually performed only using a Tuya APP (SmartLife). If you want to do this in a custom application, you can use CloudAPI.

**Smart scene linkage**

 In SmartLife the 'smart scene' management is not exactly user-friendly. In particular, I noticed the following problem:
 
*  When a device changes ID (for re-connection or replacement) all the smart scenes connected to that device are "unavailable" (ok). As a result, users have to change the automation by manually re-entering SmartLife with all the data or conditions for the new device, when a simple ID replacement would suffice. This can be really frustrating.
  
*  Manual Enable DP: "On the Tuya Smart platform, select your device on the Product page, click Extensions, and click Settings next to Scenario Connection Settings to check whether DPs for executing actions are configured for your device. If your device uses a standard solution, the DPs are fixed and enabled by default. If your device uses a non-standard solution, selected standard functions are enabled by default. However, you need to enable custom functions on the Scenario Connection Settings page." 

> In conclusion, from an open-strategy perspective, it is beneficial to create in TuyaDAEMON a new optional communication channel for OpenAPI, to be used only in essential cases, to minimize the TuyaDAEMON's dependences on the evolution and strategy of Tuya Cloud.

### core_OPENAPI custom device (preliminary)
  A custom device, **core_OPENAPI** implements the TuyaDAEMON extension to OpenAPI (work in progress), with the following objectives:
  
- Complete the access to/from Tuya devices, potentially setting/getting all available data to/from the Tuya Cloud. 
- Extend the TuyaDAEMON/Tuya Cloud collaboration in areas (space, groups, smart scenes, etc.) application-related.
- Use and implementation of core_OPENAPI must be minimal, optional, and complete (all API must be callables).
- Minimal minds that API URL construction and the map code <=> DP are user-local, defined in call parameters, and not global: this is to exclude heavy `global.alldevices` extensions. 
  
**Specifications**

   The new device OPENAPI automatically gets and refreshes the token, and exposes only one property and two new [pseudoDP](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#pseudodp). The `pseudoDP` are usable on any real/virtual tuyaDEAMON device (not on custom (fake) devices, not handled by Tuya Cloud):

- **callAPI DP**:   Allows calls to any API, so the input data must be complete.
     - Input
         - `method` (string), one of GET, PUT, POST, DELETE
         - `APIurl` (URI) complete (like "/v2.0/cloud/scene/rule?space_id=123456789")
         - `body` (JSON)  with required parameters (like {"properties":{"switch_1":false}} )
     - Output:
         - A msg for `global.tuyastatus.openapi` logging, having as `value` the result from OpenAPI (a JSON structure), 
         - or an error message.
 
- **APIstatus** pseudoDP: uses the Tuya API 'query_properties', is a replacement for "GET schema". Using this API has the advantage that the API result includes also the DPs.
     - Input: none
     - Output:
         - A msg for `global.tuyastatus.openapi` logging, having as `value` the API result (JSON),
         - A msg for `global.tuyastatus.&lt;device>` logging, having the read DP:values,
         - _note: if required the DP's `values` are decoded by the standard CORE DP logging process._
         - or an error msg.

- **APIinstruction** pseudoDP: uses the Tuya API 'send_properties', is a replacement for "MULTIPLE SET":
     - Input:
        - An object with couples (code:value) required by OpenAPI.
        -  _note: the `value` must be coded, if required by the DP definition (see device datasheet)._
     - Output:
        - A msg for `global.tuyastatus.openapi` logging, having as `value` the result from API.
        - or an error msg.

**global.alldevice update**
 - The only change is to make the device `id` _mandatory_ also for subdevices controlled by a hub (in `global.alldevice/virtual`, now optional). This is necessary to be able to use the new psudoDP. The device `id` can be provided by 'tuya_cli wizard' or SmartLife APP.
 - This change is without consequences because the 'virtual' test is always done looking at the presence of the CID, and, in the TuyaDAEMON's command messages, we can use any of `user_name | CID | ID` as an index for the device.

**tools update**
* The use of OpenAPI could allow the automation of some tedious manual steps still required by the tools, such as identifying the DPs of a new device.
* It also opens up the possibility of new tools, like an 'automation tool', to build a better alternative to SmartLife.
  
_Interesting opportunities to evaluate._



