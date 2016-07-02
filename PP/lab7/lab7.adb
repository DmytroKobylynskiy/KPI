
     -------------------------------------------
     --??????? ?????? ???
    --???. ???????
     --??????? ?.?.
     --MA = min(MX)*MO + a*(MK*MR)
     --22.04.2015
     -------------------------------------------
with Ada.TEXT_IO; use Ada.TEXT_IO;
with Ada.INTEGER_TEXT_IO; use Ada.INTEGER_TEXT_IO;
with Ada.Calendar; use Ada.Calendar;
with Ada.float_text_io; use Ada.float_text_io;
    
     procedure Main is
        N: Integer := 4;
        R: integer := 2;
        P: Integer := 2*R;
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
    
        function min2(x, y : in Integer) return Integer is
        begin
           if(x > y) then
              return y;
           end if;
           return x;
        end min2;
    
        function minH(M : Matrix) return Integer is
           buffer : Integer;
        begin
           buffer := M(1)(1);
           for i in 1..H loop
             for j in 1..N loop
              if(M(i)(j) < buffer) then
                   buffer := M(i)(j);
              end if;
             end loop;
          end loop;
              return buffer;
       end minH;
           procedure calculating(MA : out Matrix; a, m :in Integer; MK: in Matrix; MR, MO : in Matrix) is
          buf : Integer := 0;
       begin
          for i in 1..N loop
             for j in 1..H loop
                buf := 0;
                for k in 1..N loop
                   buf := buf + MK(k)(i) * MR(j)(k);
                end loop;
                 MA(j)(i):= m*MO(j)(i)+a*buf;
              end loop;
          end loop;
        end calculating;
    
        task type Tsk (id: Integer) is
        entry SetData(MX, MR: in Matrix; idp : in Integer);
           entry SetDataN(MO, MK : in Matrix; a : Integer);
        entry SetMj(m : in Integer);
           entry SetM(m: in Integer);
           entry SetMA(MA : in Matrix; idp : in Integer);
        end Tsk;
    
         type PTask1 is access Tsk;
         T: array (1..P) of PTask1;
    
    
    --------------------------------------------------------------------------------
       task body Tsk is
         MXi, MRi, bufMA : Matrix( 1..(P+1-id)*H );
          MKi: Matrix(1..N);
          MOi: Matrix(1..id*H);
          MAi : Matrix(1..N);
          index, buf : Integer := 0;
          ai, mi: Integer;
       begin
          delay 1.5;
          Put_Line("Task is started!");
   
          if id = 1 then
             inputMatrix(MXi);
             inputMatrix(MRi);
          end if;
   
         if id = P then
            inputMatrix(MOi);
            inputMatrix(MKi);
            ai := 1;
         end if;
               if (id > 1) then
            accept SetData(MX, MR: in Matrix; idp : in Integer) do
               MXi := MX(((id - idp)*H + 1)..(P+1-idp)*H);
               MRi := MR(((id - idp)*H + 1)..(P+1-idp)*H);
            end SetData;
         end if;
            while (id + 2**index <= P) loop
            if (2**index >= id) then
               T(id + 2**index).SetData(MXi, MRi,id);
             end if;
             index := index+1;
         end loop;
   
          if(id < P) then
       accept SetDataN(MO, MK : in Matrix; a : Integer) do
                MOi := MO(1..id*H);
                MKi := MK;
                ai :=  a;
             end SetDataN;
          end if;
           index := 0;
          buf:= P+1-id;
          while(buf + 2**index <= P) loop
             if (2**index >= buf) then
               T(P+1-(buf + 2**index)).SetDataN(MOi, MKi, ai);
             end if;
             index := index + 1;
          end loop;
   
          mi := minH(MXi(1..H));
   
          if (id < P) then
          	 accept SetMj(m : in Integer) do
               mi := min2(mi, m);
             end SetMj;
          end if;
   
         index := 0;
          buf:= P+1-id;
          while (buf + 2**index <= P) loop
             if (2**index >= buf) then
                T(P+1-(buf + 2**index)).SetMj(mi);
             end if;
             index := index+1;
          end loop;
   
          if (id > 1) then
             accept SetM(m: in Integer) do
                mi := m;
             end SetM;
        end if;
   
          index := 0;
          while (id + 2**index <= P) loop
             if (2**index >= id) then
                T(id + 2**index).SetM(mi);
             end if;
             index := index+1;
          end loop;
   
   
   
          calculating(bufMA, ai, mi, MKi, MRi(1..H), MOi(1..H));
  
          MAi( (id-1)*H+1..id*H) := bufMA(1..H);
   
          index:= 0;
          while(2**index < id) loop
              index := index+1;
          end loop;
          while((2**index+id) <= P) loop
             accept SetMA(MA : in Matrix; idp: in Integer) do
                MAi(((idp-1)*H+1)..idp*H) := MA(((idp-1)*H+1)..idp*H);
                buf := 0;
                while(2**buf < P) loop
                   if (2**buf >= idp) then
                      MAi(((idp + 2**buf-1)*H+1)..(idp + 2**buf)*H) := MA(((idp + 2**buf-1)*H+1)..(idp + 2**buf)*H);
                   end if;
                   buf := buf+1;
                end loop;
             end SetMA;
   
             index := index+1;
          end loop;
   
          if (id > 1) then
             buf:= 0;
             while(2**buf < id) loop
               buf := buf+1;
          end loop;
            buf := buf - 1;
            buf := id - 2**buf;
            T(buf).SetMA(MAi, id);
         end if;
               if (id=1) then
            for i in 1..N loop
              outputVector(MAi(i));
            end loop;
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
    end Main;
