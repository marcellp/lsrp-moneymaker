lsrp-moneymaker
===============

This is a small application written in AutoHotKey that allows you to quickly and reliably exploit a vulnerability on Los Santos Roleplay, a San Andreas Multiplayer server.

The bug itself
--------------
The actual bug is in the system that handles the *car thief job*. You have to take the car you've stolen to a number of different car thief boards. If a specific board has the make of your car on it, you can use */delivercar* to deliver the vehicle. After about 20 seconds, your car gets chopped and you get a sum of money after you take the car away from the board. The car then gets despawned and you can't retrieve it agian unless the owner decides to spawn it again. The models displayed on the board change periodically.

This script can be exploited in a number of ways:
- The script does not check the owner of the vehicle. This means that you *can* steal your own vehicle, drive it to a chop shop. At the chop shop, it gets disassembled and despawned. However, because you actually own the vehicle, you can spawn it again and drive it back to the shop. If you have a grade-3 insurance plan, you can simply park the car again and it will respawn in perfect condition. This is a bad enough bug as is.
- The script does not check how many times you enter the command. This is the most critical exploit because it allows you to enter the command as many times as you want, even if your vehicle has already been disassembled.

The exploit
-----------
Our application makes it easy to exploit this bug and earn a lot of money on LS-RP. This e-money can then be sold or used to buy virtual goods.

The first part of this exploit is buying an expensive car. This script only supports Cheetahs and Sultans because those are the models we use. If you know a friend who has a lot of money, ask for a loan and buy a shitty Sultan or Cheetah. You can easily re-pay that loan in one or two hours.

There are two modules to this application.

The first one is the so-called *boardfinder*, which is a script that keeps track of every car thief board on the server. The module displays a number of mapicons on the radar that mark the position of each board on the server. You have to drive to each one and check the text on the board. If the board doesn't include the model you're driving, you can check it off and go to the next one.

The second module is the *moneymaker*, which handles the actual exploitation. When you open the application, you have to enter a value which determines how often the command is sent. You have to let */deliverycar* actually chop your vehicle before you send it again. If you fail to do this, you won't get any money. Because timers in SA-MP are inaccurate, you have to fiddle around with this value (it's usually between 17 and 22 seconds).

*Moneymaker* also tells you how much money you've earned. Our estimate is that you can get around ~$1.5m in IG cash if you have a Cheetah and you arrive at the board exactly when it changes.

### Important advice
**Don't be AFK while this application is running.** Moneymaker manipulates the memory of San Andreas Multiplayer to send commands without toggling your chatbox. If GTA:SA is minimized while Moneymaker is active, **the server can flag you** because you send commands without actually being in-game. **This can lead to a ban for using an AFK-bot.** In fact, it has already happened to one of us. Don't be stupid. Stay in-game.

Detection
---------
The codebase and the private repository that this was a part of was established in Spring 2015. As of early 2016, this exploit has been detected and fixed by LS-RP staff, most of the abusers have been banned. The codebase is now available for historical purposes only.

Authors
-------
* fakukac (moneymaker)
* marcellp (boardtracker, gui)

License
-------
This is an open-source software project covered by the GNU GPL license. [LICENSE](LICENSE) for more
information.
