# 1. Home automation, why?

My first motivation, in chronological order, was to not let the terrace plants die during my holidays:
the initial solution for a few years was to use *irrigation timers* bought at the consortium shop (50 €),
but they often broke. Then I used a self-made [IOT smart timer (€ 15)](https://github.com/msillano/sonoff_watering/blob/master/watering-sonoff-en01.pdf), which can be controlled
locally with a smartphone. Now, after the call from the concierge who told me about a pipe break
while I was 100 km from home, the need to have remote control was also highlighted.

The second reason was the control of the *room temperature*. I have a centralized system, with
radiators equipped with heat meters, and we don't like the cold. Therefore, the optimization of the
management of the heating system aims both to improve comfort, to reduce costs, and, more
generally, to achieve greener management, without unnecessary waste.

The third reason is *security*. I'm not particularly anxious about it, but a little bit of control over fires, gas
leaks and intrusions I think is valid insurance.

A point often mentioned but which does not constitute a valid motivation for me (at least now) is
the control of *energy consumption* and the use of *smart" appliances* They are probably very useful
functions in the industrial or hotel sector, but they seem superfluous to me in my home, except
perhaps to turn off the water heater when the iron is turned on, so as not to trip the automatic
switch. But I have centralized hot water! (smile).

Concluding all these aspects, they can be faced and solved with a home automation control, better if
integrated.

# 2. What is meant by 'integrated'?

For example, when you leave the house you generally set the burglar alarm on, at the same time it
would be useful to lower the temperature of the radiators. The radiators must not be closed
completely, because when you return they would take too long to restore the optimal temperature,
but it is useless for them to go to their maximum when there is no one at home.
Conversely, in the case of a holiday weekend, it makes sense to completely turn off the radiators, to
turn them back on a few hours before your return.

When you have two systems available (for example, 'alarm' and 'boiler thermostat'), albeit
wonderful, from award-winning brands, very expensive but totally independent, you need to act on
both separately each time.
Conversely, with a home automation system, which "integrates" *alarm management* and *heating
management*, the two systems can easily exchange information, so a single action by the user can
control both the alarm and the radiators, with greater simplicity and reliability.

_These situations, or scenarios, are technically called_ 'use cases', _and in current home automation
terminology_ 'scenes'. _They represent an event and define the consequential actions to be taken.
The above can be represented with 4 scenes_ :

1. Leaving home for a short time
2. Departure for vacation (more than one day)
3. Imminence of returning from a vacation
4. Return home

 A ***home automation system***, therefore, must give the user the ability to define _their own scenes
according to their specific needs_. This obviously can be done in various ways, and precisely the
balance between the flexibility offered and the complexity of **_defining the scenes_** is an important
evaluation factor of a home automation system...

> For example, the definition of the scenes in IFTTT is simpler (and therefore more limited) than that
offered by Tuya, which in turn has the limit of not allowing numerical calculations.
So not even with Tuya you can have a scene like this: “if the room is 12 ° C colder than the desired
temperature, then turn on the air conditioner to heat it too”.

_It is precisely these limitations (omnipresent for commercial reasons: the app or system must be as
simple as possible) that create the need for extensions to the home automation system used, using
methods that allow, where required, a freer definition of the scenes._

> In some cases, moreover, it may be necessary to use devices not provided for in the chosen home
automation system: this is another aspect of the extensibility of a home automation system.

_For example, I might want to insert my actual timer to water the terrace in the home automation system: so I could condition the watering with weather information, obtaining savings in the use of water, while there would remain the possibility of autonomous operation in case of failure in the main system (done using fuzzy logic, [see watering_sys](https://github.com/msillano/tuyaDAEMON/wiki/derived-device-'watering_sys':-case-study))_.

_Further example: I have a small [PM10 meter module](https://www.banggood.com/search/pm2.5-pm10-detector-module-dust-sensor-2.8-inch-lcd.html), useful for assessing air pollution. It is a device with a USB serial output and I would like to insert it into the home automation system, as an alarm for the need for more ventilation. (done: see [custom device PM_detector](https://github.com/msillano/tuyaDAEMON/wiki/custom-device-'PM-detector':-case-study))_

Another important aspect of extensibility is the possibility of accessing all the data to have the
possibility to process or record those of interest automatically and in the preferred format, whether
they are ambient temperature and humidity, electricity consumption, etc. This function is generally
not foreseen in commercial products, but it can be useful in many cases, for example, to evaluate
different solutions, for the comparison between successive periods, for the certification of
maintenance within the limits of a given environment (I am thinking of greenhouses), for cost
evaluation etc..

> *In conclusion, the **_extension of each home automation_** system covers various aspects, depending
on the structure of the home automation system taken into consideration and on _the basis of the
needs to be met_. This factor constitutes another important point of evaluation when we make
choices.*

# 3. Choice of a home automation system.

There are an infinite number of systems for domestic homes on the market, they are trendy. A first
distinction can be made between two large groups:

- With devices connected to a control unit via a cable (‘wired’, with a BUS).
- With devices connected to the control unit via radio (various protocols: Bluetooth, Zigbee, WiFi, etc.).

The first group includes generally proprietary solutions that cannot be integrated easily, developed by manufacturers of electrical appliances for domestic use, for example [BTicino, Gewiss](https://www.ces.tech/About-CES.aspx), etc.
The advantage is reliable and highly secure communication.
The disadvantages derive from the need to wire the BUS to all devices and from the fact that not everything can be wired (think of the alarm switches on doors and windows).
In addition, a limited choice of devices (typically mono-brand) at high costs are available.

The second group is in continuous development and consists of proprietary solutions, Open Source solutions, totally custom solutions, with a myriad of devices from cheap to very cheap.

The great advantage is the elimination of the need for _ad hoc_ wiring, with a strong reduction in
costs and installation complexity, especially in European homes almost all in brick and concrete.


The disadvantages are related to the lower reliability of radio connections, the risk of interference
from malicious strangers, and the exposure of users to radio waves.

_However, my idea is clear: in a new building, perhaps I would consider the idea of adding the tracks for a wired home automation system, but in an already built building I have no doubts, wireless solutions are preferred._

# 4. Why Tuya?

In the myriad of wireless home automation solutions present, I chose [**Tuya**](https://pages.tuya.com/expo/ces) for myself.

_Tuya is a WiFi solution that occupies a particular place in the current commercial landscape._ **_Tuya
does NOT produce its own devices, but offers 2 services, one dedicated to hardware
manufacturers, the other to users._**

Tuya offers **_manufacturers_** ready-made HW modules and firmware, built using predefined modules (similar to how [ESPHome](https://esphome.io/) does for ESP8266/ESP32 based DIY projects). This solution cuts costs and time for new products. Tuya states that 5000+ devices use their platform (see [https://expo.tuya.com](https://expo.tuya.com)).
The Tuya firmware offers an infinite number of options: connection using various channels: WiFi, ZigBee, and others, OTA (on the air) update, user interface design, integration with Alexa and Google Home, etc... All continuously updated.

It offers **_users_** free use of a very efficient cloud, with 5 centers: [China, East US, West US, Europe, and India](https://developer.tuya.com/en/docs/iot/tuya-smart-cloud-platform-overview?id=K914joiyhhf7r):

- The response time in metropolitan areas in China is less than 40 ms (0.04 s).
- The response time in metropolitan areas in Asia is less than 80 ms (0.08 s).
- The response time in Europe and North America is less than 90 ms (0.09 s).
- Rome (Italy)  22.347 ms.
- Milan (Italy) 10.143 ms.  

_Naturally Tuya have created free apps ([Tuya smart](https://play.google.com/store/apps/details?id=com.tuya.smart) and [SmartLife](https://play.google.com/store/apps/details?id=com.tuya.smartlife), the latter preferred by me
because it is enabled for Google Home) which integrate all Tuya compatible devices into a single control application._ 
 - For an official reference [see here](https://developer.tuya.com/en/docs/iot/app-development/tuya-smart-smart-life/user-manual-for-tuya-smart-v3177). 
 - See also a good pdf [user manual](https://thermosilesia.pl/assets/default/system_object_files/e027d043706e2497a126ca5043a72e25.pdf).
 - Other apps are also developed by other companies (e.g. see [Homey](https://homey.app/it-it/app/com.tuya.cloud/Tuya-cloud/)).   

A _win-win_ solution, which is deservedly very successful: even established products, such as the simple _Sonoff-basic WiFi switch_, now have Tuya versions: no single manufacturer can compete... 

Security in these systems is essential, both for end-users and, above all, for manufacturing companies, which exert their influence in this sector to defend their investments: a good chance for users, who normally have little voice in this sector with big players (see [whitepaper](https://images.tuyacn.com/doc/security/tuyasmart-whitepaper-en.pdf)).

Some critical studies on the reliability of the solutions used can be [found online](https://www.researchgate.net/publication/342804736_Shattered_Chain_of_Trust_Understanding_Security_Risks_in_Cross-Cloud_IoT_Access_Delegation), generally referring to obsolete versions of the Tuya protocols, now at version 3.3. In fact, the ability to OTA update the firmware of the devices with more recent versions is a guarantee for both the manufacturer and the end-user.

A highly subjective question of principle remains open: my data externally? Do they contribute to BIG DATA? Sold on the dark web? In my opinion, in this specific case, it is a marginal problem: it is neither personal data nor confidential information. Nothing comparable to ‘e-mails’. Usage statistics? Sure. Email address? I
use one created only for Tuya, and besides, mine is public.
But above all, I trust in the bargaining power of the various producers, Tuya's real customers, who are also in competition with each other.


# 5. Integrations and customizations

_All right then with_ **_Tuya_**_? Yes of course, but also no._

_**All good** if our needs are met with the performance that Tuya devices and apps offer._ These are the highest performances currently available on the market, inimitable in terms of performances and ease of installation and use, economic both in terms of cost and activation time, with a very complete range of devices,
produced by many companies also in competition with each other, all upgradeable: an ecosystem with a long time horizon ahead.
The individual devices can be easily integrated with each other with the automation tools provided by the apps: *scenes and automation*. It is trivial with Tuya to connect the temperature control with the alarm system and create scenes such as 'leaving home' and 'beginning of vacation'. With the geolocation (available with _smartlife_ ) you can even have a fully automatic operation.
_Why reinvent hot water_?

However, we may have more advanced but legitimate needs, which require additions to overcome the **limits** of a home automation system built using **_devices + tuya cloud + app_**.

*Some examples based on my personal needs:*

1. I might want to make better use of the available data: for example, in the climate field, _smartLife_ offers daily, monthly, and yearly temperature graphs, for each probe or radiator, but not the possibility to export this data for further analysis, even just for calculating an average.
2. The automation mechanisms, defined as ‘scenes’ (also ‘Tap-to-Run’) or ‘automation’, depending on whether they are activated: by the user or by events from the various devices, are among the most powerful available in home automation applications. However they are simple if... then..., no calculation is possible. I would like to try more sophisticated algorithms, AI, etc...
3. A burglar alarm made with Tuya ceases to work if connections with the cloud are lost: it seems important to me to be able to increase the reliability of any alarm system so that they work even in the event of isolation.
4. Tuya-cloud only controls Tuya devices, because only for these it receives royalties from manufacturers, but we may be interested in including information provided by other equipment, not (yet) present in the Tuya ecosystem, or already in ours, into our system possession, or simply, use information obtained from the internet (e.g. weather forecast: it can be a waste to water the plants if it rains tomorrow).
5. Other times I design and build new devices myself (DIY) either because they are new and not commercially available, or because I have a better solution in mind than the existing ones. Tuya offers the possibility of prototype development, but it is expensive and requires the use of their modules, at least for the communications part
6. Tuya apps ( _smartLife and tuyasmart_ ) are nice and easy to use. But what if you wanted a different UI? For example, a graphic map of the environment with information on where the various devices are located? With status information and clickable icons? On a smartphone or on a PC? (example: see [here, Step 4](https://www.instructables.com/YAWT-Yet-Another-Watering-Timer/)).
7. With the cloud, Tuya devices can be controlled by apps from all over the world. Beautiful! But can I extend this feature to _my non-Tuya_ devices too?
8. The extension to _Google home_ and therefore having a _voice interface_ is very simple with _smartLife_, so I can give voice commands to my home automation system. The predefined commands are quite elementary (often only ON/OFF), but all the scenes defined in _smartlife_ can be activated vocally: the commands not present on Google are therefore achievable in this way (example: `"Hi Google, run 'tune tv on Raitre'"`). Even more beautiful! But can I extend this feature to my non-Tuya devices too?

These (and others: find yours...) are the reasons that can push a user to look for a methodology of integration between _Tuya_ ecosystem and the _outside world_. It is a problem made not easy to solve precisely because of the protocols with which Tuya protects the security of its devices and its cloud.

# 6. Why node-red?

_Integration, okay, but with which outside world?_

For me the answer is really simple: I don't want another cloud (certainly worse than Tuya, eg. IFTTT, not free from 2020/10/08) or another home automation application, even if Open Source, nor do I want to change the firmware of Tuya devices, so as not to use the Tuya-cloud.
At the dawn of home automation it might have made sense to build your own system from scratch, but now? The Tuya system works really well as it is, while the effort to change the firmware of the devices, for example, to use [_Tasmota_](https://tasmota.github.io/docs/) and _MQTT_, is certainly limited in the simplest cases, like switches, but let's consider my radiator thermostats with 28 parameters (data points) and with Zigbee communications or the firmware of a washing machine: the commitment can be truly remarkable. _Is worth_?

From my point of view, DIY is only worthwhile if it is something that is not achievable with the devices on the market, usually really convenient: my energy and my time have a cost. _Inventing again the well? No thanks!_

> All the problems that the use of Tuya can present can be solved, in my opinion, by
integrating Tuya ecosystem as is, with an open environment, which simplifies the integration with third-party devices and solves the problems of the various communication protocols, which allows easy access to the information resources on the Internet and which enable the implementation of recovery strategies in the event of a malfunction.

Furthermore, this environment must offer a simple use of DB and HTML interfaces (it is the universal solution), and of course, it must be programmable, to adapt to any scenario, but with minimal effort: _I have no time to waste_.

**_[node-red](https://nodered.org/)_** is the [ideal candidate](https://developer.ibm.com/components/node-red/blogs/top-5-reasons-to-use-node-red-right-now), it offers rapid graphical programming, with an impressive set of ready-made blocks (custom-nodes) but at the same time remains programmable at low level, where necessary, using js. **_Node-red_** is now an Open source project, born in IBM, with a large and lively community, truly perfect for these custom applications, with a low learning time.

Many custom home automation systems are made with **_node-red_**.

# 7. SmartLife <=> node-red integration: tuyaDEAMON

_Identified the problem, "_ **_node-red<=>tuya communications_** _", I looked at the available solutions.._

_I did not find a 'solution' but good tools ([tuyapi](https://github.com/codetheweb/tuyapi) and [node-red-contrib-tuya-smart-device](https://github.com/vinodsr/node-red-contrib-tuya-smart-device)), so I designed and implemented this project, **tuyaDAEMON** (now in alpha test, see [https://github.com/msillano/tuyaDAEMON](https://github.com/msillano/tuyaDAEMON)) to isolate and solve all problems_



