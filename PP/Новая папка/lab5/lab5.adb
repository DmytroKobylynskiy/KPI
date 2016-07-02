1   -------------------------------------------------------------------------------
  --                                                                           --
  --                   Parallel and Distributed Computing                      --
  --                   Laboratory work #7. Ada. Rendezvous                     --
  --                                                                           --
  --  File: pro2_lab7.adb                                                      --
  --  Task: A = max(Z)*E + alpha * B(MO * MK)                                  --
  --                                                                           --
  --  Author: Kuzmenko Volodymyr, group IO-21                                  --
   --  Date: 28.04.2015                                                         --
   --                                                                           --
   -------------------------------------------------------------------------------
   
   with Ada.Text_IO, Ada.Integer_text_iO, Ada.Synchronous_Task_Control, Data;
   use Ada.Text_IO, Ada.Integer_text_iO, Ada.Synchronous_Task_Control;
   
   procedure lab5 is
   
    Value : Integer := 1;
    N : Natural := 21;
    P : Natural := 7;
    H : Natural := N/P;
   
    package DataN isnew Data(N, H);
    use DataN;
   
    procedure StartTasks is
   -------------------------------------------------------------------------------
   --                             ???????????? ?????                            --
   -------------------------------------------------------------------------------
   
   --                                 ?????? T1                                 --
    task T1 is
    entry DataH(
    E : in VectorH;
    Z : in VectorH;
    MO : in MatrixH);
    entry MaxZ (maxZ : in Integer);
    entry ResultH(A : out VectorH);
    end T1;
   
   --                                 ?????? T2                                 --
    task T2 is
    entry DataMKBalfa(MK : in MatrixN; B : in VectorN; alfa : in Integer);
    entry Data2H(
    E : in Vector2H;
    Z : in Vector2H;
    MO : in Matrix2H);
    entry MaxZ1 (maxZ1 : in Integer);
    entry MaxZ (maxZ : in Integer);
    entry Result2H(A : out Vector2H);
    end T2;
   
   --                                 ?????? T3                                 --
    task T3 is
    entry DataMKBalfa(MK : in MatrixN; B : in VectorN; alfa : in Integer);
    entry Data3H(

    E : in Vector3H;
    Z : in Vector3H;
    MO : in Matrix3H);
    entry MaxZ2 (maxZ1 : in Integer);
    entry MaxZ (maxZ : in Integer);
    entry Result3H(A : out Vector3H);
    end T3;
   
   
   
   --                                 ?????? T4                                 --
    task T4 is
    entry DataMKBalfa(MK : in MatrixN; B : in VectorN; alfa : in Integer);
    entry DataMOE6H(
    E : in Vector6H;
    MO : in Matrix6H);
    entry MaxZ3 (maxZi : in Integer);
    entry MaxZ5 (maxZi : in Integer);
    entry MaxZ6 (maxZi : in Integer);
    entry MaxZ7 (maxZi : in Integer);
   
    end T4;
   
   --                                 ?????? T5                                 --
    task T5 is
    entry DataZ(Z : in VectorH);
    entry DataMKBalfaEHMOH(
    alfa : in Integer;
    E : in VectorH;
    B: in VectorN;
    MO: in MatrixH;
    MK : in MatrixN);
    entry MaxZ (maxZ : in Integer);
   entry ResultH(A : out VectorH);
   end T5;
  
  --                                 ?????? T6                                 --
   task T6 is
   entry DataZ(Z : in VectorH);
   entry DataMKBalfaEHMOH(
   alfa : in Integer;
   E : in VectorH;
    B: in VectorN;
    MO: in MatrixH;
    MK : in MatrixN);
    entry MaxZ (maxZ : in Integer);
    entry ResultH(A : out VectorH);
    end T6;
   
   --                                 ?????? T7                                 --
    task T7 is
    entry DataZ(Z : in VectorH);
    entry DataMKBalfa(
    alfa : in Integer;
    B: in VectorN;
    MK : in MatrixN);
    entry MaxZ (maxZ : in Integer);

    entry ResultH(A : out VectorH);
    end T7;
   
   -------------------------------------------------------------------------------
   --                                 ???? ?????                                --
   -------------------------------------------------------------------------------
   
   --                                 ?????? T1                                 --
   
    taskbody T1 is
    A1 : VectorH;
    Z1 : VectorH;
    E1: VectorH;
    B1 : VectorN;
    MO1 : MatrixH;
    MK1 : MatrixN;
    alfa1: Integer;
    maxZ1: Integer :=-99999;
    begin
    Put_Line("T1 started");
    --1.???????? MK, B, a
    Input(MK1,1);
    Input(B1,1);
    alfa1 := 1;
   --2.???????? MK, B, a ?????? ?2
    T2.DataMKBalfa(MK1, B1, alfa1);
   --3.???????? ZH,EH, MOH ??? ?????? ?2
    accept DataH (E : in VectorH; Z : in VectorH; MO : in MatrixH) do
    E1:=E;
    Z1:= Z;
    MO1:=MO;
    end DataH;
   --4.????????? maxZ1 = max(ZH)
    FindMaxZ(Z1, maxZ1);
   --5.???????? maxZ1 ?????? ?2
    T2.MaxZ1(maxZ1);
   --6.???????? maxZ ??? ?????? ?2
    accept MaxZ (maxZ : in Integer) do
    maxZ1:=maxZ;
    end MaxZ;
   --7.????????? AH = maxZ·EH + a·B(MOH·MK)
    Calculation(alfa1, maxZ1, B1, E1, MO1, MK1, A1);
   --8.???????? AH ?????? ?2
    accept ResultH (A : out VectorH)do
    A:= A1;
    end ResultH;
   
   
    Put_Line("T1 finished");
   
    end T1;
   
   --                                 ?????? T2                                 --
   
    taskbody T2 is
    A2 : Vector2H;
    Z2 : Vector2H;
 
    E2: Vector2H;
    B2 : VectorN;
    MO2 : Matrix2H;
    MK2 : MatrixN;
    alfa2: Integer;
    maxZ2: Integer :=-999999;
    buf: Integer;
    begin
    Put_Line("T2 started");
   --1.???????? MK, B, a ??? ?????? ?1
    accept DataMKBalfa (MK : in MatrixN; B : in VectorN; alfa : in Integer) do
    MK2:= MK;
    B2:= B;
    alfa2:= alfa;
    end DataMKBalfa;
   --2.???????? MK, B, a ?????? ?3
    T3.DataMKBalfa(MK2, B2, alfa2);
   --3.???????? Z2H,E2H, MO2H ??? ?????? ?3
    accept Data2H (E : in Vector2H; Z : in Vector2H; MO : in Matrix2H) do
    E2:=E;
    Z2:= Z;
    MO2:=MO;
    end Data2H;
   --4.???????? ZH,EH, MOH ?????? ?1
    T1.DataH(E2(1..H), Z2(1..H),MO2(1..H));
   --5.????????? maxZ2 = max(ZH)
    accept MaxZ1 (maxZ1 : in Integer) do
    buf:= maxZ1;
    end MaxZ1;
   --6.???????? maxZ1 ??? ?????? ?1
    FindMaxZ(Z2(H+1..2*H), maxZ2);
   --7.????????? maxZ2 = max (maxZ2,maxZ1)
    maxZ2 :=Max(buf, maxZ2);
   --8.???????? maxZ2 ?????? ?3
    T3.MaxZ2(maxZ2);
   --9.???????? maxZ ??? ?????? ?2
    accept MaxZ (maxZ : in Integer) do
    maxZ2:=maxZ;
    end MaxZ;
   --10.???????? maxZ ?????? ?1
    T1.MaxZ(maxZ2);
   --11.????????? AH = maxZ·EH + a·B(MOH·MK)
    Calculation(alfa2, maxZ2, B2, E2(H+1..2*H), MO2(H+1..2*H), MK2, A2(H+1..2*H));
   --12.???????? AH ??? ?????? ?1
    T1.ResultH(A2(1..H));
   --13.???????? A2H ?????? ?2
    accept Result2H(A : out Vector2H) do
    A := A2;
    end Result2H;
    Put_Line("T2 finished");
    end T2;
   
   --                                 ?????? T3                                 --
   
    taskbody T3 is
    A3 : Vector3H;
 C:\Users\Vova\ada project\lab7\src\lab7.adb 28 ?????? 2015 ?. 23:49
    Z3 : Vector3H;
    E3: Vector3H;
    B3 : VectorN;
    MO3 : Matrix3H;
    MK3 : MatrixN;
    alfa3: Integer;
    maxZ3: Integer :=-999999;
    buf: Integer;
   
    begin
    Put_Line("T3 started");
   --1.???????? MK, B, a ??? ?????? ?2
    accept DataMKBalfa (MK : in MatrixN; B : in VectorN; alfa : in Integer) do
    MK3:= MK;
    B3:= B;
    alfa3:= alfa;
    end DataMKBalfa;
   --2.???????? MK, B, a ?????? ?4
    T4.DataMKBalfa(MK3, B3, alfa3);
   --3.???????? Z3H,E3H, MO3H ??? ?????? ?4
    accept Data3H (E : in Vector3H; Z : in Vector3H; MO : in Matrix3H) do
    E3:=E;
    Z3:= Z;
    MO3:=MO;
    end Data3H;
   --4.???????? Z2H,E2H, MO2H ?????? ?2
    T2.Data2H(E3(1..2*H), Z3(1..2*H),MO3(1..2*H));
   --5.????????? maxZ3 = max(ZH)
    FindMaxZ(Z3(2*H+1..3*H), maxZ3);
   --6.???????? maxZ2 ??? ?????? ?2
    accept MaxZ2 (maxZ1 : in Integer) do
    buf:= maxZ1;
    end MaxZ2;
   --7.????????? maxZ3 = max (maxZ3,maxZ2)
    maxZ3:=Max(buf, maxZ3);
   --8.???????? maxZ3 ?????? ?4
    T4.MaxZ3(maxZ3);
   --9.???????? maxZ ??? ?????? ?4
    accept MaxZ (maxZ : in Integer) do
    maxZ3:=maxZ;
    end MaxZ;
   --10.???????? maxZ ?????? ?2
    T2.MaxZ(maxZ3);
   --11.????????? AH = maxZ·EH + a·B(MOH·MK)
    Calculation(alfa3, maxZ3, B3, E3(2*H+1..3*H), MO3(2*H+1..3*H), MK3, A3(2*H+
1..3*H));
   --12.???????? A2H ??? ?????? ?2
    T2.Result2H(A3(1..2*H));
   --13.???????? A3H ?????? ?2
    accept Result3H(A : out Vector3H) do
    A := A3;
    end Result3H;
    Put_Line("T3 finished");
    end T3;
   
   --                                 ?????? T4                                 --
   
 C:\Users\Vova\ada project\lab7\src\lab7.adb 28 ?????? 2015 ?. 23:49
    taskbody T4 is
    A4 : VectorN;
    Z4 : VectorN;
    E4: Vector6H;
    B4 : VectorN;
 MO4 : Matrix6H;
    MK4 : MatrixN;
    alfa4: Integer;
    maxZ4: Integer :=-999999;
    maxValueZ3: Integer;
    maxValueZ5: Integer;
    maxValueZ6: Integer;
    maxValueZ7: Integer;
    sum : Integer:=0;
    Sum1: Integer:=0;
   
   
    begin
    Put_Line("T4 started");
   --1.?????? Z
    Input(Z4,1);
   --2.???????? ZH ??????? ?5, ?6, T7
    T5.DataZ(Z4(4*H+1..5*H));
    T6.DataZ(Z4(5*H+1..6*H));
    T7.DataZ(Z4(6*H+1..7*H));
   --3.???????? a, B, MK ??? ?????? ?3
    accept DataMKBalfa (MK : in MatrixN; B : in VectorN; alfa : in Integer) do
    MK4:= MK;
    B4:= B;
    alfa4:= alfa;
    end DataMKBalfa;
   --4.???????? E6H, MO6H ??? ?????? ?7
    accept DataMOE6H(E : in Vector6H; MO : in Matrix6H) do
    MO4:= MO;
    E4:= E;
    end DataMOE6H;
   --5.???????? Z3H, MO3H, E3H ?????? ?3
    T3.Data3H(E4(1..3*H), Z4(1..3*H),MO4(1..3*H));
   --6.???????? a, B, MK, MOH, EH ??????? ?5, ?6
    T5.DataMKBalfaEHMOH(alfa4, E4(4*H+1..5*H),B4, MO4(4*H+1..5*H), MK4);
    T6.DataMKBalfaEHMOH(alfa4, E4(5*H+1..6*H),B4, MO4(5*H+1..6*H), MK4);
   --7.???????? a, B, MK ?????? ?7
    T7.DataMKBalfa(alfa4, B4, MK4);
   --8.????????? maxZ4 = max(ZH)
    FindMaxZ(Z4(3*H+1..4*H), maxZ4);
   --9.???????? maxZ5 ??? ?????? ?5
    accept MaxZ5 (maxZi : in Integer) do
    maxValueZ5:= maxZi;
    end MaxZ5;
   --10.????????? maxZ4 = max (maxZ4,maxZ5)
    maxZ4:=Max(maxValueZ5, maxZ4);
   --11.???????? maxZ6 ??? ?????? ?6
    accept MaxZ6 (maxZi : in Integer) do
    maxValueZ6:= maxZi;
    end MaxZ6;
   --12.????????? maxZ4 = max (maxZ4,maxZ6)
    maxZ4:=Max(maxValueZ6, maxZ4);
 C:\Users\Vova\ada project\lab7\src\lab7.adb 28 ?????? 2015 ?. 23:49
   --13.???????? maxZ7 ??? ?????? ?7
    accept MaxZ7 (maxZi : in Integer) do
    maxValueZ7:= maxZi;
    end MaxZ7;
   --14.????????? maxZ4 = max (maxZ4,maxZ7)
    maxZ4:=Max(maxValueZ7, maxZ4);
   --15.???????? maxZ3 ??? ?????? ?3
    accept MaxZ3 (maxZi : in Integer) do
    maxValueZ3:= maxZi;
    end MaxZ3;
   --16.????????? maxZ = max (maxZ4,maxZ3)
    maxZ4:=Max(maxValueZ3, maxZ4);
   --17.???????? maxZ ??????? T3,T5,T6,T7
    T3.MaxZ(maxZ4);
    T5.MaxZ(maxZ4);
    T6.MaxZ(maxZ4);
    T7.MaxZ(maxZ4);
   --18.????????? AH = maxZ·EH + a·B(MOH·MK)
    Calculation(alfa4, maxZ4, B4, E4(3*H+1..4*H), MO4(3*H+1..4*H), MK4, A4(3*H+
1..4*H));
   --19.???????? AH ??? ????? ?5, ?6, ?7
    T5.ResultH(A4(4*H+1..5*H));
    T6.ResultH(A4(5*H+1..6*H));
    T7.ResultH(A4(6*H+1..7*H));
   --20.???????? ?3H ??? ?????? ?3
    T3.Result3H(A4(1..3*H));
   --21.??????? ?
    Output(A4);
    Put_Line("T4 finished");
    end T4;
   
   --                                 ?????? T5                                 --
   
    taskbody T5 is
    A5 : VectorH;
    Z5 : VectorH;
    E5: VectorH;
 B5 : VectorN;
    MO5 : MatrixH;
    MK5 : MatrixN;
    alfa5: Integer;
    maxZ5: Integer :=-999999;
   
    begin
    Put_Line("T5 started");
   --1.???????? ZH ??? ?????? ?4
    accept DataZ (Z : in VectorH) do
    Z5:=Z;
    end DataZ;
   --2.???????? a, B, MK, MOH, EH ??? ?????? ?4
    accept DataMKBalfaEHMOH(alfa : in Integer; E : in VectorH; B: in VectorN;
    MO: in MatrixH; MK : in MatrixN) do
    alfa5:= alfa;
    E5:=E;
    B5:=B;
    MO5:=MO;
    MK5:=MK;
 
    end DataMKBalfaEHMOH;
   --3.????????? maxZ5 = max (ZH)
    FindMaxZ(Z5, maxZ5);
   --4.???????? maxZ5  ?????? ?4
    T4.MaxZ5(maxZ5);
   --5.???????? maxZ ??? ?????? ?4
    accept MaxZ (maxZ : in Integer) do
    maxZ5:= maxZ;
    end MaxZ;
   --6.????????? AH = maxZ·EH + a·B(MOH·MK)
    Calculation(alfa5, maxZ5, B5, E5, MO5, MK5, A5);
   --7.???????? ?H ?????? ?4
    accept ResultH (A : out VectorH) do
    A:= A5;
    end ResultH;
   
   
    Put_Line("T5 finished");
    end T5;
   
   --                                 ?????? T6                                 --
   
    taskbody T6 is
    A6 : VectorH;
    Z6 : VectorH;
    E6: VectorH;
    B6 : VectorN;
    MO6 : MatrixH;
    MK6 : MatrixN;
    alfa6: Integer;
    maxZ6: Integer :=-999999;
   
    begin
    Put_Line("T6 started");
   --1.???????? ZH ??? ?????? ?4
    accept DataZ (Z : in VectorH) do
    Z6:=Z;
    end DataZ;
   --2.???????? a, B, MK, MOH, EH ??? ?????? ?4
    accept DataMKBalfaEHMOH(alfa : in Integer; E : in VectorH; B: in VectorN;
    MO: in MatrixH; MK : in MatrixN) do
    alfa6:= alfa;
    E6:=E;
    B6:=B;
    MO6:=MO;
    MK6:=MK;
    end DataMKBalfaEHMOH;
   --3.????????? maxZ6 = max (ZH)
    FindMaxZ(Z6, maxZ6);
   --4.???????? maxZ6  ?????? ?4
    T4.MaxZ6(maxZ6);
   --5.???????? maxZ ??? ?????? ?4
    accept MaxZ (maxZ : in Integer) do
    maxZ6:= maxZ;
    end MaxZ;
   --6.????????? AH = maxZ·EH + a·B(MOH·MK)
    Calculation(alfa6, maxZ6, B6, E6, MO6, MK6, A6);
 
   --7.???????? ?H ?????? ?4
    accept ResultH (A : out VectorH) do
    A:= A6;
    end ResultH;
   
   
    Put_Line("T6 finished");
    end T6;
   
   --                                 ?????? T7                                 --
   
    taskbody T7 is
    A7 : VectorH;
    Z7 : VectorH;
    E7: VectorN;
    B7 : VectorN;
    MO7 : MatrixN;
    MK7 : MatrixN;
    alfa7: Integer;
    maxZ7: Integer :=-999999;
   
    begin
    Put_Line("T7 started");
   --1.?????? MO, E
    Input(MO7,1);
    Input(E7,1);
   --2.???????? ZH ??? ?????? ?4
    accept DataZ (Z : in VectorH) do
    Z7:=Z;
    end DataZ;
   --3.???????? MO6H, E6H ?????? ?4
    T4.DataMOE6H(E7(1..6*H), MO7(1..6*H));
   --4.???????? a, B, MK ??? ?????? ?4
    accept DataMKBalfa(alfa : in Integer; B: in VectorN; MK : in MatrixN) do
    alfa7:= alfa;
    B7:=B;
    MK7:=MK;
    end DataMKBalfa;
   --5.????????? maxZ7 = max (ZH)
    FindMaxZ(Z7, maxZ7);
   --6.???????? maxZ7  ?????? ?4
    T4.MaxZ7(maxZ7);
   --7.???????? maxZ ??? ?????? ?4
    accept MaxZ (maxZ : in Integer) do
    maxZ7:= maxZ;
    end MaxZ;
   --8.????????? AH = maxZ·EH + a·B(MOH·MK)
    Calculation(alfa7, maxZ7, B7, E7(6*H+1..7*H), MO7(6*H+1..7*H), MK7, A7);
   --9.???????? ?H ?????? ?4
    accept ResultH (A : out VectorH) do
    A:= A7;
    end ResultH;
   --
    Put_Line("T7 finished");
    end T7;
   
    begin
    null;
    end StartTasks;
   begin
    Put_Line ("Lab7 started");
    StartTasks;
    Put_Line ("Lab7 finished");
   end lab5;
    


