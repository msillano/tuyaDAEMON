# tuyaTRIGGER 

_A real device WiFI, having  a big unused numerical parameter, say a 'counter', accessible via MQTT by both **Tuya** and **node-red**, is all the required hardware to implement a robust bilateral event communication (**TRIGGER**)._

This 'counter' is used as a dual port HW register: a sender (_tuya-cloud/node-red_) set the counter to some XX value, the receiver gets the XX value, acts accordingly, and resets the counter to 0 (ACK action): _node-red_ read/write actions are performed by the **tuyaTRIGGER** flow, _Tuya-cloud_ actions are performed by ad hoc automations, one for TRIGGER.

 - _node-red => tuya_ (**REDTRG**): **node-red** write a predefined value in the 'counter' (say 1010) and that fires a specific **Tuya** automation: first the automation must reset the 'counter' to 0, then it can do anything.
 Tuya automation, named `trigger1010`:   _If "counter:1010" do "counter:0" and "any-action..."_ 

 - _tuya => node-red_ (**TUYATRG**): A tuya **scene** (user action) or **automation** (event) sets  a predefined value on the 'counter' (e.g. 2030), and when node-red knows that, it must first reset  the "counter' to 0, then it can do anything.
 Tuya automation,  say `trigger2030`: _If "any-event" do "counter:2030"_ 

This [**TRIGGER** mechanism](https://github.com/msillano/tuyaDAEMON/wiki/60.-tuyaTRIGGER-info), implemented in **core_TRIGGER**, allow a better _tuya <=> node-red_ integration:
 - _node-red_ can set/get status for _all devices and data point_ not found by `node-red-contrib-tuya-smart-device`.
 - _node-red_ can fire automation on _tuya-cloud_ 
 - _tuya scene_ can control _node-red flows_, so a node-red user can employ _smartlife_ as remote control (from anywhere).
 - _tuya automations_ can fire flows in _node-red_, implementing this way any advanced strategy not allowed by Tuya.
 - user can fire _node-red flows_ with vocal control (e.g. `Googlehome`)
 
### implementation

_This technique can be used with any device, named in the flow and in `alldevices` "tuya_bridge", that meet some conditions:_
  - A large numerical dp e.g. countdown present in some switch devices.
  - Idipendence: setting the countdown to 0 does not toggle the switch.
  - In case of countdown, the value must be PUSHed with a fixed frequence.

[![](./../pics/tuyadaemon04.jpg)](https://github.com/msillano/tuyaDAEMON/blob/main/devices/Smart_switch01/device_Smart_Switch01.pdf) [![](./../pics/tuyadaemon05.jpg)](https://github.com/msillano/tuyaDAEMON/blob/main/devices/switch-1CH/device_switch-1CH.pdf) ![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/tuya-bridge02.jpg)

1) _I choose first the Tuya_ [Switch MS-104](https://github.com/msillano/tuyaDAEMON/blob/main/devices/Smart_switch01/device_Smart_Switch01.pdf) (USD 8) _because its countdown (`dp` = 102) is with a large range [0-86400s, i.e. 24H] and still the device can be used as a WiFi switch, because only the countdown is used by tuyaTRIGGER, plus it is small and cheap._ 

   The unique problem with this switch is the lack of a battery backup.

2) _I also tested another device, a Tuya wifi switch_ [TYWR 7-32](https://github.com/msillano/tuyaDAEMON/blob/main/devices/switch-1CH/device_switch-1CH.pdf) (USD 10) _with a micro USB input, so it can be used with a power bank to get a UPS power supply._
It has all required features:  countdown (`dp` = 7) with a large range [0-86400s, i.e. 24H], independence, 30s PUSH period, so it is better than Switch MS-104.

   As against it is bigger and without case, and needs an external UPS power supply.
   
   I changed `tuya_bridge` to TYWR 7-32 at ver. 2.0: I put it in a box and connected it to the Android server USB, because this server is with a UPS power supply.

4)  CUSTOMIZATION: you can use other devices to implement 'tuya-bridge'. See updated information on 'Global TRIGGER config' node and 'triggerMAP (readme)' node (since 2.2.0).


**note**
 - **TuyaTRIGGER** is based on simple automations in _tuya-cloud_, more stable over the time and reliable than the protocols used with the devices, which can change with each new version.
 
 - analog values can't be sent from Tuya this way, because tuya-cloud does not allow the use of calculated values. But comparations are allowed: e.g. send trigger if `'temperature < 16'`. (Available: `<`; `=`; `>`). We can 'mirror' `BOOLEAN` dp (2 automations) `ENUM` dp: [0|1|2]  (3 automations) or also `INT`, but converted to ENUM when required: `{<16|16-20|21-25|26-30|31-35|36-40|>40}` but many automations are required (7 for this example).

 - using a countdown as a trigger, as _all switches_ does, requires REDTRG with numbers greater (e.g. 5000+) than TUYATRG (e.g. 1100..4999]): so, if _node-red_ is down, a Tuya TRIGGER action not caught can't trigger a REDTRG command.
 
 - If the counter used is a time counter (countdown in the case of switches) it is necessary to choose trigger values at least separated by enough time, to allow the ACK action. 
  
 - for fallback, MUST exist a Tuya Automation fired when the countdown is less than any trigger value (e.g. 1050), to reset the countdown to 0 without ACK: so the countdown never interferes with the logic of the switch. Required Tuya automation:  `if "tuya_bridge".countdown = 1050, then "tuya_bridge".countdown:0` 
 
