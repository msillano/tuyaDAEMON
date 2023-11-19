# TuyaDAEMON core

_TuyaDAEMON's goal is to integrate the entire Tuya ecosystem into node-red, creating a new level of abstraction that includes both Tuya-cloud and all possible custom extensions._

TuyaDAEMON isolates your IOT **custom application** from all details of _device data and commands exchanges_:
- do not require user hacking in any Tuya or custom device.
- allows bidirectional exchanges to/from _any Tuya or custom device or Tuya-cloud_.
- decodes and transforms incoming data to _standard units_.
- manages all codifications and checks before sending your _commands to devices_
- tuyaDAEMON is 'open' by design:
    - updates the `global.tuyastatus` structure (_device:property:value_) with all status messages from all controlled devices.
    - logs all commands and events in the mySQL `'tuyathome:messages'` table
    - offers complete HTTP REST interfaces (and MQTT with `core_MQTT` module)
- uses _friendly names_ for all devices and properties, in any language

### IMPLEMENTATION

 To interact low-level with _Tuya devices_ I chose [`node-red-contrib-tuya-smart-device`](https://github.com/vinodsr/node-red-contrib-tuya-smart-device), which uses [tuyapi](https://github.com/codetheweb/tuyapi), the most interesting software on **tuya<=>node-red** integration that I have found.
 They do their job well, but there are some limitations:
   
  1) The capabilities of the Tuya communication are very variable for different devices: e.g. I have found very few devices that respond to `schema` requests, and found cases where the data exchanges are not MQTT (e.g. infrared universal control).

  2) Some devices are unreachable: **TuyAPI** does not support some sensors because they only connect to the network when their state changes. They are usually battery-powered WiFi devices ([see note](https://github.com/codetheweb/tuyapi#-notes)).
 
 3) _Tuya devices_ can update their own firmware version via **OTA**: for the user, this is an investment guarantee, but it can introduce problems when the software (`tuyapi` and `tuya-smart-device`) is not updated: some device messages can't be decoded (see [issue#17](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/27)).
 
 4) Tuyapi sometimes finds an error message from devices: `"json obj data invalid"`: the source of this is not clear (see [issue#246](https://github.com/codetheweb/tuyapi/issues/246)), maybe a catch-all error message, but the best interpretation is "_the required operation is not available_" (see also [here](https://github.com/msillano/tuyaDAEMON/wiki/50.-Howto:-add-a-new-device-to-tuyaDAEMON#11-test-getset-bad-response-2--json-obj-data-unvalid)).
 
 5) Each _Tuya device_ can only make a limited number of simultaneous MQTT connections. This number, which differs from device to device, can be low: in this case, the device will close the tuyaDEAMON connection when one or more apps (smartLife, Tuya smart, google home ...) are active. Fortunately, I only found a few devices with very low potential connections. 

 _To manage such a rapidly changing environment, I choose to use a data structure in **tuyaDAEMON** to describe individual devices and single datapoint capabilities, so that all operations that are actually not managed or bogus can be intercepted and not sent to the device, giving stable and reliable operations with no surprises. And if the evolution of the SW offers us new features, it is easy to update the behavior of tuyaDAEMON._
 
 _To enable HI-LEVEL communications with Tuya-cloud you must use the [tuyaTRIGGER module](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaTRIGGER) which uses an alternative communication mechanism with the devices._
_This allows [fast and reliable](https://github.com/msillano/tuyaDAEMON/wiki/60.-tuyaTRIGGER-info) two-way communication of commands and events even with all devices not reachable via MQTT from the `tuyapi` library (WiFi sensors, IR controls, etc.)._

_**The use of tuyaDAEMON CORE + tuyaTRIGGER guarantees the user that in any case all Tuya devices can be integrated.**_

_"fake" devices_ can be implemented with specialized flows, to handle _custom (non-Tuya) devices_. In many cases, the required interface is a simple protocol adapter, as in the case of [MQTT devices](https://github.com/msillano/tuyaDAEMON/wiki/custom-device--MQTT-'Ozone_PDMtimer'-case-study) or in the case of the [PM detector](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-'PM-detector':-case-study), a device using the USB-COM interface.

### applications
_tuyaDEAMON is a powerful [event processor](https://github.com/msillano/tuyaDAEMON/wiki/30.-tuyaDAEMON-as-event-processor) with a rich framework for IoT, offering power users many ways to implement their own projects:_

1. users can add new functionalities, i.e. new tasks, building more js SW-only devices, to cover the sector of interest (see [_system](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-_system), it adds, among other things, benchmarks, text-to-speech, etc. capabilities to tuyaDAEMON). 
2. users can add any not-Tuya hardware device, with a simple node-red interface flow (see [433 MHz gateway](https://github.com/msillano/tuyaDAEMON/wiki/case-study:-433-MHz-weather-station)).
3. users can design and build new devices derived from existing ones, in OO style (see [OO devices](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#oo-devices) and [watering_sys](https://github.com/msillano/tuyaDAEMON/wiki/derived-device-'watering_sys':-case-study))
4. users can build inside tuyaDAEMON ['chains' (meta-programming)](https://github.com/msillano/tuyaDAEMON/wiki/30.-tuyaDAEMON-as-event-processor#share-and-command-chains) using existing tasks to get the required event-driven behavior: tests, delays, sequences, repetitions and fork of tasks  are simple to implement in JSON  + js (example: [system.beep_loop](https://github.com/msillano/tuyaDAEMON/wiki/30.-tuyaDAEMON-as-event-processor#iteration)).
5. the entire tuyaDAEMON engine can be integrated into any larger user project using the favorite interface: node-red or MQTT or HTTP REST or database.
 
 _Any effort is made to make it modular, small, easy to modify, and [fully documented](https://github.com/msillano/tuyaDAEMON/wiki)._
 
 
 In **tuyaDAEMON**  since 2.0 we have 3 main modules plus some extras:
 
![](./../pics/tuyadaemon01.jpg)

![](./../pics/tuyadaemon07.jpg)

 
 - **tuyaDEAMON CORE:** the main flow, for low-level MQTT communication with many tuya `'real' devices`, and also with devices using a _gateway_ (`'virtual' devices`) e.g. Zigbee sensors. (since ver 2.2.2: splitted for user convenience into two flows, 'CORE' and 'CORE_devices').
 
 - [**tuyaTRIGGER module**](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaTRIGGER) for Tuya-cloud comunications, adds extra capabilities:
   - The start of **tuya automations** from _node-red_.
   - The ability to fire **node-red flows** from _smartlife_, enabling _node-red remote_ and _vocal_ control.
   - The management RT of `'mirror' devices` for _all devices not caught at low-level by **tuyapi**_.
  
   
  - [**System module:**](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-_system) offerts some useful properties: _Alarms_ in case of WiFi, Lan or AC power down, access to remote tuyaDEAMON servers, text-to-speech, etc. See also the [reference documentation](https://github.com/msillano/tuyaDAEMON/blob/main/devices/_system/device__system.pdf).
 
 ------------------------------
  - **tuyaDEAMON MQTT:** a broker that offers access to tuyaDAEMON via MQTT and allows the use of [simple UI](https://raw.githubusercontent.com/msillano/tuyaDAEMON/main/pics/ScreenShot_20210612210400.png).
  
  - **433 MHz gateway module:** a module to receive data from devices using 433.92 MHz, 868 MHz, 315 MHz, 345 MHz and 915 MHz ISM bands. [Two devices](https://github.com/msillano/tuyaDAEMON/wiki/case-study:-433-MHz-weather-station) implemented: 'Weather station' and 'extra temperature' probes.

  - _Extra flow_: ["PM detector"](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-'PM-detector':-case-study), a `'custom' device` study case, this device uses USB-serial to communicate.
 
 - _Extra flow_: ["watering_sys"](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-'watering_sys':-case-study), a `OO level 2 device` study case, a custom super-device build using 2 switches and 1 sensor. With an UI ad hoc.
 
 - _Extra subflow_: ["Ozone_PDMtimer"](https://github.com/msillano/tuyaDAEMON/wiki/custom-device--MQTT-'Ozone_PDMtimer'-case-study) example of MQTT devices integration, using a general purpose MQTT-tuya adapter node.
 
- _Extra flow_: "mirror devices" with some examples of triggers use.
 
- **tuyaDAEMON.toolkit** is an [external application](https://github.com/msillano/tuyaDAEMON/wiki/90.-tuyaDAEMON-toolkit) in PHP that uses a MySQL database to store all information about the devices and creates some useful artifacts. Using this app, you can test the capabilities of any new device, sending commands (GET/SET/MULTIPLE/SCHEMA/REFRESH) to all DPs. A growing collection of documentation about [known devices](https://github.com/msillano/tuyaDAEMON/tree/main/devices) is ready, but it is easy to extend it to your new devices.

- **tuyaDAEMON.things** is an [external application](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaDEAMON.things) in PHP that uses a MySQL database to store information about all device instances (Tuya and custom, including comments, shares, etc.) used in one or more tuyaDAEMON servers. Using this app, which extends tuyaDAEMON.toolkit, you can  import/export the 'alldevices.json' structure and do things' definitions and management in small chunks with accessible CRUD forms.

### configuration (all modules)
   
1) Since 2.2.0, all configuration data are in a `Global MODULE config´ node, with a friendly user interface, mandatory in any module, to make simple the configuration task. **_Refer to this _node info_ for up-to-date configuration instructions for each module._**
    - Only a few node-red configuration nodes still require the user direct setup: _mySQL, MQTT, tuya-smart-device_ (new devices).     
     
2)  _Global CORE config_ node (since ver. 2.2.2 in 'CORE_devices' flow) includes [`global.alldevices`](https://github.com/msillano/tuyaDAEMON/wiki/40.-tuyaDAEMOM-global.alldevices), a big JSON structure with all required information on all devices, that control the _CORE_ behavior on a device/dps basis. <br>
Any [new device](https://github.com/msillano/tuyaDAEMON/wiki/50.-Howto:-add-a-new-device-to-tuyaDAEMON) must be added to it. To update/modify/edit this structure:
    - you can edit it directly using the `global CORE config` node, using the JSON edit facility.
    - you can export it to the file `alldevices.json` for backup or edit it using external editors (e.g. _Notepad++_ and _'JSON Viewer'_ plugin) and back with copy-paste.
    - For _known tuya devices_ a JSON fragment for `'alldevices'` is in standard device documentation [file zip](https://github.com/msillano/tuyaDAEMON/tree/main/devices#use).   
    - The application [tuyaDAEMON.toolkit](https://github.com/msillano/tuyaDAEMON/wiki/90.-tuyaDAEMON-toolkit) can produce an `'alldevice'` basic fragment for a new device.
    - The application [tuyaDAEMON.things](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaDEAMON.things) enables the 'alldevices' definition and management in small chunks with accessible CRUD forms.
      
3) All nodes requiring or allowing some user update are named with an asterisk (e.g. '*device selector') and in the  'node description' you can find specific instructions.
 
 ### First-time installation (CORE)
 - Precondition: It is not required to have any Tuya device to install or test tuyaDAEMON, you can use it as the framework for any IOT purpose. You can also never use Tuya devices, but only custom devices (USB, MQTT, tasmotized, etc...).
    - Since ver.2.2.0: you can test any module capabilities and add later the devices. 
   
 - Precondition: a clean `node-red` installed and working.
     - see [multiple instances](https://github.com/msillano/tuyaDAEMON/wiki/20.-ver.-2.0--milestones#multiple-instances-of-tuyadaemon-in-the-same-server) before install tuyaDEAMON.
     - see also: [node-red](https://nodered.org/docs/getting-started/)
     - _For Android top-box deployment see the [wiki](https://github.com/msillano/tuyaDAEMON/wiki/80.-deployment:-android-server)._
     - _May 2023: Installed in an older iMac 2008: OS 'El Capitain' 10.11.0, node v. 14.21.3, node-red v 3.0.3 + MAMP + MQTT explorer._
   
 - Precondition: a _mySQL_ server is optional, but required for serious use.
     -  The default is local MySQL ('node-red-node-mysql' is used) and, for a simple installation, you can
		  use distribution as WAMP (or XAMP, LAMP, MAMP, etc.): phpMyAdmin and Apache server are included.
          _You can also use a DB accessible on the net; the DB doesn't need to be on the same server as node-red_.
     - Import, using phpMyAdmin, the  `DB-core.x.x.x.sql`  to create the required DB and tables. 
     - More DB tables can be required by some modules: see for 'DB-modulex.x.x.x.sql.zip'.
     - you can install MySQL later: install TuyaDAEMON and disable the three MySQL nodes in CORE.

 - Precondition: when you want to add _Tuya devices_
     - A robust WiFi router (best with UPS).
     - The [SmartLife](https://apkpure.com/en/smart-life-smart-living/com.tuya.smartlife) APP running on a smartphone.
     - New Tuya devices must first be added to SmartLife and work properly.
 
 1. Install in node-red the nodes (I use 'manage pallette') : 
   - indispensable, required by CORE  
     - [node-red-node-mysql](https://flows.nodered.org/node/node-red-node-mysql)
     - [node-red-contrib-config](https://flows.nodered.org/node/node-red-contrib-config)
     - [node-red-contrib-looptimer-advanced](https://flows.nodered.org/node/node-red-contrib-looptimer-advanced)
     - [node-red-contrib-tuya-smart-device](https://flows.nodered.org/node/node-red-contrib-tuya-smart-device)
       
       - Using the `node-red-contrib-tuya-smart-device`: the ver. **5.2.0** is ok.
       - _for v. 4.1.1 see [issue#83](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/83)_
       - _for v. 5.0.1 see [issue#113](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/113)_
       - _for v. 5.1.0 see [ISSUE#118](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/118): replace the file `...\node_modules\node-red-contrib-tuya-smart-device\src\tuya-smart-device.js`._

   - required by other modules: SYSTEM
     - [node-red-contrib-jsontimer](https://flows.nodered.org/node/node-red-contrib-jsontimer)
     - [node-red-contrib-play-audio](https://flows.nodered.org/node/node-red-contrib-play-audio)
     - [node-red-node-base64](https://flows.nodered.org/node/node-red-node-base64)
   
   - required by other modules: MQTT
     - [node-red-contrib-aedes](https://flows.nodered.org/node/node-red-contrib-aedes)

  - optional, required by some custom devices:
    - [node-red-contrib-timerswitch](https://flows.nodered.org/node/node-red-contrib-timerswitch) (PM-detector, watering_sys)
    - [node-red-contrib-ui-led](https://flows.nodered.org/node/node-red-contrib-ui-led) (watering_sys)
    - [node-red-dashboard](https://flows.nodered.org/node/node-red-dashboard) (watering_sys)
    - [node-red-node-serialport](https://flows.nodered.org/node/node-red-node-serialport) (PM_detector)
    - [node-red-contrib-rtl_433](https://flows.nodered.org/node/node-red-contrib-rtl_433) (433_gateway)
 
     Alternative: Install a TuyaDAEMON module, then add the missing nodes as required by node-red messages.
        
2. The best way is to get the last version for single modules, starting from  [tuyaDAEMON.CORE-install-x.x.x.zip](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaDAEMON).
3.  See the info on the ´global CORE config´ node, it contains all the updated configuration instructions (select the node the click the `[i]` button). 
4.  Using 'full' files is faster than installing individual modules, but the configuration must always be done module by module. Advisable in case of updates, the first time is better one module at a time.

### module installation (addons) ###

TuyaDAEMON is modular: all extensions are implemented as node-red flows (modules), that the user can add to CORE.
- _CORE extensions_, to add features to TuyaDEAMON CORE: TRIGGER, SYSTEM, MQTT ..., implemented as 'devices'.
- _custom devices_, to do required protocol conversions: USB/COM, RF 433 MHz, etc...
- _subflows_, ready functional blocks, to simplify common operations or to replace *tuya-smart-device* nodes: MQTT...

1. Adding a new device (or module) you must:
    - Import the <module_nodered>.json file in node-red, then do 'Deploy'
    - For any added device, you must update the 'Global.alldevices' structure in  `*Global CORE config` node. The data are in:
    
       - the `device_xxxx.json` file in the installation package.
       - for some [known devices](https://github.com/msillano/tuyaDAEMON/tree/main/devices) data are public.
       - user built step-by-step following [instructions for new devices](https://github.com/msillano/tuyaDAEMON/wiki/Howto:-add-a-new-device-to-tuyaDAEMON).
       - built by [tuyadaemon-toolkit](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMON-toolkit), for a new device.
       - [tuyadaemon-things](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaDEAMON.things) tool can also be used to edit and built the structure 'Global.alldevices'.
        
2.  For any added TuyaDEAMON module, read the flow description and see the info of the ´global MODULE config´ node: it contains all the updated configuration instructions (select the node then click the `[i]` button). 
3.  In each module, you will find some standalone tests (see also each test node info) to verify your installation: after you can disable/delete them.
4.  Caveat: after a module 'Import' + 'Deploy' always _verify all external links_: sometimes (not clear why) the `external 'link' nodes` are not correctly updated.

-------------------
 ### Tuya devices capabilities, _as currently known_ ###
 
_Any Tuya device, any DP can have its own behavior: Tuya devices use a poll of [common HW, definitions](https://developer.tuya.com/en/docs/iot/terms?id=K914joq6tegj4) and code, but they are designed by different manufacturers, with objectives and exigences very different. (e.g.: some manufacturers try to promote their apps, reducing the performance of their products in the Tuya environment; individual manufacturers are not interested in automation, and often neglect this aspect, etc...).
Usually, it is very dangerous to make generalizations based on a few cases._


**Device Capabilities:**

**response:**
All Tuya devices react to external or internal commands by sending messages, which we find in output from the *tuya-smart-device* nodes (see [TuyAPI docs](https://codetheweb.github.io/tuyapi/index.html)). All responses have the same format: one or more pairs _(dp: value)_, regardless of whether they are caused by PUSH, REFRESH, GET, SET, SCHEMA, MULTIPLE commands (see `CORE.logging node _info_ for details).
````
msg.payload:{     
        "deviceId":    gatewayID|deviceid,       // from subdevices => "deviceId": gatewayId
        "deviceName":  name,                     // from tuya-smart node
        "data": {
            "t": Math.floor( Date.now() / 1000 );       // timestamp (sec), by tuya-smart node
            "cid": deviceid;                            // only from subdevices
            "dps":{
                [dp]: value                             //  atomic or string or encoded 
               ...                                      //  In some cases more than one dp
            }}}}
````

note 05/2023: _I found an exception, a new response format (see [ISSUE#117](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/117)) by a gateway._

**MULTIPLE:** Implemented in a few devices, it acts like many SETs. It can return:

- all DPs in the command
- only the modified DPs
- a mixed strategy: if any DP changes, it returns only the modified DPs, otherwise all the DPs. (e.g. [power\_strip](https://github.com/msillano/tuyaDAEMON/blob/main/devices/power\_strip/device\_power\_strip.pdf)).
- deprecated in tuyaDAEMON because it requires encoded data values.
  
**SCHEMA:** implemented in a few bigger devices, returns the values of all (or only some) DPs (e.g. [ACmeter](https://github.com/msillano/tuyaDAEMON/blob/main/devices/ACmeter/device\_ACmeter.pdf)).

**REFRESH:** implemented in a few devices, forces a new data sample or update. Returns only the PDs that have changed. 

- _smartLife app_ repeats REFRESH every 5s, when it is required by a responsive UI, but only when the UI is visible, to reduce the resources use.

**Data Point Capabilities:**

_The value of a DP is usually atomic (boolean, integer, string), for easy use in tuya-cloud automation. 
But some DPs can use structured values, e.g. in the case of configuration data, usually defined on a page of the tuya UI, and not used in automation. Structured data is usually JSON, base64 encoded. In many cases, the ´encode/decode´ functions (see <code>core_devices.ENCODE/DECODE user library</code> node) are indispensable for obtaining human-readable values._

Any DP as is own behavior:

- A DP can be proactively **PUSHED** by a device, especially to keep the UI up to date:
   - at regular intervals (for example, every hour, at XX:00:00 see [TRV_Thermostatic_Radiator_Valve](https://github.com/msillano/tuyaDAEMON/blob/main/devices/TRV_Thermostatic_Radiator_Valve/device_TRV_Thermostatic_Radiator.pdf).'Hist day target T').
   - at irregular intervals (unknown rule) (e.g. [Temperature_Humidity_Sensor](https://github.com/msillano/tuyaDAEMON/tree/main/devices/Temperature_Humidity_Sensor/device_Temperature_Humidity_Sensor.pdf).'temperature')
   - at a change in value (e.g. every 30s * k: [smart_breaker](https://github.com/msillano/tuyaDAEMON/blob/main/devices/smart_breaker/device_smart_breaker.pdf).'countdown ', e.g. at any variation: [device_switch-4CH](https://github.com/msillano/tuyaDAEMON/blob/main/devices/switch-4CH/device_switch-4CH.pdf).'countdown1')
   - to inform the user about the progress of a slow task  (e.g. [WiFi_IP_Camera](https://github.com/msillano/tuyaDAEMON/blob/main/devices/WiFi_IP_Camera/device_WiFi_IP_Camera.pdf ), after SET('start SD format', any))
   - for some DPs (e.g. sensors) PUSH may be the unique capability (e.g. [Temperature_Humidity_Sensor](https://github.com/msillano/tuyaDAEMON/tree/main/devices/Temperature_Humidity_Sensor/device_Temperature_Humidity_Sensor.pdf)).

- **GET(DP)** is without side effects, it can be requested as many times as you want. GET returns:
    - the present **DP** value
    - the last **PUSHED** value (e.g. [switch-1CH](https://github.com/msillano/tuyaDAEMON/blob/main/devices/switch-1CH/device_switch-1CH.pdf).'countdown ')
    - all (or many) DPs (such as **SCHEMA**), ignoring the DP in the request (e.g. [power_strip](https://github.com/msillano/tuyaDAEMON/blob/main/devices/power_strip/device_power_strip.pdf)).
 
- **SET(DP, value)** If the value is **_not null_**, updates the DP value and returns the new value (or returns no value: SET and forget):
    - can be used as a **trigger**, i.e. with side effects, in this case, the value may be useless and 'any' (e.g. [WiFi_IP_Camera](https://github.com/msillano/tuyaDAEMON/blob/main/devices/WiFi_IP_Camera/device_WiFi_IP_Camera.pdf ).'start SD format')

- **SET(DP, null)** If the value is **_null_**, returns the last DP value:
    - if it works, can be used instead of **GET(DP)**. It is useful when GET(DP) is not standard or not available (e.g. [Power_strip](https://github.com/msillano/tuyaDAEMON/blob/main/devices/power_strip/device_power_strip.pdf)).
    - can be the only capability available: no other SETs, no GETs. (e.g. [device_WiFi_IP_Camera](https://github.com/msillano/tuyaDAEMON/blob/main/devices/WiFi_IP_Camera/device_WiFi_IP_Camera.pdf).'SD status')
    - can be not allowed: all SET(DP, value) are ok, but not SET(DP, null).

**IMPORTANT**: Sending commands that are _not implemented_ or _not allowed_ or sending _wrong data type_ or _wrong value_ to a DP can have many bad effects:

- Nothing, silent ignore
- SET/GET of unexpected values
- the message _"json obj data unvalid"_
- waiting for some time, then device disconnection.
- gateway disconnection.
- the device "reboots themself".
- the device hangup (dead) and you must restart it.
- the device hangup and you get only _"json obj data unvalid"_
- the gateway hangup (dead).

To design node_red applications using Tuya devices is always necessary:
1. study each new device in detail, as explained [step by step here](https://github.com/msillano/tuyaDAEMON/wiki/Howto:-add-a-new-device-to-tuyaDAEMON).
2. If you use a few devices, you can design an ad-hoc node-red flow, tuned on your devices.
3. As a general solution, to have a flexible but robust framework, better to use a data structure that verifies the commands sent to each device (like [global.alldevices](https://github.com/msillano/tuyaDAEMON/wiki/tuyaDAEMOM-global.alldevices) object does in tyuaDAEMON CORE).
 
--------------------

**versions**
_tuyaDAEMON version 2.2.3_ 
  - node-red-contrib-tuya-smart-device 5.2.0: _Added new command 'SET_EVENT_MODE' (values: 'event-both' (default), 'event-data', 'event-dp-refresh')._

_tuyaDAEMON version 2.2.2_ 
  - node-red-contrib-tuya-smart-device 5.1.0
  - TuyAPI 7.5.1
  - Maintenance release.
  - Refactoring device installation nodes
  - bug fixes and minor code updates

_tuyaDAEMON version 2.2.1_ 
  - tuyapi ver. 7.3.0
  - Maintenance release.
  - use of credentials for device ID and key
  - bug fixes and minor code updates

 

_tuyaDAEMON version 2.2.0_ 
  - node-red-contrib-tuya-smart-device 4.1.1, modified as in [ISSUE#83](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/83).
  - tuyapi ver. 7.2.0
  - Maintenance release: better user experience, installation, customization.
  - standardization of startup and options in 'Global MODULE config' nodes.
  - Refactoring 'json_library', now implemented as a global singleton.
  - separate node for encoding/decoding functions library.
  - added "hide" field to global.alldevices for user visibility control.
  - bug fixes and minor code updates
  - added properties to 'core' and 'trigger' (new 'fake' devices).
  - added tests to any module

    
_tuyaDAEMON version 2.1_ (13/06/2021)
- node-red-contrib-tuya-smart-device 4.1.1
- tuyapi ver. 7.2.0
- Added tuyaDAEMON MQTT interface
- minor bug corrections

_tuyaDAEMON version 2.0_ (13/05/2021)
- node-red-contrib-tuya-smart-device 4.0.2, modified as in [ISSUE#57](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/57#issue-863780858).
- tuyapi ver. 7.1.0
- General revision: core added OO and remote extensions,  added 'share'.
- Refactoring '_system'.,  Updated wiki
- more custom devices (water_sys, PM_detector)

   note: Don't use the **node-red-contrib-tuya-smart-device 4.0.1** because it presents [some problems](https://github.com/vinodsr/node-red-contrib-tuya-smart-device/issues/54).

_tuyaDAEMON version 1.3_ (01/03/2021)
- node-red-contrib-tuya-smart-device 3.0.2
- tuyapi ver. 6.1.1
- Tuya_bridge uses the TYWR 7-32 relay. Trigger flows refactoring to separate custom flows.
  
_tuyaDAEMON version 1.2_ (12/02/2021)
- node-red-contrib-tuya-smart-device 2.0.0
- tuyapi ver. 6.1.1
- Added REST interface.
- new tuyaDAEMON.toolkit 1.0.
- Updated wiki documentation, and added known devices.

_tuyaDAEMON version 1.1_ (19/01/2021)
- node-red-contrib-tuya-smart-device 2.0.0
- tuyapi ver. 6.1.1
- Code refactoring: added getter methods JSON library.
- Added DB ALARM, START ALARM.

_tuyaDAEMON version 1.0_ (15/01/2021)
- node-red-contrib-tuya-smart-device 2.0.0
- tuyapi ver. 6.1.1
- Initial version     
