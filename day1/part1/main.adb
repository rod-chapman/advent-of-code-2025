with D1P1; use D1P1;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
procedure Main
is
   R : InputT;
   C : Natural;
   T1, T2 : Time;
   Total : Duration;
begin
   R := Get_Input ("input.txt");
   Dump (R);

   Put_Line ("Going to compute combination");
   Total := 0.0;
   for I in 1 .. 1000 loop
      T1 := Clock;
      C := Combination3 (R);
      T2 := Clock;
      Total := Total + To_Duration (T2 - T1);
   end loop;

   Put_Line (C'Img);
   Put_Line (Total'Img);

end Main;