- The actual implementation does not verify the ACKs presence and timing, and not uses any handshake strategy, so it is theoretically possible to have some interferences. For deatails on the implementation see 'core_TRIGGER."triggerMAP (readme)"' node.

--------------------
### minimal implementation for node-red users ###

This [tuyaTrigger downsizing](https://flows.nodered.org/flow/1d03176c75458f2665c780cb56265bf3) enables all node-red user (not only passionate IOT users, who use tuyaDEAMON) to add remote control and voice control to their projects in a simple way. only a flow with 3 nodes!
It can be [download here](https://github.com/msillano/tuyaDAEMON/tree/main/extra/tuyaTRIGGER%20for%20node-red%20users).

--------------------
### MQTT tuya_bridge tests (requres core_MQTT)

Some fast tests to do in **MQTT explorer** (copy/paste, maybe edit value), HW dependent, see [switch-1CH](https://github.com/msillano/tuyaDAEMON/blob/main/devices/switch-1CH/device_switch-1CH.pdf):

 | property  | op. |    MQTT topic               | value |                         notes|
| :------:  |:---------:|----------------------------|-----------|---|
|SCHEMA | GET| tuyaDAEMON/DEVPC/tuya_bridge/command  | &lt;empty> ||
| SCHEMA (device) | GET |tuyaDAEMON/DEVPC/HAL@home/command/\_doSCHEMA| "tuya_bridge" | 5 |
| SCHEMA (tuyastatus) | GET |tuyaDAEMON/DEVPC/HAL@home/command/\_tuyastatus | {"device":"tuya_bridge"} | 6 |
|relay | SET | tuyaDAEMON/DEVPC/tuya_bridge/command/relay | ON/OFF | |
|restart status | SET |  tuyaDAEMON/DEVPC/tuya_bridge/command/restart status | off/on/menory | |
|backlight | SET | tuyaDAEMON/DEVPC/tuya_bridge/command/backlight | true/false | |
|circulate | SET |  tuyaDAEMON/DEVPC/tuya_bridge/command/circulate | [{"active": "true"/"false", "day":"SMTWTF-", "start": "HH:MM", "end": "HH:MM", "on": "HH:MM", "off": "HH:MM"},..]/[] | 1 |
|random  | SET | tuyaDAEMON/DEVPC/tuya_bridge/command/inching  |[{"active": "true"/"false", "day":"DLMMGVS", "start": "HH:MM", "end": "HH:MM"},..]/[]|1  |
|inching | SET | tuyaDAEMON/DEVPC/tuya_bridge/command/inching  | 	{ "inching": "true"/"false" "delay": 0..3660}| |
|light mode | SET |  tuyaDAEMON/DEVPC/tuya_bridge/command/light mode | 	pos/none/relay| |
|tigger (reserved)| | _not accassible directly_ | 0..86500 | 2|
|TRIGGER | SET |   tuyaDAEMON/DEVPC/HAL@home/command/\_doTrigger    |5000| 3|
|TRIGGER | SET |   tuyaDAEMON/DEVPC/HAL@home/command/\_doTrigger     |5020|3|
|TRIGGER | SET |   tuyaDAEMON/DEVPC/HAL@home/command/\_toFastIN   |{"device":"tuya_bridge", "property":"trigger (reserved)", "value" : 5000} | 4|
|TRIGGER | SET |   tuyaDAEMON/DEVPC/HAL@home/command/\_toFastIN   |{"device":"tuya_bridge", "property":"trigger (reserved)", "value" : 5020} |4|

_notes_
1) The "day" is a string of 7 chars (a week), starting from 'Sunday': '-' minds 'skip', any char minds 'run'
2) Reseved to TRIGGERs, not accessible via GET/SET (see `global.alldevices` definition).
3) TRIGGER SET using `'system'.\_doTrigger`: the TRIGGER is sent to _tuya-cloud_, where it fires an existing  automation 'If "tuya_bridge"Countdown 1 : equals 5000 (or 5020)...'
4) TRIGGER SET using `'system'.\_toFastIN` (no checks): the TRIGGER is sent to _tuya-cloud_, where it fires an existing automation 'If "tuya_bridge"Countdown 1 : equals 5000 (or 5020)...'
5) The standard _SCHEMA_ is usable only on devices that implement it. the system.doSCHEMA(device)_ uses the result of GETs from all readable dps of the device, so it is always usable.
6) The _SCHEMA (tuyastatus)_ reads data from `global.tuyastatus`, so it gets also PUSH only dps, or pseudoDP (like '_connected') and can be used with any device.
--------------------
**Versions**

_tuyaTRIGGER version 2.2.2_ (10/05/2023)
  - Maintenance release (in download).
 
 _tuyaTRIGGER version 2.2.0_ (10/04/2022)
  - tuyaDAEMON ver 2.2.0

_tuyaTRIGGER version 2.0_ (13/05/2021)
  - included in tuyaDAEMON ver 2.0 (tuyaDAEMOM-full.2.0.json)
  
_tuyaTRIGGER version 1.1_ (19/01/2021)
  - tuyaDAEMON ver 1.1
  
_tuyaTRIGGER version 1.0_ (15/01/2021)
  - tuyaDAEMON ver 1.0

Initial version     
