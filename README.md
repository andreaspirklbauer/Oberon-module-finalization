# Oberon-module-finalization
Module finalization for the Project Oberon 2013 and Extended Oberon operating systems

Note: In this repository, the term "Project Oberon 2013" refers to a re-implementation of the original "Project Oberon" on an FPGA development board around 2013, as published at www.projectoberon.com.

**PREREQUISITES**: A current version of Project Oberon 2013 (see http://www.projectoberon.com). If you use Extended Oberon (see http://github.com/andreaspirklbauer/Oberon-extended), the functionality is already implemented.

------------------------------------------------------
**1. Description**

The modification to Project Oberon 2013 provided in this repository allows a module to set a *module finalization* sequence by calling procedure *Modules.Final* during *module initialization*. The specified routine must be a *parameterless procedure* declared in the *same* module. It is executed when the module is removed from the system.

     MODULE M;
       IMPORT Modules, Texts, Oberon;

       VAR W: Texts.Writer;

       PROCEDURE Final;  (*module finalization sequence*)
       BEGIN Texts.WriteString(W, “Finalizing module M");
         Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
       END Final;

       PROCEDURE Start*;
       BEGIN  (*load module*)
       END Start;

     BEGIN Texts.OpenWriter(W); Modules.Final(Final)
     END M.

     ORP.Compile M.Mod/s ~     # compile module M
     M.Start ~                 # load module M
     System.Free M ~           # unload module M (prints "Finalizing module M")

------------------------------------------------------
**2. Preparing your system to add module finalization**

If *Extended Oberon* is used, module finalization is already implemented on your system.

If *Project Oberon 2013* is used, download all files from the [**Sources/FPGAOberon2013**](Sources/FPGAOberon2013) directory of this repository. Convert the *source* files to Oberon format (Oberon uses CR as line endings) using the command [**dos2oberon**](dos2oberon), also available in this repository (example shown for Linux or MacOS):

     for x in *.Mod ; do ./dos2oberon $x $x ; done

Import the files to your Oberon system. If you use an emulator (e.g., **https://github.com/pdewacht/oberon-risc-emu**) to run the Oberon system, click on the *PCLink1.Run* link in the *System.Tool* viewer, copy the files to the emulator directory, and execute the following command on the command shell of your host system:

     cd oberon-risc-emu
     for x in *.Mod ; do ./pcreceive.sh $x ; sleep 1 ; done

Compile module *Modules*, build a new *inner core* and load it onto the boot area of the local disk:

     ORP.Compile Modules.Mod ~
     ORL.Link Modules ~
     ORL.Load Modules.bin ~

Compile the remaining modules of the Oberon system:

     ORP.Compile Input.Mod Display.Mod/s Viewers.Mod/s ~
     ORP.Compile Fonts.Mod/s Texts.Mod/s Oberon.Mod/s ~
     ORP.Compile MenuViewers.Mod/s TextFrames.Mod/s ~
     ORP.Compile System.Mod/s Edit.Mod/s Tools.Mod/s ~

Re-compile the Oberon compiler itself before (!) restarting the system:

     ORP.Compile ORS.Mod/s ORB.Mod/s ~
     ORP.Compile ORG.Mod/s ORP.Mod/s ~
     ORP.Compile ORL.Mod/s ORX.Mod/s ORTool.Mod/s ~

Restart the Oberon system and recompile any other modules you may have on your system.

Test module finalization using the test program provided in this repository (see above).




