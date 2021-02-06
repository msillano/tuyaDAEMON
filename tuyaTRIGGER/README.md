# tuyaTRIGGER 

_A real device WiFI, having  a big unused numerical parameter, say a 'counter', writable for both **Tuya** and **node-red**, is all the required hardware to implement a robust bilateral event communication (**TRIGGER**)._

The 'counter' is used as a dual port register: a sender (_tuya-cloud/node-red_) set the counter to some XX value, the receiver gets the XX value, acts accordingly, and resets the counter to 0 (ACK action): the _node-red_ read/write actions are performed by **tuyaTRIGGER** flow, the _Tuya-cloud_ actions are performed by ad hoc automations, one for TRIGGER.

 - _node-red => tuya_: **node-red** write a predefined value in the 'counter' and that fires a specific **Tuya** automation: first the automation must reset the 'counter' to 0, then it can do anything.
 Tuya automation, say `trigger1010`:   _If "counter:1010" do "counter:0" and "any-action..."_ 

 - _tuya => node-red_: A tuya **scene** (user action) or **automation** (event) sets  a predefined value on the 'counter' (e.g. 2030), and when node-red read that, it must first reset  the "counter' to 0, then it can do anything.
 Tuya automation,  say `trigger2030`: _If "any-event" do "counter:2030"_ 

This **TRIGGER** mechanism, implemented in **tuyaTRIGGER**, allow a better _tuya <=> node-red_ integration in **tuyaDAEMON**:
 - _node-red_ can set/get status for _all devices and data point_ not found by `node-red-contrib-tuya-smart-device`.
 - _node-red_ can fire automation on _tuya-cloud_ 
 - _tuya scene_ can control _node-red flows_, so a node-red user can employ _smartlife_ as remote control (from anywhere).
 - _tuya automations_ can fire flows in _node-red_, implementing this way any control strategy not allowed by Tuya.
 - user can fire _node-red flows_ with vocal control (`Googlehome`)

### implementation

_This technique can be used with any device, named in the flow and in `alldevices` "tuya_bridge"._

![](./../pics/tuyadaemon04.jpg)![](./../pics/tuyadaemon05.jpg)

1) _I choose first the Tuya_ [Switch MS-104](https://github.com/msillano/tuyaDAEMON/blob/main/devices/Smart_switch01/device_Smart_Switch01.pdf) (USD 8) _because its countdown (`dp` = 102) is with a large range [0-86400s, i.e. 24H] and still the device can be used as a WiFi switch, because only the countdown function is used by this implementation, plus it is small and cheap._ 

   The unique problem with this switch is the lack of a battery backup.

2) _Now I'm waiting for another device, a Tuya wifi switch_ [TYWR 7-32](https://www.aliexpress.com/item/1005001292469801.html) (USD 10) _with a micro USB input, so it can be used with a power bank. When I get it I will update here after some tests_.

3) 'TuyaTrigger' value is placed in `msg.payload.tuyatrigger`.  The conversion `data.dp["102"] ==>  msg.payload.tuyatrigger` is done by `"dp converter"` change node. _To config your own `tuya-bridge` device, and to use any `dp`:_
     - modify the  `"dp converter"` change node. 
     - modify the code in `"red trigger"` sub-flow.


**note**
 
 - analog values can't be sent from tuya this way, because tuya does not allow the use of calculated values. But comparations are allowed: e.g. send trigger if `'temperature < 16'`. (Available: `<`; `=`; `>`). We can 'mirror' `BOOLEAN` dp (2 automations) `ENUM` dp: [0|1|2]  (3 automations) or also `INT`, but converted to ENUM when required: `{<15|16-20|21-25|26-30|31-35|36-40|>40}` but many automations are required (12 for this example).

 - using a countdown as a trigger, as _Switch MS-104_ does, requires REDTRG with numbers greater (e.g. 2000+) than TUYATRG (e.g. 1000..1999]): so, if _node-red_ is down, a Tuya TRIGGER not caught can't trigger a fake REDTRG.
 
 - If the used counter is a time counter (countdown in case of  _Switch MS-104_ ) you must choose trigger values at least separated by 10s, to allow the ACK action.

 - for fallback, MUST exist a Tuya Automation fired when the countdown is less than any trigger value (e.g. 800), to reset the countdown to 0 without ACK: so the countdown never interferes with the logic of the switch (this automation is also deployed by `_trgPing` implementation). Required automation:  `if "tuya_bridge"countdown:800, "tuya_bridge"countdown:0` 
 
- this implementation does not verify the ACKs presence and timing, and not uses any handshake strategy, so it is theoretically possible to have some interferences.

--------------------
**Versions**

_tuyaTRIGGER version 1.1_ (19/01/2021)
  - tuyaDAEMON ver 1.1
_tuyaTRIGGER version 1.0_ (15/01/2021)
  - tuyaDAEMON ver 1.0

Initial version     
