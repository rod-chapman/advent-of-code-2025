with D1P1; use D1P1;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
procedure Main
is
   R : InputT;
   C : Natural;
   T1, T2 : Time;
   D : Duration;
begin
   R := Get_Input ("input.txt");
   Dump (R);

   Put_Line ("Going to compute combination");
   T1 := Clock;
   C := Combination2 (R);
   T2 := Clock;

   D := To_Duration (T2 - T1);
   Put_Line (C'Img);
   Put_Line (D'Img);

end Main;
