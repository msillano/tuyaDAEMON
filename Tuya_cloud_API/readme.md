# Tuya Cloud API (OpenAPI)

[IoT Cloud](https://www.tuya.com/) by Tuya Smart is a global cloud platform that provides a comprehensive suite of IoT capabilities, including device management, scenario automation, data analytics, and industry services. Businesses of all sizes rely on Tuya IoT Cloud to develop and manage their IoT applications.

[Tuya OpenAPI](https://developer.tuya.com/en/docs/cloud) is a set of open Application Programming Interfaces (APIs) provided by Tuya Smart, accessible via REST (HTTP), which enables developers to seamlessly integrate Tuya Cloud services into their own applications.

### notes on Tuya OpenAPI V2.0

 The OpenAPI v. 2.0 (since June 20, 2023) uses two abstraction levels for device management: _standard devices_ and _code_. Standard devices are categorized by their set of properties, defined by `codes`: a map links `code` to device `DP`. This allows the creation of DP maps for devices that are not Tuya natives but can still be controlled using the Tuya Cloud. 

Additionally, OpenAPI v. 2.0 introduces the concept of _space_ and _subspace_ for defining the spatial location of devices. Spaces represent large areas, such as a home or office, while subspaces represent smaller areas within a space, such as a living room or bedroom.

note:
  - OpenAPI v. 2.0 also introduces _virtual devices_ (i.e. SW-only models from custom projects or TuyaGo) not to be confused with TyaDAEMON's _virtual devices_ (i.e. subdevices: Tuya HW devices using a hub). The _Tuya virtual devices_ do not affect TuyaDEAMON.
  - For APPs (SmartLife) Max. Limits (2023-09-19) see [here](https://support.tuya.com/en/help/_detail/K9q79msw3accz). For user limits see [here](https://support.tuya.com/en/help/_detail/K927ttzta56wa).

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
- SET your Tuya `SecretKey` in (all) `Sign signStr with secret` nodes (bug: dynamic secretkey option doesn't work on HMAC node).
- All flows are very similar, with a few differences - read the flow comments node for the required customizations.

**notes:**
 - You may need to add `node-red-contrib-crypto-js-dynamic` from the palette manager.
 - OpenAPI uses `codes` (tuya names for DPs) and not DPs. The output of the `Get SCHEMA V2.0` flow maps `DPs <=> codes` for a device.
 - API reference:
     - IoT-Core: Start [here](https://developer.tuya.com/en/docs/cloud) (registration required). 
 - This project is derived from the project by NotEnoughTech ([https://github.com/notenoughtech/NodeRED-Projects/tree/master/Tuya Cloud API](https://github.com/notenoughtech/NodeRED-Projects/tree/master/Tuya%20Cloud%20API)). See also [here](https://forum.hacf.fr/t/api-tuya-depuis-node-red/28774).

---
### TuyaDAEMON and Tuya Cloud API
The ability to access OpenAPI can open up interesting scenarios in [TuyaDAEMON](https://github.com/msillano/tuyaDAEMON/tree/main). Let's explore the various aspects:

**Device Control**

* Local access to Tuya real (WiFi) device properties is quite good with the [`tuya-smart-device`](https://github.com/vinodsr/node-red-contrib-tuya-smart-device) node; only in rare cases, the access via CloudAPI will be useful.

* Tuya devices such as WiFi low-power sensors, which cannot be managed with the `tuya-smart-device` node, are currently controlled in TuyaDAEMON with [TRIGGER](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaTRIGGER). While the Trigger technique, event-driven, is reliable and more stable than CloudAPI, it has limitations in reading numerical measurements. In such cases, the use of CloudAPI (e.g., API `Query_Properties` in polling) could be beneficial.

* Some [subdevices](https://github.com/msillano/tuyaDEAMON-applications/wiki/note-4:-Gateways-and-sensors) (using a hub) could also benefit from CloudAPI when not all DPs are accessible via the `tuya-smart-device` node.

**Device Management**

* Some non-basic aspects of device control (e.g., spaces (home), groups, automation) are only partially manageable via TRIGGER + Automation. If you want advanced applications in these areas, the use of CloudAPI is necessary.

* Some operations (such as adding/removing/renaming devices, creating/modifying smart scenes, etc.) are actually performed only using a Tuya APP (SmartLife). If you want to do this in a custom application, you must use CloudAPI.

**Smart scene linkage**

 In SmartLife the 'smart scene' management is not exactly user-friendly. In particular, I noticed the following problem:
 
*  When a device changes ID (for re-connection or replacement) all the _smart scenes_ connected to that device are "unavailable" (OK). Unfortunately, the same effect occurred when Tuya introduced 'standard devices' with a breaking update: the device `codes` changed (e.g. `countdown` becomes `countdown_1`) and every automation is now "unavailable" (KO). As a result, a user has to change the automation by manually re-entering _SmartLife_ with all the data or conditions, when a simple `ID` or `code` replacement would suffice. This can be really frustrating.
  
*  Manual Enable DP: "On the Tuya Smart platform, select your device on the Product page, click Extensions, and click Settings next to Scenario Connection Settings to check whether DPs for executing actions are configured for your device. If your device uses a standard solution, the DPs are fixed and enabled by default. If your device uses a non-standard solution, selected standard functions are enabled by default. However, you need to enable custom functions on the Scenario Connection Settings page." 

> TuyaDAEMON uses '[shares](https://github.com/msillano/tuyaDAEMON/wiki/30.-tuyaDAEMON-as-event-processor#share-and-command-chains)' as meta-language for user device automation and OO definition. This language is with an expressive power (Turing complete) not found in other IOT environments (including Tuya 'smart scene linkage').
 
> The use of [TRIGGER](https://github.com/msillano/tuyaDAEMON/blob/main/tuyaTRIGGER/README.md) allows bidirectional communications betwnen TuyaDAEMON 'share' and Tuya 'smart scene', i.e. a Tuya automation can use the TuyaDAEMON expressive power and vice-versa. This ability of mix meta-languages is not found in other IOT environments. 

**conclusion:**  From an open-strategy perspective, it is beneficial to create in TuyaDAEMON a new optional communication channel for OpenAPI, to be used only in essential cases, to minimize the TuyaDAEMON's dependences on the evolution and strategy of Tuya Cloud.

### core_OPENAPI: custom device
  A custom device, **core_OPENAPI** implements the TuyaDAEMON extension to OpenAPI, with the following objectives:
  
- Complete the access to/from Tuya devices, potentially setting/getting all available data to/from the Tuya Cloud.
- Enables access to information on devices, their DPs, etc...
- Extend the TuyaDAEMON/Tuya Cloud collaboration in areas (space, groups, smart scenes, etc.) application-related.
- Use and implementation of core_OPENAPI must be minimal, optional, and complete (all API must be callables).
- Minimal minds that API URL construction and the map code <=> DP are user-local, defined in call parameters, and not global: this is to exclude heavy `global.alldevices` extensions. 
  
**Specifications**

   The new device OPENAPI automatically gets and refreshes the token, and exposes only `one property`, two new [pseudoDP](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#pseudodp), and a function. The `pseudoDPs` are usable on any real/virtual tuyaDEAMON device (not on custom - fake - devices, not handled by Tuya Cloud):

- **_callAPI DP**:   Allows calls to any API, so the input data must be complete.
     - Input (`value`):
         - `method` (string), one of GET, PUT, POST, DELETE
         - `APIurl` (URI) complete (like "/v2.0/cloud/scene/rule?space_id=123456789")
         - `body` (JSON)  with required parameters (like {"properties":{"switch_1": false}} )
     - Output:
         - A msg for `global.tuyastatus.openapi._callAPI` logging, having as `value` the result from OpenAPI (a JSON structure), 
         - or an error message.
````
Example (API device info):
{
    "device": "_openapi",
    "property": "_callAPI",
    "value": {
        "method": "GET",
        "APIurl": "/v2.0/cloud/thing/&lt;a_device_id>",      // deviceId, also in 'device info' from SmartLife
        "body": ""
    }
}

RESULT: "RX: openapi/_callAPI"

  payload: {
    success: true
    result: {
        active_time: 1692989353
        category: "kg"              // manufacturer defined 
        create_time: 1613403089
        custom_name: "tuya_bridge"  // in  SmartLife
        icon: "smart/device_icon/eu1580902146346G23Gy/bf8c4fd0c03067079cplb1461381627983590.png"
        id: "1234567xx"             // same as in the call, required by tuya-smart-device (Device Virtual ID)
        local_key: "12345kk"        // required by tuya-smart-device (Device key)
        ip: "2.2.2.178"             // your public network IP address
        is_online: true
        product_id: "123456pp"      // Tuya unique label for each independent product. 
        model: "1CH"                // manufacturer defined
        name: "1CH 2"               // (brand) + (product) + (module model), manufacturer defined
        product_name: "1CH"         // manufacturer defined
        sub: false                  // is subdevice?
        lat: "41.9"
        lon: "12.4"
        time_zone: "+02:00"
        update_time: 1693051814
        uuid: "987654321"           // Tuya internal use
}}
````
- **_APIstatus** pseudoDP: uses the Tuya API 'query_properties', it is a replacement for "GET schema". Using this API has the advantage that the API result includes also the DPs.
     - Input: none
     - Output:
         - A msg for `global.tuyastatus.openapi._APIstatus` logging, having as `value` the API result (JSON),
         - A msg for `global.tuyastatus.&lt;device>` logging, having the read DP: values,
         - _note: if required, the DP's `values` are decoded by the standard CORE DP logging process._
         - or an error msg.
````
Example:
{
    "device": "tuya_bridge",
    "property": "_APIstatus",
}

RESULT: "RX: openapi/_APIstatus"

  payload: {
    success: true
    result: {
       properties: array[8]
       0:  {
           code: "switch_1"
           custom_name: "Free"
           dp_id: 1
           time: 1702399814901
           value: true
           }
       1: object
       2: object
       .....
}}

plus, for any property (8 in the example), a msg like this, to update 'tuyastatus' and DB:

   ["RX: tuya_bridge/relay", "ON"]
````
note: _in TuyaDAEMON `tuya_bridge` is the device's user_name, `relay` is the 'DP 1' user_name, and `ON` is the value `true` decoded by 'BOOLEANONOFF' user decode function, as defined in the datasheet, and in `global.alldevices`._     
         - 
         
- **_APIinstruction** pseudoDP: uses the Tuya API 'send_properties', it is a replacement for "MULTIPLE SET":
     - Input:
        - An object "properties" with couples (code: value) as required by the API body.
        -  _note: the `value` must be coded, if required by the DP definition (see device datasheet)._
     - Output:
        - A msg for `global.tuyastatus.openapi._APIinstruction` logging, having as `value` the result from API.
        - or an error msg.
````
Example:
{
    "device": "tuya_bridge",
    "property": "_APIinstruction",
    "value": {
                 "properties": {
                    "switch_1": false
                    }
             }
}

RESULT: "RX: openapi/_APIinstruction"

  payload: {
    success: true
    result: { empty }
    }
````
note: _the msg ["RX: tuya_bridge/relay", "OFF"] is sent by the device as an echo of the executed instruction, if `tuya_bridge/relay` changed._


- **openapi_in** function(): called by a 'link call' node, this entry-point allows the use of `core_OPENAPI` as a function, in any TuyaDAEMON flow.
     - Input: like _callAPI, but in `msg.payload`:
         - `method` (string), one of GET, PUT, POST, DELETE
         - `APIurl` (URI) complete (like "/v2.0/cloud/scene/rule?space_id=123456789")
         - `body` (JSON)  with required parameters (like {"properties":{"switch_1": false}} )
     - Output: like _callAPI:
         - A msg having in 'payload' the result from OpenAPI (a JSON structure), 

Example (API device info):
````
       {
        "method": "GET",
        "APIurl": "/v2.0/cloud/thing/&lt;a_device_id>",     
        "body": ""
       }
````
RESULT: see _callAPI

**error handling**

Having data entered by the user presents the possibility of errors. However, the error messages provided by OpenAPI are detailed, and this immediately identifies the affected area (token, parameters, deviceID, etc.).

To simplify user tasks, i.e. to use tuya_OPENAPI in a more controlled and automatic way, it is possible to use a 'share'. The following snippet adds a _new method_ (DP) for a switch (e.g. 'tuya_bridge'), defined as 'clear' (_note: the same result can be achieved without using `openapi`; here just as a simple example_):
````
               {
                    "dp": "_clear",
                    "name": "clear",
                    "capability": "SKIP",
                    "share": [
                        {
                            "action": [
                                {
                                    "property": "_APIinstruction",
                                    "value": {
                                        "properties": {
                                            "switch_1": false,
                                            "countdown_1": 0
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                },
    
Now to call 'clear' you use the standard SET TuyaDAEMON msg:

{
    "device": "tuya_bridge",
    "property": "clear",
    "value": "any"
}

RESULT on debug pad:

[ "RX: tuya_bridge/clear", "any" ]
[ "RX: openapi/_APIinstruction", object ]
[ "RX: tuya_bridge/relay", "OFF" ]         // only if 'tuya_bridge/relay' changed
[ "RX: tuya_bridge/trigger", 0 ]           // only if 'tuya_bridge/trigger' changed

````

#### Installation
Requires CORE ver. 2.2.4.
As usual, see for updated details the node `*Global OPENAPI config` in the 'core_OPENAPI' flow.

-----
**global.alldevice update**
 - The only change is to make the device `id` _mandatory_ also for subdevices controlled by a hub (in `global.alldevice.virtual`, now optional). This is necessary to be able to use the new psudoDP. The device `id` can be provided by 'tuya_cli wizard' or SmartLife APP.
 - This change is without consequences because the 'virtual' test is always done looking at the presence of the CID, and, in the TuyaDAEMON's command messages, we can use any of `user_name | CID | ID` as an index for the device.
 - Of course, in `global.alldevice.fake` (in `CORE_devices` flow, `*Global CORE config` node) we need to add the core_OPENAPI definition; minimal is:
   ````
        {
            "id": "_openapi",
            "name": "openapi",
            "dps": [
                {
                    "dp": "_callAPI"
                },
                {
                    "dp": "_APIstatus",
                    "capability": "SKIP"
                },
                {
                    "dp": "_APIinstruction",
                    "capability": "SKIP"
                }
            ]
        },
   ````

note: Although `_APIstatus` and `_APIinstruction` are actually _pseudoDP_, they are present as DP in `alldevice.fake`, to allow definition and control of the log output.
   
### tools update (preliminary)
* The use of OpenAPI could allow the automation of some tedious manual steps still required by the tools, such as identifying the DPs of a new device.
* It also opens up the possibility of new tools, like an 'automation tool', to build a more user-friendly alternative to existing APPs like SmartLife (for example, as required by 'mirror' devices setup).

