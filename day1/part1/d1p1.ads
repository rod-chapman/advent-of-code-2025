with Interfaces; use Interfaces;
package D1P1
  with SPARK_Mode => On
is
   subtype I16 is Integer_16;
   subtype U16 is Unsigned_16;
   subtype I32 is Integer_32;
   subtype U32 is Unsigned_32;
   subtype I64 is Integer_64;

   Entries : constant := 4232;
   subtype Input_Index is Natural range 0 .. Entries - 1;

   subtype Rotation is I32 range -999 .. 999;

   type InputT is array (Input_Index) of Rotation;

   function Get_Input (Filename : in String) return InputT;

   procedure Dump  (R : in InputT);

   function Combination (R : InputT) return Natural
     with Global => null;

   function Combination2 (R : InputT) return Natural
     with Global => null;

end D1P1;
