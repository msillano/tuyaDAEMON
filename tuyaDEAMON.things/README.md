**tuyaDAEMON things project**
 
An application for managing Tuya and custom things used in one or more tuyaDAEMON servers. <br>

_When the tuyaDAEMON system grows, the management of 'alldevices' becomes more complicated: the differences between the standard definition of the devices and the data actually present in 'alldevices' increase, due to 'hide', 'share' etc. After the initial phase, where changes and tests are frequent, management operations, such as updating keys, reviewing comments, etc., are awkward in a large JSON structure and easily lead to errors._

   ![](https://github.com/msillano/tuyaDAEMON/blob/main/pics/deamonthings.png?raw=true)

 Definitions:
  - *device*: an IOT _class_ of tuya or custom gadgets, defined via DPs and capabilities using [tuyadaemon-toolkit](https://github.com/msillano/tuyaDAEMON/wiki/90.-tuyaDAEMON-toolkit).
  - *thing*: a single device instance, with its own ID, KEY, quirks, extra properties (dp or attributes), shares (methods), and comments.

_Used data resources, all in the 'BASEPATH' dir (&lt;path>/tuyadaemontoolkit/devicedata)_:
1. the 'alldevices.server.json' file, exported from node-red tuyaDAEMON servers: the main definition file.
1. the 'device_xxxxx.json' files with device definitions, from [tuyadaemon-toolkit](https://github.com/msillano/tuyaDAEMON/tree/main/tuyaDAEMON.toolkit), step 3: "JSON creation".
1. the 'tuyawizard.txt' file, from 'tuya-cli wizard' console output.
 
_Database: 'tuyathome', tables_:
 -    'allthings'    : defines a thing: name, type, device, etc...
 -    'specialthing' : defines a single thing's quirks or extra dP as a delta from the device's capabilities.
 -    'sharething'   : describes a single thing's actions using the 'share' tuyaDAEMON feature.
 -    'lookupserver' : list of options to group things.

_New Constraints, syntax update_ :
1. In 'alldevices' the 'device' field is required (references the thing's device). If missed, all dPs go to 'specialthings'.
2. In gateway devices, the word 'gateway' (or 'Gateway') MUST be present in 'thingName' or 'TuyaName' (e.g. 'multi_gateway', 'Zbee Gateway').
3. In the absence of the 'id', when not required by TuyaDAEMON (e.g. virtual devices), it is replaced by the name or by TuyaID from the wizard.
4. All 'share' are exported to 'alldevices' with a unique 'name' (decoration) for cross reference.

***Goals:***

  - Populate and update the 'tuyathome' DB from resources in a simple and iterable way.
  - Thing's definition and management in small chunks with accessible CRUD forms.
  - Bulk operation directly on DB (e.g. using 'phpMyAdmin').
  - Creating the 'alldevices.server.json' structure for one or more tuyaDAEMON servers.
  - Documentation production.

***Uses:***

1. as an interactive tool to edit the 'alldevices' file (one tuyaDEAMON):
   1. Clear the database.
   2. Import the 'alldevices' file.
   3. Merge the last 'wizard'.
   4. Edit things as required, possibly also using PHPMyAdmin.
   5. Save 'alldevices' file updated.

2. as a general 'things' archive (many tuyaDEAMON servers):
   1. Update the 'lookupserver' table to suit your needs ('ALL' and 'NEW' are required).
   1. Import all 'alldevices' files (repeatable).
   1. Merge the last 'wizard' (repeatable).
   2. Merge also 'new' things  (repeatable).
   4. Edit things as required, possibly also using PHPMyAdmin.
   5. Save all 'alldevices' files as you need.
   6. Do not clean up the database: keep it updated.


