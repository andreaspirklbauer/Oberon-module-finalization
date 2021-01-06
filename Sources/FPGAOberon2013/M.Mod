MODULE M;
  IMPORT Modules, Texts, Oberon;

  VAR W: Texts.Writer;

  PROCEDURE Finalize;  (*module finalization sequence*)
  BEGIN Texts.WriteString(W, "Finalizing module M");
    Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
  END Finalize;

  PROCEDURE Start*;
  BEGIN (*load module*)
  END Start;

BEGIN Texts.OpenWriter(W); Modules.SetFinalizer(Finalize)
END M.


ORP.Compile M.Mod/s ~     # compile module M
M.Start ~                 # load module M
System.Free M ~           # unload module M (prints "Finalizing module M")
