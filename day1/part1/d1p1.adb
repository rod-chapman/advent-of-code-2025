with Ada.Text_IO; use Ada.Text_IO;
package body D1P1
  with SPARK_Mode => On
is
   function Get_Input (Filename : in String) return InputT
     with SPARK_Mode => Off
   is
      F : File_Type;
      R : InputT;
   begin
      Open (F, In_File, Filename);
      for I in Input_Index loop
         declare
            Line : constant String := Get_Line (F);
            Num  : constant I32 := I32'Value (Line (2 .. Line'Last));
         begin
            R (I) := (if Line (1) = 'R' then Num else -Num);
         end;
      end loop;
      return R;
   end Get_Input;


   procedure Dump  (R : in InputT)
     with SPARK_Mode => Off
   is
   begin
      for I in R'Range loop
         if R (I) >= 0 then
            Put_Line ("R" & I32'Image (R (I)));
         else
            Put_Line ("L" & I32'Image (-R (I)));
         end if;
      end loop;
   end Dump;

   function Combination (R : InputT) return Natural
   is
      Q : constant := 100;
      subtype Dial_Range is I32 range 0 .. Q - 1;
      Combo : Natural := 0;
      Dial : Dial_Range := 50;
   begin
      for I in R'Range loop
         pragma Loop_Invariant (Combo <= I);
         Dial := (Dial + R (I)) mod Q;
         Combo := Combo + Boolean'Pos (Dial = 0);
      end loop;
      return Combo;
   end Combination;

   --  Faster - avoids signed "mod" by adding 10Q to each
   --  new input.
   function Combination2 (R : InputT) return Natural
   is
      Q : constant := 100;
      subtype Dial_Range is U32 range 0 .. Q - 1;
      Combo : Natural := 0;
      Dial : Dial_Range := 50;
      New_Dial : U32;
   begin
      for I in R'Range loop
         pragma Loop_Invariant (Combo <= I);
         New_Dial := Dial + U32 (R (I) + 1000);
         Dial := New_Dial rem Q;
         Combo := Combo + Boolean'Pos (Dial = 0);
      end loop;
      return Combo;
   end Combination2;

end D1P1;
