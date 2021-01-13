# case study: **alarm siren**

_My ['USB alarm siren'](https://www.aliexpress.com/item/4000161671864.html) (WiFi, AC  + BATT, USD 18) don't works with `smart_tuya_devices` (2.0.0): all answers are undecoded strings like this:_
````
ERROR from 'USB siren': not JSON data but HEX:332e3300000000000000efbfbd00000001efbfbdefbfbd6f300861efbfbd31efbfbd20efbfbdefbfbdefbfbd7e161610180671efbfbdefbfbdefbfbdefbfbd0451efbfbd530aefbfbdefbfbdefbfbdefbfbd08efbfbd01efbfbdefbfbddf8dc7a41eefbfbd0cefbfbd7defbfbd2ac8baefbfbd6314efbfbdefbfbdefbfbd0cefbfbd135b5f6c02efbfbd28efbfbdefbfbd2c32efbfbd0463efbfbd112f366d1d  ('3.3���o0a�1� ���~q����Q�S
�������ߍǤ��}�*Ⱥ�c����[_l�(��,2�c�/6m')     
````
_But while I'm waiting for `tuyap` and `smart-tuya-device `  updates,  I need it. So I will use a 'mirror' device._

### siren capabilities (data points), from smartlife
- `alarm`: BOOL, ON/OFF (RW)
- `duration` of the alarm: INT, [1..60]s  (RW)
- `battery` level: ENUM (FULL|GOOD|MEDIUM|LOW|DOWN) (RO)
- Alarm `sound`: ENUM [1..10] (RW)

This siren can produce 10 different sounds, so it can be used also as door bell, phone repeater etc. As Alarm, sound #7 (and #8) are preferred. see EN 50131-4, EN 54-3, DIN 33404-3.
- The local regolament fixes a max of 180s with a modulated sound, and the max volume to 100 dB (external) and 80 dB (internal). I  measured 70 dB.

### 'mirror' device capabilities
   _To reduce complexity I implement in the 'mirror' siren device only a optmized subset of siren capabilities: my interest is only on dynamic options and security issues: function ON/OFF,  the battery status._ 
   _I can implement some 'setup' automations to force 'sound' and 'duration' parameters to the correct values.  So I can still use the same device for more functions (intrusion alarm, fire alarm, door bell...) using different 'setup'._
   The rule is simple: fire anyway the required 'setup' before to do the ON command.

_status update_ from device events:
````
   - alarm:ON                        trigger 1800
   - alarm:OFF                       trigger 1810
            (two triggers are required for a BOOL status)
   - battery level:LOW                trigger 1820
   - battery level:DOWN               trigger 1820  
            (The automations does a battery status polling every 24H)
 ````     
_commands node-red => device_ to change status:
 ````
   - SET alarm:OFF                    trigger 2800
   - SET alarm:ON                     trigger 2810
   - SET setup:alarm                  trigger 2820
   - SET setup:todo (reserved)        trigger 2830, 2840 
````

Total count is 7 automations on  `smartlife`, all called 'sirenXXXXY' for semplicity.

### description in alldevice.fake 
````
		{
			"id": "12347807d8bfc0c5831e",
			"name": "USB siren",
			"power": "UPS",
			"capability":["SET"],
			"comment": "WiFi siren, HEX data:disabled, mirror",
			"dps": [
				{
					"dp": "1800",
					"name": "alarm",
			        "comment": "values: ON|OFF, updated RT from device",
					"capability":"WO"
				},
				{
					"dp": "2820",
					"name": "setup",
			        "comment": "values: alarm|(more todo), local update",
					"capability":"WO"
				},
				{
					"dp": "1820",
					"name": "battery",
			        "comment": "values: OK(default)|LOW, PUSH 24H from device",
					"capability":"PUSH"
				}
			]
		},
````
The flow "Siren device" implements that. _You CAN put all your 'mirror' devices on **"tuyaTRIGGER"** flow, but I keep this flow separate to make it a simpler example_.


### automations required in _smartlife_

- siren1800: ` if "siren"alarm:off, "tuya_bridge"countdown:1800`
- siren1810: ` if "siren"alarm:on, "tuya_bridge"countdown:1810`
- siren1820A:` if "siren"battery:Low,"tuya_bridge"countdown:1820`    (+ timer: 3:00H every day)
- siren1820B:` if "siren"battery:critic,"tuya_bridge"countdown:1820` (+ timer: 3:00H every day)

- siren2800:  ` if "tuya_bridge"countdown:2800, "siren"alarm:off`
- siren2810:  ` if "tuya_bridge"countdown:2810, "siren"alarm:on`
- siren2820:   `if "tuya_bridge"countdown:2820, "siren"durata:20 + "siren"type:7`

### implementation

- The siren `smart-tuya-device` node can be disabled in **tuyaDAEMON**, to cancel HEX data on debug pad.
- You can use this _siren device_ as a template for _custom 'mirror' devices_: you obviously need to modify the nodes in the flow. The  `pick and execute`  node code needs to be updated as well.


