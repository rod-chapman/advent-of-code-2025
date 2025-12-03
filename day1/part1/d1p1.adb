with Ada.Text_IO; use Ada.Text_IO;
package body D1P1
  with SPARK_Mode => On
is
   Q : constant := 100;

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

   --  Faster again - 4-way manual loop unroll to exploit potential
   --  super-scalar CPU
   function Combination3 (R : InputT) return Natural
   is
      pragma Assert (Entries mod 4 = 0);

      subtype Dial_Range is U32 range 0 .. Q - 1;

      Combo : Natural := 0;
      Dial : Dial_Range := 50;
      ND1, ND2, ND3, ND4 : U32;
      D1, D2, D3 : Dial_Range;
   begin
      for I in Input_Index range 0 .. (Entries / 4) - 1 loop
         pragma Loop_Invariant (Combo <= I * 4);
         declare
            Offset : constant Input_Index := I * 4;
         begin
            ND1 := Dial + U32 (R (Offset) + 1000);
            ND2 := ND1 + U32 (R (Offset + 1) + 1000);
            ND3 := ND2 + U32 (R (Offset + 2) + 1000);
            ND4 := ND3 + U32 (R (Offset + 3) + 1000);
         end;
         D1 := ND1 rem Q;
         D2 := ND2 rem Q;
         D3 := ND3 rem Q;
         Dial := ND4 rem Q;
         Combo := Combo + Boolean'Pos (D1 = 0) +
                          Boolean'Pos (D2 = 0) +
                          Boolean'Pos (D3 = 0) +
                          Boolean'Pos (Dial = 0);
      end loop;
      return Combo;
   end Combination3;


end D1P1;
