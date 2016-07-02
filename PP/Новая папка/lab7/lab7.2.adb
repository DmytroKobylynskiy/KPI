
     -------------------------------------------

     Lab 7 . Ada Rendezvous
     Kobylynskiy D.A
     --A = a*B + max(E)*T*(MK*MR)
     --22.04.2016
     -------------------------------------------
with Ada.TEXT_IO; use Ada.TEXT_IO;
with Ada.INTEGER_TEXT_IO; use Ada.INTEGER_TEXT_IO;
with Ada.Calendar; use Ada.Calendar;
with Ada.float_text_io; use Ada.float_text_io;

     procedure lab7 is
        N: Integer := 4;
        R: integer := 2;
        P: Integer := 2**R;
        H: Integer := N / P;

        type Vector is array(Integer range<>) of Integer;
        type Matrix is array(Integer range<>) of Vector(1..N);


        procedure inputVector(V : out Vector) is
        begin
           for i in 1..N loop
              V(i) := 1;
           end loop;
        end inputVector;

        procedure outputVector(V : in Vector) is
        begin
           for i in 1..N loop
              Ada.Integer_Text_IO.Put ( V(i) );
           end loop;
        end outputVector;

        procedure inputMatrix(M : out Matrix) is
        begin
           for i in 1..N loop
             inputVector(M(i));
           end loop;
        end inputMatrix;

        function max2(x, y : in Integer) return Integer is
        begin
           if(x > y) then
              return y;
           end if;
           return x;
        end min2;

        function maxH(M : Vector) return Integer is
           buffer : Integer;
        begin
           buffer := M(1);
           for i in 1..H loop
              if(M(i) > buffer) then
                   buffer := M(i);
              end if;
          end loop;
              return buffer;
       end minH;
           procedure calculating(A : out Vector; alpha, m :in Integer; MO,MK: in Matrix;  T1,B : in Vector) is
          buf : Integer := 0;
       begin
          for i in 1..N loop
             for j in 1..H loop
                buf := 0;
                for k in 1..N loop
                   buf := buf + MK(k)(i) * MO(j)(k);
                end loop;
                 A(j):= alpha*MO(j)(i)+m*buf*T1(j);
              end loop;
          end loop;
        end calculating;

        task type Tsk (id: Integer) is
           entry Data(E:in Vector; MR: in Matrix; idp : in Integer);
           entry Data5(B:in Vector; MO: in Matrix; idp : in Integer);
           entry DataN(T1,B: in Vector;MO : in Matrix; alpha : Integer);
           entry ResultMj(m : in Integer);
           entry ResultM(m: in Integer);
           entry ResultA(A : in Vector; idp : in Integer);
        end Tsk;

         type PTask1 is access Tsk;
         T: array (1..P) of PTask1;


    --------------------------------------------------------------------------------
       task body Tsk is
          MRi: Matrix( 1..(P+1-id)*H );
          MKi: Matrix(1..N);
          MOi: Matrix(1..id*H);
      Ti:Vector(1..N);
      Bi:Vector(1..N);
      Ai,Ei, bufA : Vector(1..(P+1-id)*H);
          index, buf : Integer := 0;
          alphai, mi: Integer;
       begin
          delay 1.5;
          Put_Line("Task is started!");

          if id = 1 then
             inputVector(Ti);
          end if;

          if id = 5 then
             inputVector(Ei);
             inputMatrix(MKi);
             alphai := 1;
          end if;

         if id = P then
            inputMatrix(MOi);
            inputVector(Bi);          
         end if;
          if (id != 1) then
            accept Data(T1:in Vector; idp : in Integer) do
               Ti := T1(((id - idp)*H + 1)..(P+1-idp)*H);
            end Data;
         end if;
            while (id + 2**index <= P) loop
            if (2**index >= id) then
               T(id + 2**index).Data(T1,id);
             end if;
             index := index+1;
         end loop;

           if (id != 5) then
            accept Data5(B:in Vector; MO: in Matrix; idp : in Integer) do
               Bi := B(((id - idp)*H + 1)..(P+1-idp)*H);
               MOi := MO(((id - idp)*H + 1)..(P+1-idp)*H);
            end Data5;
         end if;
            while (id + 2**index <= P) loop
            if (2**index >= id) then
               T(id + 2**index).Data5(Bi, MOi,id);
             end if;
             index := index+1;
         end loop;

          if(id != P) then
          accept DataN(E: in Vector;MK: in Matrix; alpha : Integer) do
                MKi := MK(1..id*H);
            	  Ei:= E;
                alphai :=  alpha;
             end DataN;
          end if;
           index := 0;
          buf:= P+1-id;
          while(buf + 2**index <= P) loop
             if (2**index >= buf) then
               T(P+1-(buf + 2**index)).DataN(Ei,MKi, alphai);
             end if;
             index := index + 1;
          end loop;

          mi := maxH(Ai(1..H));
         Ada.Integer_Text_IO.Put ( mi );

          if (id < P) then
          	 accept ResultMj(m : in Integer) do
               mi := max2(mi, m);
             end ResultMj;
          end if;
         index := 0;
          buf:= P+1-id;
          while (buf + 2**index <= P) loop
             if (2**index >= buf) then
                T(P+1-(buf + 2**index)).ResultMj(mi);
             end if;
             index := index+1;
          end loop;

          if (id > 1) then
             accept ResultM(m: in Integer) do
                mi := m;
             end ResultM;
        end if;

          index := 0;
          while (id + 2**index <= P) loop
             if (2**index >= id) then
                T(id + 2**index).ResultM(mi);
             end if;
             index := index+1;
          end loop;

          calculating(bufA, alphai, mi, MOi, MKi(1..H), Ti,Bi);

          Ai( (id-1)*H+1..id*H) := bufA(1..H);

          index:= 0;
          while(2**index < id) loop
              index := index+1;
          end loop;
          while((2**index+id) <= P) loop
             accept ResultA(A : in Vector; idp: in Integer) do
                Ai(((idp-1)*H+1)..idp*H) := A(((idp-1)*H+1)..idp*H);
                buf := 0;
                while(2**buf < P) loop
                   if (2**buf >= idp) then
                      Ai(((idp + 2**buf-1)*H+1)..(idp + 2**buf)*H) := A(((idp + 2**buf-1)*H+1)..(idp + 2**buf)*H);
                   end if;
                   buf := buf+1;
                end loop;
             end ResultA;

          index := index+1;
          end loop;

          if (id > 1) then
             buf:= 0;
             while(2**buf < id) loop
               buf := buf+1;
          end loop;
            buf := buf - 1;
            buf := id - 2**buf;
            T(buf).ResultA(Ai, id);
         end if;
               if (id=1) then
              outputVector(Ai);

         end if;

          Put_Line("Task is finished!");
       end Tsk;

       task T0;
   task body T0 is

          begin
          for i in 1..P loop
             T(i) := new Tsk(i);
          end loop;
       end T0;

    begin
       NULL;
    end lab7;
